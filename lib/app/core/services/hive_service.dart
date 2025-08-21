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
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../hive/hive_adapters.dart';

class HiveService extends GetxService {
  static const String settingsBoxName = 'settings';
  static const String journalsBoxName = 'journals';

  late Box<dynamic> settingsBox;
  late Box<JournalEntry> journalsBox;

  // ADDED: Flag to ensure adapters are only registered once.
  bool _adaptersRegistered = false;

  Future<HiveService> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    _registerAdapters();
    settingsBox = await Hive.openBox(settingsBoxName);
    journalsBox = await Hive.openBox<JournalEntry>(journalsBoxName);
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

  // --- Settings Box Methods (unchanged) ---
  bool get isFirstLaunch => settingsBox.get('isFirstLaunch', defaultValue: true);
  Future<void> setFirstLaunch(bool value) async => await settingsBox.put('isFirstLaunch', value);
  String get theme => settingsBox.get('theme', defaultValue: 'System');
  Future<void> setTheme(String theme) async => await settingsBox.put('theme', theme);
  bool get dailyReminder => settingsBox.get('dailyReminder', defaultValue: false);
  Future<void> setDailyReminder(bool value) async => await settingsBox.put('dailyReminder', value);
  TimeOfDay? get reminderTime {
    final timeString = settingsBox.get('reminderTime');
    if (timeString == null) return null;
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
  Future<void> setReminderTime(TimeOfDay time) async => await settingsBox.put('reminderTime', '${time.hour}:${time.minute}');
  bool get appLockEnabled => settingsBox.get('appLockEnabled', defaultValue: false);
  Future<void> setAppLock(bool value) async => await settingsBox.put('appLockEnabled', value);
  String? get appLockPin => settingsBox.get('appLockPin');
  Future<void> setAppLockPin(String pin) async => await settingsBox.put('appLockPin', pin);

  // --- Journals Box Methods (unchanged) ---
  Future<void> addJournalEntry(JournalEntry entry) async => await journalsBox.put(entry.id, entry);
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
  Future<void> deleteJournalEntry(String id) async => await journalsBox.delete(id);
  List<JournalEntry> getAllJournalEntries() => journalsBox.values.toList();
  ValueListenable<Box<JournalEntry>> getJournalEntriesNotifier() => journalsBox.listenable();

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

      final Map<Permission, PermissionStatus> statuses = await permissionsToRequest.request();
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
      Fluttertoast.showToast(msg: "Storage and media permissions are required to create a backup.");
      return false;
    }

    try {
      // 2. Let the user choose where to save the backup file.
      final directoryPath = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select a folder to save the backup',
      );
      if (directoryPath == null) return false; // User canceled the picker.

      // 3. Create a temporary directory to stage all files for zipping.
      final tempDir = Directory('${(await getTemporaryDirectory()).path}/backup_temp');
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
      await tempDir.create(recursive: true);
      final mediaDir = Directory('${tempDir.path}/media');
      await mediaDir.create();

      // 4. Copy Hive database files (.hive and .lock) to the temp directory.
      final appDocDir = await getApplicationDocumentsDirectory();
      for (var boxName in [journalsBox.name, settingsBox.name]) {
        final boxFile = File('${appDocDir.path}/$boxName.hive');
        final lockFile = File('${appDocDir.path}/$boxName.lock');
        if (await boxFile.exists()) await boxFile.copy('${tempDir.path}/$boxName.hive');
        if (await lockFile.exists()) await lockFile.copy('${tempDir.path}/$boxName.lock');
      }

      // 5. Copy all media files and create a manifest.
      // The manifest maps original file paths/IDs to new unique filenames in the backup
      // to prevent name collisions and to help with re-linking during restore.
      final mediaManifest = <String, dynamic>{};
      for (final entry in journalsBox.values) {
        final entryManifest = <String, List<Map<String, String>>>{
          'cameraPhotos': [], 'galleryImages': [], 'galleryAudios': [], 'recordings': [],
        };

        Future<void> processMediaFile(String originalPath, String type, String id) async {
          try {
            final sourceFile = File(originalPath);
            if (!await sourceFile.exists()) return; // Skip if file is missing
            // Create a unique name to avoid collisions inside the zip file.
            final backupFileName = '${entry.id}-${p.basename(originalPath)}';
            await sourceFile.copy('${mediaDir.path}/$backupFileName');
            entryManifest[type]!.add({'id': id, 'backupFileName': backupFileName});
          } catch (e) {
            debugPrint('Could not back up file $originalPath: $e');
          }
        }

        // Process all media types associated with the journal entry.
        for (final photo in entry.cameraPhotos) await processMediaFile(photo.file.path, 'cameraPhotos', photo.file.path);
        for (final audio in entry.recordings) await processMediaFile(audio.path, 'recordings', audio.path);
        for (final asset in entry.galleryImages) {
          final file = await asset.file;
          if (file != null) await processMediaFile(file.path, 'galleryImages', asset.id);
        }
        for (final asset in entry.galleryAudios) {
          final file = await asset.file;
          if (file != null) await processMediaFile(file.path, 'galleryAudios', asset.id);
        }

        if (entryManifest.values.any((list) => list.isNotEmpty)) {
          mediaManifest[entry.id] = entryManifest;
        }
      }

      // 6. Write the manifest to a JSON file in the temp directory.
      final manifestFile = File('${tempDir.path}/media_manifest.json');
      await manifestFile.writeAsString(jsonEncode(mediaManifest));

      // 7. Zip the entire temporary directory into a single backup file.
      final backupFileName = 'OpenJot-Backup-${DateTime.now().toIso8601String().replaceAll(':', '-')}.zip';
      final backupFile = File('$directoryPath/$backupFileName');

      // FIX: Switched to an in-memory archive creation process for better reliability.
      // This builds the zip file content and then writes it to disk in one go.
      final archive = Archive();
      await for (final entity in tempDir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          final relativePath = p.relative(entity.path, from: tempDir.path);
          final fileBytes = await entity.readAsBytes();
          archive.addFile(ArchiveFile(relativePath, fileBytes.length, fileBytes));
        }
      }

      // Encode the archive into a zip format (list of bytes).
      final zipData = ZipEncoder().encode(archive);

      // Check if encoding was successful and write the bytes to the backup file.
      if (zipData != null) {
        await backupFile.writeAsBytes(zipData);
      } else {
        throw Exception("Failed to encode the backup file.");
      }

      // 8. Clean up by deleting the temporary directory.
      await tempDir.delete(recursive: true);

      Fluttertoast.showToast(msg: "Backup created successfully!");
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to create backup: $e");
      debugPrint('Backup failed: $e');
      return false;
    }
  }

  /// Restores data from a complete backup file, making the data self-contained.
  Future<bool> restoreData() async {
    // 1. Request necessary permissions before proceeding.
    final bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      Fluttertoast.showToast(msg: "Storage and media permissions are required to restore data.");
      return false;
    }

    try {
      // 2. Let the user pick the .zip backup file.
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['zip'],
      );
      if (result == null || result.files.single.path == null) return false; // User canceled

      final zipFile = File(result.files.single.path!);
      final appDocDir = await getApplicationDocumentsDirectory();

      // 3. Extract the entire backup to a temporary directory.
      final tempDir = Directory('${(await getTemporaryDirectory()).path}/restore_temp');
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
      await tempDir.create(recursive: true);

      final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());
      for (final file in archive) {
        final filename = '${tempDir.path}/${file.name}';
        if (file.isFile) {
          File(filename)..createSync(recursive: true)..writeAsBytesSync(file.content as List<int>);
        } else {
          Directory(filename).createSync(recursive: true);
        }
      }

      // 4. CRITICAL STEP: Close current database boxes, replace the files with the backup, and re-initialize Hive.
      await Hive.close();
      for (var boxName in [journalsBox.name, settingsBox.name]) {
        final tempBoxFile = File('${tempDir.path}/$boxName.hive');
        final tempLockFile = File('${tempDir.path}/$boxName.lock');
        if (await tempBoxFile.exists()) await tempBoxFile.copy('${appDocDir.path}/$boxName.hive');
        if (await tempLockFile.exists()) await tempLockFile.copy('${appDocDir.path}/$boxName.lock');
      }
      await init(); // Re-opens boxes with the newly restored database data.

      // 5. Restore media files using the manifest. This makes the data self-contained.
      final manifestFile = File('${tempDir.path}/media_manifest.json');
      if (!await manifestFile.exists()) {
        Fluttertoast.showToast(msg: "Database restored. No media found in backup.");
        await tempDir.delete(recursive: true);
        return true;
      }

      final mediaManifest = jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
      // Create a persistent directory inside the app's folder to store all media.
      final persistentMediaDir = Directory('${appDocDir.path}/media');
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
            debugPrint('Error restoring file $backupFileName: $e');
            return null;
          }
        }

        // Process all image types, converting them to CapturedPhoto pointing to the new internal path.
        final imageLists = ['cameraPhotos', 'galleryImages'];
        for (var listName in imageLists) {
          final manifestList = (entryManifest[listName] as List<dynamic>?) ?? [];
          for (final item in manifestList) {
            final newPath = await restoreFile(item['backupFileName']);
            if (newPath != null) {
              newCameraPhotos.add(CapturedPhoto(file: XFile(newPath), name: item['backupFileName']));
              wasModified = true;
            }
          }
        }

        // Process all audio types, converting them to RecordedAudio pointing to the new internal path.
        final audioLists = ['recordings', 'galleryAudios'];
        for (var listName in audioLists) {
          final manifestList = (entryManifest[listName] as List<dynamic>?) ?? [];
          for (final item in manifestList) {
            final newPath = await restoreFile(item['backupFileName']);
            if (newPath != null) {
              final originalAudio = entry.recordings.firstWhereOrNull((r) => r.path == item['id']);
              newRecordings.add(RecordedAudio(path: newPath, duration: originalAudio?.duration ?? Duration.zero, name: item['backupFileName']));
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

      // UPDATED: Changed the toast message to be more informative.
      Fluttertoast.showToast(msg: "Restore successful. A restart is recommended to apply all changes.", toastLength: Toast.LENGTH_LONG);
      return true;
    } catch (e) {
      await init(); // Attempt to recover to a stable state if restore fails.
      Fluttertoast.showToast(msg: "Failed to restore data: $e");
      debugPrint('Restore failed: $e');
      return false;
    }
  }

  // --- Asset Loading Methods (unchanged) ---
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

// Helper extension to find an item in a list safely
extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
