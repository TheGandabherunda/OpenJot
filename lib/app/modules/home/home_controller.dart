import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../core/constants.dart';
import '../../core/models/journal_entry.dart';

class HomeController extends GetxController {
  final _hiveService = Get.find<HiveService>();
  final journalEntries = <JournalEntry>[].obs;
  final draftEntries = <JournalEntry>[].obs;

  final audioPlayer = AudioPlayer();
  final plainTextCache = <String, String>{}.obs;

  // Pre-rasterized mood images for maximum scroll performance
  final moodImages = <int, ui.Image>{}.obs;
  // Large rasterized images for the selector to maintain sharpness (480x480)
  final moodImagesLarge = <int, ui.Image>{}.obs;

  // Reactive audio state
  final currentlyPlayingPath = RxnString();
  final playerState = Rx<PlayerState>(PlayerState.stopped);

  final currentSortType = 'time'.obs;
  final Map<String, String> _sortTypeDisplayNames = {
    'time': 'Entry time',
    'bookmark': 'Bookmark first',
    'reflection': 'Reflection first',
    'media': 'With media first',
    'text': 'Text only first',
    'location': 'With location first',
    'mood': 'With mood first',
    'tags': 'With tags first',
  };

  List<String> get allUniqueTags {
    final tags = <String>{};
    for (var entry in journalEntries) {
      tags.addAll(entry.tags);
    }
    for (var entry in draftEntries) {
      tags.addAll(entry.tags);
    }
    return tags.toList();
  }

  String get currentSortTypeDisplayName =>
      _sortTypeDisplayNames[currentSortType.value] ?? 'Entry time';

  @override
  void onInit() {
    super.onInit();
    _hiveService.getJournalEntriesNotifier().addListener(loadJournalEntries);
    loadJournalEntries();

    // Listen to audio player state changes globally
    audioPlayer.onPlayerStateChanged.listen((state) {
      playerState.value = state;
      if (state == PlayerState.completed) {
        currentlyPlayingPath.value = null;
      }
    });

    // Pre-cache mood SVGs to prevent scroll lag
    for (var mood in AppConstants.moods) {
      final loader = SvgAssetLoader(mood['svg']!);
      svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
    // Also pre-cache app icon
    const iconLoader = SvgAssetLoader('assets/app_icon.svg');
    svg.cache.putIfAbsent(iconLoader.cacheKey(null), () => iconLoader.loadBytes(null));

    // Pre-rasterize mood icons for buttery smooth scrolling
    _rasterizeMoodIcons();
  }

  Future<void> _rasterizeMoodIcons() async {
    // 3x scale for high-density displays (22w * 3 = 66 pixels)
    const double targetSizeSmall = 66.0;
    // 3x scale for the large selector (160w * 3 = 480 pixels)
    const double targetSizeLarge = 480.0;

    for (int i = 0; i < AppConstants.moods.length; i++) {
      try {
        final loader = SvgAssetLoader(AppConstants.moods[i]['svg']!);
        final pictureInfo = await vg.loadPicture(loader, null);

        // Rasterize Small
        moodImages[i] = await _renderToImage(pictureInfo, targetSizeSmall);
        
        // Rasterize Large
        moodImagesLarge[i] = await _renderToImage(pictureInfo, targetSizeLarge);
      } catch (e) {
        print('Failed to rasterize mood icon $i: $e');
      }
    }
  }

  Future<ui.Image> _renderToImage(PictureInfo pictureInfo, double targetSize) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final scale = targetSize / pictureInfo.size.width;
    canvas.scale(scale);
    canvas.drawPicture(pictureInfo.picture);

    return await recorder.endRecording().toImage(
          targetSize.toInt(),
          targetSize.toInt(),
        );
  }

  @override
  void onClose() {
    _hiveService.getJournalEntriesNotifier().removeListener(loadJournalEntries);
    audioPlayer.dispose();
    super.onClose();
  }

  Future<void> loadJournalEntries() async {
    final entriesFromDb = _hiveService.getAllJournalEntries();

    // --- NEW: Auto-delete expired drafts logic ---
    final autoDeleteDays = _hiveService.autoDeleteDraftsDays;
    if (autoDeleteDays > 0) {
      final now = DateTime.now();
      final expiredDrafts = entriesFromDb.where((e) {
        if (e.isDraft) {
          final diff = now.difference(e.createdAt).inDays;
          return diff >= autoDeleteDays;
        }
        return false;
      }).toList();

      for (var draft in expiredDrafts) {
        _hiveService.deleteJournalEntry(draft.id);
        entriesFromDb.removeWhere((e) => e.id == draft.id);
      }
    }
    // ---------------------------------------------

    final loadedEntries = await _hiveService.loadAssetEntities(entriesFromDb);

    for (var entry in loadedEntries) {
      plainTextCache[entry.id] = entry.content.toPlainText().trim();
    }

    journalEntries.assignAll(loadedEntries.where((e) => !e.isDraft));
    draftEntries.assignAll(loadedEntries.where((e) => e.isDraft));

    sortEntries(currentSortType.value);
    draftEntries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void addJournalEntry(JournalEntry entry) {
    _hiveService.addJournalEntry(entry);
    plainTextCache[entry.id] = entry.content.toPlainText().trim();
    if (entry.isDraft) {
      draftEntries.insert(0, entry);
      draftEntries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      journalEntries.insert(0, entry);
      sortEntries(currentSortType.value);
    }
  }

  void updateJournalEntry(JournalEntry updatedEntry) {
    _hiveService.updateJournalEntry(updatedEntry);

    final plainText = updatedEntry.content.toPlainText().trim();
    plainTextCache[updatedEntry.id] = plainText;

    final isTextEmpty = plainText.isEmpty;
    final isMediaEmpty = updatedEntry.galleryImages.isEmpty &&
        updatedEntry.cameraPhotos.isEmpty &&
        updatedEntry.galleryAudios.isEmpty &&
        updatedEntry.recordings.isEmpty;

    if (isTextEmpty && isMediaEmpty && !updatedEntry.isDraft) {
      journalEntries.removeWhere((e) => e.id == updatedEntry.id);
      draftEntries.removeWhere((e) => e.id == updatedEntry.id);
    } else {
      // Remove from both to handle switching states easily
      journalEntries.removeWhere((e) => e.id == updatedEntry.id);
      draftEntries.removeWhere((e) => e.id == updatedEntry.id);

      if (updatedEntry.isDraft) {
        draftEntries.insert(0, updatedEntry);
        draftEntries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        journalEntries.insert(0, updatedEntry);
        sortEntries(currentSortType.value);
      }
    }
  }

  void deleteJournalEntry(String entryId) {
    _hiveService.deleteJournalEntry(entryId);
    journalEntries.removeWhere((e) => e.id == entryId);
    draftEntries.removeWhere((e) => e.id == entryId);
    plainTextCache.remove(entryId);
  }

  void toggleBookmarkStatus(String entryId) {
    final index = journalEntries.indexWhere((e) => e.id == entryId);
    if (index != -1) {
      final entry = journalEntries[index];
      entry.isBookmarked = !entry.isBookmarked;
      _hiveService.updateJournalEntry(entry);
      if (currentSortType.value == 'bookmark') {
        sortEntries('bookmark');
      }
      journalEntries.refresh();
    }
  }

  void sortEntries(String sortType) {
    currentSortType.value = sortType;
    switch (sortType) {
      case 'time':
        journalEntries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'bookmark':
        journalEntries.sort((a, b) {
          if (a.isBookmarked && !b.isBookmarked) return -1;
          if (!a.isBookmarked && b.isBookmarked) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'reflection':
        journalEntries.sort((a, b) {
          if (a.isReflection && !b.isReflection) return -1;
          if (!a.isReflection && b.isReflection) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'media':
        journalEntries.sort((a, b) {
          final aHasMedia = a.galleryImages.isNotEmpty ||
              a.cameraPhotos.isNotEmpty ||
              a.galleryAudios.isNotEmpty ||
              a.recordings.isNotEmpty;
          final bHasMedia = b.galleryImages.isNotEmpty ||
              b.cameraPhotos.isNotEmpty ||
              b.galleryAudios.isNotEmpty ||
              b.recordings.isNotEmpty;
          if (aHasMedia && !bHasMedia) return -1;
          if (!aHasMedia && bHasMedia) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'text':
        journalEntries.sort((a, b) {
          final aIsTextOnly = a.galleryImages.isEmpty &&
              a.cameraPhotos.isEmpty &&
              a.galleryAudios.isEmpty &&
              a.recordings.isEmpty;
          final bIsTextOnly = b.galleryImages.isEmpty &&
              b.cameraPhotos.isEmpty &&
              b.galleryAudios.isEmpty &&
              b.recordings.isEmpty;
          if (aIsTextOnly && !bIsTextOnly) return -1;
          if (!aIsTextOnly && bIsTextOnly) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'location':
        journalEntries.sort((a, b) {
          final aHasLocation = a.location != null;
          final bHasLocation = b.location != null;
          if (aHasLocation && !bHasLocation) return -1;
          if (!aHasLocation && bHasLocation) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'mood':
        journalEntries.sort((a, b) {
          final aHasMood = a.moodIndex != null;
          final bHasMood = b.moodIndex != null;
          if (aHasMood && !bHasMood) return -1;
          if (!aHasMood && bHasMood) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'tags':
        journalEntries.sort((a, b) {
          final aHasTags = a.tags.isNotEmpty;
          final bHasTags = b.tags.isNotEmpty;
          if (aHasTags && !bHasTags) return -1;
          if (!aHasTags && bHasTags) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
    }
    journalEntries.refresh();
  }

  Map<int, int> getMonthlyEntriesForYear(int year) {
    final monthlyCounts = {for (var i = 1; i <= 12; i++) i: 0};
    final yearlyEntries =
    journalEntries.where((entry) => entry.createdAt.year == year);
    for (final entry in yearlyEntries) {
      final month = entry.createdAt.month;
      monthlyCounts[month] = (monthlyCounts[month] ?? 0) + 1;
    }
    return monthlyCounts;
  }

  int get totalEntriesThisYear {
    final currentYear = DateTime.now().year;
    return journalEntries
        .where((entry) => entry.createdAt.year == currentYear)
        .length;
  }

  int get totalWordsWritten {
    return journalEntries.fold<int>(0, (sum, entry) {
      final text = entry.content.toPlainText().trim();
      if (text.isEmpty) return sum;
      return sum + text.split(RegExp(r'\s+')).length;
    });
  }

  int get daysJournaled {
    if (journalEntries.isEmpty) return 0;
    return journaledDates.length;
  }

  Set<DateTime> get journaledDates {
    if (journalEntries.isEmpty) return {};
    return journalEntries.map((entry) {
      final date = entry.createdAt;
      return DateTime(date.year, date.month, date.day);
    }).toSet();
  }
}