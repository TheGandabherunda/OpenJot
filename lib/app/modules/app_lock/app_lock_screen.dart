import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/app_lock_service.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/services/notification_service.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/widgets/custom_button.dart';
import 'package:open_jot/app/modules/app_lock/master_password_bottomsheet.dart';
import 'package:open_jot/app/routes/app_pages.dart';
import 'package:smooth_corner/smooth_corner.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final AppLockService _appLockService = Get.find();
  final HiveService _hiveService = Get.find();
  final TextEditingController _passwordController = TextEditingController();

  String _enteredPin = '';
  String _errorMessage = '';
  bool _obscurePassword = true;
  bool _isUnlocking = false;
  bool _biometricAvailable = false;

  bool get _isEncryptedDb => _hiveService.dbEncryptionEnabled;

  @override
  void initState() {
    super.initState();
    unawaited(_initBiometrics());
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _initBiometrics() async {
    final available = await _appLockService.isBiometricAvailable();
    if (!mounted) return;
    setState(() => _biometricAvailable = available);

    final shouldAutoPrompt =
        available && (!_isEncryptedDb || _hiveService.encryptionBiometricEnabled);
    if (shouldAutoPrompt) {
      await _authenticateWithBiometrics();
    }
  }

  Future<void> _completeUnlock() async {
    if (Get.isRegistered<NotificationService>()) {
      unawaited(Get.find<NotificationService>().checkForOnThisDayMemories());
    }
    final nextRoute =
        _hiveService.isFirstLaunch ? AppPages.INITIAL : AppPages.HOME;
    unawaited(Get.offAllNamed(nextRoute));
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isUnlocking) return;
    final unlocked = await _appLockService.unlockWithBiometrics();
    if (unlocked && mounted) {
      await _completeUnlock();
    }
  }

  Future<void> _unlockWithMasterPassword() async {
    final password = _passwordController.text;
    if (password.isEmpty || _isUnlocking) {
      if (password.isEmpty) {
        setState(() => _errorMessage = AppConstants.enterMasterPasswordHint.tr);
      }
      return;
    }

    setState(() {
      _isUnlocking = true;
      _errorMessage = '';
    });

    final ok = await _appLockService.unlockWithMasterPassword(password);
    if (!mounted) return;

    if (ok) {
      _passwordController.clear();
      await _completeUnlock();
    } else {
      setState(() {
        _isUnlocking = false;
        _errorMessage = AppConstants.incorrectMasterPassword.tr;
      });
    }
  }

  void _onNumberPress(String number) {
    if (_errorMessage.isNotEmpty) {
      setState(() {
        _errorMessage = '';
      });
    }
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += number;
      });
      if (_enteredPin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onDeletePress() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _verifyPin() async {
    final isValid = await _appLockService.verifyPin(_enteredPin);
    if (isValid) {
      await _completeUnlock();
    } else {
      setState(() {
        _errorMessage = AppConstants.incorrectPin.tr;
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    return Scaffold(
      backgroundColor: appColors.grey7,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: _isEncryptedDb
              ? _buildMasterPasswordUnlock(appColors)
              : _buildLegacyPinUnlock(appColors),
        ),
      ),
    );
  }

  Widget _buildMasterPasswordUnlock(AppThemeColors appColors) {
    final showBiometricButton =
        _biometricAvailable && _hiveService.encryptionBiometricEnabled;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: appColors.primary.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: 34.sp,
                  color: appColors.primary,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              AppConstants.hello.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppConstants.font,
                color: appColors.grey10,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppConstants.enterMasterPasswordHint.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppConstants.font,
                color: appColors.grey2,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 28.h),
            SegmentedPasswordInput(
              controller: _passwordController,
              hint: AppConstants.enterMasterPassword.tr,
              obscure: _obscurePassword,
              onToggleObscure: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              segmentBg: appColors.grey5,
              enabled: !_isUnlocking,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _unlockWithMasterPassword(),
              onChanged: () {
                if (_errorMessage.isNotEmpty) {
                  setState(() => _errorMessage = '');
                }
              },
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 24.h,
              child: _errorMessage.isNotEmpty
                  ? Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppConstants.font,
                        color: appColors.error,
                        fontSize: 13.5.sp,
                      ),
                    )
                  : null,
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              child: _isUnlocking
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.sp,
                        vertical: 14.sp,
                      ),
                      decoration: ShapeDecoration(
                        color: appColors.primary,
                        shape: SmoothRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            CustomButton.defaultBorderRadius,
                          ),
                          smoothness: 1,
                        ),
                      ),
                      child: Center(
                        child: CupertinoActivityIndicator(
                          radius: 10,
                          color: appColors.onPrimary,
                        ),
                      ),
                    )
                  : CustomButton(
                      onPressed: _unlockWithMasterPassword,
                      text: AppConstants.unlockButton.tr,
                      color: appColors.primary,
                      textColor: appColors.onPrimary,
                      expandWidth: true,
                      textPadding: EdgeInsets.symmetric(
                        horizontal: 24.sp,
                        vertical: 14.sp,
                      ),
                    ),
            ),
            if (showBiometricButton) ...[
              SizedBox(height: 16.h),
              TextButton.icon(
                onPressed: _isUnlocking ? null : _authenticateWithBiometrics,
                icon: Icon(
                  Icons.fingerprint_rounded,
                  color: appColors.grey10,
                  size: 22,
                ),
                label: Text(
                  AppConstants.unlockWithBiometrics.tr,
                  style: TextStyle(
                    fontFamily: AppConstants.font,
                    color: appColors.grey10,
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegacyPinUnlock(AppThemeColors appColors) {
    return Column(
      children: [
        const Spacer(flex: 2),
        Text(
          AppConstants.hello.tr,
          style: TextStyle(
            fontFamily: AppConstants.font,
            color: appColors.grey10,
            fontSize: 34.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          AppConstants.enterYourPin.tr,
          style: TextStyle(
            fontFamily: AppConstants.font,
            color: appColors.grey10,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 70.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return _buildPinDot(index < _enteredPin.length);
          }),
        ),
        SizedBox(
          height: 70.h,
          child: Center(
            child: _errorMessage.isNotEmpty
                ? Text(
                    _errorMessage,
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      color: appColors.error,
                      fontSize: 16.sp,
                    ),
                  )
                : null,
          ),
        ),
        const Spacer(),
        _buildKeyboard(),
        SizedBox(height: 20.h),
        TextButton(
          onPressed: _authenticateWithBiometrics,
          child: Text(
            AppConstants.useBiometrics.tr,
            style: TextStyle(
              fontFamily: AppConstants.font,
              color: appColors.grey10,
              fontSize: 16.sp,
            ),
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildPinDot(bool isActive) {
    final appColors = AppTheme.colorsOf(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      width: 18.w,
      height: 18.h,
      decoration: BoxDecoration(
        color: isActive ? appColors.grey10 : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: appColors.grey10, width: 1.5),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('1'),
            _buildKey('2'),
            _buildKey('3'),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('4'),
            _buildKey('5'),
            _buildKey('6'),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('7'),
            _buildKey('8'),
            _buildKey('9'),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 80.w, height: 80.h), // Placeholder for alignment
            _buildKey('0'),
            SizedBox(
              width: 80.w,
              height: 80.h,
              child: IconButton(
                icon: Icon(
                  Icons.backspace_outlined,
                  color: AppTheme.colorsOf(context).grey10,
                ),
                onPressed: _onDeletePress,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String number) {
    final appColors = AppTheme.colorsOf(context);
    return SizedBox(
      width: 80.w,
      height: 80.h,
      child: TextButton(
        onPressed: () => _onNumberPress(number),
        style: TextButton.styleFrom(
          backgroundColor: appColors.grey5,
          shape: const CircleBorder(),
        ),
        child: Text(
          number,
          style: TextStyle(
            fontFamily: AppConstants.font,
            color: appColors.grey10,
            fontSize: 32.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
