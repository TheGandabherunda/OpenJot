import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_jot/app/core/models/journal_entry.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../utils/custom_toast.dart';
import '../constants.dart';
import '../hive/hive_adapters.dart';

class HiveService extends GetxService {
  late Box<dynamic> settingsBox;
  late Box<JournalEntry> journalsBox;

  bool _adaptersRegistered = false;

  Future<HiveService> init({bool runGC = true}) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    _registerAdapters();
    settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
    journalsBox = await Hive.openBox<JournalEntry>(AppConstants.journalsBoxName);

    // Run this first to ensure all media paths are correctly linked to the current device session
    // This fixes absolute paths changing after app updates, backup restores, or iOS app restarts.
    await _sanitizeMediaPathsIfNeeded(appDocumentDir);

    // --- Data Migration: Mood Evolution ---
    await _migrateMoods();

    // --- Data Migration: Multiple Reminders ---
    await _migrateReminders();

    // Run Garbage Collection quietly in the background to free up storage
    if (runGC) {
      unawaited(cleanUpOrphanedMedia());
    }

    return this;
  }

  Future<void> _sanitizeMediaPathsIfNeeded(Directory appDocDir) async {
    final persistentMediaDir = Directory(p.join(appDocDir.path, 'media'));
    if (!await persistentMediaDir.exists()) {
      await persistentMediaDir.create(recursive: true);
    }

    // Use keys to avoid concurrent modification exceptions during iteration
    final keys = journalsBox.keys.toList();

    for (final key in keys) {
      final entry = journalsBox.get(key);
      if (entry == null) continue;

      bool entryModified = false;

      final newPhotos = <CapturedPhoto>[];
      for (final photo in entry.cameraPhotos) {
        final filename = p.basename(photo.file.path);
        final expectedPath = p.join(persistentMediaDir.path, filename);

        if (photo.file.path != expectedPath) {
          final oldFile = File(photo.file.path);
          final possibleRootFile = File(p.join(appDocDir.path, filename));

          if (await oldFile.exists() && oldFile.path != expectedPath) {
            try {
              await oldFile.copy(expectedPath);
            } catch (_) {}
          } else if (await possibleRootFile.exists() && possibleRootFile.path != expectedPath) {
            try {
              await possibleRootFile.copy(expectedPath);
              await possibleRootFile.delete();
            } catch (_) {}
          }

          newPhotos.add(CapturedPhoto(file: XFile(expectedPath), name: photo.name));
          entryModified = true;
        } else {
          newPhotos.add(photo);
        }
      }

      final newRecordings = <RecordedAudio>[];
      for (final rec in entry.recordings) {
        final filename = p.basename(rec.path);
        final expectedPath = p.join(persistentMediaDir.path, filename);

        if (rec.path != expectedPath) {
          final oldFile = File(rec.path);
          final possibleRootFile = File(p.join(appDocDir.path, filename));

          if (await oldFile.exists() && oldFile.path != expectedPath) {
            try {
              await oldFile.copy(expectedPath);
            } catch (_) {}
          } else if (await possibleRootFile.exists() && possibleRootFile.path != expectedPath) {
            try {
              await possibleRootFile.copy(expectedPath);
              await possibleRootFile.delete();
            } catch (_) {}
          }

          newRecordings.add(RecordedAudio(path: expectedPath, duration: rec.duration, name: rec.name));
          entryModified = true;
        } else {
          newRecordings.add(rec);
        }
      }

      if (entryModified) {
        await journalsBox.put(key, entry.copyWith(cameraPhotos: newPhotos, recordings: newRecordings));
      }
    }
  }

  Future<void> _migrateMoods() async {
    const String moodVersionKey = 'mood_schema_version';
    // Version 0: v1.0.0 (5 moods)
    // Version 1: v1.1.0 (7 moods, old order)
    // Version 2: v1.1.1 (7 moods, new order - Current)

    int currentVersion = settingsBox.get(moodVersionKey, defaultValue: -1);

    // Inferred versioning for existing users who haven't tracked version yet
    if (currentVersion == -1) {
      if (settingsBox.get('hasFixedMoodOrder7', defaultValue: false)) {
        currentVersion = 2;
      } else if (settingsBox.get('hasMigratedMoodsTo7', defaultValue: false)) {
        currentVersion = 1;
      } else {
        // If journals is empty, we can safely start at latest version
        // Otherwise, assume they are on the oldest version (5 moods)
        currentVersion = journalsBox.isEmpty ? 2 : 0;
      }
    }

    if (currentVersion >= 2) {
      debugPrint("Mood migration: Already at version $currentVersion.");
      return;
    }

    debugPrint("Mood migration: Migrating from version $currentVersion to 2...");
    final keys = journalsBox.keys.toList();
    int migrationCount = 0;

    for (final key in keys) {
      final entry = journalsBox.get(key);
      if (entry != null && entry.moodIndex != null) {
        int oldIndex = entry.moodIndex!;
        int? newIndex;

        if (currentVersion == 0) {
          // v1.0.0 (5 moods) to v1.1.1 (7 moods, new order)
          // Old 5: VU(0), U(1), N(2), P(3), VP(4)
          // New 7: VU(0), U(1), SU(2), N(3), SP(4), P(5), VP(6)
          switch (oldIndex) {
            case 0: newIndex = 0; break; // VU -> VU
            case 1: newIndex = 1; break; // U -> U
            case 2: newIndex = 3; break; // N -> N
            case 3: newIndex = 5; break; // P -> P
            case 4: newIndex = 6; break; // VP -> VP
          }
        } else if (currentVersion == 1) {
          // v1.1.0 (7 moods, old order) to v1.1.1 (7 moods, new order)
          // Old 7: VU(0), SU(1), U(2), N(3), P(4), SP(5), VP(6)
          // New 7: VU(0), U(1), SU(2), N(3), SP(4), P(5), VP(6)
          // Swaps: SU(1) <-> U(2) and P(4) <-> SP(5)
          switch (oldIndex) {
            case 1: newIndex = 2; break; // Old SU -> New SU
            case 2: newIndex = 1; break; // Old U -> New U
            case 4: newIndex = 5; break; // Old P -> New P
            case 5: newIndex = 4; break; // Old SP -> New SP
          }
        }

        if (newIndex != null && newIndex != oldIndex) {
          await journalsBox.put(key, entry.copyWith(moodIndex: newIndex));
          migrationCount++;
        }
      }
    }

    await settingsBox.put(moodVersionKey, 2);
    // Cleanup old flags
    await settingsBox.delete('hasMigratedMoodsTo7');
    await settingsBox.delete('hasMigratedMoodsTo7_v2');
    await settingsBox.delete('hasFixedMoodOrder7');

    debugPrint("Mood migration: Completed. Migrated $migrationCount entries.");
  }

  Future<void> _migrateReminders() async {
    int currentVersion = settingsBox.get(AppConstants.reminderSchemaVersionKey, defaultValue: 0);

    if (currentVersion >= 1) return;

    debugPrint("Reminder migration: Migrating to multiple reminders...");

    final oldDailyReminder = settingsBox.get(AppConstants.dailyReminderKey, defaultValue: false);
    final oldReminderTimeStr = settingsBox.get(AppConstants.reminderTimeKey);

    if (oldReminderTimeStr != null) {
      try {
        final parts = oldReminderTimeStr.split(':');
        final oldTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));

        // If it was enabled, migrate it.
        // Actually, the user says migrate it regardless? "that reminder time should be added into the list"
        // I'll migrate it if it exists.
        final List<TimeOfDay> existingTimes = reminderTimes;
        if (!existingTimes.any((t) => t.hour == oldTime.hour && t.minute == oldTime.minute)) {
          if (oldDailyReminder) {
            existingTimes.add(oldTime);
            await setReminderTimes(existingTimes);
            debugPrint("Reminder migration: Migrated $oldReminderTimeStr to list.");
          }
        }
      } catch (e) {
        debugPrint("Reminder migration: Error parsing old time: $e");
      }
    }

    await settingsBox.put(AppConstants.reminderSchemaVersionKey, 1);
    debugPrint("Reminder migration: Completed.");
  }

  void _registerAdapters() {
    if (_adaptersRegistered) return;

    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(RecordedAudioAdapter());
    Hive.registerAdapter(CapturedPhotoAdapter());
    Hive.registerAdapter(SelectedLocationAdapter());
    Hive.registerAdapter(LatLngAdapter());
    Hive.registerAdapter(XFileAdapter());
    Hive.registerAdapter(DocumentAdapter());
    Hive.registerAdapter(AssetEntityAdapter());
    Hive.registerAdapter(DurationAdapter());

    _adaptersRegistered = true;
  }

  // --- Settings Box Methods ---
  bool get isFirstLaunch =>
      settingsBox.get(AppConstants.isFirstLaunchKey, defaultValue: true);
  Future<void> setFirstLaunch(bool value) =>
      settingsBox.put(AppConstants.isFirstLaunchKey, value);

  String get theme =>
      settingsBox.get(AppConstants.themeKey, defaultValue: 'System');
  Future<void> setTheme(String theme) =>
      settingsBox.put(AppConstants.themeKey, theme);

  bool get pitchBlack =>
      settingsBox.get(AppConstants.pitchBlackKey, defaultValue: false);
  Future<void> setPitchBlack(bool value) =>
      settingsBox.put(AppConstants.pitchBlackKey, value);

  bool get dailyReminder =>
      settingsBox.get(AppConstants.dailyReminderKey, defaultValue: false);
  Future<void> setDailyReminder(bool value) =>
      settingsBox.put(AppConstants.dailyReminderKey, value);

  bool get onThisDay =>
      settingsBox.get(AppConstants.onThisDayKey, defaultValue: false);
  Future<void> setOnThisDay(bool value) =>
      settingsBox.put(AppConstants.onThisDayKey, value);

  String? get lastOnThisDayNotificationDate =>
      settingsBox.get(AppConstants.lastOnThisDayNotificationDateKey);
  Future<void> setLastOnThisDayNotificationDate(String date) =>
      settingsBox.put(AppConstants.lastOnThisDayNotificationDateKey, date);

  // --- NEW: Excluded Entries ---
  List<String> get excludedOnThisDayEntries {
    final list = settingsBox.get(AppConstants.excludedEntriesKey, defaultValue: <String>[]);
    return (list as List).cast<String>();
  }

  Future<void> setExcludedOnThisDayEntries(List<String> ids) =>
      settingsBox.put(AppConstants.excludedEntriesKey, ids);

  int get autoDeleteDraftsDays =>
      settingsBox.get(AppConstants.autoDeleteDraftsKey, defaultValue: 7);
  Future<void> setAutoDeleteDraftsDays(int days) =>
      settingsBox.put(AppConstants.autoDeleteDraftsKey, days);

  TimeOfDay? get reminderTime {
    final timeString = settingsBox.get(AppConstants.reminderTimeKey);
    if (timeString == null) return null;
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> setReminderTime(TimeOfDay time) => settingsBox
      .put(AppConstants.reminderTimeKey, '${time.hour}:${time.minute}');

  List<TimeOfDay> get reminderTimes {
    final list = settingsBox.get(AppConstants.reminderTimesKey, defaultValue: <String>[]);
    return (list as List).cast<String>().map((e) {
      final parts = e.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();
  }

  Future<void> setReminderTimes(List<TimeOfDay> times) => settingsBox.put(
      AppConstants.reminderTimesKey,
      times.map((e) => '${e.hour}:${e.minute}').toList());

  bool get appLockEnabled =>
      settingsBox.get(AppConstants.appLockEnabledKey, defaultValue: false);
  Future<void> setAppLock(bool value) =>
      settingsBox.put(AppConstants.appLockEnabledKey, value);

  String? get appLockPin => settingsBox.get(AppConstants.appLockPinKey);
  Future<void> setAppLockPin(String pin) =>
      settingsBox.put(AppConstants.appLockPinKey, pin);

  // --- Journals Box Methods ---
  Future<void> addJournalEntry(JournalEntry entry) =>
      journalsBox.put(entry.id, entry);

  Future<void> updateJournalEntry(JournalEntry entry) async {
    final isTextEmpty = entry.content.toPlainText().trim().isEmpty;
    final isMediaEmpty = entry.galleryImages.isEmpty &&
        entry.cameraPhotos.isEmpty &&
        entry.galleryAudios.isEmpty &&
        entry.recordings.isEmpty;

    if (isTextEmpty && isMediaEmpty) {
      await deleteJournalEntry(entry.id);
    } else {
      await journalsBox.put(entry.id, entry);
    }
  }

  Future<void> deleteJournalEntry(String id) async {
    await journalsBox.delete(id);
    // Optionally call unawaited(cleanUpOrphanedMedia()) here if you want instant deletion
  }

  List<JournalEntry> getAllJournalEntries() => journalsBox.values.toList();
  ValueListenable<Box<JournalEntry>> getJournalEntriesNotifier() =>
      journalsBox.listenable();

  // --- Garbage Collection (Storage Leak Fix) ---
  Future<void> cleanUpOrphanedMedia() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory(p.join(appDocDir.path, 'media'));

      // Use basenames to avoid GC incorrectly deleting files when absolute path changes
      Set<String> activeMediaBasenames = {};
      for (final entry in journalsBox.values) {
        for (final photo in entry.cameraPhotos) {
          activeMediaBasenames.add(p.basename(photo.file.path));
        }
        for (final rec in entry.recordings) {
          activeMediaBasenames.add(p.basename(rec.path));
        }
      }

      // Clean up extracted/restored files in appDocDir/media
      if (await mediaDir.exists()) {
        final files = mediaDir.listSync();
        for (final file in files) {
          if (file is File && !activeMediaBasenames.contains(p.basename(file.path))) {
            await file.delete();
            debugPrint("GC: Deleted orphaned media ${file.path}");
          }
        }
      }

      // Clean up orphaned camera photos or recordings dumped in the root appDocDir
      final rootFiles = appDocDir.listSync();
      for (final file in rootFiles) {
        if (file is File) {
          final filename = p.basename(file.path);
          if ((filename.startsWith('OpenJot_recording_') || filename.startsWith('OpenJot_image_')) &&
              !activeMediaBasenames.contains(filename)) {
            await file.delete();
            debugPrint("GC: Deleted orphaned root media ${file.path}");
          }
        }
      }
    } catch (e) {
      debugPrint("Error during garbage collection: $e");
    }
  }

  // --- Backup & Restore Methods ---

  Future<bool> _requestPermissions() async {
    if (Platform.isIOS) {
      final photoStatus = await Permission.photos.request();
      return photoStatus.isGranted;
    }

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;
      List<Permission> permissionsToRequest = [];

      if (sdkInt >= 33) {
        permissionsToRequest.add(Permission.photos);
        permissionsToRequest.add(Permission.audio);
      } else {
        permissionsToRequest.add(Permission.storage);
      }

      final Map<Permission, PermissionStatus> statuses =
      await permissionsToRequest.request();
      return statuses.values.every((status) => status.isGranted);
    }

    return false;
  }

  Future<bool> backupData({void Function(double progress)? onProgress}) async {
    final bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      CustomToast.showToast(AppConstants.storagePermissionsRequired);
      return false;
    }

    String? zipPath;
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final tempDir = await getTemporaryDirectory();

      final backupFileName = '${AppConstants.backupFileNamePrefix}${DateTime.now().toIso8601String().replaceAll(':', '-')}${AppConstants.backupFileExtension}';
      zipPath = p.join(tempDir.path, backupFileName);

      debugPrint("Starting memory-safe backup process to: $zipPath");
      onProgress?.call(0.0);

      // 1. Initialize memory-safe ZipFileEncoder (Streams direct to disk!)
      final encoder = ZipFileEncoder();
      encoder.create(zipPath);

      // 2. Add Hive database files
      for (var boxName in [AppConstants.journalsBoxName, AppConstants.settingsBoxName]) {
        final boxFile = File(p.join(appDocDir.path, '$boxName${AppConstants.hiveExtension}'));
        if (await boxFile.exists()) {
          encoder.addFile(boxFile, '$boxName${AppConstants.hiveExtension}');
        }
      }

      // 3. Process media files and build manifest
      final mediaManifest = <String, dynamic>{};
      final entries = journalsBox.values.toList();
      int processedEntries = 0;
      final totalEntries = entries.isEmpty ? 1 : entries.length;

      for (final entry in entries) {
        final entryManifest = <String, List<Map<String, String>>>{
          AppConstants.cameraPhotosKey: [],
          AppConstants.galleryImagesKey: [],
          AppConstants.galleryAudiosKey: [],
          AppConstants.recordingsKey: [],
        };

        // Inner function with strict Error Handling to prevent plugin crashes
        Future<void> processMediaFile(String originalPath, String type, String id, {bool isAssetEntity = false, AssetEntity? asset}) async {
          try {
            File? sourceFile;

            // Handle Photo Manager Assets safely
            if (isAssetEntity && asset != null) {
              final exists = await asset.exists;
              if (!exists) return;
              sourceFile = await asset.file;
            } else {
              sourceFile = File(originalPath);
              if (!await sourceFile.exists()) {
                // Last resort fallback in case paths drifted despite sanitization
                final fallbackFile = File(p.join(appDocDir.path, 'media', p.basename(originalPath)));
                if (await fallbackFile.exists()) sourceFile = fallbackFile;
              }
            }

            if (sourceFile == null || !await sourceFile.exists()) return;

            // Prevent duplicating ID in file name on subsequent backups
            final basename = p.basename(sourceFile.path);
            final backupMediaName = basename.startsWith(entry.id)
                ? basename
                : '${entry.id}-$basename';

            // Stream file directly into Zip
            encoder.addFile(sourceFile, 'media/$backupMediaName');

            entryManifest[type]!.add({
              AppConstants.idKey: id,
              AppConstants.backupFileNameKey: backupMediaName
            });
          } catch (e) {
            debugPrint("Error processing media file $id: $e");
          }
        }

        // Process all media types
        for (final photo in entry.cameraPhotos) {
          await processMediaFile(photo.file.path, AppConstants.cameraPhotosKey, photo.file.path);
        }
        for (final audio in entry.recordings) {
          await processMediaFile(audio.path, AppConstants.recordingsKey, audio.path);
        }
        for (final asset in entry.galleryImages) {
          await processMediaFile('', AppConstants.galleryImagesKey, asset.id, isAssetEntity: true, asset: asset);
        }
        for (final asset in entry.galleryAudios) {
          await processMediaFile('', AppConstants.galleryAudiosKey, asset.id, isAssetEntity: true, asset: asset);
        }

        if (entryManifest.values.any((list) => list.isNotEmpty)) {
          mediaManifest[entry.id] = entryManifest;
        }

        // Update progress callback
        processedEntries++;
        onProgress?.call(processedEntries / totalEntries);
      }

      // 4. Add Versioned Manifest to archive
      final rootManifest = {
        'version': '1.0.0',
        'timestamp': DateTime.now().toIso8601String(),
        'entries': mediaManifest,
      };

      final manifestJson = jsonEncode(rootManifest);
      final manifestFile = File(p.join(tempDir.path, 'media_manifest.json'));
      await manifestFile.writeAsString(manifestJson);
      encoder.addFile(manifestFile, 'media_manifest.json');

      // 5. Close encoder to finalize zip
      encoder.close();

      // 6. Export using file_picker
      final zipFile = File(zipPath);
      final zipBytes = await zipFile.readAsBytes();

      final String? selectedPath = await FilePicker.platform.saveFile(
        dialogTitle: AppConstants.selectBackupFolder,
        fileName: backupFileName,
        type: FileType.custom,
        allowedExtensions: ['zip'],
        bytes: zipBytes,
      );

      if (selectedPath == null) {
        return false;
      }

      CustomToast.showToast(AppConstants.backupCreatedSuccess);
      return true;

    } catch (e) {
      debugPrint("Backup failed with exception: $e");
      CustomToast.showToast(AppConstants.backupFailed.replaceFirst('%s', e.toString()));
      return false;
    } finally {
      // Guaranteed Cleanup: Ensure no massive zip files are left eating device storage
      if (zipPath != null) {
        final f = File(zipPath);
        if (await f.exists()) await f.delete();
      }
    }
  }

  Future<bool> restoreData({void Function(double progress)? onProgress}) async {
    final bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      CustomToast.showToast(AppConstants.restorePermissionsRequired);
      return false;
    }

    Directory? tempDir;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );
      if (result == null || result.files.single.path == null) return false;

      final zipFile = File(result.files.single.path!);
      final appDocDir = await getApplicationDocumentsDirectory();

      tempDir = Directory(p.join((await getTemporaryDirectory()).path, 'restore_temp'));
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
      await tempDir.create(recursive: true);

      onProgress?.call(0.1); // Notify starting extraction

      // MEMORY SAFE: Extracts directly to disk instead of filling up device RAM
      await extractFileToDisk(zipFile.path, tempDir.path);
      onProgress?.call(0.3);

      // Close Hive before replacing files
      await Hive.close();

      for (var boxName in [AppConstants.journalsBoxName, AppConstants.settingsBoxName]) {
        final tempBoxFile = File(p.join(tempDir.path, '$boxName${AppConstants.hiveExtension}'));
        if (await tempBoxFile.exists()) {
          await tempBoxFile.copy(p.join(appDocDir.path, '$boxName${AppConstants.hiveExtension}'));
        }
      }

      // Re-initialize Hive and open boxes (SKIP GC during restore to prevent race condition)
      await init(runGC: false);
      onProgress?.call(0.4);

      final manifestFile = File(p.join(tempDir.path, 'media_manifest.json'));
      if (!await manifestFile.exists()) {
        if (Get.isRegistered<HomeController>()) {
          await Get.find<HomeController>().loadJournalEntries();
        }
        // Run GC now that the DB is replaced (even if no media to link)
        unawaited(cleanUpOrphanedMedia());
        return true;
      }

      // Version-safe manifest decoding
      final parsedJson = jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
      Map<String, dynamic> mediaManifest;
      if (parsedJson.containsKey('version')) {
        mediaManifest = parsedJson['entries'] as Map<String, dynamic>;
      } else {
        mediaManifest = parsedJson; // Fallback for v1 legacy backups
      }

      final persistentMediaDir = Directory(p.join(appDocDir.path, 'media'));
      await persistentMediaDir.create(recursive: true);

      int processedEntries = 0;
      final totalEntries = journalsBox.values.isEmpty ? 1 : journalsBox.values.length;

      for (final entry in journalsBox.values) {
        if (!mediaManifest.containsKey(entry.id)) {
          processedEntries++;
          continue;
        }

        final entryManifest = mediaManifest[entry.id] as Map<String, dynamic>;
        bool wasModified = false;

        final newCameraPhotos = <CapturedPhoto>[];
        final newRecordings = <RecordedAudio>[];

        Future<String?> restoreFile(String backupFileName) async {
          try {
            final sourceFile = File(p.join(tempDir!.path, 'media', backupFileName));
            if (!await sourceFile.exists()) return null;
            final destPath = p.join(persistentMediaDir.path, backupFileName);
            await sourceFile.copy(destPath);
            return destPath;
          } catch (e) {
            return null;
          }
        }

        final imageLists = [AppConstants.cameraPhotosKey, AppConstants.galleryImagesKey];
        for (var listName in imageLists) {
          final manifestList = (entryManifest[listName] as List<dynamic>?) ?? [];
          for (final item in manifestList) {
            final newPath = await restoreFile(item[AppConstants.backupFileNameKey]);
            if (newPath != null) {
              newCameraPhotos.add(CapturedPhoto(file: XFile(newPath), name: item[AppConstants.backupFileNameKey]));
              wasModified = true;
            }
          }
        }

        final audioLists = [AppConstants.recordingsKey, AppConstants.galleryAudiosKey];
        for (var listName in audioLists) {
          final manifestList = (entryManifest[listName] as List<dynamic>?) ?? [];
          for (final item in manifestList) {
            final newPath = await restoreFile(item[AppConstants.backupFileNameKey]);
            if (newPath != null) {
              final originalAudio = entry.recordings.firstWhereOrNull((r) => r.path == item[AppConstants.idKey]);
              newRecordings.add(RecordedAudio(
                  path: newPath,
                  duration: originalAudio?.duration ?? Duration.zero,
                  name: item[AppConstants.backupFileNameKey]));
              wasModified = true;
            }
          }
        }

        if (wasModified) {
          final updatedEntry = entry.copyWith(
            cameraPhotos: newCameraPhotos,
            recordings: newRecordings,
            galleryImages: [], // Clear device-dependent assets since they were extracted locally
            galleryAudios: [],
          );
          await journalsBox.put(entry.id, updatedEntry);
        }

        processedEntries++;
        onProgress?.call(0.4 + (0.6 * (processedEntries / totalEntries))); // Progress from 40% to 100%
      }

      // Now that all entries are updated with new local media paths, safe to run GC
      unawaited(cleanUpOrphanedMedia());

      // Force reload UI
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().loadJournalEntries();
      }

      CustomToast.showToast(AppConstants.restoreSuccess);
      return true;
    } catch (e) {
      debugPrint("Restore failed with exception: $e");
      await init();
      CustomToast.showToast(AppConstants.restoreFailed.replaceFirst('%s', e.toString()));
      return false;
    } finally {
      // Guaranteed Cleanup: Wipe extraction folder to prevent storage leaks
      if (tempDir != null && await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  }

  Future<List<JournalEntry>> loadAssetEntities(List<JournalEntry> entries) async {
    List<JournalEntry> updatedEntries = [];
    for (var entry in entries) {
      final loadedGalleryImages = await _loadAssets(entry.galleryImages);
      final loadedGalleryAudios = await _loadAssets(entry.galleryAudios);
      updatedEntries.add(entry.copyWith(
        galleryImages: loadedGalleryImages,
        galleryAudios: loadedGalleryAudios,
        id: entry.id,
        content: entry.content,
        createdAt: entry.createdAt,
        isBookmarked: entry.isBookmarked,
        isReflection: entry.isReflection,
        moodIndex: entry.moodIndex,
        location: entry.location,
        cameraPhotos: entry.cameraPhotos,
        recordings: entry.recordings,
      ));
    }
    return updatedEntries;
  }

  Future<List<AssetEntity>> _loadAssets(List<AssetEntity> placeholders) async {
    if (placeholders.isEmpty) return [];
    List<AssetEntity> loadedAssets = [];
    for (var placeholder in placeholders) {
      try {
        final asset = await AssetEntity.fromId(placeholder.id);
        if (asset != null && await asset.exists) {
          loadedAssets.add(asset);
        }
      } catch (e) {
        debugPrint("Skipping invalid device asset: ${placeholder.id}");
      }
    }
    return loadedAssets;
  }
}

extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}