import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/services/app_lock_service.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';

class VerifyPinBottomSheet extends StatefulWidget {
  const VerifyPinBottomSheet({super.key});

  @override
  _VerifyPinBottomSheetState createState() => _VerifyPinBottomSheetState();
}

class _VerifyPinBottomSheetState extends State<VerifyPinBottomSheet> {
  final AppLockService _appLockService = Get.find();
  String _enteredPin = '';
  String _errorMessage = '';

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
      Get.back(result: true); // Return true on success
    } else {
      setState(() {
        _errorMessage = 'Incorrect PIN';
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: appColors.grey6,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Verify your PIN',
            style: TextStyle(
              fontFamily: AppConstants.font,
              color: appColors.grey10,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return _buildPinDot(index < _enteredPin.length);
            }),
          ),
          SizedBox(
            height: 50.h,
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
          _buildKeyboard(),
          SizedBox(height: 20.h),
        ],
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
