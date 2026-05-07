import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/models/journal_entry.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DailyYouMigrationService extends GetxService {
  final HiveService _hiveService = Get.find<HiveService>();

  Future<int> importFromDailyYou(String zipPath, {void Function(String status)? onStatusUpdate}) async {
    Directory? tempDir;
    Database? db;
    int importedCount = 0;

    try {
      onStatusUpdate?.call("Extracting backup...");
      tempDir = Directory(p.join((await getTemporaryDirectory()).path, 'daily_you_import_${DateTime.now().millisecondsSinceEpoch}'));
      await tempDir.create(recursive: true);

      // Extract ZIP
      await extractFileToDisk(zipPath, tempDir.path);

      final dbPath = p.join(tempDir.path, 'daily_you.db');
      if (!await File(dbPath).exists()) {
        throw Exception("Daily You database not found in backup.");
      }

      onStatusUpdate?.call("Parsing database...");
      db = await openDatabase(dbPath, readOnly: true);

      // Fetch entries
      final List<Map<String, dynamic>> entriesRaw = await db.query('entries');
      // Fetch images
      final List<Map<String, dynamic>> imagesRaw = await db.query('entry_images');

      final appDocDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory(p.join(appDocDir.path, 'media'));
      await mediaDir.create(recursive: true);

      final existingEntries = _hiveService.getAllJournalEntries();

      for (var entryMap in entriesRaw) {
        final String text = entryMap['text'] ?? "";
        final DateTime createdAt = DateTime.parse(entryMap['time_create']);
        final int? dailyYouMood = entryMap['mood'];

        // Map Mood Index
        // Daily You: -2 (VS), -1 (S), 0 (N), 1 (H), 2 (VH)
        // OpenJot: 0 (VU), 1 (U), 2 (SU), 3 (N), 4 (SP), 5 (P), 6 (VP)
        int? mappedMood;
        if (dailyYouMood != null) {
          switch (dailyYouMood) {
            case -2: mappedMood = 0; break; // Very Sad -> Very Unpleasant
            case -1: mappedMood = 1; break; // Sad -> Unpleasant
            case 0:  mappedMood = 3; break; // Neutral -> Neutral
            case 1:  mappedMood = 5; break; // Happy -> Pleasant
            case 2:  mappedMood = 6; break; // Very Happy -> Very Pleasant
          }
        }

        // Deduplication: Check if an entry with same content and createdAt exists
        bool isDuplicate = existingEntries.any((e) => 
          e.content.toPlainText().trim() == text.trim() && 
          e.createdAt.millisecondsSinceEpoch == createdAt.millisecondsSinceEpoch
        );

        if (isDuplicate) continue;

        onStatusUpdate?.call("Importing entry from ${createdAt.toLocal().toString().split(' ')[0]}...");

        // Process images for this entry
        final entryId = entryMap['id'];
        final entryImagesRaw = imagesRaw.where((img) => img['entry_id'] == entryId).toList();
        final List<CapturedPhoto> cameraPhotos = [];

        for (var imgMap in entryImagesRaw) {
          final String originalFileName = p.basename(imgMap['img_path']);
          final sourceFile = File(p.join(tempDir.path, 'Images', originalFileName));
          
          if (await sourceFile.exists()) {
            final String newFileName = 'OpenJot_image_${const Uuid().v4()}${p.extension(originalFileName)}';
            final destPath = p.join(mediaDir.path, newFileName);
            await sourceFile.copy(destPath);
            cameraPhotos.add(CapturedPhoto(file: XFile(destPath), name: newFileName));
          }
        }

        // Create JournalEntry
        // Convert Markdown text to Delta for Quill using markdown_quill 4.3.0 API
        Document doc;
        try {
          final mdDocument = md.Document(
            encodeHtml: false,
            extensionSet: md.ExtensionSet.gitHubFlavored,
          );
          final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
          final delta = mdToDelta.convert(text);
          doc = Document.fromDelta(delta);
        } catch (e) {
          debugPrint("Markdown conversion error for entry $entryId: $e. Falling back to plain text.");
          doc = Document()..insert(0, text);
        }
        
        final newEntry = JournalEntry(
          id: const Uuid().v4(),
          content: doc,
          createdAt: createdAt,
          moodIndex: mappedMood,
          cameraPhotos: cameraPhotos,
        );

        await _hiveService.addJournalEntry(newEntry);
        importedCount++;
      }

      return importedCount;
    } catch (e) {
      debugPrint("Daily You Import error: $e");
      rethrow;
    } finally {
      await db?.close();
      if (tempDir != null && await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  }
}
