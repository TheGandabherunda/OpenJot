import 'package:get/get.dart';

import '../../core/models/journal_entry.dart';

class HomeController extends GetxController {
  final journalEntries = <JournalEntry>[].obs;

  // 1. Add an observable for the current sort type.
  final currentSortType = 'time'.obs;

  // 2. Add a map for user-friendly sort type names.
  final Map<String, String> _sortTypeDisplayNames = {
    'time': 'Entry time',
    'bookmark': 'Bookmark first',
    'reflection': 'Reflection first',
    'media': 'With media first',
    'text': 'Text only first',
    'location': 'With location first',
    'mood': 'With mood first',
  };

  // 3. Add a getter for the current sort type's display name.
  String get currentSortTypeDisplayName =>
      _sortTypeDisplayNames[currentSortType.value] ?? 'Entry time';

  void addJournalEntry(JournalEntry entry) {
    journalEntries.insert(0, entry); // Add to the top of the list
    sortEntries(currentSortType.value); // Re-sort after adding
  }

  void updateJournalEntry(JournalEntry updatedEntry) {
    final index = journalEntries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      journalEntries[index] = updatedEntry;
      sortEntries(currentSortType.value); // Re-sort after updating
    }
  }

  void deleteJournalEntry(String entryId) {
    journalEntries.removeWhere((entry) => entry.id == entryId);
  }

  /// Toggles the bookmark status of a journal entry.
  void toggleBookmarkStatus(String entryId) {
    final index = journalEntries.indexWhere((e) => e.id == entryId);
    if (index != -1) {
      final entry = journalEntries[index];
      // Create an updated entry with the new bookmark status.
      final updatedEntry = entry.copyWith(isBookmarked: !entry.isBookmarked);
      // Replace the old entry with the updated one.
      journalEntries[index] = updatedEntry;
      if (currentSortType.value == 'bookmark') {
        sortEntries('bookmark');
      }
    }
  }

  /// Sorts the journal entries based on the provided sort type.
  void sortEntries(String sortType) {
    // 4. Update the current sort type when sorting.
    currentSortType.value = sortType;
    switch (sortType) {
      case 'time':
      // Sorts by creation date, newest first.
        journalEntries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'bookmark':
      // Sorts bookmarked entries to the top, then by creation date.
        journalEntries.sort((a, b) {
          if (a.isBookmarked && !b.isBookmarked) return -1;
          if (!a.isBookmarked && b.isBookmarked) return 1;
          return b.createdAt.compareTo(a.createdAt); // Secondary sort
        });
        break;
      case 'reflection':
      // Sorts reflection entries to the top, then by creation date.
        journalEntries.sort((a, b) {
          if (a.isReflection && !b.isReflection) return -1;
          if (!a.isReflection && b.isReflection) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'media':
      // Sorts entries with media to the top, then by creation date.
        journalEntries.sort((a, b) {
          final aHasMedia =
              a.galleryImages.isNotEmpty || a.cameraPhotos.isNotEmpty;
          final bHasMedia =
              b.galleryImages.isNotEmpty || b.cameraPhotos.isNotEmpty;
          if (aHasMedia && !bHasMedia) return -1;
          if (!aHasMedia && bHasMedia) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'text':
      // Sorts text-only entries to the top, then by creation date.
        journalEntries.sort((a, b) {
          final aIsTextOnly =
              a.galleryImages.isEmpty && a.cameraPhotos.isEmpty;
          final bIsTextOnly =
              b.galleryImages.isEmpty && b.cameraPhotos.isEmpty;
          if (aIsTextOnly && !bIsTextOnly) return -1;
          if (!aIsTextOnly && bIsTextOnly) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'location':
      // Sorts entries with a location to the top, then by creation date.
        journalEntries.sort((a, b) {
          final aHasLocation = a.location != null;
          final bHasLocation = b.location != null;
          if (aHasLocation && !bHasLocation) return -1;
          if (!aHasLocation && bHasLocation) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'mood':
      // Sorts entries with a mood to the top, then by creation date.
        journalEntries.sort((a, b) {
          final aHasMood = a.moodIndex != null;
          final bHasMood = b.moodIndex != null;
          if (aHasMood && !bHasMood) return -1;
          if (!aHasMood && bHasMood) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
    }
    // Notify listeners that the list has been changed.
    journalEntries.refresh();
  }

  Map<int, int> getMonthlyEntriesForYear(int year) {
    // Initialize a map with all months having 0 entries.
    final monthlyCounts = { for (var i = 1; i <= 12; i++) i : 0 };

    // Filter entries for the specified year.
    final yearlyEntries = journalEntries.where((entry) => entry.createdAt.year == year);

    // Count entries for each month.
    for (final entry in yearlyEntries) {
      final month = entry.createdAt.month;
      monthlyCounts[month] = (monthlyCounts[month] ?? 0) + 1;
    }

    return monthlyCounts;
  }


  // Computed property for total entries this year
  int get totalEntriesThisYear {
    final currentYear = DateTime.now().year;
    return journalEntries
        .where((entry) => entry.createdAt.year == currentYear)
        .length;
  }

  // Computed property for total words written
  int get totalWordsWritten {
    return journalEntries.fold<int>(0, (sum, entry) {
      final text = entry.content.toPlainText().trim();
      if (text.isEmpty) return sum;
      // Simple word count by splitting on whitespace
      return sum + text.split(RegExp(r'\s+')).length;
    });
  }

  // Computed property for unique days journaled
  int get daysJournaled {
    if (journalEntries.isEmpty) return 0;
    final uniqueDays = journalEntries.map((entry) {
      final date = entry.createdAt;
      // Normalize to the start of the day to count unique days
      return DateTime(date.year, date.month, date.day);
    }).toSet();
    return uniqueDays.length;
  }
}
