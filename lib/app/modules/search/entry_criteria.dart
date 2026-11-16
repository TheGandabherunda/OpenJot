import '../../core/models/journal_entry.dart';

/// Immutable filter criteria shared by the journal bottom bar, SearchView,
/// and the exclude-entries bottom sheet.
///
/// The query is already lowercased by the caller. When [matchTagsOnly] is
/// true the query is matched against tags only (the `#tag` prefix rule is
/// applied by the caller before constructing this object).
class EntryCriteria {
  /// Already lowercased search query. Empty matches everything.
  final String query;

  /// When true, [query] is matched against entry tags instead of content.
  final bool matchTagsOnly;

  /// Additional tags that must all be present on the entry (AND filter).
  final Set<String> selectedTags;

  final bool bookmarked;
  final bool textOnly;
  final bool mediaOnly;
  final bool withMood;
  final bool withLocation;
  final bool withReflection;
  final bool withDraft;
  final bool withAnyTags;

  const EntryCriteria({
    this.query = '',
    this.matchTagsOnly = false,
    this.selectedTags = const {},
    this.bookmarked = false,
    this.textOnly = false,
    this.mediaOnly = false,
    this.withMood = false,
    this.withLocation = false,
    this.withReflection = false,
    this.withDraft = false,
    this.withAnyTags = false,
  });
}

/// Single owner of the "does this entry match?" rules.
///
/// Centralises the duplicated media test, tag test and boolean-flag tests
/// that previously lived in three places (search_view.dart twice, and
/// exclude_entries_bottomsheet.dart). Stateless and free of GetX/Hive so it
/// can be tested with plain Dart.
class EntryQuery {
  EntryQuery._();

  /// Returns [entries] filtered by [criteria].
  ///
  /// [searchableText] resolves the text to search within for each entry.
  /// Defaults to `entry.content.toPlainText().toLowerCase()`.
  static List<JournalEntry> filter(
    List<JournalEntry> entries,
    EntryCriteria criteria, {
    String Function(JournalEntry entry)? searchableText,
  }) {
    final textOf = searchableText ??
        (JournalEntry entry) => entry.content.toPlainText().toLowerCase();

    return entries.where((entry) {
      // --- Query match ---
      if (criteria.query.isNotEmpty) {
        final text = textOf(entry);
        if (criteria.matchTagsOnly) {
          if (!entry.tags.any((t) => t.toLowerCase().contains(criteria.query))) {
            return false;
          }
        } else {
          if (!text.contains(criteria.query)) {
            return false;
          }
        }
      }

      // --- Boolean flags ---
      if (criteria.bookmarked && !entry.isBookmarked) return false;
      if (criteria.withReflection && !entry.isReflection) return false;
      if (criteria.withDraft && !entry.isDraft) return false;
      if (criteria.withMood && entry.moodIndex == null) return false;
      if (criteria.withLocation && entry.location == null) return false;
      if (criteria.withAnyTags && entry.tags.isEmpty) return false;

      // --- Media tests (owned here, written once) ---
      final hasMedia =
          entry.galleryImages.isNotEmpty ||
          entry.cameraPhotos.isNotEmpty ||
          entry.galleryAudios.isNotEmpty ||
          entry.recordings.isNotEmpty;
      if (criteria.textOnly && hasMedia) return false;
      if (criteria.mediaOnly && !hasMedia) return false;

      // --- Selected tags (AND) ---
      if (criteria.selectedTags.isNotEmpty &&
          !criteria.selectedTags.every((tag) => entry.tags.contains(tag))) {
        return false;
      }

      return true;
    }).toList();
  }
}
