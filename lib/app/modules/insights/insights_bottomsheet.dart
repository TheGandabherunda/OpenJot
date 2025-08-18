import 'package:flutter/material.dart';

import '../../core/theme.dart';

class InsightsBottomSheet extends StatelessWidget {
  const InsightsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    return Material(
      child: Scaffold(
        backgroundColor: appThemeColors.grey6,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(''),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: appThemeColors.grey10,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Text('This is the content for a new reflection.'),
        ),
      ),
    );
  }
}
