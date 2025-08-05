import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../constants.dart';
import '../theme.dart';

class CustomButton extends StatefulWidget {
  static const double defaultBorderRadius = 16.0;
  static EdgeInsets defaultTextPadding = EdgeInsets.symmetric(
    horizontal: 56.sp,
    vertical: 16.sp,
  );

  final VoidCallback? onPressed;
  final String text;
  final Color color;
  final double borderRadius;
  final EdgeInsets textPadding;
  final Color textColor;
  final double textSize;
  final double iconSize;
  final IconData? icon;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.color,
    this.textSize = 16,
    this.iconSize = 16,
    this.borderRadius = defaultBorderRadius,
    required this.textPadding,
    required this.textColor,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;
  static const Duration _animationDuration = Duration(milliseconds: 100); // Keep this consistent

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final buttonColor = widget.onPressed == null ? widget.color.withOpacity(0.5) : widget.color;

    final rippleColor = appColors.grey7;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null) {
          setState(() {
            _isPressed = true;
          });
        }
      },
      onTapUp: (_) {
        if (widget.onPressed != null) {
          setState(() {
            _isPressed = false;
          });
          // Calling onPressed immediately to ensure reliable bottom sheet opening
          // The visual scale animation will still complete.
          widget.onPressed?.call();
        }
      },
      onTapCancel: () {
        if (widget.onPressed != null) {
          setState(() {
            _isPressed = false;
          });
        }
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: _animationDuration, // Use the constant duration
        curve: Curves.easeInOut,
        child: IntrinsicWidth(
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: ShapeDecoration(
                color: buttonColor,
                shape: SmoothRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  smoothness: 1,
                ),
              ),
              child: InkWell(
                onTap: null, // Still null, as GestureDetector manages the tap logic
                borderRadius: BorderRadius.circular(widget.borderRadius),
                splashColor: widget.onPressed != null
                    ? rippleColor.withOpacity(0.2)
                    : Colors.transparent,
                highlightColor: widget.onPressed != null
                    ? rippleColor.withOpacity(0.1)
                    : Colors.transparent,
                splashFactory: InkRipple.splashFactory,
                child: Padding(
                  padding: widget.textPadding,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: widget.textColor, size: widget.iconSize),
                          const SizedBox(width: 16),
                        ],
                        Text(
                          widget.text,
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontSize: widget.textSize,
                            height: 1.3.sp,
                            color: widget.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
