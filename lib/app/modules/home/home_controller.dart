import 'package:get/get.dart';

import '../../core/models/journal_entry.dart';

class HomeController extends GetxController {
  final journalEntries = <JournalEntry>[].obs;

  void addJournalEntry(JournalEntry entry) {
    journalEntries.insert(0, entry); // Add to the top of the list
  }

  void updateJournalEntry(JournalEntry updatedEntry) {
    final index = journalEntries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      journalEntries[index] = updatedEntry;
      // The .value assignment is not needed for RxList,
      // but if you face UI update issues, calling refresh() can help.
      journalEntries.refresh();
    }
  }

  void deleteJournalEntry(String entryId) {
    journalEntries.removeWhere((entry) => entry.id == entryId);
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
