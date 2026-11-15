import 'package:flutter_test/flutter_test.dart';
import 'package:open_jot/app/modules/write_journal/save_target.dart';

void main() {
  String Function() counter() {
    var n = 0;
    return () => 'id-${n++}';
  }

  group('SaveTargetResolver', () {
    test('a saved entry branches once, however many drafts are saved', () {
      final r = SaveTargetResolver();
      final newId = counter();

      final first = r.resolve(
        currentId: 'sheet',
        entryId: 'saved-1',
        entryIsDraft: false,
        entryOriginalId: null,
        isDraft: true,
        newId: newId,
      );
      final second = r.resolve(
        currentId: 'sheet',
        entryId: 'saved-1',
        entryIsDraft: false,
        entryOriginalId: null,
        isDraft: true,
        newId: newId,
      );

      expect(first.id, 'id-0');
      expect(second.id, first.id, reason: 'two autosaves must not make two drafts');
      expect(first.originalId, 'saved-1');
      expect(r.branchedDraftId, first.id);
    });

    test('a different saved entry gets its own branch', () {
      final r = SaveTargetResolver();
      final newId = counter();

      r.resolve(
        currentId: 'sheet',
        entryId: 'saved-1',
        entryIsDraft: false,
        entryOriginalId: null,
        isDraft: true,
        newId: newId,
      );
      final other = r.resolve(
        currentId: 'sheet',
        entryId: 'saved-2',
        entryIsDraft: false,
        entryOriginalId: null,
        isDraft: true,
        newId: newId,
      );

      expect(other.id, isNot('id-0'));
      expect(other.originalId, 'saved-2');
    });

    test('Done on a branched draft writes the original and drops the branch', () {
      final r = SaveTargetResolver();
      final newId = counter();

      r.resolve(
        currentId: 'sheet',
        entryId: 'saved-1',
        entryIsDraft: false,
        entryOriginalId: null,
        isDraft: true,
        newId: newId,
      );

      final done = r.resolve(
        currentId: 'sheet',
        entryId: 'id-0',
        entryIsDraft: true,
        entryOriginalId: 'saved-1',
        isDraft: false,
        newId: newId,
      );

      expect(done.id, 'saved-1');
      expect(done.draftToDelete, 'id-0');
    });

    test('a new entry writes to its own id, with no original', () {
      final r = SaveTargetResolver();
      final newId = counter();

      final decision = r.resolve(
        currentId: 'sheet',
        entryId: null,
        entryIsDraft: false,
        entryOriginalId: null,
        isDraft: true,
        newId: newId,
      );

      expect(decision.id, 'sheet');
      expect(decision.originalId, isNull);
      expect(decision.draftToDelete, isNull);
    });

    test('Done on an existing entry writes it in place', () {
      final r = SaveTargetResolver();
      final newId = counter();

      final decision = r.resolve(
        currentId: 'sheet',
        entryId: 'saved-1',
        entryIsDraft: false,
        entryOriginalId: null,
        isDraft: false,
        newId: newId,
      );

      expect(decision.id, 'saved-1');
    });
  });

  group('journalHasContent', () {
    test('nothing written when there is no text and no media', () {
      expect(
        journalHasContent(isTextEmpty: true, isMediaEmpty: true),
        isFalse,
      );
    });

    test('written when there is text', () {
      expect(
        journalHasContent(isTextEmpty: false, isMediaEmpty: true),
        isTrue,
      );
    });

    test('written when there is only media', () {
      expect(
        journalHasContent(isTextEmpty: true, isMediaEmpty: false),
        isTrue,
      );
    });
  });
}