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
}
