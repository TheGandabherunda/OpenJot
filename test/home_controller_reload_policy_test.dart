import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_jot/app/modules/home/reload_coalescer.dart';
import 'package:open_jot/app/modules/home/self_write_gate.dart';

void main() {
  group('journal reload policy', () {
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

    test('a burst of foreign writes still reloads once', () {
      fakeAsync((async) {
        var reloads = 0;
        final gate = SelfWriteGate();
        final coalescer = ReloadCoalescer(onFire: () => reloads++);

        // A restore writes every entry in turn; none of it is self-inflicted.
        for (var i = 0; i < 50; i++) {
          expect(gate.isSelfWrite(), isFalse);
          coalescer.schedule();
        }

        async.elapse(const Duration(milliseconds: 301));
        expect(reloads, 1);
      });
    });

    test('a leftover mark from a write that raised no notification does not swallow a later import', () {
      fakeAsync((async) {
        var reloads = 0;
        final gate = SelfWriteGate();
        final coalescer = ReloadCoalescer(onFire: () => reloads++);

        // The controller marks a write and then drops what the box did not
        // consume, the way the write helper in HomeController does.
        gate.begin();
        gate.clear();
        expect(gate.depth, 0);

        // An import arrives later. The dropped mark must not eat it.
        expect(gate.isSelfWrite(), isFalse);
        coalescer.schedule();
        async.elapse(const Duration(milliseconds: 301));
        expect(reloads, 1);
      });
    });
  });
}