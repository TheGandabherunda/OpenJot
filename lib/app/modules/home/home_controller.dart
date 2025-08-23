import 'package:get/get.dart';
import 'package:open_jot/app/core/services/hive_service.dart';

import '../../core/models/journal_entry.dart';

class HomeController extends GetxController {
  final _hiveService = Get.find<HiveService>();
  final journalEntries = <JournalEntry>[].obs;

  final currentSortType = 'time'.obs;
  final Map<String, String> _sortTypeDisplayNames = {
    'time': 'Entry time',
    'bookmark': 'Bookmark first',
    'reflection': 'Reflection first',
    'media': 'With media first',
    'text': 'Text only first',
    'location': 'With location first',
    'mood': 'With mood first',
  };

  String get currentSortTypeDisplayName =>
      _sortTypeDisplayNames[currentSortType.value] ?? 'Entry time';

  @override
  void onInit() {
    super.onInit();
    _hiveService.getJournalEntriesNotifier().addListener(loadJournalEntries);
    loadJournalEntries();
  }

  @override
  void onClose() {
    _hiveService.getJournalEntriesNotifier().removeListener(loadJournalEntries);
    super.onClose();
  }

  Future<void> loadJournalEntries() async {
    final entriesFromDb = _hiveService.getAllJournalEntries();
    final loadedEntries = await _hiveService.loadAssetEntities(entriesFromDb);
    journalEntries.assignAll(loadedEntries);
    sortEntries(currentSortType.value);
  }

  void addJournalEntry(JournalEntry entry) {
    _hiveService.addJournalEntry(entry);
    journalEntries.insert(0, entry);
    sortEntries(currentSortType.value);
  }

  void updateJournalEntry(JournalEntry updatedEntry) {
    _hiveService.updateJournalEntry(updatedEntry);
    final index = journalEntries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      final isTextEmpty = updatedEntry.content.toPlainText().trim().isEmpty;
      final isMediaEmpty = updatedEntry.galleryImages.isEmpty &&
          updatedEntry.cameraPhotos.isEmpty &&
          updatedEntry.galleryAudios.isEmpty &&
          updatedEntry.recordings.isEmpty;

      if (isTextEmpty && isMediaEmpty) {
        journalEntries.removeAt(index);
      } else {
        journalEntries[index] = updatedEntry;
      }
    }
  }

  void deleteJournalEntry(String entryId) {
    _hiveService.deleteJournalEntry(entryId);
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
