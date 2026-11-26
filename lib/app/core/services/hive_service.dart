import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

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
import 'package:open_jot/app/core/services/crypto_service.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pointycastle/api.dart' show InvalidCipherTextException;

import '../../utils/custom_toast.dart';
import '../../utils/mood_helper.dart';
import '../constants.dart';
import '../hive/hive_adapters.dart';

class HiveService extends GetxService {
  late Box<dynamic> settingsBox;
  Box<JournalEntry>? _journalsBox;
  Uint8List? _activeDek;

  bool _adaptersRegistered = false;

  bool get isJournalsBoxOpen => _journalsBox != null && _journalsBox!.isOpen;
  bool get hasActiveDek => _activeDek != null;

  Box<JournalEntry> get journalsBox {
    final box = _journalsBox;
    if (box == null || !box.isOpen) {
      throw StateError('Journals database is locked.');
    }
    return box;
  }

  Future<HiveService> init({bool runGC = true}) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    _registerAdapters();
    settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
    await _migrateReminders();

    if (!dbEncryptionEnabled) {
      _journalsBox = await Hive.openBox<JournalEntry>(AppConstants.journalsBoxName);
      await _runPostOpenJournalSetup(appDocumentDir, runGC: runGC);
    }

    return this;
  }

  Future<void> _runPostOpenJournalSetup(
    Directory appDocumentDir, {
    bool runGC = true,
  }) async {
    await _sanitizeMediaPathsIfNeeded(appDocumentDir);
    await _migrateMoods();
    await _migrateAudioKinds();
    if (runGC) {
      unawaited(cleanUpOrphanedMedia());
    }
  }

  void _setActiveDek(Uint8List dek) {
    _clearActiveDek();
    _activeDek = Uint8List.fromList(dek);
  }

  void _clearActiveDek() {
    if (_activeDek != null) {
      _activeDek!.fillRange(0, _activeDek!.length, 0);
      _activeDek = null;
    }
  }

  Future<void> unlockJournalsBox(Uint8List dek, {bool runGC = true}) async {
    if (isJournalsBoxOpen) return;
    final appDocumentDir = await getApplicationDocumentsDirectory();
    _setActiveDek(dek);
    _journalsBox = await Hive.openBox<JournalEntry>(
      AppConstants.journalsBoxName,
      encryptionCipher: AesGcmHiveCipher(dek),
    );
    await _runPostOpenJournalSetup(appDocumentDir, runGC: runGC);
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().attachJournalListener();
    }
  }

  Future<void> lockJournalsBox() async {
    _clearActiveDek();
    if (_journalsBox != null && _journalsBox!.isOpen) {
      await _journalsBox!.close();
    }
    _journalsBox = null;
  }

  Future<void> _deleteBoxFilesIfPresent(
    String dirPath,
    String boxName, {
    bool keepHive = false,
  }) async {
    if (!keepHive) {
      final hiveFile = File(p.join(dirPath, '$boxName${AppConstants.hiveExtension}'));
      if (await hiveFile.exists()) {
        await hiveFile.delete();
      }
    }
    final lockFile = File(p.join(dirPath, '$boxName${AppConstants.lockExtension}'));
    if (await lockFile.exists()) {
      await lockFile.delete();
    }
  }

  /// Atomically rewrites `journals.hive` using a staged temporary Hive box
  /// so an interruption never corrupts or deletes user journal entries.
  Future<void> _rewriteJournalsBox({Uint8List? cipherKey}) async {
    final currentBox = journalsBox;
    final appDocDir = await getApplicationDocumentsDirectory();
    const tempBoxName = 'journals_migration_tmp';
    final snapshot = currentBox.toMap().map(
          (key, value) => MapEntry(key, value.copyWith()),
        );

    await _deleteBoxFilesIfPresent(appDocDir.path, tempBoxName);

    final stagingBox = await Hive.openBox<JournalEntry>(
      tempBoxName,
      encryptionCipher: cipherKey != null ? AesGcmHiveCipher(cipherKey) : null,
    );
    try {
      if (snapshot.isNotEmpty) {
        await stagingBox.putAll(snapshot);
      }
      if (stagingBox.length != snapshot.length) {
        throw StateError(
          'Database migration count mismatch: expected ${snapshot.length}, got ${stagingBox.length}.',
        );
      }
      await stagingBox.flush();
    } catch (_) {
      await stagingBox.close();
      await _deleteBoxFilesIfPresent(appDocDir.path, tempBoxName);
      rethrow;
    }
    await stagingBox.close();

    await currentBox.close();
    _journalsBox = null;

    await _deleteBoxFilesIfPresent(appDocDir.path, AppConstants.journalsBoxName);
    final stagedFile = File(
      p.join(appDocDir.path, '$tempBoxName${AppConstants.hiveExtension}'),
    );
    final targetFile = File(
      p.join(appDocDir.path, '${AppConstants.journalsBoxName}${AppConstants.hiveExtension}'),
    );
    await stagedFile.rename(targetFile.path);
    await _deleteBoxFilesIfPresent(appDocDir.path, tempBoxName, keepHive: true);

    _journalsBox = await Hive.openBox<JournalEntry>(
      AppConstants.journalsBoxName,
      encryptionCipher: cipherKey != null ? AesGcmHiveCipher(cipherKey) : null,
    );
    if (cipherKey != null) {
      _setActiveDek(cipherKey);
    } else {
      _clearActiveDek();
    }
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().attachJournalListener();
    }
  }

  /// Encrypts the local journal database in-place using a fresh random 256-bit DEK
  /// wrapped with a PBKDF2 key derived from [masterPassword]. Returns the new DEK.
  Future<Uint8List> enableDatabaseEncryption({
    required String masterPassword,
    bool enableBiometrics = false,
  }) async {
    final dek = CryptoService.generateDek();
    final wrapped = await CryptoService.wrapDekWithPassword(
      dek: dek,
      password: masterPassword,
    );

    await _rewriteJournalsBox(cipherKey: dek);

    await settingsBox.put(AppConstants.dbEncryptionEnabledKey, true);
    await settingsBox.put(AppConstants.encryptionKdfSaltKey, wrapped.saltB64);
    await settingsBox.put(AppConstants.encryptionKdfIterationsKey, wrapped.iterations);
    await settingsBox.put(AppConstants.encryptionWrappedDekKey, wrapped.wrappedDekB64);
    await settingsBox.put(AppConstants.encryptionBiometricEnabledKey, enableBiometrics);
    await settingsBox.put(AppConstants.appLockEnabledKey, true);
    await settingsBox.delete(AppConstants.appLockPinKey);

    return dek;
  }

  /// Re-wraps the existing database DEK under [newPassword] without rewriting
  /// journal entries. Throws [InvalidCipherTextException] if [currentPassword] is wrong.
  Future<void> changeMasterPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final saltB64 = encryptionKdfSalt;
    final wrappedDekB64 = encryptionWrappedDek;
    if (!dbEncryptionEnabled || saltB64 == null || wrappedDekB64 == null) {
      throw StateError('Database encryption is not enabled.');
    }
    final dek = await CryptoService.unwrapDekWithPassword(
      password: currentPassword,
      saltB64: saltB64,
      wrappedDekB64: wrappedDekB64,
      iterations: encryptionKdfIterations,
    );
    try {
      final rewrapped = await CryptoService.wrapDekWithPassword(
        dek: dek,
        password: newPassword,
      );
      await settingsBox.put(AppConstants.encryptionKdfSaltKey, rewrapped.saltB64);
      await settingsBox.put(AppConstants.encryptionKdfIterationsKey, rewrapped.iterations);
      await settingsBox.put(AppConstants.encryptionWrappedDekKey, rewrapped.wrappedDekB64);
    } finally {
      dek.fillRange(0, dek.length, 0);
    }
  }

  /// Verifies [masterPassword] and decrypts the local journal database back to
  /// standard unencrypted Hive storage.
  Future<void> disableDatabaseEncryption({
    required String masterPassword,
  }) async {
    final saltB64 = encryptionKdfSalt;
    final wrappedDekB64 = encryptionWrappedDek;
    if (!dbEncryptionEnabled || saltB64 == null || wrappedDekB64 == null) {
      return;
    }
    final dek = await CryptoService.unwrapDekWithPassword(
      password: masterPassword,
      saltB64: saltB64,
      wrappedDekB64: wrappedDekB64,
      iterations: encryptionKdfIterations,
    );
    try {
      if (!isJournalsBoxOpen) {
        await unlockJournalsBox(dek, runGC: false);
      }
      await _rewriteJournalsBox(cipherKey: null);
      await settingsBox.put(AppConstants.dbEncryptionEnabledKey, false);
      await settingsBox.delete(AppConstants.encryptionKdfSaltKey);
      await settingsBox.delete(AppConstants.encryptionKdfIterationsKey);
      await settingsBox.delete(AppConstants.encryptionWrappedDekKey);
      await settingsBox.put(AppConstants.encryptionBiometricEnabledKey, false);
      await settingsBox.put(AppConstants.appLockEnabledKey, false);
      await settingsBox.delete(AppConstants.appLockPinKey);
    } finally {
      dek.fillRange(0, dek.length, 0);
    }
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
        var expectedPath = p.join(persistentMediaDir.path, filename);
        if (!await File(expectedPath).exists()) {
          final prefixedCandidate = p.join(
            persistentMediaDir.path,
            filename.startsWith('${entry.id}-') ? filename : '${entry.id}-$filename',
          );
          if (await File(prefixedCandidate).exists()) {
            expectedPath = prefixedCandidate;
          }
        }

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
        var expectedPath = p.join(persistentMediaDir.path, filename);
        if (!await File(expectedPath).exists()) {
          final prefixedCandidate = p.join(
            persistentMediaDir.path,
            filename.startsWith('${entry.id}-') ? filename : '${entry.id}-$filename',
          );
          if (await File(prefixedCandidate).exists()) {
            expectedPath = prefixedCandidate;
          }
        }

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

          newRecordings.add(RecordedAudio(
            path: expectedPath,
            duration: rec.duration,
            name: rec.name,
            isShared: rec.isShared,
            isMusic: rec.isMusic,
          ));
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

  /// Differentiates external/shared audio from in-app voice recordings without
  /// altering legacy in-app recordings for existing users.
  Future<void> _migrateAudioKinds() async {
    const String audioSchemaKey = 'audio_kind_schema_version';
    if (settingsBox.get(audioSchemaKey, defaultValue: 0) >= 2) {
      return;
    }

    for (final key in journalsBox.keys.toList()) {
      final entry = journalsBox.get(key);
      if (entry == null || entry.recordings.isEmpty) continue;

      bool modified = false;
      final updatedRecordings = <RecordedAudio>[];
      for (final rec in entry.recordings) {
        if (rec.isShared && !rec.isMusic) {
          updatedRecordings.add(RecordedAudio(
            path: rec.path,
            name: rec.name,
            duration: rec.duration,
            isShared: rec.isShared,
            isMusic: true,
          ));
          modified = true;
        } else if (!rec.isShared && rec.isMusic) {
          final basename = p.basename(rec.path);
          final lowerName = rec.name.toLowerCase();
          final isRecordingName =
              basename.contains('OpenJot_recording_') ||
              lowerName.contains('openjot recording') ||
              lowerName.contains('openjot.rec');
          if (isRecordingName) {
            updatedRecordings.add(RecordedAudio(
              path: rec.path,
              name: rec.name,
              duration: rec.duration,
              isShared: rec.isShared,
              isMusic: false,
            ));
            modified = true;
          } else {
            updatedRecordings.add(rec);
          }
        } else {
          updatedRecordings.add(rec);
        }
      }

      if (modified) {
        await journalsBox.put(
          key,
          entry.copyWith(recordings: updatedRecordings),
        );
      }
    }

    await settingsBox.put(audioSchemaKey, 2);
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

  bool get dbEncryptionEnabled =>
      settingsBox.get(AppConstants.dbEncryptionEnabledKey, defaultValue: false);
  String? get encryptionKdfSalt =>
      settingsBox.get(AppConstants.encryptionKdfSaltKey);
  int get encryptionKdfIterations => settingsBox.get(
        AppConstants.encryptionKdfIterationsKey,
        defaultValue: CryptoService.defaultPbkdf2Iterations,
      );
  String? get encryptionWrappedDek =>
      settingsBox.get(AppConstants.encryptionWrappedDekKey);
  bool get encryptionBiometricEnabled => settingsBox.get(
        AppConstants.encryptionBiometricEnabledKey,
        defaultValue: false,
      );
  Future<void> setEncryptionBiometricEnabled(bool value) =>
      settingsBox.put(AppConstants.encryptionBiometricEnabledKey, value);

  bool get shouldShowAppLock => dbEncryptionEnabled || appLockEnabled;

  bool get hideHomeStats =>
      settingsBox.get(AppConstants.hideHomeStatsKey, defaultValue: false);
  Future<void> setHideHomeStats(bool value) =>
      settingsBox.put(AppConstants.hideHomeStatsKey, value);

  bool get hideInsightsStats =>
      settingsBox.get(AppConstants.hideInsightsStatsKey, defaultValue: false);
  Future<void> setHideInsightsStats(bool value) =>
      settingsBox.put(AppConstants.hideInsightsStatsKey, value);

  // --- Custom Mood Palettes (Preserved across backups/restores) ---
  static const String customMoodPalettesKey = 'custom_mood_palettes';

  Map<int, Map<String, String>>? get customMoodPalettes {
    final raw = settingsBox.get(customMoodPalettesKey);
    if (raw == null) return null;
    try {
      final map = <int, Map<String, String>>{};
      (raw as Map).forEach((key, val) {
        final intKey = key is int ? key : int.tryParse(key.toString());
        if (intKey != null && val is Map) {
          map[intKey] = val.map((k, v) => MapEntry(k.toString(), v.toString()));
        }
      });
      return map;
    } catch (_) {
      return null;
    }
  }

  Future<void> setCustomMoodPalettes(Map<int, Map<String, String>> palettes) async {
    await settingsBox.put(customMoodPalettesKey, palettes);
  }

  Future<void> clearCustomMoodPalettes() async {
    await settingsBox.delete(customMoodPalettesKey);
  }

  // --- Journals Box Methods ---
  Future<void> addJournalEntry(JournalEntry entry) =>
      journalsBox.put(entry.id, entry);

  Future<void> updateJournalEntry(JournalEntry entry) async {
    final isTextEmpty = entry.content.toPlainText().trim().isEmpty;
    final isMediaEmpty = entry.galleryImages.isEmpty &&
        entry.cameraPhotos.isEmpty &&
        entry.galleryAudios.isEmpty &&
        entry.recordings.isEmpty;
    final hasMetadata =
        entry.location != null || entry.moodIndex != null || entry.tags.isNotEmpty;

    if (isTextEmpty && isMediaEmpty && !hasMetadata) {
      await deleteJournalEntry(entry.id);
    } else {
      await journalsBox.put(entry.id, entry);
    }
  }

  Future<void> deleteJournalEntry(String id) async {
    await journalsBox.delete(id);
    // Optionally call unawaited(cleanUpOrphanedMedia()) here if you want instant deletion
  }

  List<JournalEntry> getAllJournalEntries() =>
      isJournalsBoxOpen ? journalsBox.values.toList() : <JournalEntry>[];
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

  static Future<void> _runCreateZipInIsolate(
    String targetZipPath,
    List<(String, String)> archiveItems,
  ) {
    return Isolate.run(() {
      final encoder = ZipFileEncoder();
      encoder.create(targetZipPath);
      for (final item in archiveItems) {
        final file = File(item.$1);
        if (file.existsSync()) {
          encoder.addFile(file, item.$2);
        }
      }
      encoder.close();
    });
  }

  static Future<void> _runExtractZipInIsolate(
    String zipPath,
    String destPath,
  ) {
    return Isolate.run(() => extractFileToDisk(zipPath, destPath));
  }

  static const Set<String> _nonPortableSettingKeys = {
    AppConstants.appLockEnabledKey,
    AppConstants.appLockPinKey,
    AppConstants.dbEncryptionEnabledKey,
    AppConstants.encryptionKdfSaltKey,
    AppConstants.encryptionKdfIterationsKey,
    AppConstants.encryptionWrappedDekKey,
    AppConstants.encryptionBiometricEnabledKey,
  };

  Future<File?> _createPortableSettingsBoxFile(Directory appDocDir) async {
    const tempSettingsBoxName = 'settings_backup_tmp';
    await _deleteBoxFilesIfPresent(appDocDir.path, tempSettingsBoxName);
    final stagingBox = await Hive.openBox<dynamic>(tempSettingsBoxName);
    try {
      final filtered = <dynamic, dynamic>{};
      for (final key in settingsBox.keys) {
        if (!_nonPortableSettingKeys.contains(key)) {
          filtered[key] = settingsBox.get(key);
        }
      }
      if (filtered.isNotEmpty) {
        await stagingBox.putAll(filtered);
      }
      await stagingBox.flush();
    } finally {
      await stagingBox.close();
    }
    final file = File(
      p.join(appDocDir.path, '$tempSettingsBoxName${AppConstants.hiveExtension}'),
    );
    return await file.exists() ? file : null;
  }

  Future<File?> _createPortableJournalsBoxFile(Directory appDocDir) async {
    if (!dbEncryptionEnabled) {
      final plainFile = File(
        p.join(
          appDocDir.path,
          '${AppConstants.journalsBoxName}${AppConstants.hiveExtension}',
        ),
      );
      return await plainFile.exists() ? plainFile : null;
    }

    const tempJournalsBoxName = 'journals_backup_plain_tmp';
    await _deleteBoxFilesIfPresent(appDocDir.path, tempJournalsBoxName);
    final stagingBox = await Hive.openBox<JournalEntry>(tempJournalsBoxName);
    try {
      final snapshot = journalsBox.toMap().map(
            (key, value) => MapEntry(key, value.copyWith()),
          );
      if (snapshot.isNotEmpty) {
        await stagingBox.putAll(snapshot);
      }
      await stagingBox.flush();
    } finally {
      await stagingBox.close();
    }
    final file = File(
      p.join(appDocDir.path, '$tempJournalsBoxName${AppConstants.hiveExtension}'),
    );
    return await file.exists() ? file : null;
  }

  Future<bool> backupData({
    String? encryptionPassword,
    void Function(double progress)? onProgress,
    void Function(String status)? onStatusUpdate,
  }) async {
    final bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      CustomToast.showToast(AppConstants.storagePermissionsRequired);
      return false;
    }

    String? zipPath;
    String? encryptedBackupPath;
    Directory? appDocDir;
    try {
      onStatusUpdate?.call(AppConstants.takingBackup);
      // Allow dialog frame to paint cleanly before synchronous/heavy zip I/O.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      appDocDir = await getApplicationDocumentsDirectory();
      final tempDir = await getTemporaryDirectory();

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final isEncryptedExport =
          encryptionPassword != null && encryptionPassword.isNotEmpty;
      final zipTempName = '${AppConstants.backupFileNamePrefix}$timestamp${AppConstants.backupFileExtension}';
      final exportFileName = isEncryptedExport
          ? '${AppConstants.encryptedBackupFileNamePrefix}$timestamp${AppConstants.encryptedBackupFileExtension}'
          : zipTempName;
      zipPath = p.join(tempDir.path, zipTempName);

      debugPrint("Starting memory-safe backup process to: $zipPath");
      onProgress?.call(0.0);

      // 1. Collect files to archive (compression runs off the UI isolate)
      final filesToArchive = <({String sourcePath, String archivePath})>[];
      final seenArchivePaths = <String>{};
      void queueArchiveFile(String sourcePath, String archivePath) {
        if (seenArchivePaths.add(archivePath)) {
          filesToArchive.add((sourcePath: sourcePath, archivePath: archivePath));
        }
      }

      // 2. Add portable Hive database files (unencrypted inside container so
      //    backups restore on any device; whole archive is AES-256-GCM wrapped
      //    when encryptionPassword is set)
      final portableJournalsFile = await _createPortableJournalsBoxFile(appDocDir);
      if (portableJournalsFile != null) {
        queueArchiveFile(
          portableJournalsFile.path,
          '${AppConstants.journalsBoxName}${AppConstants.hiveExtension}',
        );
      }
      final portableSettingsFile = await _createPortableSettingsBoxFile(appDocDir);
      if (portableSettingsFile != null) {
        queueArchiveFile(
          portableSettingsFile.path,
          '${AppConstants.settingsBoxName}${AppConstants.hiveExtension}',
        );
      }

      // 3. Process media files and build manifest
      final mediaManifest = <String, dynamic>{};
      final waveformsManifest = <String, List<double>>{};
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
        Future<void> processMediaFile(
          String originalPath,
          String type,
          String id, {
          bool isAssetEntity = false,
          AssetEntity? asset,
          Map<String, String>? extraMetadata,
          List<double>? waveformBars,
        }) async {
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
                final fallbackFile = File(p.join(appDocDir!.path, 'media', p.basename(originalPath)));
                if (await fallbackFile.exists()) sourceFile = fallbackFile;
              }
            }

            if (sourceFile == null || !await sourceFile.exists()) return;

            // Prevent duplicating ID in file name on subsequent backups
            final basename = p.basename(sourceFile.path);
            final backupMediaName = basename.startsWith(entry.id)
                ? basename
                : '${entry.id}-$basename';

            // Queue file for off-isolate zip compression
            queueArchiveFile(sourceFile.path, 'media/$backupMediaName');

            if (waveformBars != null && waveformBars.isNotEmpty) {
              waveformsManifest[backupMediaName] = waveformBars;
            }

            entryManifest[type]!.add({
              AppConstants.idKey: id,
              AppConstants.backupFileNameKey: backupMediaName,
              if (extraMetadata != null) ...extraMetadata,
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
          final wfRaw = settingsBox.get('audio_waveform_${p.basename(audio.path)}');
          final wfBars = wfRaw is List
              ? wfRaw.whereType<num>().map((e) => e.toDouble()).toList()
              : null;
          await processMediaFile(
            audio.path,
            AppConstants.recordingsKey,
            audio.path,
            extraMetadata: {
              'name': audio.name,
              'durationMs': audio.duration.inMilliseconds.toString(),
              'isShared': audio.isShared ? '1' : '0',
              'isMusic': audio.isMusic ? '1' : '0',
            },
            waveformBars: wfBars,
          );
        }
        for (final asset in entry.galleryImages) {
          await processMediaFile('', AppConstants.galleryImagesKey, asset.id, isAssetEntity: true, asset: asset);
        }
        for (final asset in entry.galleryAudios) {
          await processMediaFile(
            '',
            AppConstants.galleryAudiosKey,
            asset.id,
            isAssetEntity: true,
            asset: asset,
            extraMetadata: {
              'name': asset.title ?? AppConstants.audioTrack,
              'durationMs': (asset.duration * 1000).toString(),
              'isMusic': '1',
            },
          );
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
        if (waveformsManifest.isNotEmpty) 'waveforms': waveformsManifest,
      };

      final manifestJson = jsonEncode(rootManifest);
      final manifestFile = File(p.join(tempDir.path, 'media_manifest.json'));
      await manifestFile.writeAsString(manifestJson);
      queueArchiveFile(manifestFile.path, 'media_manifest.json');

      // 5. Build zip archive in a background isolate so UI spinner stays smooth
      final targetZipPath = zipPath;
      final archiveItems = filesToArchive
          .map<(String, String)>((e) => (e.sourcePath, e.archivePath))
          .toList();
      await _runCreateZipInIsolate(targetZipPath, archiveItems);

      // 6. Export using file_picker (optionally AES-256-GCM encrypting the zip on disk off the UI thread)
      final Uint8List outputBytes;
      if (isEncryptedExport) {
        onStatusUpdate?.call(AppConstants.encryptingBackup);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        encryptedBackupPath = p.join((await getTemporaryDirectory()).path, exportFileName);
        await CryptoService.encryptBackupFile(
          zipPath: zipPath,
          outPath: encryptedBackupPath,
          password: encryptionPassword,
        );
        outputBytes = await File(encryptedBackupPath).readAsBytes();
      } else {
        outputBytes = await File(zipPath).readAsBytes();
      }

      onStatusUpdate?.call(AppConstants.savingBackup);
      final selectedUri = await FilePicker.saveFile(
        dialogTitle: AppConstants.selectBackupFolder,
        fileName: exportFileName,
        bytes: outputBytes,
      );

      if (selectedUri == null) {
        return false;
      }

      CustomToast.showToast(AppConstants.backupCreatedSuccess);
      return true;

    } catch (e) {
      debugPrint("Backup failed with exception: $e");
      CustomToast.showToast(AppConstants.backupFailed.replaceFirst('%s', e.toString()));
      return false;
    } finally {
      // Guaranteed Cleanup: Ensure no massive zip or staging files remain
      if (appDocDir != null) {
        await _deleteBoxFilesIfPresent(appDocDir.path, 'journals_backup_plain_tmp');
        await _deleteBoxFilesIfPresent(appDocDir.path, 'settings_backup_tmp');
      }
      if (zipPath != null) {
        final f = File(zipPath);
        if (await f.exists()) await f.delete();
      }
      if (encryptedBackupPath != null) {
        final f = File(encryptedBackupPath);
        if (await f.exists()) await f.delete();
      }
    }
  }

  Future<bool> restoreData({
    Future<String?> Function({String? initialError})? onRequestBackupPassword,
    void Function(double progress)? onProgress,
    void Function(bool isLoading, String status)? onLoadingStateChanged,
  }) async {
    final bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      CustomToast.showToast(AppConstants.restorePermissionsRequired);
      return false;
    }

    Directory? tempDir;
    File? decryptedZipFile;
    Uint8List? preservedDek;
    Map<String, dynamic>? preservedEncryptionSettings;
    bool hiveWasClosed = false;

    try {
      final file = await FilePicker.pickFile(
        type: FileType.any,
      );
      if (file == null) return false;

      onLoadingStateChanged?.call(true, AppConstants.preparingBackup);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      File selectedFile;
      if (file.path != null) {
        selectedFile = File(file.path!);
      } else {
        final tempPickPath = p.join(
          (await getTemporaryDirectory()).path,
          file.name.isNotEmpty ? file.name : 'temp_restore.bin',
        );
        selectedFile = File(tempPickPath);
        await selectedFile.writeAsBytes(await file.readAsBytes());
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      tempDir = Directory(p.join((await getTemporaryDirectory()).path, 'restore_temp'));
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
      await tempDir.create(recursive: true);

      onProgress?.call(0.05);

      // Peek only the file header first so standard .zip restores stream
      // straight from disk without loading the entire archive into RAM.
      final raf = await selectedFile.open();
      late final Uint8List headerBytes;
      try {
        headerBytes = await raf.read(40);
      } finally {
        await raf.close();
      }
      File zipToExtract;

      if (CryptoService.isEncryptedHeaderPrefix(headerBytes)) {
        if (onRequestBackupPassword == null) {
          CustomToast.showToast(AppConstants.encryptedBackupPasswordRequired);
          return false;
        }
        final decryptedPath = p.join(
          (await getTemporaryDirectory()).path,
          'restore_decrypted.zip',
        );
        decryptedZipFile = File(decryptedPath);
        var decryptedOk = false;
        String? passwordError;
        while (!decryptedOk) {
          onLoadingStateChanged?.call(false, '');
          final password =
              await onRequestBackupPassword(initialError: passwordError);
          if (password == null || password.isEmpty) {
            return false;
          }
          onLoadingStateChanged?.call(true, AppConstants.decryptingBackup);
          await Future<void>.delayed(const Duration(milliseconds: 50));
          try {
            await CryptoService.decryptBackupFile(
              encPath: selectedFile.path,
              outZipPath: decryptedPath,
              password: password,
            );
            decryptedOk = true;
          } on InvalidCipherTextException {
            passwordError = AppConstants.incorrectBackupPassword;
          }
        }
        onLoadingStateChanged?.call(true, AppConstants.restoringBackup);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        zipToExtract = decryptedZipFile;
      } else if (headerBytes.length >= 2 &&
          headerBytes[0] == 0x50 &&
          headerBytes[1] == 0x4B) {
        onLoadingStateChanged?.call(true, AppConstants.restoringBackup);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        zipToExtract = selectedFile;
      } else {
        CustomToast.showToast(AppConstants.invalidBackupFile);
        return false;
      }

      onProgress?.call(0.1); // Notify starting extraction

      // Preserve current device encryption configuration across restore
      if (dbEncryptionEnabled && _activeDek != null) {
        preservedDek = Uint8List.fromList(_activeDek!);
        preservedEncryptionSettings = {
          AppConstants.dbEncryptionEnabledKey: true,
          AppConstants.encryptionKdfSaltKey: encryptionKdfSalt,
          AppConstants.encryptionKdfIterationsKey: encryptionKdfIterations,
          AppConstants.encryptionWrappedDekKey: encryptionWrappedDek,
          AppConstants.encryptionBiometricEnabledKey: encryptionBiometricEnabled,
          AppConstants.appLockEnabledKey: appLockEnabled,
        };
      }

      // Extract zip in a background isolate so spinner animates smoothly
      await _runExtractZipInIsolate(zipToExtract.path, tempDir.path);
      onProgress?.call(0.3);

      // Close Hive before replacing files
      await Hive.close();
      _journalsBox = null;
      hiveWasClosed = true;

      for (var boxName in [AppConstants.journalsBoxName, AppConstants.settingsBoxName]) {
        final tempBoxFile = File(p.join(tempDir.path, '$boxName${AppConstants.hiveExtension}'));
        if (await tempBoxFile.exists()) {
          await tempBoxFile.copy(p.join(appDocDir.path, '$boxName${AppConstants.hiveExtension}'));
        }
      }

      // Open settings first and clear any non-portable lock/encryption metadata
      // that may have come from an older backup before opening restored journals.hive.
      Hive.init(appDocDir.path);
      _registerAdapters();
      settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
      for (final key in _nonPortableSettingKeys) {
        await settingsBox.delete(key);
      }

      // Re-initialize Hive unencrypted first (SKIP GC during restore to prevent race condition)
      await init(runGC: false);
      hiveWasClosed = false;
      onProgress?.call(0.4);

      final persistentMediaDir = Directory(p.join(appDocDir.path, 'media'));
      await persistentMediaDir.create(recursive: true);

      final manifestFile = File(p.join(tempDir.path, 'media_manifest.json'));
      if (!await manifestFile.exists()) {
        await _restoreLegacyMediaWithoutManifest(
          tempDir: tempDir,
          persistentMediaDir: persistentMediaDir,
          onProgress: onProgress,
        );
      } else {
        // Version-safe manifest decoding
        final parsedJson = jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
        Map<String, dynamic> mediaManifest;
        Map<String, dynamic> waveformsManifest = {};
        if (parsedJson.containsKey('version')) {
          mediaManifest = parsedJson['entries'] as Map<String, dynamic>;
          if (parsedJson['waveforms'] is Map<String, dynamic>) {
            waveformsManifest = parsedJson['waveforms'] as Map<String, dynamic>;
          }
        } else {
          mediaManifest = parsedJson; // Fallback for v1 legacy backups
        }

        int processedEntries = 0;
        final journalKeys = journalsBox.keys.toList();
        final totalEntries = journalKeys.isEmpty ? 1 : journalKeys.length;

        for (final key in journalKeys) {
          final entry = journalsBox.get(key);
          if (entry == null || !mediaManifest.containsKey(entry.id)) {
            processedEntries++;
            continue;
          }

          final entryManifest = mediaManifest[entry.id] as Map<String, dynamic>;
          bool wasModified = false;

          final newCameraPhotos = <CapturedPhoto>[];
          final newRecordings = <RecordedAudio>[];

          Future<String?> restoreFile(String backupFileName) async {
            try {
              var sourceFile = File(p.join(tempDir!.path, 'media', backupFileName));
              if (!await sourceFile.exists()) {
                final fallbackSource = File(p.join(tempDir!.path, 'media', p.basename(backupFileName)));
                if (await fallbackSource.exists()) {
                  sourceFile = fallbackSource;
                } else {
                  return null;
                }
              }
              final destPath = p.join(persistentMediaDir.path, p.basename(backupFileName));
              await sourceFile.copy(destPath);
              final wf = waveformsManifest[backupFileName];
              if (wf is List) {
                await settingsBox.put(
                  'audio_waveform_${p.basename(destPath)}',
                  wf.whereType<num>().map((e) => e.toDouble()).toList(),
                );
              }
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
              final backupName = item[AppConstants.backupFileNameKey] as String;
              final newPath = await restoreFile(backupName);
              if (newPath != null) {
                final itemId = item[AppConstants.idKey]?.toString() ?? '';
                final originalAudio = entry.recordings.firstWhereOrNull(
                  (r) => r.path == itemId || p.basename(r.path) == p.basename(itemId),
                );
                final isFromGalleryList = listName == AppConstants.galleryAudiosKey;
                final parsedDurationMs = int.tryParse(item['durationMs']?.toString() ?? '');
                final hasExplicitMusicFlag = item.containsKey('isMusic');
                final bool isMusicItem = isFromGalleryList ||
                    (hasExplicitMusicFlag
                        ? item['isMusic'] == '1'
                        : (originalAudio?.isMusic ?? false));
                final bool isSharedItem =
                    item['isShared'] == '1' || (originalAudio?.isShared ?? false);
                final String displayName =
                    (item['name'] as String?) ?? originalAudio?.name ?? backupName;

                newRecordings.add(RecordedAudio(
                  path: newPath,
                  duration: parsedDurationMs != null
                      ? Duration(milliseconds: parsedDurationMs)
                      : (originalAudio?.duration ?? Duration.zero),
                  name: displayName,
                  isShared: isSharedItem,
                  isMusic: isMusicItem,
                ));
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
            await journalsBox.put(key, updatedEntry);
          }

          processedEntries++;
          onProgress?.call(0.4 + (0.6 * (processedEntries / totalEntries))); // Progress from 40% to 100%
          if (processedEntries % 5 == 0) {
            await Future<void>.delayed(Duration.zero);
          }
        }
      }

      // Re-run audio differentiation migration on restored database in case it
      // came from an older backup before the flag existed.
      await settingsBox.delete('audio_kind_schema_version');
      await _migrateAudioKinds();

      // Now that all entries are updated with new local media paths, safe to run GC
      unawaited(cleanUpOrphanedMedia());

      // Force reload UI
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().loadJournalEntries();
      }

      // Reload custom mood colors from restored settings
      await MoodHelper.reloadFromSettings();
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().rasterizeMoodIcons();
      }

      // Re-encrypt restored database under the device's active encryption key
      // if encryption was enabled before restoring.
      if (preservedDek != null && preservedEncryptionSettings != null) {
        for (final entry in preservedEncryptionSettings.entries) {
          if (entry.value != null) {
            await settingsBox.put(entry.key, entry.value);
          }
        }
        await _rewriteJournalsBox(cipherKey: preservedDek);
      }

      CustomToast.showToast(AppConstants.restoreSuccess);
      return true;
    } catch (e) {
      debugPrint("Restore failed with exception: $e");
      if (hiveWasClosed) {
        if (preservedDek != null && preservedEncryptionSettings != null) {
          final appDocDir = await getApplicationDocumentsDirectory();
          Hive.init(appDocDir.path);
          _registerAdapters();
          settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
          for (final entry in preservedEncryptionSettings.entries) {
            if (entry.value != null) {
              await settingsBox.put(entry.key, entry.value);
            }
          }
          await unlockJournalsBox(preservedDek, runGC: false);
        } else {
          await init();
        }
      }
      CustomToast.showToast(AppConstants.restoreFailed.replaceFirst('%s', e.toString()));
      return false;
    } finally {
      onLoadingStateChanged?.call(false, '');
      preservedDek?.fillRange(0, preservedDek.length, 0);
      if (decryptedZipFile != null && await decryptedZipFile.exists()) {
        await decryptedZipFile.delete();
      }
      // Guaranteed Cleanup: Wipe extraction folder to prevent storage leaks
      if (tempDir != null && await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  }

  static const Set<String> _legacyImageExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
    '.heic',
    '.heif',
    '.gif',
    '.bmp',
    '.dng',
  };

  static const Set<String> _legacyAudioExtensions = {
    '.m4a',
    '.mp3',
    '.wav',
    '.aac',
    '.opus',
    '.ogg',
    '.flac',
    '.amr',
    '.3gp',
    '.wma',
    '.caf',
  };

  /// Restores media from legacy backups that include `media/` files without
  /// a `media_manifest.json` index, matching both explicit paths and prefixed
  /// `<entryId>-<filename>` archives.
  Future<void> _restoreLegacyMediaWithoutManifest({
    required Directory tempDir,
    required Directory persistentMediaDir,
    void Function(double progress)? onProgress,
  }) async {
    final backupMediaDir = Directory(p.join(tempDir.path, 'media'));
    final backupFiles = <File>[];

    if (await backupMediaDir.exists()) {
      for (final entity in backupMediaDir.listSync(recursive: true)) {
        if (entity is File) backupFiles.add(entity);
      }
    }

    // Also include any loose media files placed directly in tempDir root.
    for (final entity in tempDir.listSync()) {
      if (entity is File) {
        final ext = p.extension(entity.path).toLowerCase();
        if (_legacyImageExtensions.contains(ext) ||
            _legacyAudioExtensions.contains(ext)) {
          backupFiles.add(entity);
        }
      }
    }

    if (backupFiles.isEmpty) {
      onProgress?.call(1.0);
      return;
    }

    final consumedPaths = <String>{};
    final journalKeys = journalsBox.keys.toList();
    final totalEntries = journalKeys.isEmpty ? 1 : journalKeys.length;
    int processedEntries = 0;

    for (final key in journalKeys) {
      final entry = journalsBox.get(key);
      if (entry == null) {
        processedEntries++;
        continue;
      }

      final prefix = '${entry.id}-';
      final prefixedForEntry = backupFiles
          .where((f) => p.basename(f.path).startsWith(prefix))
          .toList();

      String stripEntryPrefix(String filename) =>
          filename.startsWith(prefix) ? filename.substring(prefix.length) : filename;

      File? takeMatch(String candidatePathOrName) {
        final target = p.basename(candidatePathOrName);
        if (target.isEmpty) return null;

        for (final file in prefixedForEntry) {
          if (consumedPaths.contains(file.path)) continue;
          final base = p.basename(file.path);
          if (base == target || stripEntryPrefix(base) == target) {
            consumedPaths.add(file.path);
            return file;
          }
        }

        for (final file in backupFiles) {
          if (consumedPaths.contains(file.path)) continue;
          final base = p.basename(file.path);
          if (base == target || base.endsWith('-$target')) {
            consumedPaths.add(file.path);
            return file;
          }
        }
        return null;
      }

      Future<String> copyIntoMedia(File sourceFile) async {
        final destName = p.basename(sourceFile.path);
        final destPath = p.join(persistentMediaDir.path, destName);
        await sourceFile.copy(destPath);
        return destPath;
      }

      bool wasModified = false;
      final newCameraPhotos = <CapturedPhoto>[];
      for (final photo in entry.cameraPhotos) {
        final matched =
            takeMatch(photo.file.path) ?? takeMatch(photo.name);
        if (matched != null) {
          final destPath = await copyIntoMedia(matched);
          final stripped = stripEntryPrefix(p.basename(matched.path));
          newCameraPhotos.add(CapturedPhoto(
            file: XFile(destPath),
            name: photo.name.isNotEmpty ? photo.name : stripped,
          ));
          wasModified = true;
        } else {
          newCameraPhotos.add(photo);
        }
      }

      final newRecordings = <RecordedAudio>[];
      for (final rec in entry.recordings) {
        final matched = takeMatch(rec.path) ?? takeMatch(rec.name);
        if (matched != null) {
          final destPath = await copyIntoMedia(matched);
          newRecordings.add(RecordedAudio(
            path: destPath,
            duration: rec.duration,
            name: rec.name,
            isShared: rec.isShared,
            isMusic: rec.isMusic,
          ));
          wasModified = true;
        } else {
          newRecordings.add(rec);
        }
      }

      // Recover any remaining `<entryId>-*` files (e.g. archived gallery photos/audios)
      bool recoveredGalleryImages = false;
      bool recoveredGalleryAudios = false;
      for (final file in prefixedForEntry) {
        if (consumedPaths.contains(file.path)) continue;
        final base = p.basename(file.path);
        final stripped = stripEntryPrefix(base);
        final ext = p.extension(stripped).toLowerCase();

        if (_legacyImageExtensions.contains(ext)) {
          consumedPaths.add(file.path);
          final destPath = await copyIntoMedia(file);
          newCameraPhotos.add(CapturedPhoto(
            file: XFile(destPath),
            name: stripped,
          ));
          recoveredGalleryImages = true;
          wasModified = true;
        } else if (_legacyAudioExtensions.contains(ext)) {
          consumedPaths.add(file.path);
          final destPath = await copyIntoMedia(file);
          final isVoiceRecording = stripped.startsWith('OpenJot_recording_');
          newRecordings.add(RecordedAudio(
            path: destPath,
            duration: Duration.zero,
            name: stripped,
            isShared: !isVoiceRecording,
            isMusic: !isVoiceRecording,
          ));
          recoveredGalleryAudios = true;
          wasModified = true;
        }
      }

      if (wasModified) {
        await journalsBox.put(
          key,
          entry.copyWith(
            cameraPhotos: newCameraPhotos,
            recordings: newRecordings,
            galleryImages: recoveredGalleryImages ? [] : entry.galleryImages,
            galleryAudios: recoveredGalleryAudios ? [] : entry.galleryAudios,
          ),
        );
      }

      processedEntries++;
      onProgress?.call(0.4 + (0.6 * (processedEntries / totalEntries)));
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