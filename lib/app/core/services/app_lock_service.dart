import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/crypto_service.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:pointycastle/api.dart' show InvalidCipherTextException;

class AppLockService extends GetxService {
  static const String _biometricDekKey = 'openjot_biometric_dek';

  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final _hiveService = Get.find<HiveService>();

  Future<bool> isBiometricAvailable() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    return canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: AppConstants.authenticateToUnlock.tr,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> saveDekForBiometrics(Uint8List dek) async {
    await _secureStorage.write(
      key: _biometricDekKey,
      value: base64Encode(dek),
    );
  }

  Future<void> clearBiometricDek() async {
    await _secureStorage.delete(key: _biometricDekKey);
  }

  Future<bool> hasBiometricDekStored() async {
    final value = await _secureStorage.read(key: _biometricDekKey);
    return value != null && value.isNotEmpty;
  }

  /// Authenticates via biometrics, retrieves the Keystore-backed DEK, and
  /// unlocks the encrypted Hive journal box when database encryption is active.
  Future<bool> unlockWithBiometrics() async {
    if (!await isBiometricAvailable()) return false;
    final authenticated = await authenticate();
    if (!authenticated) return false;

    if (!_hiveService.dbEncryptionEnabled) {
      return true;
    }

    final encoded = await _secureStorage.read(key: _biometricDekKey);
    if (encoded == null || encoded.isEmpty) {
      return false;
    }

    final dek = Uint8List.fromList(base64Decode(encoded));
    try {
      await _hiveService.unlockJournalsBox(dek);
      return true;
    } catch (e) {
      debugPrint('Failed unlocking with biometric DEK: $e');
      return false;
    } finally {
      dek.fillRange(0, dek.length, 0);
    }
  }

  /// Derives the KEK from [masterPassword], unwraps the stored DEK, and unlocks
  /// the encrypted database. Returns `false` if the password is incorrect.
  Future<bool> unlockWithMasterPassword(String masterPassword) async {
    final saltB64 = _hiveService.encryptionKdfSalt;
    final wrappedDekB64 = _hiveService.encryptionWrappedDek;
    if (saltB64 == null || wrappedDekB64 == null) {
      return false;
    }

    try {
      final dek = await CryptoService.unwrapDekWithPassword(
        password: masterPassword,
        saltB64: saltB64,
        wrappedDekB64: wrappedDekB64,
        iterations: _hiveService.encryptionKdfIterations,
      );
      try {
        await _hiveService.unlockJournalsBox(dek);
        if (_hiveService.encryptionBiometricEnabled &&
            !await hasBiometricDekStored()) {
          await saveDekForBiometrics(dek);
        }
        return true;
      } finally {
        dek.fillRange(0, dek.length, 0);
      }
    } on InvalidCipherTextException {
      return false;
    }
  }

  /// Encrypts the journal box with AES-256-GCM wrapped by [masterPassword].
  Future<void> enableDatabaseEncryption({
    required String masterPassword,
    bool enableBiometrics = false,
  }) async {
    final dek = await _hiveService.enableDatabaseEncryption(
      masterPassword: masterPassword,
      enableBiometrics: enableBiometrics,
    );
    try {
      if (enableBiometrics) {
        await saveDekForBiometrics(dek);
      } else {
        await clearBiometricDek();
      }
    } finally {
      dek.fillRange(0, dek.length, 0);
    }
  }

  /// Toggles biometric quick-unlock after verifying [masterPassword].
  Future<bool> setBiometricUnlockForEncryptedDb({
    required bool enabled,
    String? masterPassword,
  }) async {
    if (!_hiveService.dbEncryptionEnabled) return false;
    if (!enabled) {
      await clearBiometricDek();
      await _hiveService.setEncryptionBiometricEnabled(false);
      return true;
    }

    if (masterPassword == null) return false;
    final saltB64 = _hiveService.encryptionKdfSalt;
    final wrappedDekB64 = _hiveService.encryptionWrappedDek;
    if (saltB64 == null || wrappedDekB64 == null) return false;

    try {
      final dek = await CryptoService.unwrapDekWithPassword(
        password: masterPassword,
        saltB64: saltB64,
        wrappedDekB64: wrappedDekB64,
        iterations: _hiveService.encryptionKdfIterations,
      );
      try {
        await saveDekForBiometrics(dek);
        await _hiveService.setEncryptionBiometricEnabled(true);
        return true;
      } finally {
        dek.fillRange(0, dek.length, 0);
      }
    } on InvalidCipherTextException {
      return false;
    }
  }

  Future<bool> changeMasterPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _hiveService.changeMasterPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } on InvalidCipherTextException {
      return false;
    }
  }

  Future<bool> disableDatabaseEncryption(String masterPassword) async {
    try {
      await _hiveService.disableDatabaseEncryption(
        masterPassword: masterPassword,
      );
      await clearBiometricDek();
      return true;
    } on InvalidCipherTextException {
      return false;
    }
  }

  // Legacy 4-digit PIN methods kept for users who have PIN lock without DB encryption.
  Future<void> setPin(String pin) async {
    await _hiveService.setAppLockPin(pin);
    await _hiveService.setAppLock(true);
  }

  Future<bool> verifyPin(String pin) async {
    final storedPin = _hiveService.appLockPin;
    return storedPin == pin;
  }
}
