import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/theme.dart';

class CustomToast {
  static void showToast(
      String message, {
        Duration duration = const Duration(seconds: 2),
        Color? backgroundColor,
        Color? textColor,
      }) {
    final context = Get.overlayContext;
    if (context == null) return;

    final appColors = AppTheme.colorsOf(context);
    final finalBackgroundColor = backgroundColor ?? appColors.grey7;
    final finalTextColor = textColor ?? appColors.grey10;

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.h,
        left: 24.w,
        right: 24.w,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: finalBackgroundColor,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: finalTextColor,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
