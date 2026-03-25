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

  Future<HiveService> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    _registerAdapters();
    settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
    journalsBox = await Hive.openBox<JournalEntry>(AppConstants.journalsBoxName);
    return this;
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

  bool get dailyReminder =>
      settingsBox.get(AppConstants.dailyReminderKey, defaultValue: false);
  Future<void> setDailyReminder(bool value) =>
      settingsBox.put(AppConstants.dailyReminderKey, value);

  bool get onThisDay =>
      settingsBox.get(AppConstants.onThisDayKey, defaultValue: false);
  Future<void> setOnThisDay(bool value) =>
      settingsBox.put(AppConstants.onThisDayKey, value);

  // NEW: Auto-delete drafts setting (-1 means never)
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

  Future<void> deleteJournalEntry(String id) =>
      journalsBox.delete(id);

  List<JournalEntry> getAllJournalEntries() => journalsBox.values.toList();
  ValueListenable<Box<JournalEntry>> getJournalEntriesNotifier() =>
      journalsBox.listenable();

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

  Future<bool> backupData() async {
    final bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      CustomToast.showToast(AppConstants.storagePermissionsRequired);
      return false;
    }

    try {
      final archive = Archive();
      final appDocDir = await getApplicationDocumentsDirectory();

      debugPrint("Starting backup process...");

      // 1. Add Hive database files
      for (var boxName in [AppConstants.journalsBoxName, AppConstants.settingsBoxName]) {
        final boxFile = File(p.join(appDocDir.path, '$boxName${AppConstants.hiveExtension}'));
        if (await boxFile.exists()) {
          final bytes = await boxFile.readAsBytes();
          archive.addFile(ArchiveFile('$boxName${AppConstants.hiveExtension}', bytes.length, bytes));
          debugPrint("Added Hive box to archive: $boxName");
        } else {
          debugPrint("Hive box file not found: ${boxFile.path}");
        }
      }

      // 2. Process media files and build manifest
      final mediaManifest = <String, dynamic>{};
      final entries = journalsBox.values.toList();
      debugPrint("Processing ${entries.length} entries for media backup");

      for (final entry in entries) {
        final entryManifest = <String, List<Map<String, String>>>{
          AppConstants.cameraPhotosKey: [],
          AppConstants.galleryImagesKey: [],
          AppConstants.galleryAudiosKey: [],
          AppConstants.recordingsKey: [],
        };

        Future<void> processMediaFile(String originalPath, String type, String id) async {
          try {
            final sourceFile = File(originalPath);
            if (!await sourceFile.exists()) return;

            final bytes = await sourceFile.readAsBytes();
            final backupFileName = '${entry.id}-${p.basename(originalPath)}';

            archive.addFile(ArchiveFile('media/$backupFileName', bytes.length, bytes));

            entryManifest[type]!.add({
              AppConstants.idKey: id,
              AppConstants.backupFileNameKey: backupFileName
            });
            debugPrint("Added media file to archive: $backupFileName");
          } catch (e) {
            debugPrint("Error processing media file $originalPath: $e");
          }
        }

        for (final photo in entry.cameraPhotos) {
          await processMediaFile(photo.file.path, AppConstants.cameraPhotosKey, photo.file.path);
        }
        for (final audio in entry.recordings) {
          await processMediaFile(audio.path, AppConstants.recordingsKey, audio.path);
        }
        for (final asset in entry.galleryImages) {
          final file = await asset.file;
          if (file != null) {
            await processMediaFile(file.path, AppConstants.galleryImagesKey, asset.id);
          }
        }
        for (final asset in entry.galleryAudios) {
          final file = await asset.file;
          if (file != null) {
            await processMediaFile(file.path, AppConstants.galleryAudiosKey, asset.id);
          }
        }

        if (entryManifest.values.any((list) => list.isNotEmpty)) {
          mediaManifest[entry.id] = entryManifest;
        }
      }

      // 3. Add Manifest to archive
      final manifestJson = jsonEncode(mediaManifest);
      final manifestBytes = utf8.encode(manifestJson);
      archive.addFile(ArchiveFile('media_manifest.json', manifestBytes.length, manifestBytes));
      debugPrint("Added media manifest to archive");

      // 4. Encode archive to Zip
      final zipData = ZipEncoder().encode(archive);
      if (zipData == null) {
        debugPrint("Zip encoding failed: returned null");
        return false;
      }
      final uint8ZipData = Uint8List.fromList(zipData);
      debugPrint("Zip archive encoded. Size: ${uint8ZipData.length} bytes");

      // 5. Save Zip file
      final backupFileName = '${AppConstants.backupFileNamePrefix}${DateTime.now().toIso8601String().replaceAll(':', '-')}${AppConstants.backupFileExtension}';

      final String? selectedPath = await FilePicker.platform.saveFile(
        dialogTitle: AppConstants.selectBackupFolder,
        fileName: backupFileName,
        type: FileType.custom,
        allowedExtensions: ['zip'],
        bytes: uint8ZipData,
      );

      if (selectedPath == null) {
        debugPrint("User canceled backup file save");
        return false;
      }

      debugPrint("Backup saved successfully to: $selectedPath");
      CustomToast.showToast(AppConstants.backupCreatedSuccess);
      return true;
    } catch (e) {
      debugPrint("Backup failed with exception: $e");
      CustomToast.showToast(AppConstants.backupFailed.replaceFirst('%s', e.toString()));
      return false;
    }
  }

  Future<bool> restoreData() async {
    final bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      CustomToast.showToast(AppConstants.restorePermissionsRequired);
      return false;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );
      if (result == null || result.files.single.path == null) return false;

      final zipFile = File(result.files.single.path!);
      final appDocDir = await getApplicationDocumentsDirectory();

      final tempDir = Directory(p.join((await getTemporaryDirectory()).path, 'restore_temp'));
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
      await tempDir.create(recursive: true);

      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive) {
        final filename = p.join(tempDir.path, file.name);
        if (file.isFile) {
          File(filename)
            ..createSync(recursive: true)
            ..writeAsBytesSync(file.content as List<int>);
        } else {
          Directory(filename).createSync(recursive: true);
        }
      }

      // Close Hive before replacing files
      await Hive.close();

      for (var boxName in [AppConstants.journalsBoxName, AppConstants.settingsBoxName]) {
        final tempBoxFile = File(p.join(tempDir.path, '$boxName${AppConstants.hiveExtension}'));
        if (await tempBoxFile.exists()) {
          await tempBoxFile.copy(p.join(appDocDir.path, '$boxName${AppConstants.hiveExtension}'));
          debugPrint("Restored Hive box file: $boxName");
        }
      }

      // Re-initialize Hive and open boxes
      await init();

      final manifestFile = File(p.join(tempDir.path, 'media_manifest.json'));
      if (!await manifestFile.exists()) {
        debugPrint("No media manifest found in backup. Skipping media restore.");
        await tempDir.delete(recursive: true);
        await Get.find<HomeController>().loadJournalEntries();
        return true;
      }

      final mediaManifest = jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
      final persistentMediaDir = Directory(p.join(appDocDir.path, 'media'));
      await persistentMediaDir.create(recursive: true);

      for (final entry in journalsBox.values) {
        if (!mediaManifest.containsKey(entry.id)) continue;

        final entryManifest = mediaManifest[entry.id] as Map<String, dynamic>;
        bool wasModified = false;

        final newCameraPhotos = <CapturedPhoto>[];
        final newRecordings = <RecordedAudio>[];

        Future<String?> restoreFile(String backupFileName) async {
          try {
            final sourceFile = File(p.join(tempDir.path, 'media', backupFileName));
            if (!await sourceFile.exists()) return null;
            final destPath = p.join(persistentMediaDir.path, backupFileName);
            await sourceFile.copy(destPath);
            return destPath;
          } catch (e) {
            debugPrint("Error restoring media file $backupFileName: $e");
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
            galleryImages: [],
            galleryAudios: [],
          );
          await journalsBox.put(entry.id, updatedEntry);
        }
      }

      await tempDir.delete(recursive: true);

      // Force reload UI
      await Get.find<HomeController>().loadJournalEntries();

      CustomToast.showToast(AppConstants.restoreSuccess);
      return true;
    } catch (e) {
      debugPrint("Restore failed with exception: $e");
      await init();
      CustomToast.showToast(AppConstants.restoreFailed.replaceFirst('%s', e.toString()));
      return false;
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
      final asset = await AssetEntity.fromId(placeholder.id);
      if (asset != null) {
        loadedAssets.add(asset);
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