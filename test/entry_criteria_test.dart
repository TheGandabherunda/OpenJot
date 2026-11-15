import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../lib/app/core/models/journal_entry.dart';
import '../lib/app/modules/search/entry_criteria.dart';

JournalEntry _entry({
  required String id,
  String content = 'hello world',
  bool isBookmarked = false,
  bool isReflection = false,
  int? moodIndex,
  bool isDraft = false,
  List<String> tags = const [],
}) {
  return JournalEntry(
    id: id,
    content: Document()..insert(0, content),
    createdAt: DateTime(2026),
    isBookmarked: isBookmarked,
    isReflection: isReflection,
    moodIndex: moodIndex,
    tags: tags,
    isDraft: isDraft,
    galleryImages: const [],
    cameraPhotos: const [],
    galleryAudios: const [],
    recordings: const [],
  );
}

void main() {
  group('EntryQuery.filter', () {
    test('empty criteria matches everything', () {
      final entries = [_entry(id: 'a'), _entry(id: 'b')];
      expect(EntryQuery.filter(entries, EntryCriteria()).length, 2);
    });

    test('query matches content', () {
      final entries = [
        _entry(id: 'a', content: 'hello world'),
        _entry(id: 'b', content: 'goodbye'),
      ];
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(query: 'hello'),
      );
      expect(result.map((e) => e.id), ['a']);
    });

    test('query is case-insensitive', () {
      final entries = [_entry(id: 'a', content: 'Hello World')];
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(query: 'hello'),
      );
      expect(result.map((e) => e.id), ['a']);
    });

    test('matchTagsOnly matches tags', () {
      final entries = [
        _entry(id: 'a', tags: ['work', 'urgent']),
        _entry(id: 'b', tags: ['home']),
      ];
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(query: 'work', matchTagsOnly: true),
      );
      expect(result.map((e) => e.id), ['a']);
    });

    test('matchTagsOnly does not match content', () {
      final entries = [_entry(id: 'a', content: 'work meeting', tags: [])];
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(query: 'work', matchTagsOnly: true),
      );
      expect(result.isEmpty, true);
    });

    test('bookmarked flag', () {
      final entries = [
        _entry(id: 'a', isBookmarked: true),
        _entry(id: 'b', isBookmarked: false),
      ];
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(bookmarked: true),
      );
      expect(result.map((e) => e.id), ['a']);
    });

    test('textOnly excludes media entries', () {
      final entries = [
        _entry(id: 'a'),
        _entry(id: 'b'),
      ];
      // Both have no media, so textOnly keeps both
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(textOnly: true),
      );
      expect(result.map((e) => e.id), ['a', 'b']);
    });

    test('mediaOnly excludes text-only entries', () {
      final entries = [
        _entry(id: 'a'),
        _entry(id: 'b'),
      ];
      // Both have no media, so mediaOnly drops both
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(mediaOnly: true),
      );
      expect(result.isEmpty, true);
    });

    test('withMood flag', () {
      final entries = [
        _entry(id: 'a', moodIndex: 3),
        _entry(id: 'b', moodIndex: null),
      ];
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(withMood: true),
      );
      expect(result.map((e) => e.id), ['a']);
    });

    test('withReflection flag', () {
      final entries = [
        _entry(id: 'a', isReflection: true),
        _entry(id: 'b', isReflection: false),
      ];
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(withReflection: true),
      );
      expect(result.map((e) => e.id), ['a']);
    });

    test('withDraft flag', () {
      final entries = [
        _entry(id: 'a', isDraft: true),
        _entry(id: 'b', isDraft: false),
      ];
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(withDraft: true),
      );
      expect(result.map((e) => e.id), ['a']);
    });

    test('withAnyTags excludes entries without tags', () {
      final entries = [
        _entry(id: 'a', tags: ['work']),
        _entry(id: 'b', tags: []),
      ];
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(withAnyTags: true),
      );
      expect(result.map((e) => e.id), ['a']);
    });

    test('selectedTags AND filter', () {
      final entries = [
        _entry(id: 'a', tags: ['work', 'urgent']),
        _entry(id: 'b', tags: ['work']),
        _entry(id: 'c', tags: ['urgent']),
      ];
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(selectedTags: {'work', 'urgent'}.toSet()),
      );
      expect(result.map((e) => e.id), ['a']);
    });

    test('combined filters', () {
      final entries = [
        _entry(
          id: 'a',
          content: 'meeting notes',
          isBookmarked: true,
          tags: ['work'],
        ),
        _entry(
          id: 'b',
          content: 'meeting notes',
          isBookmarked: false,
          tags: ['work'],
        ),
      ];
      final result = EntryQuery.filter(
        entries,
        EntryCriteria(
          query: 'meeting',
          bookmarked: true,
          selectedTags: {'work'}.toSet(),
        ),
      );
      expect(result.map((e) => e.id), ['a']);
    });
  });
}
