import 'package:flutter/material.dart';

import '../theme.dart';

class WriteJournalToolbarContent extends StatelessWidget {
  final IconData? selectedToolbarIcon;
  final ScrollController scrollController;

  const WriteJournalToolbarContent({
    super.key,
    required this.selectedToolbarIcon,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final Map<IconData, String> contentMap = {
      Icons.image_rounded: 'Content for Images',
      Icons.location_on_rounded: 'Content for Location',
      Icons.camera_alt_rounded: 'Content for Camera',
      Icons.mic_rounded: 'Content for Mic',
      Icons.format_quote_rounded: 'Content for Quote',
      Icons.sentiment_satisfied_rounded: 'Content for Emoji',
    };

    final contentText = contentMap[selectedToolbarIcon] ?? 'No content selected.';

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      children: [
        Center(
          child: Text(
            contentText,
            style: TextStyle(color: colors.grey10),
          ),
        ),
      ],
    );
  }
}