import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';

class MoodPalette {
  final String dark;
  final String accent;
  final String mid;
  final String light;
  final String veryLight;
  final String? name;

  const MoodPalette({
    required this.dark,
    required this.accent,
    required this.mid,
    required this.light,
    required this.veryLight,
    this.name,
  });

  Map<String, String> toMap() => {
    'dark': dark,
    'accent': accent,
    'mid': mid,
    'light': light,
    'veryLight': veryLight,
    if (name != null) 'name': name!,
  };

  factory MoodPalette.fromMap(Map<dynamic, dynamic> map) => MoodPalette(
    dark: map['dark'] as String,
    accent: map['accent'] as String,
    mid: map['mid'] as String,
    light: map['light'] as String,
    veryLight: map['veryLight'] as String,
    name: map['name'] as String?,
  );

  Color get darkColor => MoodHelper.hexToColor(dark);
  Color get accentColor => MoodHelper.hexToColor(accent);
  Color get midColor => MoodHelper.hexToColor(mid);
  Color get lightColor => MoodHelper.hexToColor(light);
  Color get veryLightColor => MoodHelper.hexToColor(veryLight);
}

class AppleColorPreset {
  final String name;
  final Color color;
  final MoodPalette palette;

  const AppleColorPreset({
    required this.name,
    required this.color,
    required this.palette,
  });
}

class MoodThemePreset {
  final String name;
  final String description;
  final List<MoodPalette> palettes;

  const MoodThemePreset({
    required this.name,
    required this.description,
    required this.palettes,
  });
}

class MoodHelper {
  // Original default palettes for moods 0..6
  static const List<MoodPalette> defaultPalettes = [
    // 0: Very Unpleasant (Purple)
    MoodPalette(
      dark: '#4C1D95',
      accent: '#A855F7',
      mid: '#C084FC',
      light: '#E9D5FF',
      veryLight: '#F3E8FF',
      name: 'Purple',
    ),
    // 1: Unpleasant (Pink)
    MoodPalette(
      dark: '#9F1239',
      accent: '#F472B6',
      mid: '#FB7185',
      light: '#FFD6E7',
      veryLight: '#FFE4EF',
      name: 'Rose',
    ),
    // 2: Slightly Unpleasant (Blue)
    MoodPalette(
      dark: '#1E3A8A',
      accent: '#3B82F6',
      mid: '#60A5FA',
      light: '#DBEAFE',
      veryLight: '#E0F2FE',
      name: 'Blue',
    ),
    // 3: Neutral (Teal)
    MoodPalette(
      dark: '#134E4A',
      accent: '#14B8A6',
      mid: '#2DD4BF',
      light: '#CCFBF1',
      veryLight: '#E6FFFA',
      name: 'Teal',
    ),
    // 4: Slightly Pleasant (Mint)
    MoodPalette(
      dark: '#065F46',
      accent: '#34D399',
      mid: '#6EE7B7',
      light: '#D1FAE5',
      veryLight: '#ECFDF5',
      name: 'Mint',
    ),
    // 5: Pleasant (Green)
    MoodPalette(
      dark: '#14532D',
      accent: '#22C55E',
      mid: '#4ADE80',
      light: '#DCFCE7',
      veryLight: '#F0FDF4',
      name: 'Green',
    ),
    // 6: Very Pleasant (Yellow)
    MoodPalette(
      dark: '#854D0E',
      accent: '#EAB308',
      mid: '#FACC15',
      light: '#FEF9C3',
      veryLight: '#FEFCE8',
      name: 'Yellow',
    ),
  ];

  static final MoodPalette basePalette = defaultPalettes[0];

  static final List<MoodPalette> _currentPalettes = List<MoodPalette>.from(defaultPalettes);

  /// Current active palettes for moods 0..6
  static List<MoodPalette> get palettes => List.unmodifiable(_currentPalettes);

  static String? _templateSvg;
  static final Map<int, String> _coloredSvgCache = {};

  /// Pre-loads template and colors all mood SVGs.
  static Future<void> init([String? templateSvg]) async {
    _templateSvg = templateSvg ?? _templateSvg;
    _templateSvg ??= await rootBundle.loadString(AppConstants.moodSvgPath);

    await _loadCustomPalettesFromSettings();
    _populateCache(_templateSvg!);
  }

  /// Reloads custom mood colors from Hive settings (e.g. after backup restore).
  static Future<void> reloadFromSettings() async {
    await _loadCustomPalettesFromSettings();
    if (_templateSvg != null) {
      _populateCache(_templateSvg!);
    }
  }

  static Future<void> _loadCustomPalettesFromSettings() async {
    if (!Get.isRegistered<HiveService>()) return;
    final hiveService = Get.find<HiveService>();
    final custom = hiveService.customMoodPalettes;

    if (custom != null && custom.isNotEmpty) {
      for (int i = 0; i < defaultPalettes.length; i++) {
        if (custom.containsKey(i)) {
          _currentPalettes[i] = MoodPalette.fromMap(custom[i]!);
        } else {
          _currentPalettes[i] = defaultPalettes[i];
        }
      }
    } else {
      for (int i = 0; i < defaultPalettes.length; i++) {
        _currentPalettes[i] = defaultPalettes[i];
      }
    }
  }

  static Future<void> _savePalettesToSettings() async {
    if (!Get.isRegistered<HiveService>()) return;
    final hiveService = Get.find<HiveService>();

    final map = <int, Map<String, String>>{};
    for (int i = 0; i < _currentPalettes.length; i++) {
      map[i] = _currentPalettes[i].toMap();
    }
    await hiveService.setCustomMoodPalettes(map);
  }

  static void _populateCache(String template) {
    for (int i = 0; i < _currentPalettes.length; i++) {
      _coloredSvgCache[i] = _colorSvg(template, i);
    }
  }

  static String _colorSvg(String template, int moodIndex) {
    final palette = _currentPalettes[moodIndex.clamp(0, _currentPalettes.length - 1)];

    // Scope mask/clip/gradient IDs to avoid collisions when multiple SVGs render
    var result = template.replaceAll('_mood', '_mood_$moodIndex');

    result = result
        .replaceAll(basePalette.dark, palette.dark)
        .replaceAll(basePalette.accent, palette.accent)
        .replaceAll(basePalette.mid, palette.mid)
        .replaceAll(basePalette.light, palette.light)
        .replaceAll(basePalette.veryLight, palette.veryLight);

    return result;
  }

  /// Returns the colored SVG XML string for the specified mood index.
  static String getMoodSvgString(int moodIndex) {
    final clamped = moodIndex.clamp(0, _currentPalettes.length - 1);
    final cached = _coloredSvgCache[clamped];
    if (cached != null) {
      return cached;
    }

    if (_templateSvg != null) {
      _coloredSvgCache[clamped] = _colorSvg(_templateSvg!, clamped);
      return _coloredSvgCache[clamped]!;
    }

    return '';
  }

  /// Returns recolored SVG string for any custom MoodPalette on-the-fly.
  static String getSvgStringForPalette(int moodIndex, MoodPalette palette) {
    if (_templateSvg == null) return '';
    var result = _templateSvg!.replaceAll('_mood', '_mood_$moodIndex');
    result = result
        .replaceAll(basePalette.dark, palette.dark)
        .replaceAll(basePalette.accent, palette.accent)
        .replaceAll(basePalette.mid, palette.mid)
        .replaceAll(basePalette.light, palette.light)
        .replaceAll(basePalette.veryLight, palette.veryLight);
    return result;
  }

  /// Builds SvgPicture widget for any custom MoodPalette on-the-fly.
  static Widget buildMoodSvgForPalette(
    int moodIndex,
    MoodPalette palette, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) {
    return SvgPicture.string(
      getSvgStringForPalette(moodIndex, palette),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }

  /// Saves all 7 palettes at once and re-rasterizes all icons.
  static Future<void> saveAllPalettes(List<MoodPalette> newPalettes) async {
    for (int i = 0; i < defaultPalettes.length && i < newPalettes.length; i++) {
      _currentPalettes[i] = newPalettes[i];
    }

    if (_templateSvg != null) {
      _populateCache(_templateSvg!);
    }

    await _savePalettesToSettings();

    // Re-rasterize all for lag-free rendering
    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().rasterizeMoodIcons();
    }
  }

  /// Sets a new palette for a specific mood index and re-rasterizes images.
  static Future<void> setMoodPalette(int moodIndex, MoodPalette palette) async {
    final clamped = moodIndex.clamp(0, _currentPalettes.length - 1);
    _currentPalettes[clamped] = palette;

    if (_templateSvg != null) {
      _coloredSvgCache[clamped] = _colorSvg(_templateSvg!, clamped);
    }

    await _savePalettesToSettings();

    // Re-rasterize for lag-free rendering
    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().reRasterizeMood(clamped);
    }
  }

  /// Applies a full 7-mood preset theme.
  static Future<void> applyThemePreset(List<MoodPalette> themePalettes) async {
    for (int i = 0; i < defaultPalettes.length && i < themePalettes.length; i++) {
      _currentPalettes[i] = themePalettes[i];
    }

    if (_templateSvg != null) {
      _populateCache(_templateSvg!);
    }

    await _savePalettesToSettings();

    // Re-rasterize all for lag-free rendering
    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().rasterizeMoodIcons();
    }
  }

  /// Resets all mood colors to factory defaults.
  static Future<void> resetToDefault() async {
    for (int i = 0; i < defaultPalettes.length; i++) {
      _currentPalettes[i] = defaultPalettes[i];
    }

    if (_templateSvg != null) {
      _populateCache(_templateSvg!);
    }

    if (Get.isRegistered<HiveService>()) {
      await Get.find<HiveService>().clearCustomMoodPalettes();
    }

    // Re-rasterize all for lag-free rendering
    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().rasterizeMoodIcons();
    }
  }

  /// Creates a harmonious 5-stop MoodPalette from any primary color.
  static MoodPalette createFromColor(Color color, {String? name}) {
    final hsl = HSLColor.fromColor(color);

    final accentHex = colorToHex(color);

    final darkColor = hsl
        .withLightness(0.28)
        .withSaturation((hsl.saturation * 0.95).clamp(0.45, 0.95))
        .toColor();
    final darkHex = colorToHex(darkColor);

    final midColor = hsl
        .withLightness((hsl.lightness * 1.15).clamp(0.65, 0.78))
        .withSaturation((hsl.saturation * 0.9).clamp(0.5, 1.0))
        .toColor();
    final midHex = colorToHex(midColor);

    final lightColor = hsl
        .withLightness(0.89)
        .withSaturation((hsl.saturation * 0.75).clamp(0.35, 0.85))
        .toColor();
    final lightHex = colorToHex(lightColor);

    final veryLightColor = hsl
        .withLightness(0.96)
        .withSaturation((hsl.saturation * 0.6).clamp(0.25, 0.75))
        .toColor();
    final veryLightHex = colorToHex(veryLightColor);

    return MoodPalette(
      dark: darkHex,
      accent: accentHex,
      mid: midHex,
      light: lightHex,
      veryLight: veryLightHex,
      name: name,
    );
  }

  /// Returns the vibrant accent color for a mood.
  static Color getAccentColor(int moodIndex) {
    final clamped = moodIndex.clamp(0, _currentPalettes.length - 1);
    return hexToColor(_currentPalettes[clamped].accent);
  }

  /// Returns a 3-element list [accent (text), normal (vibrant), background (wash)]
  /// for a mood, matching the AppTheme's light/dark accent color structure.
  static List<Color> getMoodThemeColors(
    int moodIndex,
    AppThemeColors themeColors,
    bool isDark,
  ) {
    final clamped = moodIndex.clamp(0, _currentPalettes.length - 1);
    final currentAccentHex = _currentPalettes[clamped].accent.toUpperCase();
    final defaultAccentHex = defaultPalettes[clamped].accent.toUpperCase();

    // Default palette colors map directly to AppTheme accent lists
    if (currentAccentHex == defaultAccentHex) {
      final defaultThemeLists = [
        themeColors.aPurple,
        themeColors.aPink,
        themeColors.aBlue,
        themeColors.aTeal,
        themeColors.aMint,
        themeColors.aGreen,
        themeColors.aYellow,
      ];
      return defaultThemeLists[clamped];
    }

    // For customized mood color, derive harmonious [text, vibrant, background]
    final baseColor = hexToColor(currentAccentHex);
    final hsl = HSLColor.fromColor(baseColor);
    final darkShade = hsl
        .withLightness(0.20)
        .withSaturation((hsl.saturation * 0.95).clamp(0.4, 0.95))
        .toColor();
    final lightShade = hsl
        .withLightness(0.97)
        .withSaturation((hsl.saturation * 0.6).clamp(0.2, 0.7))
        .toColor();

    if (isDark) {
      return [lightShade, baseColor, darkShade];
    } else {
      return [darkShade, baseColor, lightShade];
    }
  }

  /// Returns the primary dark color for a mood.
  static Color getNormalColor(int moodIndex) {
    final clamped = moodIndex.clamp(0, _currentPalettes.length - 1);
    return hexToColor(_currentPalettes[clamped].dark);
  }

  /// Returns the light background wash color for a mood.
  static Color getBackgroundColor(int moodIndex) {
    final clamped = moodIndex.clamp(0, _currentPalettes.length - 1);
    return hexToColor(_currentPalettes[clamped].veryLight);
  }

  /// Returns the mid-tone gradient color for a mood.
  static Color getMidColor(int moodIndex) {
    final clamped = moodIndex.clamp(0, _currentPalettes.length - 1);
    return hexToColor(_currentPalettes[clamped].mid);
  }

  /// Helper to convert a Color to uppercase '#RRGGBB' hex string.
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  /// Helper to convert '#RRGGBB' hex string to Color.
  static Color hexToColor(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
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

  /// Curated Apple-style color presets.
  static final List<AppleColorPreset> appleColorPresets = [
    AppleColorPreset(
      name: 'Purple',
      color: const Color(0xFFAF52DE),
      palette: defaultPalettes[0],
    ),
    AppleColorPreset(
      name: 'Rose',
      color: const Color(0xFFF472B6),
      palette: defaultPalettes[1],
    ),
    AppleColorPreset(
      name: 'Blue',
      color: const Color(0xFF007AFF),
      palette: defaultPalettes[2],
    ),
    AppleColorPreset(
      name: 'Teal',
      color: const Color(0xFF30B0C7),
      palette: defaultPalettes[3],
    ),
    AppleColorPreset(
      name: 'Mint',
      color: const Color(0xFF00C7BE),
      palette: defaultPalettes[4],
    ),
    AppleColorPreset(
      name: 'Green',
      color: const Color(0xFF34C759),
      palette: defaultPalettes[5],
    ),
    AppleColorPreset(
      name: 'Yellow',
      color: const Color(0xFFFFCC00),
      palette: defaultPalettes[6],
    ),
    AppleColorPreset(
      name: 'Indigo',
      color: const Color(0xFF5856D6),
      palette: createFromColor(const Color(0xFF5856D6), name: 'Indigo'),
    ),
    AppleColorPreset(
      name: 'Cyan',
      color: const Color(0xFF32ADE6),
      palette: createFromColor(const Color(0xFF32ADE6), name: 'Cyan'),
    ),
    AppleColorPreset(
      name: 'Sky',
      color: const Color(0xFF0EA5E9),
      palette: createFromColor(const Color(0xFF0EA5E9), name: 'Sky'),
    ),
    AppleColorPreset(
      name: 'Lime',
      color: const Color(0xFF84CC16),
      palette: createFromColor(const Color(0xFF84CC16), name: 'Lime'),
    ),
    AppleColorPreset(
      name: 'Amber',
      color: const Color(0xFFF59E0B),
      palette: createFromColor(const Color(0xFFF59E0B), name: 'Amber'),
    ),
    AppleColorPreset(
      name: 'Orange',
      color: const Color(0xFFFF9500),
      palette: createFromColor(const Color(0xFFFF9500), name: 'Orange'),
    ),
    AppleColorPreset(
      name: 'Coral',
      color: const Color(0xFFFF6B6B),
      palette: createFromColor(const Color(0xFFFF6B6B), name: 'Coral'),
    ),
    AppleColorPreset(
      name: 'Red',
      color: const Color(0xFFFF3B30),
      palette: createFromColor(const Color(0xFFFF3B30), name: 'Red'),
    ),
    AppleColorPreset(
      name: 'Crimson',
      color: const Color(0xFFE11D48),
      palette: createFromColor(const Color(0xFFE11D48), name: 'Crimson'),
    ),
    AppleColorPreset(
      name: 'Violet',
      color: const Color(0xFF7C3AED),
      palette: createFromColor(const Color(0xFF7C3AED), name: 'Violet'),
    ),
    AppleColorPreset(
      name: 'Pink',
      color: const Color(0xFFFF2D55),
      palette: createFromColor(const Color(0xFFFF2D55), name: 'Pink'),
    ),
    AppleColorPreset(
      name: 'Fuchsia',
      color: const Color(0xFFD946EF),
      palette: createFromColor(const Color(0xFFD946EF), name: 'Fuchsia'),
    ),
    AppleColorPreset(
      name: 'Brown',
      color: const Color(0xFFA2845E),
      palette: createFromColor(const Color(0xFFA2845E), name: 'Brown'),
    ),
    AppleColorPreset(
      name: 'Slate',
      color: const Color(0xFF64748B),
      palette: createFromColor(const Color(0xFF64748B), name: 'Slate'),
    ),
  ];

  /// Full 7-mood theme presets.
  static final List<MoodThemePreset> themePresets = [
    const MoodThemePreset(
      name: 'Classic OpenJot',
      description: 'The signature Apple-inspired mood palette',
      palettes: defaultPalettes,
    ),
    MoodThemePreset(
      name: 'Warm Sunset',
      description: 'Radiant gradients from rich berry to warm gold',
      palettes: [
        createFromColor(const Color(0xFF881337), name: 'Crimson'),
        createFromColor(const Color(0xFFE11D48), name: 'Berry'),
        createFromColor(const Color(0xFFFF3B30), name: 'Red'),
        createFromColor(const Color(0xFFFF6B6B), name: 'Coral'),
        createFromColor(const Color(0xFFFF9500), name: 'Orange'),
        createFromColor(const Color(0xFFF59E0B), name: 'Amber'),
        createFromColor(const Color(0xFFFFCC00), name: 'Gold'),
      ],
    ),
    MoodThemePreset(
      name: 'Cool Ocean',
      description: 'Calm nautical spectrum from deep abyss to seafoam',
      palettes: [
        createFromColor(const Color(0xFF312E81), name: 'Abyss'),
        createFromColor(const Color(0xFF1E3A8A), name: 'Navy'),
        createFromColor(const Color(0xFF007AFF), name: 'Royal'),
        createFromColor(const Color(0xFF0EA5E9), name: 'Sky'),
        createFromColor(const Color(0xFF06B6D4), name: 'Cyan'),
        createFromColor(const Color(0xFF14B8A6), name: 'Teal'),
        createFromColor(const Color(0xFF34D399), name: 'Seafoam'),
      ],
    ),
    MoodThemePreset(
      name: 'Neon Glow',
      description: 'High-energy electric tones with bold presence',
      palettes: [
        createFromColor(const Color(0xFF7C3AED), name: 'Electric Violet'),
        createFromColor(const Color(0xFFD946EF), name: 'Neon Fuchsia'),
        createFromColor(const Color(0xFF3B82F6), name: 'Neon Blue'),
        createFromColor(const Color(0xFF06B6D4), name: 'Cyan Glow'),
        createFromColor(const Color(0xFF84CC16), name: 'Neon Lime'),
        createFromColor(const Color(0xFF22C55E), name: 'Neon Green'),
        createFromColor(const Color(0xFFEAB308), name: 'Electric Amber'),
      ],
    ),
    MoodThemePreset(
      name: 'Pastel Garden',
      description: 'Soft, delicate tones inspired by spring blossoms',
      palettes: [
        createFromColor(const Color(0xFFC084FC), name: 'Lavender'),
        createFromColor(const Color(0xFFF472B6), name: 'Blush'),
        createFromColor(const Color(0xFF93C5FD), name: 'Baby Blue'),
        createFromColor(const Color(0xFF67E8F9), name: 'Soft Cyan'),
        createFromColor(const Color(0xFF6EE7B7), name: 'Mint Cream'),
        createFromColor(const Color(0xFF86EFAC), name: 'Sage Green'),
        createFromColor(const Color(0xFFFDE047), name: 'Buttercup'),
      ],
    ),
    MoodThemePreset(
      name: 'Earth & Forest',
      description: 'Warm organic tones inspired by nature and soil',
      palettes: [
        createFromColor(const Color(0xFF581C87), name: 'Plum'),
        createFromColor(const Color(0xFF9A3412), name: 'Terracotta'),
        createFromColor(const Color(0xFFC2410C), name: 'Rust'),
        createFromColor(const Color(0xFFB45309), name: 'Ochre'),
        createFromColor(const Color(0xFF4D7C0F), name: 'Olive'),
        createFromColor(const Color(0xFF15803D), name: 'Forest'),
        createFromColor(const Color(0xFFA16207), name: 'Sand'),
      ],
    ),
  ];
}
