import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../theme.dart'; // For AppTheme.colorsOf

class CustomIconButton extends StatefulWidget {
  static const double defaultBorderRadius = 36.0;

  final VoidCallback? onPressed;
  final Color color;
  final double borderRadius;
  final EdgeInsets? iconPadding; // Made nullable
  final Color iconColor; // Renamed from textColor
  final double iconSize;
  final IconData icon; // Made mandatory as it's an icon button

  const CustomIconButton({
    super.key,
    this.onPressed,
    required this.icon, // Icon is now required
    required this.color,
    this.iconSize = 32, // Default icon size, can be adjusted
    this.borderRadius = defaultBorderRadius,
    this.iconPadding, // Now directly nullable, default handled in build method
    required this.iconColor, // Icon color is required
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool _isPressed = false;
  static const Duration _animationDuration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    // Accessing theme colors, assuming AppTheme is correctly set up
    final appColors = AppTheme.colorsOf(context);
    final buttonColor = widget.onPressed == null
        ? widget.color.withOpacity(0.5)
        : widget.color;

    final rippleColor = appColors.grey7; // Assuming appColors.grey7 exists

    // Determine the effective padding, using a fixed value for better control
    final effectiveIconPadding =
        widget.iconPadding ??
        EdgeInsets.all(16.0); // Further reduced padding to 10.0

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
        duration: _animationDuration,
        curve: Curves.easeInOut,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: ShapeDecoration(
              color: buttonColor,
              shape: SmoothRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                smoothness: 1, // Smoothness for the rounded corners
              ),
            ),
            child: InkWell(
              onTap: null,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              splashColor: widget.onPressed != null
                  ? rippleColor.withOpacity(0.2)
                  : Colors.transparent,
              highlightColor: widget.onPressed != null
                  ? rippleColor.withOpacity(0.1)
                  : Colors.transparent,
              splashFactory: InkRipple.splashFactory,
              // Explicitly constrain the size of the InkWell's child
              child: SizedBox(
                width: widget.iconSize + effectiveIconPadding.horizontal,
                // Calculate total width
                height: widget.iconSize + effectiveIconPadding.vertical,
                // Calculate total height
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: widget.iconSize,
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
