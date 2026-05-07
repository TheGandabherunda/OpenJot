import 'package:flutter/material.dart';

import 'package:open_jot/app/core/theme.dart';

class TextStylingToolbar extends StatelessWidget {
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
    this.isBulletActive = false,
    this.isRtlActive = false,
    required this.onRtlToggle,
  });

  final Function(String) onToolbarItemTap;
  final VoidCallback onPinTap;
  final bool isBoldActive;
  final bool isItalicActive;
  final bool isUnderlineActive;
  final bool isStrikethroughActive;
  final bool isTitleActive;
  final bool isQuoteActive;
  final bool isBulletActive;
  final bool isRtlActive;
  final VoidCallback onRtlToggle;

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);

    final styleMap = <String, IconData>{
      'title': Icons.title,
      'bold': Icons.format_bold,
      'italic': Icons.format_italic,
      'underline': Icons.format_underline,
      'strikethrough': Icons.format_strikethrough,
      'bullet': Icons.format_list_bulleted,
      'quote': Icons.format_quote_rounded,
      'rtl': Icons.format_textdirection_r_to_l_rounded,
    };

    final styles = styleMap.keys.toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < styles.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                        right: 2, // Spacing between styling icons
                      ),
                      child: _buildToolbarIcon(
                        styleMap[styles[i]]!,
                        appThemeColors,
                        i,
                        _isStyleActive(styles[i]),
                        () {
                          if (styles[i] == 'rtl') {
                            onRtlToggle();
                          } else {
                            onToolbarItemTap(styles[i]);
                          }
                        },
                        false,
                      ),
                    ),
                  // Added Attachment (Clip) button at the end of the styling row
                  _buildToolbarIcon(
                    Icons.attach_file_rounded,
                    appThemeColors,
                    0, // Index doesn't matter much for square icons in a scrollable list
                    false,
                    onPinTap,
                    false, // Changed to false to make it square like other styling tools
                  ),
                ],
              ),
            ),
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
      case 'bullet':
        return isBulletActive;
      case 'rtl':
        return isRtlActive;
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
          left: Radius.circular(50),
          right: Radius.circular(16),
        );
      } else if (index == 7) {
        // 7 is the last index (rtl)
        borderRadius = const BorderRadius.horizontal(
          left: Radius.circular(16),
          right: Radius.circular(50),
        );
      } else {
        borderRadius = BorderRadius.circular(6);
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
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
