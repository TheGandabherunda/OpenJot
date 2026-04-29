import 'dart:async';

import 'package:flutter/cupertino.dart';
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
    // ... existing showToast implementation ...
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

    final overlayState = Get.key.currentState?.overlay ?? Overlay.maybeOf(context);
    if (overlayState != null) {
      overlayState.insert(overlayEntry);
    }
  }

  /// Shows a persistent loading toast that can be closed manually.
  static ClosableToast showLoadingToast(String message) {
    final context = Get.overlayContext ?? Get.context;
    if (context == null) return ClosableToast(() {});

    final appColors = AppTheme.colorsOf(context);
    final backgroundColor = appColors.grey10;
    final textColor = appColors.grey8;

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _PersistentLoadingToast(
        message: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
      ),
    );

    final overlayState = Get.key.currentState?.overlay ?? Overlay.maybeOf(context);
    if (overlayState != null) {
      overlayState.insert(overlayEntry);
      return ClosableToast(() {
        try {
          overlayEntry.remove();
        } catch (_) {}
      });
    }
    return ClosableToast(() {});
  }
}

class ClosableToast {
  final VoidCallback close;
  ClosableToast(this.close);
}

class _PersistentLoadingToast extends StatefulWidget {
  const _PersistentLoadingToast({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
  });

  final String message;
  final Color backgroundColor;
  final Color textColor;

  @override
  _PersistentLoadingToastState createState() => _PersistentLoadingToastState();
}

class _PersistentLoadingToastState extends State<_PersistentLoadingToast> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _opacity = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50.h,
      left: 24.w,
      right: 24.w,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 300),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CupertinoActivityIndicator(
                      radius: 10.r,
                      color: widget.textColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: widget.textColor,
                      decoration: TextDecoration.none,
                      fontFamily: 'OpenRunde',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedToast extends StatefulWidget {
  const _AnimatedToast({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.animationDuration,
    required this.displayDuration,
    required this.overlayEntry,
  });

  final String message;
  final Color backgroundColor;
  final Color textColor;
  final Duration animationDuration;
  final Duration displayDuration;
  final OverlayEntry overlayEntry;

  @override
  _AnimatedToastState createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast> {
  double _opacity = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _opacity = 1;
        });
      }
    });

    _timer = Timer(widget.displayDuration, () {
      if (mounted) {
        setState(() {
          _opacity = 0;
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
