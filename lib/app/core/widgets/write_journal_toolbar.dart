import 'package:flutter/material.dart';

import '../theme.dart';

class WriteJournalToolbar extends StatelessWidget {
  final List<IconData> toolbarIcons;
  final IconData? selectedToolbarIcon;
  final bool isDraggableSheetActive;
  final Function(IconData) onToolbarItemTap;

  const WriteJournalToolbar({
    super.key,
    required this.toolbarIcons,
    required this.selectedToolbarIcon,
    required this.isDraggableSheetActive,
    required this.onToolbarItemTap,
  });

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
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              for (var i = 0; i < groupedIcons.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    right: i < groupedIcons.length - 1 ? 2.0 : 0,
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
          _buildToolbarIcon(separatedIcon, appThemeColors, 0, 1, separatedIcon),
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
          left: Radius.circular(50.0),
          right: Radius.circular(16.0),
        );
      } else if (index == groupLength - 1) {
        borderRadius = const BorderRadius.horizontal(
          left: Radius.circular(16.0),
          right: Radius.circular(50.0),
        );
      } else {
        borderRadius = BorderRadius.circular(6.0);
      }
    }

    return GestureDetector(
      onTap: () => onToolbarItemTap(icon),
      child: Container(
        padding: const EdgeInsets.all(10.0),
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
