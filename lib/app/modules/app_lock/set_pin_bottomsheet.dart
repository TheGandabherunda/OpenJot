import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/services/app_lock_service.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/widgets/custom_button.dart';

class SetPinBottomSheet extends StatefulWidget {
  const SetPinBottomSheet({super.key});

  @override
  _SetPinBottomSheetState createState() => _SetPinBottomSheetState();
}

class _SetPinBottomSheetState extends State<SetPinBottomSheet> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;

  final AppLockService _appLockService = Get.find();

  void _onNumberPress(String number) {
    final currentPin = _isConfirming ? _confirmPin : _pin;
    if (currentPin.length < 4) {
      setState(() {
        if (_isConfirming) {
          _confirmPin += number;
        } else {
          _pin += number;
        }
      });
    }
  }

  void _onDeletePress() {
    if (_isConfirming) {
      if (_confirmPin.isNotEmpty) {
        setState(() {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        });
      }
    } else {
      if (_pin.isNotEmpty) {
        setState(() {
          _pin = _pin.substring(0, _pin.length - 1);
        });
      }
    }
  }

  void _onContinue() {
    if (_pin.length == 4) {
      setState(() {
        _isConfirming = true;
      });
    }
  }

  void _onSetPin() async {
    if (_pin == _confirmPin) {
      await _appLockService.setPin(_pin);
      Get.back(result: true);
    } else {
      Fluttertoast.showToast(
        msg: "PINs do not match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.colorsOf(context).grey7,
        textColor: AppTheme.colorsOf(context).grey10,
        fontSize: 16.0,
      );
      setState(() {
        _confirmPin = '';
        _isConfirming = false;
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final pin = _isConfirming ? _confirmPin : _pin;

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
            _isConfirming ? 'Confirm PIN' : 'Set a PIN',
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
              return _buildPinDot(index < pin.length);
            }),
          ),
          SizedBox(height: 50.h),
          _buildKeyboard(),
          SizedBox(height: 30.h),
          CustomButton(
            onPressed: pin.length == 4
                ? (_isConfirming ? _onSetPin : _onContinue)
                : null,
            text: _isConfirming ? 'Set PIN' : 'Continue',
            color: appColors.primary,
            textColor: appColors.onPrimary,
            textPadding: CustomButton.defaultTextPadding,
          ),
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
