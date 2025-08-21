import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/services/app_lock_service.dart';
import 'package:open_jot/app/routes/app_pages.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  _AppLockScreenState createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final AppLockService _appLockService = Get.find();
  String _enteredPin = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _authenticateWithBiometrics();
  }

  void _authenticateWithBiometrics() async {
    if (await _appLockService.isBiometricAvailable()) {
      final authenticated = await _appLockService.authenticate();
      if (authenticated) {
        Get.offAllNamed(AppPages.HOME);
      }
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
      Get.offAllNamed(AppPages.HOME);
    } else {
      setState(() {
        _errorMessage = AppConstants.incorrectPin;
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
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                AppConstants.hello,
                style: TextStyle(
                  fontFamily: AppConstants.font,
                  color: appColors.grey10,
                  fontSize: 34.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                AppConstants.enterYourPin,
                style: TextStyle(
                    fontFamily: AppConstants.font,
                    color: appColors.grey10,
                    fontSize: 18.sp),
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
                        fontSize: 16.sp),
                  )
                      : null,
                ),
              ),
              const Spacer(flex: 1),
              _buildKeyboard(),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: _authenticateWithBiometrics,
                child: Text(
                  AppConstants.useBiometrics,
                  style: TextStyle(
                      fontFamily: AppConstants.font,
                      color: appColors.grey10,
                      fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
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
                icon: Icon(Icons.backspace_outlined,
                    color: AppTheme.colorsOf(context).grey10),
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
