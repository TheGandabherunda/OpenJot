# Dependency baseline upgrade — design

Date: 2026-11-15 · Branch: `chore/dependency-baseline-upgrade` · Status: awaiting approval

## Intent

The dependency set is between one and four years behind. Two causes, one of them structural:

1. **The Dart baseline is the ceiling.** `pubspec.yaml` declares `sdk: '>=3.2.3 <4.0.0'`, and CI builds with Flutter 3.41.2 (Dart 3.11.0). Most current releases of `flutter_quill`, `record`, `video_player`, `sqflite`, `pdf`, `printing`, `shimmer`, `flutter_svg`, `camera` and `flutter_local_notifications` require Dart `^3.12.0` or newer. They cannot be installed until the baseline moves.
2. **`flutter_local_notifications` is pinned by its own version syntax.** `^21.0.0-dev.2` is a caret on a prerelease, so pub only ever considers the 21.0.0-dev line. It has been stuck there for a year while 22.3.3 and 23.0.2 shipped.

The goal is a dependency set that is current, that installs, that analyzes clean, and that is verified by a command someone can re-run — not a `pubspec.yaml` that looks modern and does not compile.

## Goals

- Every direct dependency at the newest release that the chosen Dart baseline allows, including the five majors (`file_picker` 13, `permission_handler` 13, `device_info_plus` 13, `package_info_plus` 10, `flutter_local_notifications` 23).
- Dart and Flutter SDK constraints in `pubspec.yaml` that state the real floor, not a historical one.
- `flutter pub get`, `flutter analyze` and `flutter test` all pass on the new set.
- Remove dependencies nothing imports.
- CI that runs the three commands above on every push, so the next bump is not a guess.

## Non-goals

- Migrating off `hive`. `hive` 2.2.3 (2022) and `hive_flutter` 1.1.0 (2021) have no newer release; replacing them means a storage engine change, a data migration and its own design. Out of scope here.
- Fixing the `progressive_blur` rendering bug on some Android devices. That is a separate diagnosis.
- The performance work (full-list reload on every save, blocked first frame, mood raster memory).
- Any behaviour change beyond what an API change forces.

## Anti-goals

- A green `pub get` with a red build. Resolvable versions are not working code.
- Bumping without a re-runnable verification command.
- Splitting this into six pull requests, each of which leaves the tree unbuildable between merges.

## Constraints

- **The app must still write and read existing Hive data.** The `JournalEntry` Hive adapter (`journal_entry.g.dart`) and the settings/mood/reminder migrations in `hive_service.dart` are load-bearing for real users' journals. No dependency may force a change to persisted data.
- **`flutter_quill` is pinned exactly** (`flutter_quill: 11.5.0`, no caret). That pin is deliberate. A move to 11.6.0 changes it to a range and must be checked against the editor code that depends on internals: `write_journal_bottom_sheet.dart` (`toDelta`, `Document.fromJson`, `Attribute.rtl`, `ChangeSource.remote`) and `write_journal_toolbar_content.dart`.
- **Android minSdk is 24** (`android/app/build.gradle.kts`). `permission_handler` 13 and `device_info_plus` 13 raise their own floors; check them against 24 rather than assuming.
- **Verification happens on box-04**, not on the machine that holds the working tree. box-02 (where this file is written) has Flutter 3.47.9 / Dart 3.13.7 and 4.9 GiB free, which cannot resolve `sdk: ^3.14.0`. box-04 has Flutter 3.50.0 / Dart 3.14.0, the Android SDK, and 7.9 GiB free.

## Approaches

### A · Bump within the old baseline

Take the newest release of each package that still fits Dart 3.11. 23 packages move. Rejected: `flutter_quill` stays at 11.5.0, `record` at 6.2.1, `video_player` at 2.11.1 — the three packages the editor and media paths churn on most stay a generation behind, and the prerelease pin on notifications is untouched in spirit.

### B · Move the baseline, then take everything current — chosen

Raise the SDK floor, then bump every direct dependency to the newest release the new floor allows, majors included. This is the only route that clears the structural cause rather than routing around it, and it is the route you picked.

**The floor, and where it is verified.** Verification runs on the box-04 self-hosted runner, which now has Flutter 3.50.0 / Dart 3.14.0 and the Android SDK installed. So the floor goes to `sdk: ^3.14.0` and `flutter: ^3.50.0` — the newest stable, not a compromise. box-02 has Flutter 3.47.9 / Dart 3.13.7 and cannot resolve this set; it is no longer part of the loop.

### C · Patch only

Eight packages, zero API risk, ceiling untouched. Rejected: it leaves the cause in place and would have to be redone as B a month later.

## Target versions

Newest release installable under Dart 3.13.7. `now` is the current constraint in `pubspec.yaml`.

| package | now | target | kind |
| --- | --- | --- | --- |
| get | ^4.7.2 | ^4.7.3 | patch |
| hive | ^2.2.3 | ^2.2.3 | no newer release exists |
| hive_flutter | ^1.1.0 | ^1.1.0 | no newer release exists |
| sqflite | ^2.4.1 | ^2.4.6 | minor |
| markdown_quill | ^4.3.0 | ^4.3.0 | none |
| flutter_quill | 11.5.0 (pinned) | ^11.6.0 | minor, unpins |
| flutter_screenutil | ^5.9.3 | ^5.9.3 | none |
| modal_bottom_sheet | ^3.0.0 | ^3.0.0 | none |
| progressive_blur | ^0.0.2 | ^0.0.2 | none |
| shimmer | ^3.0.0 | ^4.0.0 | major |
| smooth_corner | ^1.1.1 | ^1.1.1 | none |
| archive | ^4.0.7 | ^4.7.1 | minor |
| audioplayers | ^6.5.0 | ^6.8.1 | minor |
| camera | ^0.11.2 | ^0.12.2 | breaking (0.x) |
| file_picker | ^10.3.2 | ^13.3.3 | major, two majors |
| image | ^4.5.4 | ^4.13.1 | minor |
| pdf | ^3.11.3 | ^3.13.1 | minor |
| permission_handler | ^12.0.1 | ^13.0.2 | major |
| photo_manager | ^3.7.1 | ^3.12.0 | minor |
| photo_manager_image_provider | ^2.2.0 | ^2.2.0 | none |
| printing | ^5.14.2 | ^5.15.1 | minor |
| record | ^6.1.1 | ^7.2.0 | major |
| video_player | ^2.10.0 | ^2.14.1 | minor |
| flutter_map | ^8.2.1 | ^8.3.2 | minor |
| latlong2 | ^0.9.0 | ^0.10.1 | breaking (0.x) |
| flutter_local_notifications | ^21.0.0-dev.2 | ^23.0.2 | major, off prerelease |
| flutter_timezone | ^5.0.0 | ^5.1.1 | minor |
| timezone | ^0.11.0 | ^0.11.2 | patch |
| local_auth | ^3.0.0 | ^3.0.2 | patch |
| device_info_plus | ^12.1.0 | ^13.3.0 | major |
| intl | ^0.20.2 | ^0.20.3 | patch |
| package_info_plus | ^9.0.0 | ^10.2.2 | major |
| palette_generator | ^0.3.3+7 | ^0.3.3+7 | none |
| path | ^1.9.0 | ^1.9.1 | patch |
| path_provider | ^2.1.5 | ^2.1.6 | patch |
| url_launcher | ^6.3.2 | ^6.3.3 | patch |
| uuid | ^4.5.1 | ^4.6.0 | minor |
| build_runner (dev) | ^2.4.13 | ^2.17.1 | minor; drops 2 discontinued transitives |

### Removals

- `flutter_staggered_grid_view` — no `package:` import anywhere in `lib/`. It appears only as a name in the licences screen (`terms_and_conditions_screen.dart:27`).
- `vector_graphics` — same: no import, only a credit line at `terms_and_conditions_screen.dart:29`. It stays available transitively through `flutter_svg` if anything needs it.

Both credit lines get removed with the dependency.

### dev_dependencies

| package | now | target | kind |
| --- | --- | --- | --- |
| build_runner | ^2.4.13 | ^2.17.1 | minor |
| flutter_lints | ^6.0.0 | ^6.0.0 | none |
| hive_generator | ^2.0.1 | ^2.0.1 | none; dead upstream, tied to `hive` |

`build_runner` matters more than its version suggests. `flutter pub outdated` reports that the pinned 2.4.13 drags in two **discontinued** packages, `build_resolvers` and `build_runner_core`, both stuck at their final versions. Moving to 2.17.1 removes them from the graph.

## Known breakage to expect

Predicted from where the code touches each API. `flutter analyze` decides, not this list.

| package | code that must change |
| --- | --- |
| flutter_local_notifications 21 → 23 | `notification_service.dart` — `initialize`, `zonedSchedule` and the `AndroidScheduleMode` argument, `AndroidInitializationSettings`, `DarwinInitializationSettings` (whole file, 360 LOC) |
| file_picker 10 → 13 | `settings_controller.dart:323`, `write_journal_toolbar_content.dart:404`, `hive_service.dart:569` (`saveFile`), `:606` |
| permission_handler 12 → 13 | `write_journal_bottom_sheet.dart:156,737,758,765`, `hive_service.dart:427`, `permission_service.dart` |
| device_info_plus 12 → 13 | `hive_service.dart:425`, `permission_service.dart:11` (`androidInfo`) |
| package_info_plus 9 → 10 | `settings_bottomsheet.dart:35`, `about_screen.dart:30` (`PackageInfo.fromPlatform`) |
| camera 0.11 → 0.12 | `camera_view.dart`, `write_journal_bottom_sheet.dart` (`XFile` paths at `:294,301,1166`), `read_journal_bottom_sheet.dart:153` |
| latlong2 0.9 → 0.10 | `location_map_view.dart:22,159,237,331` and every `SelectedLocation` use |
| flutter_quill 11.5 → 11.6 | `write_journal_bottom_sheet.dart:223,232,362,392-398,465,850-938`, `write_journal_toolbar_content.dart` |
| record 6 → 7 | `AudioRecorderView` in `write_journal_toolbar_content.dart:1181+` |
| shimmer 3 → 4 | `write_journal_bottom_sheet.dart:33`, `write_journal_toolbar_content.dart:30` |

## Verification

One command chain, run on this machine with the toolchain at `/data/workspace/toolchain/flutter`:

```sh
# on box-04, where Flutter 3.50.0 / Dart 3.14.0 and the Android SDK live
export PATH=/data/workspace/toolchain/flutter/bin:$PATH
export ANDROID_HOME=/data/workspace/android-sdk
cd OpenJot
flutter pub get          # proves the set resolves
flutter analyze          # proves the code compiles against the new APIs
flutter test             # proves nothing regressed (currently 0 tests)
```

What each step proves, and does not:

- `pub get` — the versions resolve together. Proves nothing about compilation.
- `analyze` — static analysis clean. Catches every broken call site listed above, since all of them are compile-time.
- `test` — currently vacuous: `test/widget_test.dart` is 0 bytes. It will stay vacuous until a test exists. Not a safety net; do not treat it as one.
- **Not verified by any of the three:** that the app runs, that journals still load, that media, reminders, backup/restore and the PDF export still work. Those need a device. Whoever merges this must install the APK and write one entry with a photo, one recording, a reminder and a backup round-trip.

## Disk cost, measured

Measured on this machine (box-02), `/data` 20 GiB, 4.9 GiB free before starting:

| step | cost on /data |
| --- | --- |
| `flutter pub get` on the current set | **307 MB** (measured: 5047 MB → 4740 MB free) |
| `flutter analyze` | no download; runs from the toolchain |
| `flutter test` | no download; currently 0 tests |
| Android SDK (cmdline-tools, platform, build-tools) | 1.0–1.5 GiB |
| Gradle distribution + dependency cache + `build/` | 1.5–2.5 GiB |
| one debug APK build, all in | **~3 GiB** |

The toolchain itself is already installed and is not part of this cost: `/data/workspace/toolchain/flutter` is 2.3 GiB and ships with the machine image.

box-02 is tight on disk (4.9 GiB free) and tops out at Dart 3.13.7, so it does not verify this work. box-04 does, and it has room: after installing Flutter 3.50.0 (1.5 GiB) and the Android SDK (447 MB), it sits at 12 GiB used of 20 GiB, **7.9 GiB free**.

## CI

`.github/workflows/ci.yml`, on every push and pull request: `flutter --version` → `flutter pub get` → `flutter analyze` → `flutter test`, with a concurrency group so a newer push cancels the older run.

**Runner setup is done** (2026-11-15). box-04 now carries a second runner instance:

| | |
| --- | --- |
| runner name | `box-04-openjot` |
| registered for | `https://github.com/muava12/OpenJot` |
| labels | `self-hosted`, `Linux`, `X64`, `flutter` |
| home | `/data/workspace/gh-runner-openjot` |
| service | `actions.runner.muava12-OpenJot.box-04-openjot.service` (active) |
| toolchain | Flutter 3.50.0 / Dart 3.14.0 at `/data/workspace/toolchain/flutter`, on the runner's `.path` |
| Android SDK | `/data/workspace/android-sdk` (cmdline-tools, platform-tools, platform 36, build-tools 36) |

Two things worth knowing. The pre-existing `muava12/anchor` runner on the same box claimed the `flutter` label with no Flutter installed, so anchor's `mobile-lint` job could not have passed there; installing the toolchain fixed that too. And `sudo` on box-04 needs no password, so any push to this repository can run arbitrary code there — restrict `pull_request` to same-repo branches before accepting outside contributions.

The one thing CI does not prove: that the app runs. `pub get`, `analyze` and `test` are static. Someone must install the APK and write one entry with a photo, one recording, a reminder and a backup round-trip.

## Left to the builder

1. Branch from `origin/main`, bump `sdk` and `flutter` constraints, bump every row in the target table, remove the two unused dependencies and their credit lines.
2. `flutter pub get`, then fix every analyze error. Work package by package, largest API surface first: notifications, then file_picker, permission_handler, camera, quill.
3. Unpin `flutter_quill` last, after everything else is green, so a quill regression is distinguishable from the rest.
4. Keep `hive`, `hive_flutter`, `markdown_quill`, `progressive_blur` and `flutter_screenutil` untouched.
5. Add the CI workflow.
6. Report the analyze-clean commit, then hand off for on-device verification.

Do not bump the version number in `pubspec.yaml` (`1.2.0+4`) as part of this; release versioning is a separate decision.