import 'dart:async';

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
    // Get the most appropriate context for theme data.
    final context = Get.overlayContext ?? Get.context;
    if (context == null) return;

    final appColors = AppTheme.colorsOf(context);
    final finalBackgroundColor = backgroundColor ?? appColors.grey10;
    final finalTextColor = textColor ?? appColors.grey8;

    const animationDuration = Duration(milliseconds: 300);
    final displayDuration = duration + animationDuration;

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedToast(
        message: message,
        backgroundColor: finalBackgroundColor,
        textColor: finalTextColor,
        animationDuration: animationDuration,
        displayDuration: displayDuration,
        overlayEntry: overlayEntry,
      ),
    );

    // Use Get.key to find the NavigatorState and its OverlayState.
    // This is more reliable than Overlay.of(context) when the context is above the Overlay.
    final overlayState = Get.key.currentState?.overlay ?? Overlay.maybeOf(context);

    if (overlayState != null) {
      overlayState.insert(overlayEntry);
    } else {
      // Fallback to Get.snackbar if for some reason the custom overlay fails.
      Get.rawSnackbar(
        messageText: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: finalTextColor,
            fontSize: 16.sp,
          ),
        ),
        backgroundColor: finalBackgroundColor,
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 50.h),
        borderRadius: 25.r,
        duration: duration,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class _AnimatedToast extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final Duration animationDuration;
  final Duration displayDuration;
  final OverlayEntry overlayEntry;

  const _AnimatedToast({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.animationDuration,
    required this.displayDuration,
    required this.overlayEntry,
  });

  @override
  _AnimatedToastState createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast> {
  double _opacity = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    _timer = Timer(widget.displayDuration, () {
      if (mounted) {
        setState(() {
          _opacity = 0.0;
        });
        Future.delayed(widget.animationDuration, () {
          try {
            widget.overlayEntry.remove();
          } catch (_) {}
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50.h,
      left: 24.w,
      right: 24.w,
      child: IgnorePointer(
        ignoring: _opacity == 0.0,
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: widget.animationDuration,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: widget.textColor,
                    decoration: TextDecoration.none,
                    fontFamily: 'OpenRunde',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
