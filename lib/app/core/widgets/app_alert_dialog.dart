import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:smooth_corner/smooth_corner.dart';

class AppAlertAction {
  final String label;
  final VoidCallback onPressed;
  final bool isDefault;
  final bool isDestructive;

  const AppAlertAction({
    required this.label,
    required this.onPressed,
    this.isDefault = false,
    this.isDestructive = false,
  });
}

/// Presents an OpenJot-styled alert modal centered on screen with scale/fade
/// transitions and keyboard avoidance.
Future<T?> showAppAlertDialog<T>({
  required BuildContext context,
  required String title,
  String? message,
  Widget? content,
  List<AppAlertAction> Function(BuildContext dialogContext)? actionsBuilder,
  List<AppAlertAction>? actions,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.48),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return AppAlertDialog(
        title: title,
        message: message,
        content: content,
        actions: actionsBuilder != null
            ? actionsBuilder(dialogContext)
            : (actions ?? const []),
      );
    },
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final List<AppAlertAction> actions;

  const AppAlertDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = Get.isRegistered<HiveService>() &&
        Get.find<HiveService>().pitchBlack;

    final cardBg = isPitchBlack
        ? (isDark ? const Color(0xFF121216) : Colors.white)
        : appColors.grey6;
    final neutralButtonBg = isPitchBlack
        ? (isDark
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.black.withValues(alpha: 0.06))
        : appColors.grey5;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 16.h,
          bottom: 16.h + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 340.w),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 20.h),
                  decoration: ShapeDecoration(
                    color: cardBg,
                    shape: SmoothRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                      smoothness: 1,
                      side: isPitchBlack && isDark
                          ? BorderSide(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            )
                          : BorderSide.none,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppConstants.font,
                          color: appColors.grey10,
                          fontSize: 18.5.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      if (message != null && message!.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            message!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppConstants.font,
                              color: appColors.grey1,
                              fontSize: 14.sp,
                              height: 1.38,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                      if (content != null) ...[
                        SizedBox(height: 14.h),
                        content!,
                      ],
                      if (actions.isNotEmpty) ...[
                        SizedBox(height: 18.h),
                        _buildActions(context, appColors, neutralButtonBg),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    AppThemeColors appColors,
    Color neutralBg,
  ) {
    final pillRadius = BorderRadius.circular(21.r);

    if (actions.length == 2) {
      return SizedBox(
        height: 42.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildActionButton(
                action: actions[0],
                appColors: appColors,
                neutralBg: neutralBg,
                borderRadius: pillRadius,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildActionButton(
                action: actions[1],
                appColors: appColors,
                neutralBg: neutralBg,
                borderRadius: pillRadius,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) SizedBox(height: 8.h),
          SizedBox(
            height: 42.h,
            child: _buildActionButton(
              action: actions[i],
              appColors: appColors,
              neutralBg: neutralBg,
              borderRadius: pillRadius,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required AppAlertAction action,
    required AppThemeColors appColors,
    required Color neutralBg,
    required BorderRadius borderRadius,
  }) {
    final Color bg;
    final Color fg;

    if (action.isDestructive) {
      bg = appColors.error;
      fg = Colors.white;
    } else if (action.isDefault) {
      bg = appColors.primary;
      fg = appColors.onPrimary;
    } else {
      bg = neutralBg;
      fg = appColors.grey10;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onPressed,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: borderRadius,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  action.label,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: AppConstants.font,
                    color: fg,
                    fontSize: 14.5.sp,
                    fontWeight:
                        (action.isDefault || action.isDestructive)
                            ? FontWeight.w600
                            : FontWeight.w500,
                    letterSpacing: -0.2,
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
