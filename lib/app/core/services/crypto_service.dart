import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart' as crypto;
import 'package:cryptography/dart.dart' as crypto_dart;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pointycastle/export.dart';

/// HiveCipher implementation backed by AES-256-GCM.
///
/// Each encrypted Hive frame has layout:
/// `[12-byte random nonce][ciphertext][16-byte GCM authentication tag]`.
class AesGcmHiveCipher implements HiveCipher {
  static const int keyLength = 32;
  static const int nonceLength = 12;
  static const int tagLength = 16;
  static const int overheadLength = nonceLength + tagLength;

  final Uint8List _keyBytes;
  final int _keyCrc;
  final Random _secureRandom = Random.secure();
  final GCMBlockCipher _cipher = GCMBlockCipher(AESEngine());

  AesGcmHiveCipher(Uint8List keyBytes)
      : _keyBytes = Uint8List.fromList(keyBytes),
        _keyCrc = _computeKeyCrc(keyBytes) {
    if (keyBytes.length != keyLength) {
      throw ArgumentError(
        'AesGcmHiveCipher requires a $keyLength-byte key, got ${keyBytes.length}.',
      );
    }
  }

  static int _computeKeyCrc(Uint8List keyBytes) {
    final digest = SHA256Digest().process(keyBytes);
    return _Crc32.compute(digest);
  }

  @override
  int calculateKeyCrc() => _keyCrc;

  @override
  int maxEncryptedSize(Uint8List inp) => inp.length + overheadLength;

  @override
  int encrypt(
    Uint8List inp,
    int inpOff,
    int inpLength,
    Uint8List out,
    int outOff,
  ) {
    final nonce = Uint8List(nonceLength);
    for (var i = 0; i < nonceLength; i++) {
      nonce[i] = _secureRandom.nextInt(256);
    }
    out.setRange(outOff, outOff + nonceLength, nonce);

    _cipher.init(
      true,
      AEADParameters(KeyParameter(_keyBytes), tagLength * 8, nonce, Uint8List(0)),
    );

    var written = 0;
    if (inpLength > 0) {
      written += _cipher.processBytes(
        inp,
        inpOff,
        inpLength,
        out,
        outOff + nonceLength,
      );
    }
    written += _cipher.doFinal(out, outOff + nonceLength + written);
    return nonceLength + written;
  }

  @override
  int decrypt(
    Uint8List inp,
    int inpOff,
    int inpLength,
    Uint8List out,
    int outOff,
  ) {
    if (inpLength < overheadLength) {
      throw InvalidCipherTextException(
        'Encrypted Hive frame too short ($inpLength bytes).',
      );
    }

    final nonce = Uint8List.sublistView(inp, inpOff, inpOff + nonceLength);
    _cipher.init(
      false,
      AEADParameters(KeyParameter(_keyBytes), tagLength * 8, nonce, Uint8List(0)),
    );

    var written = _cipher.processBytes(
      inp,
      inpOff + nonceLength,
      inpLength - nonceLength,
      out,
      outOff,
    );
    written += _cipher.doFinal(out, outOff + written);
    return written;
  }
}

/// Cryptographic primitives for Master Password KDF, DEK wrapping,
/// and `.openjot` AES-256-GCM encrypted backup archives.
///
/// On Android, heavy KDF and streaming file encrypt/decrypt run on a background
/// Kotlin thread via [MethodChannel] (`openjot/native_crypto`). On other platforms
/// and in tests, pure-Dart implementations execute inside [Isolate.run].
class CryptoService {
  static const int keyLengthBytes = 32;
  static const int saltLengthBytes = 16;
  static const int nonceLengthBytes = 12;
  static const int tagLengthBytes = 16;
  static const int defaultPbkdf2Iterations = 210000;

  static const MethodChannel _nativeChannel =
      MethodChannel('openjot/native_crypto');

  /// Magic header for encrypted OpenJot backups: `OJENC01\0` (8 bytes).
  static final Uint8List backupMagicHeader = Uint8List.fromList([
    0x4F, // O
    0x4A, // J
    0x45, // E
    0x4E, // N
    0x43, // C
    0x30, // 0
    0x31, // 1
    0x00, // \0
  ]);

  static const int _backupHeaderLength = 8 + 16 + 4; // magic + salt + iterations

  static bool get _useAndroidNativeChannel => !kIsWeb && Platform.isAndroid;

  static Uint8List randomBytes(int length) {
    final rng = Random.secure();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = rng.nextInt(256);
    }
    return bytes;
  }

  static Uint8List generateDek() => randomBytes(keyLengthBytes);

  static Future<Uint8List> _deriveKeyDartIsolate(
    String password,
    Uint8List salt,
    int iterations,
  ) {
    final saltCopy = Uint8List.fromList(salt);
    return Isolate.run(() async {
      final pbkdf2 = crypto_dart.DartPbkdf2(
        macAlgorithm: crypto.Hmac.sha256(),
        iterations: iterations,
        bits: keyLengthBytes * 8,
      );
      final secretKey = await pbkdf2.deriveKeyFromPassword(
        password: password,
        nonce: saltCopy,
      );
      return Uint8List.fromList(await secretKey.extractBytes());
    });
  }

  /// Derives a 256-bit key from [password] and [salt] off the UI thread.
  static Future<Uint8List> deriveKey({
    required String password,
    required Uint8List salt,
    int iterations = defaultPbkdf2Iterations,
  }) async {
    if (_useAndroidNativeChannel) {
      try {
        final result = await _nativeChannel.invokeMethod<Uint8List>(
          'pbkdf2',
          {
            'password': password,
            'salt': salt,
            'iterations': iterations,
            'bits': keyLengthBytes * 8,
          },
        );
        if (result != null) return result;
      } on MissingPluginException {
        // Fallback when running headless unit tests on Android environment.
      }
    }
    return _deriveKeyDartIsolate(password, salt, iterations);
  }

  /// Encrypts [plaintext] using AES-256-GCM inside a background isolate.
  /// Output format: `[12-byte nonce][ciphertext][16-byte GCM tag]`.
  static Future<Uint8List> aesGcmEncryptBytes({
    required Uint8List key,
    required Uint8List plaintext,
    Uint8List? aad,
  }) {
    if (key.length != keyLengthBytes) {
      throw ArgumentError('AES-256-GCM requires a $keyLengthBytes-byte key.');
    }
    final keyCopy = Uint8List.fromList(key);
    final plaintextCopy = Uint8List.fromList(plaintext);
    final aadCopy = aad != null ? Uint8List.fromList(aad) : const <int>[];
    final nonce = randomBytes(nonceLengthBytes);

    return Isolate.run(() async {
      final aesGcm = crypto_dart.DartAesGcm.with256bits();
      final secretBox = await aesGcm.encrypt(
        plaintextCopy,
        secretKey: crypto.SecretKey(keyCopy),
        nonce: nonce,
        aad: aadCopy,
      );
      return secretBox.concatenation();
    });
  }

  /// Decrypts bytes produced by [aesGcmEncryptBytes] inside a background isolate.
  /// Throws [InvalidCipherTextException] if the key/AAD/ciphertext is invalid.
  static Future<Uint8List> aesGcmDecryptBytes({
    required Uint8List key,
    required Uint8List encrypted,
    Uint8List? aad,
  }) {
    if (key.length != keyLengthBytes) {
      throw ArgumentError('AES-256-GCM requires a $keyLengthBytes-byte key.');
    }
    const minLen = nonceLengthBytes + tagLengthBytes;
    if (encrypted.length < minLen) {
      throw InvalidCipherTextException(
        'Encrypted payload too short (${encrypted.length} bytes).',
      );
    }

    final keyCopy = Uint8List.fromList(key);
    final encryptedCopy = Uint8List.fromList(encrypted);
    final aadCopy = aad != null ? Uint8List.fromList(aad) : const <int>[];

    return Isolate.run(() async {
      final aesGcm = crypto_dart.DartAesGcm.with256bits();
      final secretBox = crypto.SecretBox.fromConcatenation(
        encryptedCopy,
        nonceLength: nonceLengthBytes,
        macLength: tagLengthBytes,
        copy: false,
      );
      try {
        final clear = await aesGcm.decrypt(
          secretBox,
          secretKey: crypto.SecretKey(keyCopy),
          aad: aadCopy,
        );
        return clear is Uint8List ? clear : Uint8List.fromList(clear);
      } on crypto.SecretBoxAuthenticationError catch (e) {
        throw InvalidCipherTextException(e.toString());
      }
    });
  }

  /// Derives a KEK from [password] and wraps [dek] using AES-256-GCM.
  static Future<({String saltB64, String wrappedDekB64, int iterations})>
      wrapDekWithPassword({
    required Uint8List dek,
    required String password,
    int iterations = defaultPbkdf2Iterations,
  }) async {
    final salt = randomBytes(saltLengthBytes);
    final kek = await deriveKey(
      password: password,
      salt: salt,
      iterations: iterations,
    );
    try {
      final wrapped = await aesGcmEncryptBytes(
        key: kek,
        plaintext: dek,
        aad: salt,
      );
      return (
        saltB64: base64Encode(salt),
        wrappedDekB64: base64Encode(wrapped),
        iterations: iterations,
      );
    } finally {
      kek.fillRange(0, kek.length, 0);
    }
  }

  /// Unwraps the stored DEK using [password]. Throws [InvalidCipherTextException]
  /// on wrong password or tamper.
  static Future<Uint8List> unwrapDekWithPassword({
    required String password,
    required String saltB64,
    required String wrappedDekB64,
    required int iterations,
  }) async {
    final salt = Uint8List.fromList(base64Decode(saltB64));
    final wrapped = Uint8List.fromList(base64Decode(wrappedDekB64));
    final kek = await deriveKey(
      password: password,
      salt: salt,
      iterations: iterations,
    );
    try {
      return await aesGcmDecryptBytes(
        key: kek,
        encrypted: wrapped,
        aad: salt,
      );
    } finally {
      kek.fillRange(0, kek.length, 0);
    }
  }

  /// Checks whether [bytes] starts with the 8-byte `.openjot` magic header.
  static bool isEncryptedHeaderPrefix(Uint8List bytes) {
    if (bytes.length < backupMagicHeader.length) return false;
    for (var i = 0; i < backupMagicHeader.length; i++) {
      if (bytes[i] != backupMagicHeader[i]) return false;
    }
    return true;
  }

  /// Checks whether [bytes] begins with the `.openjot` encrypted backup header
  /// and is large enough to contain KDF params, nonce, and GCM tag.
  static bool isEncryptedBackupBytes(Uint8List bytes) {
    if (bytes.length < _backupHeaderLength + nonceLengthBytes + tagLengthBytes) {
      return false;
    }
    return isEncryptedHeaderPrefix(bytes);
  }

  /// Encrypts a `.zip` file on disk directly into `.openjot` at [outPath] off the UI thread.
  static Future<void> encryptBackupFile({
    required String zipPath,
    required String outPath,
    required String password,
    int iterations = defaultPbkdf2Iterations,
  }) async {
    if (_useAndroidNativeChannel) {
      try {
        await _nativeChannel.invokeMethod<void>(
          'encryptBackupFile',
          {
            'zipPath': zipPath,
            'outPath': outPath,
            'password': password,
            'iterations': iterations,
          },
        );
        return;
      } on MissingPluginException {
        // Fallback when running unit tests without Android Activity.
      }
    }

    final zipBytes = await File(zipPath).readAsBytes();
    final encBytes = await encryptBackupBytes(
      zipBytes: zipBytes,
      password: password,
      iterations: iterations,
    );
    await File(outPath).writeAsBytes(encBytes, flush: true);
  }

  /// Decrypts an `.openjot` file at [encPath] directly to `.zip` at [outZipPath]
  /// off the UI thread. Throws [InvalidCipherTextException] on wrong password.
  static Future<void> decryptBackupFile({
    required String encPath,
    required String outZipPath,
    required String password,
  }) async {
    if (_useAndroidNativeChannel) {
      try {
        await _nativeChannel.invokeMethod<void>(
          'decryptBackupFile',
          {
            'encPath': encPath,
            'outZipPath': outZipPath,
            'password': password,
          },
        );
        return;
      } on PlatformException catch (e) {
        if (e.code == 'INCORRECT_PASSWORD') {
          throw InvalidCipherTextException(
            e.message ?? 'Incorrect backup password.',
          );
        }
        rethrow;
      } on MissingPluginException {
        // Fallback when running unit tests without Android Activity.
      }
    }

    final encBytes = await File(encPath).readAsBytes();
    final zipBytes = await decryptBackupBytes(
      encryptedFileBytes: encBytes,
      password: password,
    );
    await File(outZipPath).writeAsBytes(zipBytes, flush: true);
  }

  /// Encrypts a `.zip` backup archive into the `.openjot` binary format.
  ///
  /// Layout:
  /// - `0..7`   : `OJENC01\0` magic (8 bytes)
  /// - `8..23`  : PBKDF2 salt (16 bytes)
  /// - `24..27` : PBKDF2 iteration count (uint32 big-endian)
  /// - `28..39` : AES-GCM nonce (12 bytes)
  /// - `40..end`: ciphertext + 16-byte GCM tag (AAD = bytes `0..27`)
  static Future<Uint8List> encryptBackupBytes({
    required Uint8List zipBytes,
    required String password,
    int iterations = defaultPbkdf2Iterations,
  }) async {
    final salt = randomBytes(saltLengthBytes);
    final header = Uint8List(_backupHeaderLength);
    header.setRange(0, backupMagicHeader.length, backupMagicHeader);
    header.setRange(8, 24, salt);
    ByteData.sublistView(header, 24, 28).setUint32(0, iterations, Endian.big);

    final key = await deriveKey(
      password: password,
      salt: salt,
      iterations: iterations,
    );
    try {
      final encryptedPayload = await aesGcmEncryptBytes(
        key: key,
        plaintext: zipBytes,
        aad: header,
      );
      final result = Uint8List(header.length + encryptedPayload.length);
      result.setRange(0, header.length, header);
      result.setRange(header.length, result.length, encryptedPayload);
      return result;
    } finally {
      key.fillRange(0, key.length, 0);
    }
  }

  /// Decrypts an `.openjot` encrypted backup back into raw `.zip` bytes.
  static Future<Uint8List> decryptBackupBytes({
    required Uint8List encryptedFileBytes,
    required String password,
  }) async {
    if (!isEncryptedBackupBytes(encryptedFileBytes)) {
      throw const FormatException('Not a valid encrypted OpenJot backup file.');
    }

    final header = Uint8List.fromList(
      Uint8List.sublistView(encryptedFileBytes, 0, _backupHeaderLength),
    );
    final salt = Uint8List.fromList(Uint8List.sublistView(header, 8, 24));
    final iterations =
        ByteData.sublistView(header, 24, 28).getUint32(0, Endian.big);
    if (iterations < 1000 || iterations > 10000000) {
      throw const FormatException('Unsupported backup KDF iteration count.');
    }

    final payload = Uint8List.sublistView(
      encryptedFileBytes,
      _backupHeaderLength,
    );
    final key = await deriveKey(
      password: password,
      salt: salt,
      iterations: iterations,
    );
    try {
      return await aesGcmDecryptBytes(
        key: key,
        encrypted: payload,
        aad: header,
      );
    } finally {
      key.fillRange(0, key.length, 0);
    }
  }
}

/// Standard IEEE 802.3 CRC32 table matching Hive's frame CRC calculation.
class _Crc32 {
  static int compute(Uint8List bytes) {
    var crc = 0xffffffff;
    for (var i = 0; i < bytes.length; i++) {
      crc = _table[(crc ^ bytes[i]) & 0xff] ^ (crc >> 8);
    }
    return crc ^ 0xffffffff;
  }

  static const List<int> _table = [
    0x00000000, 0x77073096, 0xee0e612c, 0x990951ba, 0x076dc419, 0x706af48f,
    0xe963a535, 0x9e6495a3, 0x0edb8832, 0x79dcb8a4, 0xe0d5e91e, 0x97d2d988,
    0x09b64c2b, 0x7eb17cbd, 0xe7b82d07, 0x90bf1d91, 0x1db71064, 0x6ab020f2,
    0xf3b97148, 0x84be41de, 0x1adad47d, 0x6ddde4eb, 0xf4d4b551, 0x83d385c7,
    0x136c9856, 0x646ba8c0, 0xfd62f97a, 0x8a65c9ec, 0x14015c4f, 0x63066cd9,
    0xfa0f3d63, 0x8d080df5, 0x3b6e20c8, 0x4c69105e, 0xd56041e4, 0xa2677172,
    0x3c03e4d1, 0x4b04d447, 0xd20d85fd, 0xa50ab56b, 0x35b5a8fa, 0x42b2986c,
    0xdbbbc9d6, 0xacbcf940, 0x32d86ce3, 0x45df5c75, 0xdcd60dcf, 0xabd13d59,
    0x26d930ac, 0x51de003a, 0xc8d75180, 0xbfd06116, 0x21b4f4b5, 0x56b3c423,
    0xcfba9599, 0xb8bda50f, 0x2802b89e, 0x5f058808, 0xc60cd9b2, 0xb10be924,
    0x2f6f7c87, 0x58684c11, 0xc1611dab, 0xb6662d3d, 0x76dc4190, 0x01db7106,
    0x98d220bc, 0xefd5102a, 0x71b18589, 0x06b6b51f, 0x9fbfe4a5, 0xe8b8d433,
    0x7807c9a2, 0x0f00f934, 0x9609a88e, 0xe10e9818, 0x7f6a0dbb, 0x086d3d2d,
    0x91646c97, 0xe6635c01, 0x6b6b51f4, 0x1c6c6162, 0x856530d8, 0xf262004e,
    0x6c0695ed, 0x1b01a57b, 0x8208f4c1, 0xf50fc457, 0x65b0d9c6, 0x12b7e950,
    0x8bbeb8ea, 0xfcb9887c, 0x62dd1ddf, 0x15da2d49, 0x8cd37cf3, 0xfbd44c65,
    0x4db26158, 0x3ab551ce, 0xa3bc0074, 0xd4bb30e2, 0x4adfa541, 0x3dd895d7,
    0xa4d1c46d, 0xd3d6f4fb, 0x4369e96a, 0x346ed9fc, 0xad678846, 0xda60b8d0,
    0x44042d73, 0x33031de5, 0xaa0a4c5f, 0xdd0d7cc9, 0x5005713c, 0x270241aa,
    0xbe0b1010, 0xc90c2086, 0x5768b525, 0x206f85b3, 0xb966d409, 0xce61e49f,
    0x5edef90e, 0x29d9c998, 0xb0d09822, 0xc7d7a8b4, 0x59b33d17, 0x2eb40d81,
    0xb7bd5c3b, 0xc0ba6cad, 0xedb88320, 0x9abfb3b6, 0x03b6e20c, 0x74b1d29a,
    0xead54739, 0x9dd277af, 0x04db2615, 0x73dc1683, 0xe3630b12, 0x94643b84,
    0x0d6d6a3e, 0x7a6a5aa8, 0xe40ecf0b, 0x9309ff9d, 0x0a00ae27, 0x7d079eb1,
    0xf00f9344, 0x8708a3d2, 0x1e01f268, 0x6906c2fe, 0xf762575d, 0x806567cb,
    0x196c3671, 0x6e6b06e7, 0xfed41b76, 0x89d32be0, 0x10da7a5a, 0x67dd4acc,
    0xf9b9df6f, 0x8ebeeff9, 0x17b7be43, 0x60b08ed5, 0xd6d6a3e8, 0xa1d1937e,
    0x38d8c2c4, 0x4fdff252, 0xd1bb67f1, 0xa6bc5767, 0x3fb506dd, 0x48b2364b,
    0xd80d2bda, 0xaf0a1b4c, 0x36034af6, 0x41047a60, 0xdf60efc3, 0xa867df55,
    0x316e8eef, 0x4669be79, 0xcb61b38c, 0xbc66831a, 0x256fd2a0, 0x5268e236,
    0xcc0c7795, 0xbb0b4703, 0x220216b9, 0x5505262f, 0xc5ba3bbe, 0xb2bd0b28,
    0x2bb45a92, 0x5cb36a04, 0xc2d7ffa7, 0xb5d0cf31, 0x2cd99e8b, 0x5bdeae1d,
    0x9b64c2b0, 0xec63f226, 0x756aa39c, 0x026d930a, 0x9c0906a9, 0xeb0e363f,
    0x72076785, 0x05005713, 0x95bf4a82, 0xe2b87a14, 0x7bb12bae, 0x0cb61b38,
    0x92d28e9b, 0xe5d5be0d, 0x7cdcefb7, 0x0bdbdf21, 0x86d3d2d4, 0xf1d4e242,
    0x68ddb3f8, 0x1fda836e, 0x81be16cd, 0xf6b9265b, 0x6fb077e1, 0x18b74777,
    0x88085ae6, 0xff0f6a70, 0x66063bca, 0x11010b5c, 0x8f659eff, 0xf862ae69,
    0x616bffd3, 0x166ccf45, 0xa00ae278, 0xd70dd2ee, 0x4e048354, 0x3903b3c2,
    0xa7672661, 0xd06016f7, 0x4969474d, 0x3e6e77db, 0xaed16a4a, 0xd9d65adc,
    0x40df0b66, 0x37d83bf0, 0xa9bcae53, 0xdebb9ec5, 0x47b2cf7f, 0x30b5ffe9,
    0xbdbdf21c, 0xcabac28a, 0x53b39330, 0x24b4a3a6, 0xbad03605, 0xcdd70693,
    0x54de5729, 0x23d967bf, 0xb3667a2e, 0xc4614ab8, 0x5d681b02, 0x2a6f2b94,
    0xb40bbe37, 0xc30c8ea1, 0x5a05df1b, 0x2d02ef8d,
  ];
}
