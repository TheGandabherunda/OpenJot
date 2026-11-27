import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/hive/hive_adapters.dart';
import 'package:open_jot/app/core/models/journal_entry.dart';
import 'package:open_jot/app/core/services/crypto_service.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:path/path.dart' as p;

void _registerTestAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(JournalEntryAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(RecordedAudioAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(CapturedPhotoAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(SelectedLocationAdapter());
  }
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(LatLngAdapter());
  }
  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(XFileAdapter());
  }
  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(DocumentAdapter());
  }
  if (!Hive.isAdapterRegistered(8)) {
    Hive.registerAdapter(AssetEntityAdapter());
  }
  if (!Hive.isAdapterRegistered(9)) {
    Hive.registerAdapter(DurationAdapter());
  }
}

void main() {
  test(
    'createZipInIsolate and encrypted backup round-trip non-empty archive and restored data re-backs up',
    () async {
      final rootDir = await Directory.systemTemp.createTemp('openjot_backup_');
      final dbDir = Directory(p.join(rootDir.path, 'db'))..createSync();
      final extractDir = Directory(p.join(rootDir.path, 'extract'))
        ..createSync();
      final reBackupZipPath = p.join(rootDir.path, 'rebackup.zip');
      final mediaBytes = List<int>.generate(2048, (i) => (i * 13) & 0xff);
      final mediaFile = File(p.join(rootDir.path, 'entry1-photo.jpg'))
        ..writeAsBytesSync(mediaBytes);
      final manifestFile = File(p.join(rootDir.path, 'media_manifest.json'))
        ..writeAsStringSync(
          jsonEncode({
            'version': '1.0.0',
            'entries': {
              'entry1': {
                AppConstants.cameraPhotosKey: [
                  {
                    AppConstants.idKey: mediaFile.path,
                    AppConstants.backupFileNameKey: 'entry1-photo.jpg',
                  },
                ],
              },
            },
          }),
        );

      try {
        Hive.init(dbDir.path);
        _registerTestAdapters();

        final settingsBox = await Hive.openBox<dynamic>(
          AppConstants.settingsBoxName,
        );
        await settingsBox.put(AppConstants.themeKey, AppConstants.themeDark);
        await settingsBox.flush();

        final journalsBox = await Hive.openBox<JournalEntry>(
          AppConstants.journalsBoxName,
        );
        final doc = Document()..insert(0, 'Hello OpenJot backup!');
        await journalsBox.put(
          'entry1',
          JournalEntry(
            id: 'entry1',
            content: doc,
            createdAt: DateTime(2026, 11, 27),
          ),
        );
        await journalsBox.flush();
        await Hive.close();

        final zipPath = p.join(rootDir.path, 'backup.zip');
        final items = <(String, String)>[
          (
            p.join(
              dbDir.path,
              '${AppConstants.journalsBoxName}${AppConstants.hiveExtension}',
            ),
            '${AppConstants.journalsBoxName}${AppConstants.hiveExtension}',
          ),
          (
            p.join(
              dbDir.path,
              '${AppConstants.settingsBoxName}${AppConstants.hiveExtension}',
            ),
            '${AppConstants.settingsBoxName}${AppConstants.hiveExtension}',
          ),
          (mediaFile.path, 'media/entry1-photo.jpg'),
          (manifestFile.path, 'media_manifest.json'),
        ];

        await HiveService.createZipInIsolate(zipPath, items);
        final zipFile = File(zipPath);
        expect(await zipFile.exists(), isTrue);
        // Empty ZIP is 22 bytes; real archive must include all queued files.
        expect(await zipFile.length(), greaterThan(500));

        // Verify central directory entries in raw zip.
        final input = InputFileStream(zipPath);
        try {
          final archive = ZipDecoder().decodeStream(input);
          final names = archive.files.map((f) => f.name).toSet();
          expect(names, contains('journals.hive'));
          expect(names, contains('settings.hive'));
          expect(names, contains('media/entry1-photo.jpg'));
          expect(names, contains('media_manifest.json'));
        } finally {
          await input.close();
        }

        // Encrypt & decrypt .openjot container and verify size > 78 bytes.
        final encPath = p.join(rootDir.path, 'backup.openjot');
        await CryptoService.encryptBackupFile(
          zipPath: zipPath,
          outPath: encPath,
          password: 'BackupPassword!99',
          iterations: 5000,
        );
        final encFile = File(encPath);
        expect(await encFile.length(), greaterThan(500));

        final decryptedZipPath = p.join(rootDir.path, 'decrypted.zip');
        await CryptoService.decryptBackupFile(
          encPath: encPath,
          outZipPath: decryptedZipPath,
          password: 'BackupPassword!99',
        );

        await HiveService.extractZipInIsolate(decryptedZipPath, extractDir.path);
        final restoredPhoto = File(
          p.join(extractDir.path, 'media', 'entry1-photo.jpg'),
        );
        expect(await restoredPhoto.exists(), isTrue);
        expect(await restoredPhoto.readAsBytes(), equals(mediaBytes));

        // Reopen restored boxes and re-zip to verify post-restore backup works.
        Hive.init(extractDir.path);
        final reopenedSettings = await Hive.openBox<dynamic>(
          AppConstants.settingsBoxName,
        );
        expect(
          reopenedSettings.get(AppConstants.themeKey),
          equals(AppConstants.themeDark),
        );
        final reopenedJournals = await Hive.openBox<JournalEntry>(
          AppConstants.journalsBoxName,
        );
        expect(reopenedJournals.length, equals(1));
        expect(
          reopenedJournals.get('entry1')?.content.toPlainText().trim(),
          equals('Hello OpenJot backup!'),
        );
        await reopenedJournals.flush();
        await reopenedSettings.flush();
        await Hive.close();

        await HiveService.createZipInIsolate(reBackupZipPath, [
          (
            p.join(extractDir.path, 'journals.hive'),
            'journals.hive',
          ),
          (
            p.join(extractDir.path, 'settings.hive'),
            'settings.hive',
          ),
          (restoredPhoto.path, 'media/entry1-photo.jpg'),
        ]);
        expect(await File(reBackupZipPath).length(), greaterThan(500));
      } finally {
        await Hive.close();
        await rootDir.delete(recursive: true);
      }
    },
  );
}
