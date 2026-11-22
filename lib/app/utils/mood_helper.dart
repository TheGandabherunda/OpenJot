import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_jot/app/core/constants.dart';

class MoodPalette {
  final String dark;
  final String accent;
  final String mid;
  final String light;
  final String veryLight;

  const MoodPalette({
    required this.dark,
    required this.accent,
    required this.mid,
    required this.light,
    required this.veryLight,
  });
}

class MoodHelper {
  // Palettes corresponding to moods 0..6 matching original 1.svg .. 7.svg
  static const List<MoodPalette> palettes = [
    // 0: Very Unpleasant (Purple - original 1.svg)
    MoodPalette(
      dark: '#4C1D95',
      accent: '#A855F7',
      mid: '#C084FC',
      light: '#E9D5FF',
      veryLight: '#F3E8FF',
    ),
    // 1: Unpleasant (Pink - original 2.svg)
    MoodPalette(
      dark: '#9F1239',
      accent: '#F472B6',
      mid: '#FB7185',
      light: '#FFD6E7',
      veryLight: '#FFE4EF',
    ),
    // 2: Slightly Unpleasant (Blue - original 3.svg)
    MoodPalette(
      dark: '#1E3A8A',
      accent: '#3B82F6',
      mid: '#60A5FA',
      light: '#DBEAFE',
      veryLight: '#E0F2FE',
    ),
    // 3: Neutral (Teal - original 4.svg)
    MoodPalette(
      dark: '#134E4A',
      accent: '#14B8A6',
      mid: '#2DD4BF',
      light: '#CCFBF1',
      veryLight: '#E6FFFA',
    ),
    // 4: Slightly Pleasant (Mint - original 5.svg)
    MoodPalette(
      dark: '#065F46',
      accent: '#34D399',
      mid: '#6EE7B7',
      light: '#D1FAE5',
      veryLight: '#ECFDF5',
    ),
    // 5: Pleasant (Green - original 6.svg)
    MoodPalette(
      dark: '#14532D',
      accent: '#22C55E',
      mid: '#4ADE80',
      light: '#DCFCE7',
      veryLight: '#F0FDF4',
    ),
    // 6: Very Pleasant (Yellow - original 7.svg)
    MoodPalette(
      dark: '#854D0E',
      accent: '#EAB308',
      mid: '#FACC15',
      light: '#FEF9C3',
      veryLight: '#FEFCE8',
    ),
  ];

  static const MoodPalette basePalette = MoodPalette(
    dark: '#4C1D95',
    accent: '#A855F7',
    mid: '#C084FC',
    light: '#E9D5FF',
    veryLight: '#F3E8FF',
  );

  static String? _templateSvg;
  static final Map<int, String> _coloredSvgCache = {};

  /// Pre-loads and colors all mood SVGs.
  static Future<void> init([String? templateSvg]) async {
    if (_coloredSvgCache.length == palettes.length && templateSvg == null) {
      return;
    }
    _templateSvg = templateSvg ?? await rootBundle.loadString(AppConstants.moodSvgPath);
    _populateCache(_templateSvg!);
  }

  static void _populateCache(String template) {
    for (int i = 0; i < palettes.length; i++) {
      _coloredSvgCache[i] = _colorSvg(template, i);
    }
  }

  static String _colorSvg(String template, int moodIndex) {
    final palette = palettes[moodIndex.clamp(0, palettes.length - 1)];

    // Scope mask/clip/gradient IDs to avoid collisions when multiple SVGs render
    var result = template.replaceAll('_mood', '_mood_$moodIndex');

    if (moodIndex != 0) {
      result = result
          .replaceAll(basePalette.dark, palette.dark)
          .replaceAll(basePalette.accent, palette.accent)
          .replaceAll(basePalette.mid, palette.mid)
          .replaceAll(basePalette.light, palette.light)
          .replaceAll(basePalette.veryLight, palette.veryLight);
    }

    return result;
  }

  /// Returns the colored SVG XML string for the specified mood index.
  static String getMoodSvgString(int moodIndex) {
    final clamped = moodIndex.clamp(0, palettes.length - 1);
    final cached = _coloredSvgCache[clamped];
    if (cached != null) {
      return cached;
    }

    if (_templateSvg != null) {
      _coloredSvgCache[clamped] = _colorSvg(_templateSvg!, clamped);
      return _coloredSvgCache[clamped]!;
    }

    // Fallback if not initialized yet
    return '';
  }

  /// Creates a BytesLoader for vector_graphics / vg.loadPicture.
  static SvgStringLoader getLoader(int moodIndex) {
    return SvgStringLoader(getMoodSvgString(moodIndex));
  }

  /// Builds an SvgPicture widget with the recolored SVG string.
  static Widget buildMoodSvg(
    int moodIndex, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) {
    return SvgPicture.string(
      getMoodSvgString(moodIndex),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }
}
