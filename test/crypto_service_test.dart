import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:open_jot/app/core/services/crypto_service.dart';
import 'package:pointycastle/api.dart' show InvalidCipherTextException;

void main() {
  group('AesGcmHiveCipher', () {
    test('round-trips plaintext at arbitrary buffer offsets and empty input', () {
      final key = CryptoService.generateDek();
      final cipher = AesGcmHiveCipher(key);

      for (final len in [0, 1, 15, 16, 17, 1024, 65536]) {
        final inp = Uint8List(len + 10);
        for (var i = 0; i < len; i++) {
          inp[i + 5] = (i * 31 + 7) & 0xff;
        }
        final encBuf = Uint8List(len + AesGcmHiveCipher.overheadLength + 20);
        final writtenEnc = cipher.encrypt(inp, 5, len, encBuf, 7);
        expect(writtenEnc, len + AesGcmHiveCipher.overheadLength);

        final decBuf = Uint8List(writtenEnc + 10);
        final writtenDec = cipher.decrypt(encBuf, 7, writtenEnc, decBuf, 3);
        expect(writtenDec, len);
        expect(
          decBuf.sublist(3, 3 + len),
          equals(inp.sublist(5, 5 + len)),
        );
      }
    });

    test('detects tampering and wrong key', () {
      final key1 = CryptoService.generateDek();
      final key2 = CryptoService.generateDek();
      final cipher1 = AesGcmHiveCipher(key1);
      final cipher2 = AesGcmHiveCipher(key2);

      final plaintext = Uint8List.fromList('Top secret journal entry'.codeUnits);
      final enc = Uint8List(cipher1.maxEncryptedSize(plaintext));
      final encLen = cipher1.encrypt(plaintext, 0, plaintext.length, enc, 0);

      // Flip a bit in ciphertext/tag
      final tampered = Uint8List.fromList(enc);
      tampered[AesGcmHiveCipher.nonceLength + 2] ^= 0x01;
      expect(
        () => cipher1.decrypt(tampered, 0, encLen, Uint8List(encLen), 0),
        throwsA(isA<InvalidCipherTextException>()),
      );

      // Wrong key
      expect(
        () => cipher2.decrypt(enc, 0, encLen, Uint8List(encLen), 0),
        throwsA(isA<InvalidCipherTextException>()),
      );
    });

    test('encrypts real Hive box on disk with AES-256-GCM', () async {
      final dir = await Directory.systemTemp.createTemp('openjot_hive_cipher_');
      try {
        Hive.init(dir.path);
        final dek = CryptoService.generateDek();
        final secretText = 'UltraSecretDiaryContent_XYZ_987654';

        final box = await Hive.openBox<String>(
          'encrypted_test',
          encryptionCipher: AesGcmHiveCipher(dek),
        );
        await box.put('note1', secretText);
        await box.flush();
        await box.close();

        final rawBytes =
            await File('${dir.path}/encrypted_test.hive').readAsBytes();
        expect(
          String.fromCharCodes(rawBytes).contains(secretText),
          isFalse,
        );

        final reopened = await Hive.openBox<String>(
          'encrypted_test',
          encryptionCipher: AesGcmHiveCipher(dek),
        );
        expect(reopened.get('note1'), secretText);
        await reopened.close();
      } finally {
        await Hive.close();
        await dir.delete(recursive: true);
      }
    });
  });

  group('CryptoService KDF, DEK wrapping, and .openjot backups', () {
    test('wraps and unwraps DEK with master password', () async {
      final dek = CryptoService.generateDek();
      final sw = Stopwatch()..start();
      final wrapped = await CryptoService.wrapDekWithPassword(
        dek: dek,
        password: 'CorrectHorseBatteryStaple!',
      );
      sw.stop();
      // ignore: avoid_print
      print('PBKDF2 (${wrapped.iterations} iters) elapsed: ${sw.elapsedMilliseconds}ms');

      final unwrapped = await CryptoService.unwrapDekWithPassword(
        password: 'CorrectHorseBatteryStaple!',
        saltB64: wrapped.saltB64,
        wrappedDekB64: wrapped.wrappedDekB64,
        iterations: wrapped.iterations,
      );
      expect(unwrapped, equals(dek));

      expect(
        () => CryptoService.unwrapDekWithPassword(
          password: 'WrongPassword',
          saltB64: wrapped.saltB64,
          wrappedDekB64: wrapped.wrappedDekB64,
          iterations: wrapped.iterations,
        ),
        throwsA(isA<InvalidCipherTextException>()),
      );
    });

    test('encrypts and decrypts .openjot backup payload', () async {
      final zipPayload = Uint8List.fromList(List.generate(4096, (i) => i % 251));
      final enc = await CryptoService.encryptBackupBytes(
        zipBytes: zipPayload,
        password: 'BackupPassword#42',
        iterations: 5000,
      );
      expect(CryptoService.isEncryptedHeaderPrefix(enc), isTrue);
      expect(CryptoService.isEncryptedBackupBytes(enc), isTrue);
      expect(
        CryptoService.isEncryptedHeaderPrefix(Uint8List.fromList([0x50, 0x4B, 0x03, 0x04])),
        isFalse,
      );

      final dec = await CryptoService.decryptBackupBytes(
        encryptedFileBytes: enc,
        password: 'BackupPassword#42',
      );
      expect(dec, equals(zipPayload));

      expect(
        () => CryptoService.decryptBackupBytes(
          encryptedFileBytes: enc,
          password: 'BadPassword',
        ),
        throwsA(isA<InvalidCipherTextException>()),
      );
    });
  });
}
