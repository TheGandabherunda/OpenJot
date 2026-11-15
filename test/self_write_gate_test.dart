import 'package:flutter_test/flutter_test.dart';
import 'package:open_jot/app/modules/home/self_write_gate.dart';

void main() {
  group('SelfWriteGate', () {
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

    test('clear drops a mark the notification did not consume', () {
      final gate = SelfWriteGate();
      gate.begin();
      gate.clear();
      expect(gate.depth, 0);
      expect(gate.isSelfWrite(), isFalse);
    });
  });
}