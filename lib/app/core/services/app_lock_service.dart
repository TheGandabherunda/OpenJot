import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:open_jot/app/core/services/hive_service.dart';

class AppLockService extends GetxService {
  final LocalAuthentication _auth = LocalAuthentication();
  final _hiveService = Get.find<HiveService>();

  Future<bool> isBiometricAvailable() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    return canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: ' ',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> setPin(String pin) async {
    await _hiveService.setAppLockPin(pin);
    await _hiveService.setAppLock(true);
  }

  Future<bool> verifyPin(String pin) async {
    final storedPin = _hiveService.appLockPin;
    return storedPin == pin;
  }
}
