import 'package:flutter/material.dart';

import 'package:open_jot/app/core/theme.dart';

class WriteJournalToolbar extends StatelessWidget {
  const WriteJournalToolbar({
    super.key,
    required this.toolbarIcons,
    required this.selectedToolbarIcon,
    required this.isDraggableSheetActive,
    required this.onToolbarItemTap,
    this.onCloseTap,
  });

  final List<IconData> toolbarIcons;
  final IconData? selectedToolbarIcon;
  final bool isDraggableSheetActive;
  final Function(IconData) onToolbarItemTap;
  final VoidCallback? onCloseTap;

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    if (toolbarIcons.isEmpty) {
      return const SizedBox.shrink();
    }
    // Treat the last icon in the list as the one to be separated.
    final separatedIcon = toolbarIcons.last;
    final groupedIcons = toolbarIcons.take(toolbarIcons.length - 1).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              for (var i = 0; i < groupedIcons.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    right: i < groupedIcons.length - 1 ? 2 : 0,
                  ),
                  child: _buildToolbarIcon(
                    groupedIcons[i],
                    appThemeColors,
                    i,
                    groupedIcons.length,
                    separatedIcon,
                  ),
                ),
            ],
          ),
          Row(
            children: [
              _buildToolbarIcon(separatedIcon, appThemeColors, 0, 1, separatedIcon),
              if (isDraggableSheetActive) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onCloseTap,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: appThemeColors.grey5,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: appThemeColors.grey10,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarIcon(
      IconData icon,
      AppThemeColors appThemeColors,
      int index,
      int groupLength,
      IconData separatedIcon,
      ) {
    final isSelected = selectedToolbarIcon == icon && isDraggableSheetActive;

    BorderRadius? borderRadius;
    // Check if the icon is the separated one.
    if (icon != separatedIcon) {
      if (index == 0) {
        borderRadius = const BorderRadius.horizontal(
          left: Radius.circular(50),
          right: Radius.circular(16),
        );
      } else if (index == groupLength - 1) {
        borderRadius = const BorderRadius.horizontal(
          left: Radius.circular(16),
          right: Radius.circular(50),
        );
      } else {
        borderRadius = BorderRadius.circular(6);
      }
    }

    return GestureDetector(
      onTap: () => onToolbarItemTap(icon),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? appThemeColors.grey4 : appThemeColors.grey5,
          // Check if the icon is the separated one.
          shape: icon == separatedIcon ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: borderRadius,
        ),
        child: Icon(
          icon,
          color: isSelected ? appThemeColors.primary : appThemeColors.grey1,
        ),
      ),
    );
  }
}