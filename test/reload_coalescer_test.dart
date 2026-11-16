import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_jot/app/modules/home/reload_coalescer.dart';

void main() {
  group('ReloadCoalescer', () {
    test('one call fires once after the window', () {
      fakeAsync((async) {
        var fires = 0;
        final c = ReloadCoalescer(
          onFire: () => fires++,
          window: const Duration(milliseconds: 300),
        );
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
        final c = ReloadCoalescer(
          onFire: () => fires++,
          window: const Duration(milliseconds: 300),
        );
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
        final c = ReloadCoalescer(
          onFire: () => fires++,
          window: const Duration(milliseconds: 300),
        );
        c.schedule();
        c.dispose();
        async.elapse(const Duration(seconds: 5));
        expect(fires, 0);
      });
    });
  });
}