# Autosave and a cheap write path — design

Date: 2026-11-15 · Status: awaiting approval · Branch: not created yet

## Intent

Typing in the editor is only persisted when the app is paused, deactivated, detached, or the sheet is disposed. There is no timer and no debounce. A hard crash — or the OS killing the app while it is in the foreground — loses every keystroke since the last lifecycle event.

Adding a timer on its own is not enough, because of what a save costs today. Every `journalsBox.put` fires `journalsBox.listenable()`, which is wired straight to `HomeController.loadJournalEntries()`, and that method copies the whole box, sweeps expired drafts, resolves every asset through `photo_manager`, and runs `toPlainText()` on every entry. A two-second autosave would therefore re-read the entire journal every two seconds on the main isolate. The data-loss bug and the worst performance bug sit on the same seam, so they are fixed in one change.

## Goals

- Keystrokes survive a crash: the current draft is on disk within about two seconds of the last change, not only at the next lifecycle event.
- A save no longer re-reads the journal. Writes the controller performed itself must not trigger a full reload.
- One test in `test/` that fails without the autosave and passes with it. This is the first test in the repository.

## Non-goals

- The dependency baseline upgrade. That is `docs/superpowers/specs/2026-11-15-dependency-baseline-upgrade-design.md`, a separate branch.
- The `progressive_blur` rendering bug on some Android devices.
- Moving editor state out of the widget. That is candidate K1 in the architecture review; this change deliberately stays small, and only the autosave timing is extracted as its own module.
- Deferred first frame: `main()` still blocks on `HiveService.init()` before `runApp`. Real, but a separate change with its own risk.

## Anti-goals

- A timer that fires a full journal reload. That is the failure mode this design exists to prevent.
- Marking a `JournalEntry` as a draft on every keystroke, which would reorder the home list and re-sort while the user types. The existing code already avoids this: `updateJournalEntry` re-inserts the entry and re-sorts on each write, so autosave must not amplify it into a visible list churn.
- Editing `journal_entry.g.dart` by hand.

## Constraints

- `hive_service.dart` owns every Hive box; no view or controller touches `Hive.box` directly, and this change must not break that.
- The controller already updates its Rx lists in place in `addJournalEntry`, `updateJournalEntry` and `deleteJournalEntry`. Whatever replaces the reload must keep those call sites working for external changes such as the Daily You import, which writes to the box behind the controller's back.
- `updateJournalEntry` deletes the entry when it is both text-empty and media-empty (`hive_service.dart:348-360`). Autosave inherits that rule and must not create empty entries.
- Verification runs on the box-04 self-hosted runner: Flutter 3.50.0 / Dart 3.14.0. The working tree lives on box-02, which has Dart 3.13.7 and cannot resolve the dependency branch.
- `fake_async` is already in the lock as a transitive dependency of `flutter_test`, so timer tests need no new package.

## Approach

Chosen from three, with the order inverted from the obvious one.

**A · Timer only, inside the widget.** A `Timer(2s)` on document changes calling the existing `_saveEntry(isDraft: true)`, keeping the pause and dispose saves as a flush. Smallest diff. Rejected: every two-second pause in typing triggers a full journal reload, so the fix makes the app measurably slower than the bug it fixes.

**B · Cheap write path first, then the timer — chosen.** Stop self-inflicted writes from causing a full reload, coalesce the reloads that remain, then put the timer on top of a write path that is now cheap.

**C · Extract editor state into a controller first, then autosave there.** The Anchor shape (`note_editor_controller.dart` with a two-second timer, `saveNow`, `flushOnLeave`, `discardIfBlank`), and the only version testable through a wide surface. Rejected for now: refactoring 2.822 lines with zero tests as the entry point for the repository's first test is the wrong way round. Revisit as K1 once tests exist.

## How it works

Four parts, in this order.

### 1 · The controller stops reloading its own writes

`HomeController` is the only writer that goes through both the box and the in-place list update, so it can tell its own writes apart from anyone else's.

- Add a counter, `_selfWrites`.
- Wrap each of `addJournalEntry`, `updateJournalEntry`, `deleteJournalEntry` so the counter goes up before the `HiveService` call and comes back down when the write has settled. Since `journalsBox.listenable()` fires synchronously for `put` and `delete`, incrementing before the call and decrementing in the listener is enough; if the listener turns out to fire asynchronously for some paths, use a generation number instead and compare it in the listener.
- In `loadJournalEntries`, return immediately when the notification was self-inflicted. The in-place update the controller already did is the whole truth.

### 2 · The remaining reloads are coalesced

External writes still need a real reload: the Daily You import writes through `HiveService` while the controller is not involved.

- Replace the direct `addListener(loadJournalEntries)` with a listener that restarts a single `Timer` of about 300 ms.
- One burst of writes, one reload.

### 3 · The autosave module

A new file, `lib/app/modules/write_journal/draft_autosave.dart`. It holds no widget and no Flutter import beyond the foundation:

```
class DraftAutosave {
  DraftAutosave({required this.save, this.idle = const Duration(seconds: 2)});
  final Future<void> Function() save;
  final Duration idle;
  void noteChange();          // (re)start the idle timer
  Future<void> flush();       // save now if a change is pending, cancel the timer
  void discard();             // cancel without saving
}
```

Rules the module owns: a change restarts the timer rather than queueing saves; `flush()` saves at most once even if called twice; nothing is saved when there is no pending change. Everything else — what "changed" means, what a draft is — stays with the caller.

### 4 · Wiring the editor to it

In `WriteJournalBottomSheetState`:

- Build the `DraftAutosave` in `initState`, with `save` calling the existing `_saveEntry(isDraft: true)`.
- Call `noteChange()` from `_handleTextChange` and from each of the media, tag, mood, location and bookmark mutations. Today these paths have no single funnel, so the wiring is the fiddly part; `_handleTextChange` alone covers the common case of typing.
- Call `flush()` from `didChangeAppLifecycleState` on pause, inactive and detached, replacing the direct `_saveEntry` there, and from `dispose`.
- Call `discard()` from the paths that set `_isSavedOrDiscarded`, so a completed save or a user discard is not followed by a stray draft write.

## Test

`test/draft_autosave_test.dart`, using `fake_async`:

- a change, then 1.9 s, saves nothing; at 2.0 s, saves once
- three changes 500 ms apart produce exactly one save
- `flush()` with a pending change saves once and cancels the timer, so the timer does not fire afterwards
- `flush()` twice saves once
- `flush()` with no pending change saves nothing
- `discard()` cancels and saves nothing

This is the regression test for the data-loss bug: it goes red if the timer is removed, and it needs no Hive box and no widget.

If a second test is cheap, cover the reload decision in `HomeController` with a fake store: a self-write must not call the reload path, an external notification must. That one needs the store to be injectable, which is candidate K5; do not build K5 just for it.

## Verification

On box-04, after this branch is rebased onto the dependency branch:

```sh
flutter pub get
flutter analyze
flutter test
```

`flutter test` stops being vacuous here: it has one real test that fails if the autosave is broken. That is the first time this repository has a signal.

Not covered by any command: that a draft actually survives a crash. That needs a device — start an entry, type, kill the app from the OS, reopen, confirm the draft is there. Someone has to do that once before this is called done.

## Sequencing

This branch touches the same three files as the dependency branch (`home_controller.dart`, `hive_service.dart`, `write_journal_bottom_sheet.dart`), so doing them in parallel means resolving the same regions twice. The dependency branch goes first: fix the four `FilePicker.platform` call sites, get `analyze` clean on box-04, merge it, then branch this from the updated `main`.

## Left to the builder

1. `DraftAutosave` plus its test. Land these first; they are independent of everything else and give the repository its first passing test.
2. The self-write guard and the coalesced reload in `HomeController`.
3. The wiring in `WriteJournalBottomSheetState`, including every mutation path, not just text.
4. Confirm with the device check above, and record in the pull request what was verified by command and what was verified by hand.