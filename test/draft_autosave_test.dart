import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_jot/app/modules/write_journal/draft_autosave.dart';

void main() {
  late List<int> saves;
  late DraftAutosave autosave;

  /// Builds an autosave whose save callback records the fake-clock time it ran.
  DraftAutosave build({Duration idle = const Duration(seconds: 2)}) {
    saves = <int>[];
    return DraftAutosave(
      save: () async {
        saves.add(now.inMilliseconds);
        return;
      },
      idle: idle,
    );
  }

  late int now;

  setUp(() {
    now = 0;
  });

  group('DraftAutosave', () {
    test('writes nothing until the idle time has passed', () {
      fakeAsync((async) {
        autosave = build();
        now = 0;

        autosave.noteChange();
        async.elapse(const Duration(milliseconds: 1900));
        expect(saves, isEmpty);

        async.elapse(const Duration(milliseconds: 100));
        expect(saves, hasLength(1));
        expect(saves.single, 2000);
      });
    });

    test('a change restarts the timer, so typing produces one write', () {
      fakeAsync((async) {
        autosave = build();

        autosave.noteChange();
        async.elapse(const Duration(milliseconds: 1500));
        autosave.noteChange();
        async.elapse(const Duration(milliseconds: 1500));
        autosave.noteChange();
        async.elapse(const Duration(milliseconds: 1900));
        expect(saves, isEmpty);

        async.elapse(const Duration(milliseconds: 100));
        expect(saves, hasLength(1));
      });
    });

    test('flush writes a pending change and cancels the timer', () {
      fakeAsync((async) {
        autosave = build();

        autosave.noteChange();
        async.elapse(const Duration(milliseconds: 500));
        autosave.flush();
        async.flushMicrotasks();
        expect(saves, hasLength(1));

        // The cancelled timer must not write a second time.
        async.elapse(const Duration(seconds: 10));
        expect(saves, hasLength(1));
      });
    });

    test('flush twice writes once', () {
      fakeAsync((async) {
        autosave = build();

        autosave.noteChange();
        autosave.flush();
        autosave.flush();
        async.flushMicrotasks();
        expect(saves, hasLength(1));
      });
    });

    test('flush with nothing pending writes nothing', () {
      fakeAsync((async) {
        autosave = build();

        autosave.flush();
        async.flushMicrotasks();
        expect(saves, isEmpty);
      });
    });

    test('discard cancels without writing', () {
      fakeAsync((async) {
        autosave = build();

        autosave.noteChange();
        autosave.discard();
        async.elapse(const Duration(seconds: 10));
        expect(saves, isEmpty);
      });
    });

    test('a change after dispose is ignored', () {
      fakeAsync((async) {
        autosave = build();

        autosave.noteChange();
        autosave.dispose();
        autosave.noteChange();
        async.elapse(const Duration(seconds: 10));
        expect(saves, isEmpty);
      });
    });

    test('hasPendingChanges follows the pending write', () {
      fakeAsync((async) {
        autosave = build();

        expect(autosave.hasPendingChanges, isFalse);
        autosave.noteChange();
        expect(autosave.hasPendingChanges, isTrue);

        async.elapse(const Duration(seconds: 2));
        async.flushMicrotasks();
        expect(autosave.hasPendingChanges, isFalse);
      });
    });
  });
}