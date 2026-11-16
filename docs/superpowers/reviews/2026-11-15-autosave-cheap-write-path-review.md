# Code review — `feat/autosave-and-cheap-write-path` (52ca758..d0fde32)

Reviewer: agent, on box-02, Flutter 3.47.9 / Dart 3.13.7. No file in the repository was changed.

**Status: Critical 1, Critical 2 and Important 3 were fixed in `8ed3bb9` and `ffa97a9`, each with a test. The ten Minors were left in place on purpose.**

Read in this order: the plan (`docs/superpowers/plans/2026-11-15-autosave-and-cheap-write-path.md`), the spec (`docs/superpowers/specs/2026-11-15-autosave-cheap-write-path-design.md`), then the code itself and the library sources (hive 2.2.3, hive_flutter 1.1.0, flutter_quill 11.6.0 in `/data/home/.pub-cache`).

## 1 · What I ran

| Command | Result |
| --- | --- |
| `flutter analyze` (PATH `/data/workspace/toolchain/flutter/bin`) | `No issues found!` |
| `flutter test` | `00:00 +22: All tests passed!` |
| `flutter test /tmp/probe/listener2_test.dart` (throwaway, outside the repo) | box listener is **not** detached by `removeListener` on a fresh `listenable()` |
| `flutter test /tmp/probe/probe_test.dart` (throwaway) | `Document.format` on an empty document emits no change for bold/italic, emits one for a header or list style |

`analysis_options.yaml` excludes `test/**` from analysis, so the test files are not held to the CI bar; the library code is clean.

## 2 · Standards

**The plan's Interfaces are honoured, with two deviations, both recorded.**

- Task 1 produced `begin()` / `isSelfWrite()` / `depth` and one extra member, `clear()` (`self_write_gate.dart:35-37`). The plan's Task 1 Interfaces block does not name it; the plan's Task 3 Step 3 told the implementer to change the gate's shape if the notifier turned out not to be synchronous, and the ledger records the ruling. `clear()` is documented at `self_write_gate.dart:29-34`.
- Task 2 matches `ReloadCoalescer({required onFire, window})/schedule/dispose` exactly.
- Task 3 wires both as specified, except that the mark is dropped after a grace turn rather than decremented in the listener. Documented in `progress.md` and in the commit message of `ab01014`.
- Task 4 does **not** hook `_handleTextChange`, against the plan's Step 2. The plan was wrong: `_handleTextChange` returns early unless `docChange.source == ChangeSource.remote` (`write_journal_bottom_sheet.dart:477-479`), so ordinary typing would not have reached it. The implementer hooked `_quillController.document.changes` (`:219`), which fires for local edits and not for cursor moves. This is the correct reading of the code and it is recorded in the ledger.

**Where the code departs from the plan's intent.** Task 4 Step 2 asks for `noteChange()` from *each* path that mutates the preview lists, the tags, the mood, the location or the bookmark. The add paths got it. The **removal** paths did not (see Minor 4).

**Flutter/Dart hygiene, as the brief asks.**

- Unawaited futures: `_selfWrite` is launched with `unawaited` at `home_controller.dart:208`, `:220`, `:250`. An error from the box write becomes an unhandled asynchronous error, and `unawaited_futures` is set to `ignore` in `analysis_options.yaml`, so neither the analyzer nor CI will ever say so. The same was true before the branch (the box write was already dropped on `main`), so this is not a regression.
- `setState` after dispose: the new code adds none. `_saveEntry` (the autosave's only call) touches no widget state that requires a live element, and it reads the document and the preview lists synchronously before returning, so the un-awaited `flush()` inside `dispose()` (`:354`) cannot read state after `_quillController.dispose()` (`:363`). The pre-existing `.then((value) { setState(...) })` at `:1340-1345` and `:1945-1947` have no `mounted` guard; they are outside this diff.
- Listeners added and never removed: the two `document.changes` subscriptions (`:218-219`) are never cancelled, but `Document.close()` closes the broadcast controller (`flutter_quill-11.6.0/lib/src/document/document.dart:566-570`), which completes them. `:362`'s `listen(null)` is dead code — it creates a third subscription, it does not remove the first two.
- `flutter analyze` stays clean. Verified.

## 3 · Spec

Delivered: an idle autosave two seconds after the last change; the controller's own writes no longer reload the journal; the remaining reloads are coalesced; the autosave module already existed on `main` and is wired in.

Contradicted, by effect:

- **The anti-goal "autosave must not amplify the re-sort/re-insert of the home list" is not met for drafts.** `updateJournalEntry` in the controller re-inserts and re-sorts on every write (`home_controller.dart:236-245`); that is cheap for one entry. The amplification the spec feared comes from the * branched-draft* path in `_saveEntry`, which does not re-insert an existing draft but creates a new one — Critical 1.
- **The constraint "autosave inherits the rule that an entry is deleted when it is both text-empty and media-empty" is not met.** The rule lives in `hive_service.updateJournalEntry` (`hive_service.dart:348-360`); the autosave reaches it only when the sheet thinks the entry already exists. When it does not, `addJournalEntry` writes an empty entry unconditionally — Critical 2.
- Non-goals respected: no `journal_entry.g.dart` edit, no new `HiveField`, no new dependency, `hive_service.dart` still owns the boxes.

## 4 · Correctness, by effect — the plan's five Review Focus inputs

### 1 · The OS kills the app while the keyboard is open

**What a person gets:** the text typed before the last two seconds of quiet is on disk. Text typed in the final two seconds before an abrupt kill is lost, and more than two seconds of continuous typing is lost, because the timer only starts after the typing stops. Hive writes through `writeRaf.writeFrom` (`hive-2.2.3/lib/src/backend/vm/storage_backend_vm.dart:123-143`); the bytes are in the kernel's page cache, so killing the *process* does not lose them. A device power loss would.

The flush on `paused` / `inactive` / `detached` (`write_journal_bottom_sheet.dart:152-158`) covers the normal path where the OS asks first. An abrupt `SIGKILL`, a native crash, or an ANR kill does not get that callback, so the idle timer is the only protection in that case.

Verdict: the requirement is met as the spec states it ("within about two seconds of the last change"). The plan's manual check M1 as written ("type for ten seconds, then kill") would fail on an abrupt kill, and the plan does not say so. Not a code defect.

### 2 · A save fires while media is still being attached

**What a person gets:** no half-attached entry. `noteChange()` is called from the mutation callbacks *after* the picker returns and *before* `setState` (`:2315`, `:2331`, `:2358`, `:2368`, `:2384`), so the pending write always sees a complete media list. While the picker is open, the only thing the timer can write is the entry as it stood before, which is a complete entry. No entry is written with a half-built media list.

The one gap is the share-to-app path: `_loadSharedMedia` mutates the lists after an `await` and does not call `noteChange` (`:289-324`). A shared file that arrives after the last save is written only by the dispose or lifecycle flush. Minor.

### 3 · Open A, go back within two seconds, open B

**What a person gets:** A's text stays in A. `_autosave` is per-`State`, built in `_initializeState` (`:217`) and disposed with the sheet (`:360`); B is a different `State` with its own `DraftAutosave`, its own timer and its own `_currentEntryId`. `_currentEntryId` is assigned once (`:183`, `:199`) and never reassigned, so even the plan's narrower worry — capturing the id when the timer fires instead of when the change is noted — cannot bite here. A's pending write is either flushed by `dispose` before the sheet is gone or cancelled by it.

### 4 · Delete every character of an existing entry, then leave

**What a person gets: broken.** Two cases, both wrong.

- **Existing non-draft entry, all text deleted.** `_saveEntry(isDraft: true)` reaches the branched-draft branch (`:389-393`), which mints a **new** UUID and keeps the original id as `originalId`; `exists` is then false for that new id, so `addJournalEntry` writes it (`:431-438`). The user gets: the original entry, untouched, plus a new *empty draft* in the box and in the Drafts list. Pressing Done is refused with "Journal entry cannot be empty" (`:450-455`), so the user cannot even finish the deletion. Pressing back and choosing Discard writes the original entry back (`:2562`) but never deletes the branched draft, so the empty entry survives the discard, the app restart, and every reload.
- **New entry, text typed, all of it deleted.** `isDraft` is true and `widget.entry` is null, so `saveId` is `_currentEntryId`, `exists` is false, and `addJournalEntry` writes an empty entry. `_hasUnsavedChanges` is now false (`:232-249`), so `_onWillPop` returns `true` at `:2523-2525` with no warning and `dispose` skips the flush. The empty draft stays in the box and in Drafts across restarts.

This is Review Focus item 4 failing in the direction the plan said to check, plus one the plan did not name.

### 5 · A Daily You import finishes while the editor is open

**What a person gets:** the imported entries appear. The import writes through `_hiveService.addJournalEntry` (`daily_you_migration_service.dart:125`), not through `HomeController`, so no mark is set and `_onBoxChanged` schedules a reload (`home_controller.dart:150-153`) that fires 300 ms after the burst. `settings_controller.dart:356-358` also calls `loadJournalEntries()` explicitly when the import finishes, so the list is correct even if a notification is lost.

A mark can only swallow a notification inside the same event-loop turn as a self-write (`_selfWrite` marks, the write's notification is delivered in a microtask, the mark is consumed or cleared before the next timer turn). An import is not a single write, and its later writes are unmarked. Residual risk: negligible.

## 5 · `DraftAutosave` on its own merits

The module is a timer, a pending flag and an in-flight flag (`draft_autosave.dart:19-22`). I looked for interleavings of `noteChange`, `flush`, `discard` and `dispose` that write when they should not or lose a change.

- **Writes when it should not:** none found. `discard()` and `dispose()` both clear `_pending` and cancel the timer; `noteChange()` after `dispose()` is ignored (`:29`); `flush()` with nothing pending returns without saving (`:42`).
- **Loses a change it should keep, in one interleaving:** `flush()` while a save is in flight. `flush()` cancels the timer, sees `_pending`, calls `_run()`; `_run()` sees `_inFlight` and re-arms the timer instead of saving (`:64-67`). The change is still pending, so a later tick picks it up — unless the caller was `dispose()`, which immediately follows with `dispose()` and cancels the timer. The change is then lost. Unreachable in this app, because the injected `save` is `() async => _saveEntry(...)`, whose body has no `await` and therefore completes inside one synchronous run. It is a live trap for whoever injects a real asynchronous save.
- **`discard()` during an in-flight save still writes.** The doc comment says "Cancels the pending write" and the class doc says "discard cancels without writing"; a save that has already started is not cancelled. Unreachable for the same reason.
- **`_pending` is cleared before `await save()`** (`:68`). If `save()` throws, the change is gone and the error surfaces on the `_run()` future, which for the timer path is nobody's. `_saveEntry` catches everything internally (`:439-441`), so the timer path cannot throw; `flush()` from `dispose()` can only throw if `Get.find<HomeController>()` throws, which would be a different failure.

The module is sound for the way it is used. Its tests cover the timer, the in-flight case and the no-op cases; they do not cover `discard`/`dispose` during an in-flight save.

## 6 · Is the self-write gate sound, given Hive's timing?

Yes, for the writes the controller makes, and the failure direction is always "one extra reload", never "a lost notification".

The library source, read directly:

- `Box.put` → `putAll` → `_writeFrames` (`hive-2.2.3/lib/src/box/box_impl.dart:60-95`). `keystore.beginTransaction` → `insert` → `_notifier.notify` (`keystore.dart:148-180`) happens **synchronously inside the call**, before the first `await` in `_writeFrames`. `ChangeNotifier` is a broadcast `StreamController` (`change_notifier.dart:8-10`), so delivery is a microtask, not inline.
- Therefore the notification is always queued before the write's future resolves, and always delivered before `await box.put(...)` returns. `test/hive_notification_timing_test.dart:41-50` pins exactly that.
- `_selfWrite`'s grace turn is `Future.delayed(Duration.zero)` — a timer, which runs after every pending microtask. So the listener has consumed the mark before `clear()`.
- A write that raises **no** notification does exist: `deleteAll` only emits frames for keys that exist (`box_base_impl.dart:75-85`), so deleting a key that is not there returns without notifying. `clear()` is what keeps that stale mark from hiding the next outside change. This is the right call.

Two reservations:

1. `clear()` is global (`self_write_gate.dart:35-37`), not per write. Two overlapping `_selfWrite` calls can have the later write's mark dropped by the earlier write's `clear()`. The effect is one extra reload, which is the old behaviour, and the ledger says so. But the "one mark per notification" contract in the class doc is not actually held under overlap, and no test covers `_selfWrite` itself — `home_controller_reload_policy_test.dart` drives a gate and a coalescer by hand, not the controller.
2. `Duration.zero` plus a named constant is indirection over a no-op (`home_controller.dart:27`, `:167`).

## 7 · Findings

### Critical

**C1 · Every idle save while editing a saved entry creates another draft copy of it.** `write_journal_bottom_sheet.dart:217` (autosave calls `_saveEntry(isDraft: true)`), `:389-393` (branched-draft branch mints a new UUID whenever `widget.entry` is a non-draft), `:431-438` (the new id does not exist, so `addJournalEntry`), `home_controller.dart:207-217` (inserted into `draftEntries`), `hive_service.dart:345-346` (written to the box unconditionally). `widget.entry` never changes during the sheet's life, so *every* idle save takes that branch: a 30-second editing session with a pause every few seconds leaves several full copies of the entry in Drafts, each with a different id and the same `originalId`. They are never reconciled, deduplicated or garbage-collected, and they survive restarts because `loadJournalEntries` copies the box (`home_controller.dart:200-201`). Pressing Done updates the original (`:396-400` does not apply, so `saveId` stays `_currentEntryId`) and leaves every copy behind. The pre-existing lifecycle save did this once per app pause; the branch turns it into once per idle window. No device check would catch it, because it is not a crash, a lost write or a wrong entry — it is a duplicate the user only sees in Drafts.

**C2 · Emptying an entry leaves an empty entry behind.** Two paths, both described in section 4 above: `write_journal_bottom_sheet.dart:379` (the `!isDraft` guard does not stop the draft path), `:389-393` (a new empty draft for an emptied non-draft entry), `:431-438`, `:450-455` (Done refuses to finish), `:2523-2525` (leaving a new entry with nothing in it raises no warning), `:2556-2564` (Discard does not delete what the autosave already wrote), `hive_service.dart:345-346` (`addJournalEntry` has no emptiness rule) and `:348-360` (the emptiness rule lives only on the update path). The user's observable result: a blank card in Drafts that they cannot get rid of through the UI, or an entry that reappears after they delete all its text.

### Important

**I1 · `HomeController.onClose` never detaches its box listener, so after a restore the dead controller keeps paying the cost the branch removed.** `home_controller.dart:75` subscribes `_onBoxChanged` to `getJournalEntriesNotifier()`, and `:142` unsubscribes from a *different* object: `hive_service.dart:368-369` returns `journalsBox.listenable()`, and `hive_flutter-1.1.0/lib/src/box_extensions.dart:35-66` builds a fresh `_BoxListenable` per call, so the `removeListener` finds an empty listener list and cancels nothing. Verified against a real box (section 1, probe). `settings_controller.dart:305-311` is the only place that deletes and re-creates `HomeController` — after Settings → Restore — so from then on every box write also runs the dead controller's `_onBoxChanged`, which schedules `_reloads` and reloads the whole journal: a copy of the box, `loadAssetEntities` for every entry, `toPlainText` on every one. With autosave writing every couple of seconds while the user types, that is the exact main-isolate cost the branch set out to delete, silently back after a restore. The listener is leaked either way; only the handler changed, so the bug is pre-existing, but the diff touched both lines and the class's own doc comment claims the listener is removed.

### Minor

1. `_notificationGrace` is a named constant that is always `Duration.zero`, and the grace turn is a timer per write (`home_controller.dart:27`, `:162-170`). The gate's own doc says the notification always lands inside the write future, so the grace turn can never be the thing that saves a mark.
2. `clear()` is global, not per write (section 6).
3. `DraftAutosave` loses a change if `flush()` is called during an in-flight save and the caller is `dispose()`, and `discard()` does not cancel an in-flight save although its doc says it cancels without writing (`draft_autosave.dart:39-51`, `:59-75`). Unreachable with today's synchronous save; the module's contract does not say so.
4. The removal paths do not report changes: media removal at `:1199-1207`, `:1484-1490`, `:1686-1688`, `:1780-1786`; location removal at `:1945-1947`; "use current date" at `:1341-1345`; and `_loadSharedMedia` at `:319-323`. A deletion that is the user's last action is persisted only if the app receives a lifecycle callback or disposes the sheet. Plan Task 4 Step 2 asked for every mutation path.
5. `:362`'s `_quillController.document.changes.listen(null)` creates a third subscription rather than removing the two at `:218-219`. Harmless (the document closes its controller), but it reads as a cleanup that is not one.
6. `unawaited(_selfWrite(...))` drops write errors on the floor, and `unawaited_futures: ignore` keeps the analyzer quiet (`home_controller.dart:208`, `:220`, `:250`; `analysis_options.yaml`).
7. `dispose()` calls `_autosave?.flush()` without awaiting it, so the surrounding `try/catch` at `:351-359` cannot catch a rejection — it only catches synchronous throws. Unreachable with a synchronous save.
8. `loadJournalEntries` deletes expired drafts through `_hiveService.deleteJournalEntry` without a mark (`home_controller.dart:187-190`), so each sweep schedules one extra full reload 300 ms later.
9. `test/hive_notification_timing_test.dart:32-39` calls `box.put(1, 1)` and never awaits it, while `tearDown` deletes the box from disk; the assertion is about the synchronous part only, so the test is correct, but the dangling write is untidy.
10. No test reaches `_onBoxChanged` or `_selfWrite` together. `home_controller_reload_policy_test.dart` exercises the two policies by hand, as the plan specified, so the wiring itself — the part that could be wrong — is only covered by reading it.

## 8 · Declined to judge

- The plan's manual checks M1–M4. No Android device on this box, and a debug build does not fit on the disk (the ledger says so too). Everything I say about them is from the code.
- Real `photo_manager` behaviour on a device: whether `AssetEntity.fromId` resolves, how long a large `loadAssetEntities` takes, whether `_loadAssets` drops assets silently. I read the call sites only.
- Whether each platform delivers `paused`/`inactive`/`detached` before killing the process. That determines how much of section 4.1's residual window is real.
- `setState` after dispose in the pre-existing dialog `then` callbacks (`:1340-1345`, `:1945-1947`) and the `dispose` path's `CustomToast.showToast`. Outside the diff.
- Rendering, layout, typography and the editor's own behaviour. No device.
- Whether the restore path's explicit `loadJournalEntries()` plus the notification causes a double reload. The coalescer makes it harmless.
- Anything in `main` that the diff does not touch, including `hive_service.dart`, which the branch does not modify.

## 9 · What the branch gets right

- The cheap write path works for the common case: a self-write raises exactly one notification, it is consumed inside the write's own future, and no reload is scheduled. Verified against the library source and the timing test.
- The coalescer collapses a burst, and it is disposed with the controller.
- The autosave timer, the per-sheet `DraftAutosave`, the per-sheet id and the `discard()` calls on the Done and discard paths are all correct.
- `flutter analyze` is clean and all 22 tests pass.
- The commit messages and the ledger state plainly that M1–M4 were not run. Nothing in the branch implies otherwise.
- The `document.changes` hook is the right change signal and the plan's `_handleTextChange` hook would have been wrong.