import 'package:get/get.dart';

import '../../core/models/journal_entry.dart';

class HomeController extends GetxController {
  final journalEntries = <JournalEntry>[].obs;

  void addJournalEntry(JournalEntry entry) {
    journalEntries.insert(0, entry); // Add to the top of the list
  }
}
