# Autosave and a cheap write path — implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Keystrokes reach storage within about two seconds of the last change, and a save no longer re-reads the whole journal.

**Architecture:** Two small pure-Dart policies own the decisions — whether a box notification should trigger a reload, and when a burst of them collapses into one. `HomeController` uses both instead of wiring the box notifier straight to a full reload. `WriteJournalBottomSheetState` reports changes to `DraftAutosave`, which already exists and already owns the timing.

**Tech Stack:** Flutter 3.47.9, Dart 3.13, GetX, Hive, `fake_async` for timer tests.

**Spec:** `docs/superpowers/specs/2026-11-15-autosave-cheap-write-path-design.md`

## Global Constraints

- Baseline is `sdk: ^3.13.0` and `flutter: ^3.47.9`. Verify on box-02 with `/data/workspace/toolchain/flutter/bin` on `PATH`.
- `flutter analyze` must report **no issues**. In this project infos are fatal in CI, not just errors and warnings.
- `flutter test` must pass; `DraftAutosave` and its 9 tests already exist on the branch this plan builds on.
- No new dependencies. `fake_async` is already in the lock through `flutter_test`.
- Idle delay is 2 seconds. Do not make it configurable in the editor; `DraftAutosave.idle` already takes a value for tests.
- Do not edit `lib/app/core/models/journal_entry.g.dart`, and do not add or remove a `HiveField`.
- `hive_service.dart` stays the only owner of the Hive boxes.
- Land PR #1 (`chore/dependency-baseline-upgrade`) on `main` first. This plan modifies the same three files that PR touches; branching before it merges means resolving the same regions twice.

## Review Focus

Five inputs the spec implies and no unit test can reach from the current seams. Each is pinned where a seam exists and named as a manual check where none does.

1. **The OS kills the app while the keyboard is open.** The last two seconds of typing must survive. No seam: the editor's `save` closure and the Hive box are both behind the widget. Pinned by manual check M1 in Task 4.
2. **A save fires while media is still being attached.** The entry must not be written half-attached. Pinned by `DraftAutosave`'s in-flight test plus manual check M2 in Task 4.
3. **Open entry A, go back, open entry B within two seconds.** A's pending write must not land in B. The save closure must capture the entry id when the change is noted, not when the timer fires. Pinned by manual check M3 in Task 4; a unit test needs the wiring out of the widget, which is candidate K1 and out of scope.
4. **The user deletes every character of an existing entry, then leaves.** No empty entry may exist afterwards. `HiveService.updateJournalEntry` already deletes when text and media are both empty, so the requirement is that autosave calls it rather than `addJournalEntry`. Pinned by manual check M4 in Task 4.
5. **A Daily You import finishes while the editor is open.** The home list must show the imported entries. This is what the self-write guard could break by swallowing a notification that was not self-inflicted. Pinned by Task 2's third test.

---

### Task 1: Self-write gate

**Files:**
- Create: `lib/app/modules/home/self_write_gate.dart`
- Test: `test/self_write_gate_test.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: `SelfWriteGate` with `void begin()`, `bool isSelfWrite()`, `int get depth`. `begin()` marks the next box notification as self-inflicted; `isSelfWrite()` consumes the mark and reports whether the notification it answers was one. Nested `begin()` calls need the same number of `isSelfWrite()` calls before a foreign notification is seen as foreign.

- [ ] **Step 1: Write the failing test**

```dart
test('consumes one mark per begin, and reports a foreign change after', () {
  final gate = SelfWriteGate();
  gate.begin();
  expect(gate.isSelfWrite(), isTrue);
  expect(gate.isSelfWrite(), isFalse);
});

test('nested begin needs as many reads as there were writes', () {
  final gate = SelfWriteGate();
  gate.begin();
  gate.begin();
  expect(gate.isSelfWrite(), isTrue);
  expect(gate.isSelfWrite(), isTrue);
  expect(gate.isSelfWrite(), isFalse);
});

test('depth reports the marks still outstanding', () {
  final gate = SelfWriteGate();
  expect(gate.depth, 0);
  gate.begin();
  gate.begin();
  expect(gate.depth, 2);
  gate.isSelfWrite();
  expect(gate.depth, 1);
});
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `flutter test test/self_write_gate_test.dart`
Expected: FAIL, `Error: Couldn't resolve the package 'open_jot'` or `SelfWriteGate` undefined.

- [ ] **Step 3: Implement `SelfWriteGate` in `lib/app/modules/home/self_write_gate.dart`**

A depth counter. `begin()` increments it. `isSelfWrite()` returns true and decrements when the depth is above zero, otherwise returns false.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/self_write_gate_test.dart`
Expected: PASS, 3 tests.

- [ ] **Step 5: Commit**

```bash
git add lib/app/modules/home/self_write_gate.dart test/self_write_gate_test.dart
git commit -m "feat: add SelfWriteGate, so the controller can tell its own writes apart"
```

---

### Task 2: Coalesced reload

**Files:**
- Create: `lib/app/modules/home/reload_coalescer.dart`
- Test: `test/reload_coalescer_test.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: `ReloadCoalescer({required VoidCallback onFire, this.window = const Duration(milliseconds: 300)})` with `void schedule()` and `void dispose()`. `schedule()` restarts a single timer; when the window elapses with no further call, `onFire` runs once. Repeated calls inside the window produce one `onFire`.

- [ ] **Step 1: Write the failing test**

```dart
test('one call fires once after the window', () {
  fakeAsync((async) {
    var fires = 0;
    final c = ReloadCoalescer(onFire: () => fires++, window: const Duration(milliseconds: 300));
    c.schedule();
    async.elapse(const Duration(milliseconds: 299));
    expect(fires, 0);
    async.elapse(const Duration(milliseconds: 1));
    expect(fires, 1);
  });
});

test('a burst inside the window fires once, not once per call', () {
  fakeAsync((async) {
    var fires = 0;
    final c = ReloadCoalescer(onFire: () => fires++, window: const Duration(milliseconds: 300));
    c.schedule();
    async.elapse(const Duration(milliseconds: 100));
    c.schedule();
    async.elapse(const Duration(milliseconds: 100));
    c.schedule();
    async.elapse(const Duration(milliseconds: 299));
    expect(fires, 0);
    async.elapse(const Duration(milliseconds: 1));
    expect(fires, 1);
  });
});

test('dispose cancels a pending fire', () {
  fakeAsync((async) {
    var fires = 0;
    final c = ReloadCoalescer(onFire: () => fires++, window: const Duration(milliseconds: 300));
    c.schedule();
    c.dispose();
    async.elapse(const Duration(seconds: 5));
    expect(fires, 0);
  });
});
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `flutter test test/reload_coalescer_test.dart`
Expected: FAIL, `ReloadCoalescer` undefined.

- [ ] **Step 3: Implement `ReloadCoalescer` in `lib/app/modules/home/reload_coalescer.dart`**

One `Timer?`. `schedule()` cancels and restarts it. The timer callback clears the field and calls `onFire`. `dispose()` cancels and clears. This covers Review Focus item 5: an imported entry arrives as a foreign notification, and the coalescer still fires for it.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/reload_coalescer_test.dart`
Expected: PASS, 3 tests.

- [ ] **Step 5: Commit**

```bash
git add lib/app/modules/home/reload_coalescer.dart test/reload_coalescer_test.dart
git commit -m "feat: add ReloadCoalescer, so a burst of writes costs one reload"
```

---

### Task 3: HomeController uses both

**Files:**
- Modify: `lib/app/modules/home/home_controller.dart:12-13` (fields), `:57-62` (`onInit`), `:126-128` (`onClose`), `:167-215` (`addJournalEntry`, `updateJournalEntry`, `deleteJournalEntry`)
- Test: `test/home_controller_reload_policy_test.dart`

**Interfaces:**
- Consumes: `SelfWriteGate` and `ReloadCoalescer` from Tasks 1 and 2; `DraftAutosave.save` is not involved here.
- Produces: no new public names. `HomeController`'s existing method signatures are unchanged: `void addJournalEntry(JournalEntry)`, `void updateJournalEntry(JournalEntry)`, `void deleteJournalEntry(String)`, `Future<void> loadJournalEntries()`.

- [ ] **Step 1: Write the failing test**

The test drives the policy the controller now uses, without constructing a controller. Build a gate and a coalescer, wire the coalescer to a counter, and assert what a self-write and a foreign write each produce.

```dart
test('a self write does not schedule a reload, a foreign one does', () {
  fakeAsync((async) {
    var reloads = 0;
    final gate = SelfWriteGate();
    final coalescer = ReloadCoalescer(onFire: () => reloads++);

    // What the controller now does for each of its own writes.
    gate.begin();
    // box notification arrives
    expect(gate.isSelfWrite(), isTrue);

    // What the controller now does for a write from outside, such as an import.
    expect(gate.isSelfWrite(), isFalse);
    coalescer.schedule();

    async.elapse(const Duration(milliseconds: 301));
    expect(reloads, 1);
  });
});
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/home_controller_reload_policy_test.dart`
Expected: PASS, because both policies already exist. This test documents the contract Task 3 wires; if it fails, the policy signatures drifted from Tasks 1 and 2. Do not write code to make a passing test pass.

- [ ] **Step 3: Wire the controller**

In `onInit`, replace `addListener(loadJournalEntries)` with a listener that asks the gate first and schedules the coalescer when the change is foreign. Build the coalescer with `onFire: loadJournalEntries`. In `onClose`, remove the listener and dispose the coalescer. In `addJournalEntry`, `updateJournalEntry` and `deleteJournalEntry`, call `begin()` before the `HiveService` call and nothing after it: the box notifier fires synchronously for `put` and `delete`, so the mark is consumed by the notification that the write itself causes.

If a write path turns out not to notify synchronously, do not add a delay: switch the gate to a generation number, incremented in `begin()` and compared in the listener, so a notification carries the generation it was raised under. Note which one you used in the commit message.

- [ ] **Step 4: Verify**

Run: `flutter analyze` then `flutter test`
Expected: no issues; all tests pass, including the 6 from Tasks 1 and 2, the 9 from `DraftAutosave`, and this task's 1.

- [ ] **Step 5: Commit**

```bash
git add lib/app/modules/home/home_controller.dart test/home_controller_reload_policy_test.dart
git commit -m "perf: stop reloading the journal for the controller's own writes, and coalesce the rest"
```

---

### Task 4: The editor reports changes to DraftAutosave

**Files:**
- Modify: `lib/app/modules/write_journal/write_journal_bottom_sheet.dart:124-151` (`initState`, `didChangeAppLifecycleState`), `:338-358` (`dispose`), `:465-536` (`_handleTextChange`), and the media, tag, mood, location and bookmark mutation paths that call `setState`
- Test: none. There is no correct seam: the save closure closes over widget state and the box is behind `HiveService`, so a test here would pump a 2.8k-line widget and a real Hive box, which is exactly the false confidence the spec rules out.

**Interfaces:**
- Consumes: `DraftAutosave` from `lib/app/modules/write_journal/draft_autosave.dart`, already present: `void noteChange()`, `Future<void> flush()`, `void discard()`, `void dispose()`, `bool get hasPendingChanges`.
- Produces: nothing outside this widget.

- [ ] **Step 1: Build the autosave in `initState`**

```dart
_autosave = DraftAutosave(save: () async => _saveEntry(isDraft: true));
```

The save closure must read `_currentEntryId` and the preview lists **when it runs**, because the field is what the write targets. Do not capture them at construction time — that is Review Focus item 3, and capturing them here is the bug.

- [ ] **Step 2: Report changes**

Call `_autosave.noteChange()` from `_handleTextChange`, and from each path that mutates `_previewImages`, `_previewPhotos`, `_previewAudios`, `_previewRecordings`, `_tags`, `_selectedMoodIndex`, `_selectedLocation` or `_isBookmarked`.

Keep the existing guard in `_handleTextChange` that ignores `ChangeSource.remote` while `_isFormatting` is set: a remote change is the document being rewritten by the autolink pass, not the user typing, and noting it as a change would make autosave fire on its own edits.

- [ ] **Step 3: Flush and discard at the lifecycle edges**

In `didChangeAppLifecycleState`, for `paused`, `inactive` and `detached`, replace the direct `_saveEntry(isDraft: true)` with `await _autosave.flush()`. In `dispose`, call `_autosave.flush()` and then `_autosave.dispose()`. Where the code sets `_isSavedOrDiscarded = true` (the Done path and the discard dialogs), call `_autosave.discard()` after the save completes, so a completed save is not followed by a stray draft write.

- [ ] **Step 4: Verify statically**

Run: `flutter analyze` then `flutter test`
Expected: no issues; all 16 tests pass.

- [ ] **Step 5: Device check, before the commit message claims it works**

Install the debug APK on a phone. Then, in order:

- **M1** Open a new entry, type for ten seconds, then kill the app from the OS while it is in the foreground. Reopen: the draft is there with the last line of text.
- **M2** Open an entry, start attaching a photo, and press Home before the picker returns. Reopen: the entry is not half-attached, and the text is still there.
- **M3** Open entry A, type, press back within two seconds, then open entry B and type. Save A's text is in A, B's in B, neither in the wrong entry.
- **M4** Open an entry, delete every character, press back. Reopen: no empty entry exists in the list.

Record which of M1 to M4 you ran and what happened. If a device is not available, say so in the pull request rather than implying the check passed.

- [ ] **Step 6: Commit**

```bash
git add lib/app/modules/write_journal/write_journal_bottom_sheet.dart
git commit -m "feat: autosave the entry draft two seconds after the last change

Flushes on pause, inactive, detached and dispose, and discards the pending
write once a save or a user discard has completed.

Verified: flutter analyze clean, 16 tests pass, and manual checks M1-M4 on a
device (list which ones)."
```

---

## Self-review

- **Spec coverage.** Cheap write path: Tasks 1 to 3. Coalesced reloads: Task 2 and Task 3. The autosave module: already landed; Task 4 wires it. The test that fails without the autosave: the 9 existing `DraftAutosave` tests. The sequencing note: Global Constraints. All covered.
- **Step scan.** Each step yields one action with a checkable result. Task 3 Step 2 is the one odd step: it expects a pass, and says what to do if it does not. That is deliberate — the policies are built and tested before the controller uses them, so a failing contract test means drift, not missing code.
- **Type consistency.** `SelfWriteGate.begin/isSelfWrite/depth`, `ReloadCoalescer(onFire:, window:)/schedule/dispose`, and `DraftAutosave.noteChange/flush/discard/dispose/hasPendingChanges` are used identically in the tasks that define them and the task that consumes them.
- **Review Focus.** Items 1 to 4 are pinned by M1 to M4 in Task 4, which is the task that owns the code and the only place a seam would be. Item 5 is pinned by Task 2's third test. No item is left without a pin, and the four without an automated test say so.
- **Proportion.** The spec is about 150 lines; this plan is about 250, of which roughly a third is test code the implementer must write. Within proportion.