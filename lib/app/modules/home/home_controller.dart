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
    // Listen to the journal entries box for real-time updates
    _hiveService.getJournalEntriesNotifier().addListener(loadJournalEntries);
    // Initial load of entries
    loadJournalEntries();
  }

  @override
  void onClose() {
    // Remove the listener when the controller is disposed
    _hiveService.getJournalEntriesNotifier().removeListener(loadJournalEntries);
    super.onClose();
  }

  /// Loads and sorts journal entries from the Hive box.
  /// This is now public so it can be called from other controllers (e.g., after a restore).
  Future<void> loadJournalEntries() async {
    final entriesFromDb = _hiveService.getAllJournalEntries();
    // Asynchronously load asset entities (for images/videos from gallery)
    final loadedEntries = await _hiveService.loadAssetEntities(entriesFromDb);
    journalEntries.assignAll(loadedEntries);
    sortEntries(currentSortType.value);
  }

  /// Adds a new journal entry and saves it to Hive.
  void addJournalEntry(JournalEntry entry) {
    _hiveService.addJournalEntry(entry);
    // The listener will automatically update the UI, but we can sort immediately
    // for a more responsive feel.
    journalEntries.insert(0, entry);
    sortEntries(currentSortType.value);
  }

  /// Updates an existing journal entry in Hive.
  void updateJournalEntry(JournalEntry updatedEntry) {
    _hiveService.updateJournalEntry(updatedEntry);
  }

  /// Deletes a journal entry from Hive.
  void deleteJournalEntry(String entryId) {
    _hiveService.deleteJournalEntry(entryId);
  }

  /// Toggles the bookmark status of a journal entry in Hive.
  void toggleBookmarkStatus(String entryId) {
    final index = journalEntries.indexWhere((e) => e.id == entryId);
    if (index != -1) {
      final entry = journalEntries[index];
      entry.isBookmarked = !entry.isBookmarked;
      _hiveService.updateJournalEntry(entry); // Save the change to Hive
      if (currentSortType.value == 'bookmark') {
        sortEntries('bookmark');
      }
      journalEntries.refresh();
    }
  }

  /// Sorts the journal entries based on the provided sort type.
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
          // FIX: Included audio in the definition of "media"
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
          // FIX: Included audio when checking for "text only"
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
    final monthlyCounts = { for (var i = 1; i <= 12; i++) i : 0 };
    final yearlyEntries = journalEntries.where((entry) => entry.createdAt.year == year);
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
