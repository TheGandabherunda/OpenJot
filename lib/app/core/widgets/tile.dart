import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_jot/app/core/constants.dart';

import '../theme.dart';

class Tile extends StatelessWidget {
  final String title;
  final IconData icon;
  // final VoidCallback onTap; // REMOVED onTap

  // Added customizable parameters
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;

  // Icon container parameters
  final bool showIconContainer;
  final Color? iconContainerColor;
  final EdgeInsetsGeometry iconContainerPadding;

  // Main tile padding
  final EdgeInsetsGeometry tilePadding;

  const Tile({
    super.key,
    required this.title,
    required this.icon,
    // required this.onTap, // REMOVED onTap from constructor
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.iconSize = 20,
    required this.fontSize,
    this.fontWeight = FontWeight.w500,
    this.showIconContainer = false,
    this.iconContainerColor,
    this.iconContainerPadding = const EdgeInsets.all(8),
    this.tilePadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final effectiveIconColor = iconColor ?? colors.grey1;

    Widget iconWidget = Icon(icon, size: iconSize, color: effectiveIconColor);

    // Wrap icon in container if showIconContainer is true
    if (showIconContainer) {
      final containerColor =
          iconContainerColor ?? effectiveIconColor.withOpacity(0.2);

      iconWidget = Container(
        padding: iconContainerPadding,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: iconWidget,
      );
    }

    // REMOVED Material and InkWell, replaced with a simple Container
    // or just the Padding if backgroundColor is transparent by default
    // Using a Container to handle potential backgroundColor
    return Container(
      color: backgroundColor ?? Colors.transparent,
      child: Padding(
        padding: tilePadding,
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  height: 1.2.sp,
                  fontFamily: AppConstants.font,
                  fontSize: fontSize,
                  color: textColor ?? colors.grey10,
                  fontWeight: fontWeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
