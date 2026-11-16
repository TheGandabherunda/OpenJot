import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;

/// The perf change in HomeController rests on one assumption: a box
/// notification arrives after the write's own future completes, but within one
/// event-loop turn. `SelfWriteGate` is marked before the write and cleared after
/// a `Duration.zero` grace turn, so if Hive delivered later than that, every
/// self-inflicted write would still reload the journal; if it delivered
/// synchronously, the mark would be pointless.
///
/// This test pins the timing against a real box, with no service in between.
void main() {
  late Directory tempDir;
  late Box<int> box;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('openjot_timing');
    Hive.init(p.join(tempDir.path, 'hive'));
    box = await Hive.openBox<int>('timing');
  });

  tearDown(() async {
    await box.deleteFromDisk();
    await Hive.close();
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  test('a notification is not delivered synchronously by put', () {
    var notifications = 0;
    box.listenable().addListener(() => notifications++);

    box.put(1, 1);

    expect(notifications, 0, reason: 'put must not call the listener inline');
  });

  test('a notification arrives by the time the write future completes', () async {
    var notifications = 0;
    box.listenable().addListener(() => notifications++);

    // What HomeController._selfWrite does: mark, await the write, yield one turn,
    // then clear. The notification must land inside the await, or the mark would
    // still be set when the next change from outside arrives.
    await box.put(2, 2);
    expect(notifications, 1, reason: 'the box event lands inside the write future');
  });

  test('a delete notifies the same way as a put', () async {
    var notifications = 0;
    box.listenable().addListener(() => notifications++);

    await box.put(3, 3);
    notifications = 0;

    // updateJournalEntry deletes when an entry ends up empty, so delete must
    // notify the same way as put for the gate to hold.
    await box.delete(3);
    expect(notifications, 1);

  });
}