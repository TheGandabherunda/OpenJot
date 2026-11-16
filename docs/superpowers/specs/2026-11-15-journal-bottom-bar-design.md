# Journal bottom bar and inline search — design

Date: 2026-11-15 · Status: implemented

## Intent

A fixed bottom bar on the journal screen: a search pill that expands into a full input on tap, plus a round write button on the right. Search filters the journal list in place (entries + drafts), no page navigation. The matching rule lives in one module (`EntryQuery`) so the filter predicates are not duplicated across screens.

## Goals

- One fixed bottom bar: search pill → full input on tap, Cancel visible only while searching, round write button on the right.
- Typing filters the journal list in place, including drafts.
- The matching rule lives in one pure, testable module (`EntryQuery`).
- `SearchView` and `exclude_entries_bottomsheet.dart` route through `EntryQuery` with unchanged behaviour.
- `flutter analyze`: **"No issues found!"** (CI treats infos as failures).
- No new dependencies.
- No Anchor code copied (Anchor is AGPL-3.0, OpenJot is Apache-2.0).

## Non-goals

- The editor (`write_journal_bottom_sheet.dart`).
- The blur (`progressive_blur` unchanged).
- The sort popup, stats row, year/month dividers.
- Anchor's motion system, tokens or l10n.

## Constraint decisions

- **Flutter 3.47.9 / Dart 3.13**, not 3.50 (AGP/Gradle incompatibility).
- `hive_service.dart` stays the only Hive owner; `HomeController` stays the only mutator of the Rx lists.
- The bar sits above the bottom safe area; list bottom padding `140.h` → `90.h`.
- Search query is lowercased by callers; `#` prefix stripped before `matchTagsOnly`.

## Files

| File | Role |
|------|------|
| `lib/app/modules/search/entry_criteria.dart` | `EntryCriteria` + `EntryQuery.filter()` — pure Dart, no GetX/Hive |
| `lib/app/core/widgets/journal_bottom_bar.dart` | `JournalBottomBar` widget — pill, input, Cancel, write button |
| `lib/app/modules/home/home_view.dart` | Bottom bar replaces floating FAB; inline search; drafts included |
| `lib/app/modules/search/search_view.dart` | Routes via `EntryQuery.filter`; duplicated tag check removed |
| `lib/app/modules/settings/exclude_entries_bottomsheet.dart` | Routes via `EntryQuery.filter`; duplicated media test removed |
| `lib/app/modules/write_journal/write_journal_bottom_sheet.dart` | M2 fix: close sheet on app `paused`/`detached` |
| `test/entry_criteria_test.dart` | Table test for `EntryQuery.filter` |

## Behaviour

- Idle: frosted pill with hint "Search entries or #tag", round write button on the right.
- Tap pill: pill expands to full-width `TextField`, Cancel appears between pill and write button.
- Type: filters `journalEntries + draftEntries` through `EntryQuery`, in place.
- Clear query / Cancel: restores unfiltered list.
- `#tag`: strip `#`, set `matchTagsOnly`, match against tags only.
- App background (`paused`/`detached`): editor sheet closes; draft autosave flushes.

## Left to the builder

None — all reviewer findings (C1–C3, I1–I8, minors) are fixed. Verified: `flutter analyze` clean, 44/44 tests pass.
