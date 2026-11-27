import 'package:flutter/material.dart';

import 'package:open_jot/app/core/theme.dart';

class WriteJournalToolbar extends StatelessWidget {
  const WriteJournalToolbar({
    super.key,
    required this.toolbarIcons,
    required this.selectedToolbarIcon,
    required this.isDraggableSheetActive,
    required this.onToolbarItemTap,
    required this.isRtlActive,
    required this.onRtlToggle,
    this.onCloseTap,
  });

  final List<IconData> toolbarIcons;
  final IconData? selectedToolbarIcon;
  final bool isDraggableSheetActive;
  final Function(IconData) onToolbarItemTap;
  final bool isRtlActive;
  final VoidCallback onRtlToggle;
  final VoidCallback? onCloseTap;

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    if (toolbarIcons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            for (var i = 0; i < toolbarIcons.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  right: i < toolbarIcons.length - 1 ? 2 : 0,
                ),
                child: _buildToolbarIcon(
                  toolbarIcons[i],
                  appThemeColors,
                  i,
                  toolbarIcons.length,
                ),
              ),
          ],
        ),
        if (isDraggableSheetActive)
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
    );
  }

  Widget _buildToolbarIcon(
    IconData icon,
    AppThemeColors appThemeColors,
    int index,
    int groupLength,
  ) {
    final isSelected = selectedToolbarIcon == icon && isDraggableSheetActive;

    BorderRadiusGeometry borderRadius;
    if (groupLength == 1) {
      borderRadius = BorderRadius.circular(50);
    } else if (index == 0) {
      borderRadius = const BorderRadiusDirectional.horizontal(
        start: Radius.circular(50),
        end: Radius.circular(16),
      );
    } else if (index == groupLength - 1) {
      borderRadius = const BorderRadiusDirectional.horizontal(
        start: Radius.circular(16),
        end: Radius.circular(50),
      );
    } else {
      borderRadius = BorderRadius.circular(6);
    }

    return GestureDetector(
      onTap: () => onToolbarItemTap(icon),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? appThemeColors.grey4 : appThemeColors.grey5,
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