import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_jot/app/core/models/journal_entry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../hive/hive_adapters.dart';

class HiveService extends GetxService {
  static const String settingsBoxName = 'settings';
  static const String journalsBoxName = 'journals';

  late final Box<dynamic> settingsBox;
  late final Box<JournalEntry> journalsBox;

  Future<HiveService> init() async {
    // 1. Initialize Hive and get the application documents directory
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // 2. Register all necessary adapters
    _registerAdapters();

    // 3. Open Hive boxes
    settingsBox = await Hive.openBox(settingsBoxName);
    journalsBox = await Hive.openBox<JournalEntry>(journalsBoxName);

    return this;
  }

  void _registerAdapters() {
    // Register generated adapters
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(RecordedAudioAdapter());
    Hive.registerAdapter(CapturedPhotoAdapter());
    Hive.registerAdapter(SelectedLocationAdapter());

    // Register custom adapters
    Hive.registerAdapter(LatLngAdapter());
    Hive.registerAdapter(XFileAdapter());
    Hive.registerAdapter(DocumentAdapter());
    Hive.registerAdapter(AssetEntityAdapter());

    // FIX: Register the new DurationAdapter
    Hive.registerAdapter(DurationAdapter());
  }

  // --- Settings Box Methods ---

  bool get isFirstLaunch => settingsBox.get('isFirstLaunch', defaultValue: true);

  Future<void> setFirstLaunch(bool value) async {
    await settingsBox.put('isFirstLaunch', value);
  }

  String get theme => settingsBox.get('theme', defaultValue: 'System');

  Future<void> setTheme(String theme) async {
    await settingsBox.put('theme', theme);
  }

  bool get dailyReminder => settingsBox.get('dailyReminder', defaultValue: false);

  Future<void> setDailyReminder(bool value) async {
    await settingsBox.put('dailyReminder', value);
  }

  TimeOfDay? get reminderTime {
    final timeString = settingsBox.get('reminderTime');
    if (timeString == null) return null;
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> setReminderTime(TimeOfDay time) async {
    await settingsBox.put('reminderTime', '${time.hour}:${time.minute}');
  }

  // --- Journals Box Methods ---

  /// Adds a new journal entry to the database.
  Future<void> addJournalEntry(JournalEntry entry) async {
    await journalsBox.put(entry.id, entry);
  }

  /// Updates an existing journal entry. If the entry becomes empty (no text or media),
  /// it will be deleted instead.
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

  /// Deletes a journal entry by its ID.
  Future<void> deleteJournalEntry(String id) async {
    await journalsBox.delete(id);
  }

  /// Retrieves all journal entries.
  List<JournalEntry> getAllJournalEntries() {
    return journalsBox.values.toList();
  }

  /// Provides a listenable for real-time UI updates.
  ValueListenable<Box<JournalEntry>> getJournalEntriesNotifier() {
    return journalsBox.listenable();
  }

  // --- Backup & Restore Methods ---

  Future<bool> backupData() async {
    if (await Permission.storage.request().isGranted) {
      try {
        final path = await FilePicker.platform.getDirectoryPath(
          dialogTitle: 'Select a folder to save the backup',
        );

        if (path == null) return false; // User canceled

        final backupFile = File('$path/OpenJot-Backup-${DateTime.now().toIso8601String()}.zip');
        final encoder = ZipFileEncoder();
        encoder.create(backupFile.path);

        final journalsPath = journalsBox.path;
        final settingsPath = settingsBox.path;

        if (journalsPath != null) {
          encoder.addFile(File(journalsPath));
        }
        if (settingsPath != null) {
          encoder.addFile(File(settingsPath));
        }

        encoder.close();
        Get.snackbar('Success', 'Backup created successfully at ${backupFile.path}');
        return true;
      } catch (e) {
        Get.snackbar('Error', 'Failed to create backup: $e');
        return false;
      }
    }
    Fluttertoast.showToast(
      msg: "Storage permission is required to create a backup.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return false;
  }

  Future<bool> restoreData() async {
    if (await Permission.storage.request().isGranted) {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['zip'],
        );

        if (result == null || result.files.single.path == null) {
          return false; // User canceled
        }

        final zipFile = File(result.files.single.path!);
        final destinationDir = await getApplicationDocumentsDirectory();

        // Close boxes before overwriting files
        await journalsBox.close();
        await settingsBox.close();

        final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());

        for (final file in archive) {
          final filename = file.name;
          if (file.isFile) {
            final data = file.content as List<int>;
            File('${destinationDir.path}/$filename')
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          }
        }

        // Re-initialize the service to reopen boxes with restored data
        await init();

        Get.snackbar('Success', 'Data restored successfully. Please restart the app.');
        return true;
      } catch (e) {
        // If restore fails, try to re-initialize to avoid a corrupted state
        await init();
        Get.snackbar('Error', 'Failed to restore data: $e');
        return false;
      }
    }
    Fluttertoast.showToast(
      msg: "Storage permission is required to restore data.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return false;
  }

  /// Asynchronously loads AssetEntities for a list of journal entries.
  /// This is needed because AssetEntity cannot be loaded synchronously.
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
