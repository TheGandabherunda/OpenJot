import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_jot/app/core/models/journal_entry.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../constants.dart';
import '../hive/hive_adapters.dart';

class HiveService extends GetxService {
  late Box<dynamic> settingsBox;
  late Box<JournalEntry> journalsBox;

  // ADDED: Flag to ensure adapters are only registered once.
  bool _adaptersRegistered = false;

  Future<HiveService> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    _registerAdapters();
    settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
    journalsBox =
    await Hive.openBox<JournalEntry>(AppConstants.journalsBoxName);
    return this;
  }

  void _registerAdapters() {
    // FIX: Check if adapters are already registered to prevent HiveError on re-initialization.
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
  Future<void> setFirstLaunch(bool value) async =>
      await settingsBox.put(AppConstants.isFirstLaunchKey, value);
  String get theme =>
      settingsBox.get(AppConstants.themeKey, defaultValue: 'System');
  Future<void> setTheme(String theme) async =>
      await settingsBox.put(AppConstants.themeKey, theme);
  bool get dailyReminder =>
      settingsBox.get(AppConstants.dailyReminderKey, defaultValue: false);
  Future<void> setDailyReminder(bool value) async =>
      await settingsBox.put(AppConstants.dailyReminderKey, value);

  // --- NEW: Getter and Setter for "On This Day" feature ---
  bool get onThisDay =>
      settingsBox.get(AppConstants.onThisDayKey, defaultValue: false);
  Future<void> setOnThisDay(bool value) async =>
      await settingsBox.put(AppConstants.onThisDayKey, value);
  // --- END NEW ---

  TimeOfDay? get reminderTime {
    final timeString = settingsBox.get(AppConstants.reminderTimeKey);
    if (timeString == null) return null;
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> setReminderTime(TimeOfDay time) async => await settingsBox
      .put(AppConstants.reminderTimeKey, '${time.hour}:${time.minute}');
  bool get appLockEnabled =>
      settingsBox.get(AppConstants.appLockEnabledKey, defaultValue: false);
  Future<void> setAppLock(bool value) async =>
      await settingsBox.put(AppConstants.appLockEnabledKey, value);
  String? get appLockPin => settingsBox.get(AppConstants.appLockPinKey);
  Future<void> setAppLockPin(String pin) async =>
      await settingsBox.put(AppConstants.appLockPinKey, pin);

  // --- Journals Box Methods (unchanged) ---
  Future<void> addJournalEntry(JournalEntry entry) async =>
      await journalsBox.put(entry.id, entry);
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

  Future<void> deleteJournalEntry(String id) async =>
      await journalsBox.delete(id);
  List<JournalEntry> getAllJournalEntries() => journalsBox.values.toList();
  ValueListenable<Box<JournalEntry>> getJournalEntriesNotifier() =>
      journalsBox.listenable();

  // --- NEW AND IMPROVED Backup & Restore Methods ---

  /// Requests the necessary permissions for backup and restore based on the OS and SDK version.
  Future<bool> _requestPermissions() async {
    if (Platform.isIOS) {
      // On iOS, photo library permission is typically what's needed.
      final photoStatus = await Permission.photos.request();
      return photoStatus.isGranted;
    }

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;
      List<Permission> permissionsToRequest = [];

      // Android 13 (SDK 33) and above require granular media permissions.
      // The general 'storage' permission no longer provides access to media.
      if (sdkInt >= 33) {
        permissionsToRequest.add(Permission.photos);
        permissionsToRequest.add(Permission.audio);
        // Add Permission.videos if your app handles videos.
      } else {
        // For older Android versions, the 'storage' permission is sufficient.
        permissionsToRequest.add(Permission.storage);
      }

      final Map<Permission, PermissionStatus> statuses =
      await permissionsToRequest.request();
      // Ensure all requested permissions were granted.
      return statuses.values.every((status) => status.isGranted);
    }

    return false; // Deny for other unhandled platforms.
  }

  /// Creates a complete backup including the database and all media files into a single .zip file.
  Future<bool> backupData() async {
    // 1. Request necessary permissions before proceeding.
    final bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      Fluttertoast.showToast(msg: AppConstants.storagePermissionsRequired);
      return false;
    }

    try {
      // 2. Let the user choose where to save the backup file.
      final directoryPath = await FilePicker.platform.getDirectoryPath(
        dialogTitle: AppConstants.selectBackupFolder,
      );
      if (directoryPath == null) return false; // User canceled the picker.

      // 3. Create a temporary directory to stage all files for zipping.
      final tempDir = Directory(
          '${(await getTemporaryDirectory()).path}${AppConstants.backupTempDir}');
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
      await tempDir.create(recursive: true);
      final mediaDir = Directory('${tempDir.path}${AppConstants.mediaDir}');
      await mediaDir.create();

      // 4. Copy Hive database files (.hive and .lock) to the temp directory.
      final appDocDir = await getApplicationDocumentsDirectory();
      for (var boxName in [journalsBox.name, settingsBox.name]) {
        final boxFile =
        File('${appDocDir.path}/$boxName${AppConstants.hiveExtension}');
        final lockFile =
        File('${appDocDir.path}/$boxName${AppConstants.lockExtension}');
        if (await boxFile.exists()) {
          await boxFile
              .copy('${tempDir.path}/$boxName${AppConstants.hiveExtension}');
        }
        if (await lockFile.exists()) {
          await lockFile
              .copy('${tempDir.path}/$boxName${AppConstants.lockExtension}');
        }
      }

      // 5. Copy all media files and create a manifest.
      // The manifest maps original file paths/IDs to new unique filenames in the backup
      // to prevent name collisions and to help with re-linking during restore.
      final mediaManifest = <String, dynamic>{};
      for (final entry in journalsBox.values) {
        final entryManifest = <String, List<Map<String, String>>>{
          AppConstants.cameraPhotosKey: [],
          AppConstants.galleryImagesKey: [],
          AppConstants.galleryAudiosKey: [],
          AppConstants.recordingsKey: [],
        };

        Future<void> processMediaFile(
            String originalPath, String type, String id) async {
          try {
            final sourceFile = File(originalPath);
            if (!await sourceFile.exists()) return; // Skip if file is missing
            // Create a unique name to avoid collisions inside the zip file.
            final backupFileName = '${entry.id}-${p.basename(originalPath)}';
            await sourceFile.copy('${mediaDir.path}/$backupFileName');
            entryManifest[type]!.add({
              AppConstants.idKey: id,
              AppConstants.backupFileNameKey: backupFileName
            });
          } catch (e) {
            debugPrint(AppConstants.backupFileError
                .replaceFirst('%s', originalPath)
                .replaceFirst('%s', e.toString()));
          }
        }

        // Process all media types associated with the journal entry.
        for (final photo in entry.cameraPhotos) {
          await processMediaFile(
              photo.file.path, AppConstants.cameraPhotosKey, photo.file.path);
        }
        for (final audio in entry.recordings) {
          await processMediaFile(
              audio.path, AppConstants.recordingsKey, audio.path);
        }
        for (final asset in entry.galleryImages) {
          final file = await asset.file;
          if (file != null) {
            await processMediaFile(
                file.path, AppConstants.galleryImagesKey, asset.id);
          }
        }
        for (final asset in entry.galleryAudios) {
          final file = await asset.file;
          if (file != null) {
            await processMediaFile(
                file.path, AppConstants.galleryAudiosKey, asset.id);
          }
        }

        if (entryManifest.values.any((list) => list.isNotEmpty)) {
          mediaManifest[entry.id] = entryManifest;
        }
      }

      // 6. Write the manifest to a JSON file in the temp directory.
      final manifestFile =
      File('${tempDir.path}${AppConstants.mediaManifestFileName}');
      await manifestFile.writeAsString(jsonEncode(mediaManifest));

      // 7. Zip the entire temporary directory into a single backup file.
      final backupFileName =
          '${AppConstants.backupFileNamePrefix}${DateTime.now().toIso8601String().replaceAll(':', '-')}${AppConstants.backupFileExtension}';
      final backupFile = File('$directoryPath/$backupFileName');

      // FIX: Switched to an in-memory archive creation process for better reliability.
      // This builds the zip file content and then writes it to disk in one go.
      final archive = Archive();
      await for (final entity
      in tempDir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          final relativePath = p.relative(entity.path, from: tempDir.path);
          final fileBytes = await entity.readAsBytes();
          archive
              .addFile(ArchiveFile(relativePath, fileBytes.length, fileBytes));
        }
      }

      // Encode the archive into a zip format (list of bytes).
      final zipData = ZipEncoder().encode(archive);

      // Check if encoding was successful and write the bytes to the backup file.
      if (zipData != null) {
        await backupFile.writeAsBytes(zipData);
      }

      // 8. Clean up by deleting the temporary directory.
      await tempDir.delete(recursive: true);

      Fluttertoast.showToast(msg: AppConstants.backupCreatedSuccess);
      return true;
    } catch (e) {
      Fluttertoast.showToast(
          msg: AppConstants.backupFailed.replaceFirst('%s', e.toString()));
      debugPrint(
          AppConstants.backupFailed.replaceFirst('%s', e.toString()));
      return false;
    }
  }

  /// Restores data from a complete backup file, making the data self-contained.
  Future<bool> restoreData() async {
    // 1. Request necessary permissions before proceeding.
    final bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      Fluttertoast.showToast(msg: AppConstants.restorePermissionsRequired);
      return false;
    }

    try {
      // 2. Let the user pick the .zip backup file.
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );
      if (result == null || result.files.single.path == null) {
        return false;
      } // User canceled

      final zipFile = File(result.files.single.path!);
      final appDocDir = await getApplicationDocumentsDirectory();

      // 3. Extract the entire backup to a temporary directory.
      final tempDir = Directory(
          '${(await getTemporaryDirectory()).path}${AppConstants.restoreTempDir}');
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
      await tempDir.create(recursive: true);

      final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());
      for (final file in archive) {
        final filename = '${tempDir.path}/${file.name}';
        if (file.isFile) {
          File(filename)
            ..createSync(recursive: true)
            ..writeAsBytesSync(file.content as List<int>);
        } else {
          Directory(filename).createSync(recursive: true);
        }
      }

      // 4. CRITICAL STEP: Close current database boxes, replace the files with the backup, and re-initialize Hive.
      await Hive.close();
      for (var boxName in [journalsBox.name, settingsBox.name]) {
        final tempBoxFile =
        File('${tempDir.path}/$boxName${AppConstants.hiveExtension}');
        final tempLockFile =
        File('${tempDir.path}/$boxName${AppConstants.lockExtension}');
        if (await tempBoxFile.exists()) {
          await tempBoxFile
              .copy('${appDocDir.path}/$boxName${AppConstants.hiveExtension}');
        }
        if (await tempLockFile.exists()) {
          await tempLockFile
              .copy('${appDocDir.path}/$boxName${AppConstants.lockExtension}');
        }
      }
      await init(); // Re-opens boxes with the newly restored database data.

      // 5. Restore media files using the manifest. This makes the data self-contained.
      final manifestFile =
      File('${tempDir.path}${AppConstants.mediaManifestFileName}');
      if (!await manifestFile.exists()) {
        Fluttertoast.showToast(msg: AppConstants.databaseRestoredNoMedia);
        await tempDir.delete(recursive: true);
        // --- CHANGE: Force reload even if there's no media ---
        await Get.find<HomeController>().loadJournalEntries();
        return true;
      }

      final mediaManifest =
      jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
      // Create a persistent directory inside the app's folder to store all media.
      final persistentMediaDir =
      Directory('${appDocDir.path}${AppConstants.mediaDir}');
      await persistentMediaDir.create(recursive: true);

      for (final entry in journalsBox.values) {
        if (!mediaManifest.containsKey(entry.id)) continue;

        final entryManifest = mediaManifest[entry.id] as Map<String, dynamic>;
        bool wasModified = false;

        // After restore, all media (camera, gallery, etc.) will be treated as local, internal files.
        // This removes dependency on the device's gallery, which is crucial for data integrity.
        final newCameraPhotos = <CapturedPhoto>[];
        final newRecordings = <RecordedAudio>[];

        Future<String?> restoreFile(String backupFileName) async {
          try {
            final sourceFile = File('${tempDir.path}/media/$backupFileName');
            if (!await sourceFile.exists()) return null;
            final destPath = '${persistentMediaDir.path}/$backupFileName';
            await sourceFile.copy(destPath);
            return destPath;
          } catch (e) {
            debugPrint(AppConstants.errorRestoringFile
                .replaceFirst('%s', backupFileName)
                .replaceFirst('%s', e.toString()));
            return null;
          }
        }

        // Process all image types, converting them to CapturedPhoto pointing to the new internal path.
        final imageLists = [
          AppConstants.cameraPhotosKey,
          AppConstants.galleryImagesKey
        ];
        for (var listName in imageLists) {
          final manifestList =
              (entryManifest[listName] as List<dynamic>?) ?? [];
          for (final item in manifestList) {
            final newPath =
            await restoreFile(item[AppConstants.backupFileNameKey]);
            if (newPath != null) {
              newCameraPhotos.add(CapturedPhoto(
                  file: XFile(newPath),
                  name: item[AppConstants.backupFileNameKey]));
              wasModified = true;
            }
          }
        }

        // Process all audio types, converting them to RecordedAudio pointing to the new internal path.
        final audioLists = [
          AppConstants.recordingsKey,
          AppConstants.galleryAudiosKey
        ];
        for (var listName in audioLists) {
          final manifestList =
              (entryManifest[listName] as List<dynamic>?) ?? [];
          for (final item in manifestList) {
            final newPath =
            await restoreFile(item[AppConstants.backupFileNameKey]);
            if (newPath != null) {
              final originalAudio = entry.recordings
                  .firstWhereOrNull((r) => r.path == item[AppConstants.idKey]);
              newRecordings.add(RecordedAudio(
                  path: newPath,
                  duration: originalAudio?.duration ?? Duration.zero,
                  name: item[AppConstants.backupFileNameKey]));
              wasModified = true;
            }
          }
        }

        // If media was restored for this entry, update it in the database with the new internal paths
        // and clear the old (and now invalid) gallery references.
        if (wasModified) {
          final updatedEntry = entry.copyWith(
            cameraPhotos: newCameraPhotos,
            recordings: newRecordings,
            galleryImages: [], // Clear old invalid gallery references.
            galleryAudios: [], // Clear old invalid gallery references.
          );
          await journalsBox.put(entry.id, updatedEntry);
        }
      }

      // 6. Clean up the temporary restore directory.
      await tempDir.delete(recursive: true);

      // --- CHANGE START: Force the HomeController to reload all data from the new database ---
      // This crucial step refreshes the UI without needing an app restart.
      await Get.find<HomeController>().loadJournalEntries();
      // --- CHANGE END ---

      Fluttertoast.showToast(
          msg: "Restore successful!", toastLength: Toast.LENGTH_LONG);
      return true;
    } catch (e) {
      await init(); // Attempt to recover to a stable state if restore fails.
      Fluttertoast.showToast(
          msg: AppConstants.restoreFailed.replaceFirst('%s', e.toString()));
      debugPrint(
          AppConstants.restoreFailed.replaceFirst('%s', e.toString()));
      return false;
    }
  }

  // --- Asset Loading Methods (unchanged) ---
  Future<List<JournalEntry>> loadAssetEntities(
      List<JournalEntry> entries) async {
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
      final asset = await AssetEntity.fromId(placeholder.id);
      if (asset != null) {
        loadedAssets.add(asset);
      }
    }
    return loadedAssets;
  }
}

// Helper extension to find an item in a list safely
extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
