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
    final context = Get.overlayContext;
    if (context == null) return;

    final appColors = AppTheme.colorsOf(context);
    final finalBackgroundColor = backgroundColor ?? appColors.grey10;
    final finalTextColor = textColor ?? appColors.grey8;

    // Define the animation duration for fading in and out.
    const animationDuration = Duration(milliseconds: 300);
    // The total duration is the animation duration plus the time the toast is fully visible.
    final displayDuration = duration + animationDuration;

    // We create a new OverlayEntry and pass it to the animated toast widget.
    // This allows the widget to remove itself when the animation is complete.
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedToast(
        message: message,
        backgroundColor: finalBackgroundColor,
        textColor: finalTextColor,
        animationDuration: animationDuration,
        displayDuration: displayDuration,
        overlayEntry: overlayEntry, // Pass the entry to the widget
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }
}

// A stateful widget to manage the animated opacity of the toast.
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
  // Opacity value that will be animated.
  double _opacity = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start fade-in animation after the widget is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    // Set a timer to start the fade-out animation after the toast has been displayed.
    _timer = Timer(widget.displayDuration, () {
      if (mounted) {
        setState(() {
          _opacity = 0.0;
        });
        // Remove the overlay entry after the fade-out animation completes.
        Future.delayed(widget.animationDuration, () {
          widget.overlayEntry.remove();
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
