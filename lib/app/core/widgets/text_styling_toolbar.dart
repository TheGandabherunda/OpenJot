import 'package:flutter/material.dart';

import '../theme.dart';

class TextStylingToolbar extends StatelessWidget {
  final Function(String) onToolbarItemTap;
  final VoidCallback onPinTap;
  final bool isBoldActive;
  final bool isItalicActive;
  final bool isUnderlineActive;
  final bool isStrikethroughActive;
  final bool isTitleActive;
  final bool isQuoteActive;

  const TextStylingToolbar({
    super.key,
    required this.onToolbarItemTap,
    required this.onPinTap,
    this.isBoldActive = false,
    this.isItalicActive = false,
    this.isUnderlineActive = false,
    this.isStrikethroughActive = false,
    this.isTitleActive = false,
    this.isQuoteActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);

    final Map<String, IconData> styleMap = {
      'bold': Icons.format_bold,
      'italic': Icons.format_italic,
      'underline': Icons.format_underline,
      'strikethrough': Icons.format_strikethrough,
      'bullet': Icons.format_list_bulleted,
      'quote': Icons.format_quote_rounded,
      'title': Icons.title,
    };

    final List<String> styles = styleMap.keys.toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              for (var i = 0; i < styles.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    right: i < styles.length - 1 ? 2.0 : 0,
                  ),
                  child: _buildToolbarIcon(
                    styleMap[styles[i]]!,
                    appThemeColors,
                    i,
                    _isStyleActive(styles[i]),
                    () => onToolbarItemTap(styles[i]),
                    false,
                  ),
                ),
            ],
          ),
          _buildToolbarIcon(
            Icons.push_pin_outlined,
            appThemeColors,
            0,
            false,
            onPinTap,
            true,
          ),
        ],
      ),
    );
  }

  bool _isStyleActive(String style) {
    switch (style) {
      case 'bold':
        return isBoldActive;
      case 'italic':
        return isItalicActive;
      case 'underline':
        return isUnderlineActive;
      case 'strikethrough':
        return isStrikethroughActive;
      case 'title':
        return isTitleActive;
      case 'quote':
        return isQuoteActive;
      default:
        return false;
    }
  }

  Widget _buildToolbarIcon(
    IconData icon,
    AppThemeColors appThemeColors,
    int index,
    bool isActive,
    VoidCallback onTap,
    bool isPin,
  ) {
    BorderRadius? borderRadius;
    if (!isPin) {
      if (index == 0) {
        borderRadius = const BorderRadius.horizontal(
          left: Radius.circular(50.0),
          right: Radius.circular(16.0),
        );
      } else if (index == 6) {
        // 6 is the last index
        borderRadius = const BorderRadius.horizontal(
          left: Radius.circular(16.0),
          right: Radius.circular(50.0),
        );
      } else {
        borderRadius = BorderRadius.circular(6.0);
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isActive
              ? appThemeColors.primary.withOpacity(0.3)
              : appThemeColors.grey5,
          shape: isPin ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: borderRadius,
        ),
        child: Icon(
          icon,
          color: isActive ? appThemeColors.primary : appThemeColors.grey1,
        ),
      ),
    );
  }
}
