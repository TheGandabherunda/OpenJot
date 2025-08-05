// expanding_colors.dart
import 'package:flutter/material.dart';

class ExpandingColors {
  final List<Color> dark;
  final List<Color> light;

  const ExpandingColors({required this.dark, required this.light});

  ExpandingColors copyWith({List<Color>? dark, List<Color>? light}) {
    return ExpandingColors(dark: dark ?? this.dark, light: light ?? this.light);
  }
}

class ImmersiveColors {
  final Color primary;
  final Color secondary;
  final ExpandingColors expanding;

  const ImmersiveColors({
    required this.primary,
    required this.secondary,
    required this.expanding,
  });

  ImmersiveColors copyWith({
    Color? primary,
    Color? secondary,
    ExpandingColors? expanding,
  }) {
    return ImmersiveColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      expanding: expanding ?? this.expanding,
    );
  }

  static const defaultColors = ImmersiveColors(
    primary: Color(0xFF5465FF),
    secondary: Color(0xFF5465FF),
    expanding: ExpandingColors(
      dark: [
        Color(0xFFFFA500), // orange
        Color(0xFFFF0000), // red
        Color(0xFF5465FF),
      ],
      light: [
        Color(0xFFFFA500), // orange
        Color(0xFFFF0000), // red
        Color(0xFF0077B6),
      ],
    ),
  );
}

class ColorUtils {
  static List<Color> generateExpandingColors(List<Color> colors) {
    if (colors.isEmpty) return [];

    final List<Color> processedColors = [];
    for (int i = 0; i < colors.length - 1; i++) {
      processedColors.add(colors[i].withOpacity(0.95));
    }
    final lastColor = colors.last;
    processedColors.add(lastColor.withOpacity(0.95));
    processedColors.add(lastColor.withOpacity(0.2));

    return processedColors;
  }
}