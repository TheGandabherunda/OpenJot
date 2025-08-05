import 'dart:ui';

class AppColors {
  // Neutral Colors
  static const Color lightGrey10 = Color(0xFF000000); // Black
  static const Color lightGrey1 = Color(0xFF8E8E93);
  static const Color lightGrey2 = Color(0xFFAEAEB2);
  static const Color lightGrey3 = Color(0xFFC7C7CC);
  static const Color lightGrey4 = Color(0xFFD1D1D6);
  static const Color lightGrey5 = Color(0xFFE5E5EA);
  static const Color lightGrey6 = Color(0xFFF2F2F7);
  static const Color lightGrey7 = Color(0xFFFFFFFF); // White
  static const Color lightGrey8 = Color(0xFFF2F2F7);
  static const Color lightGrey9 = Color(0xFFFFFFFF);

  static const Color darkGrey10 = Color(0xFFFFFFFF); // White
  static const Color darkGrey1 = Color(0xFF8E8E93);
  static const Color darkGrey2 = Color(0xFF636366);
  static const Color darkGrey3 = Color(0xFF48484A);
  static const Color darkGrey4 = Color(0xFF3A3A3C);
  static const Color darkGrey5 = Color(0xFF2C2C2E);
  static const Color darkGrey6 = Color(0xFF1C1C1E);
  static const Color darkGrey7 = Color(0xFF000000); // Black
  static const Color darkGrey8 = Color(0xFF000000);
  static const Color darkGrey9 = Color(0xFF1C1C1E);

  // Core Colors
  static const Color lightSuccess = Color(0xFF2E7D32);
  static const Color lightError = Color(0xFFB71C1C);
  static const Color lightWarning = Color(0xFFFF8F00);

  static const Color darkSuccess = Color(0xFF4CAF50);
  static const Color darkError = Color(0xFFE53935);
  static const Color darkWarning = Color(0xFFFFB300);

  // Accent Colors (Light Theme) - [Darkest, Base, Lightest]
  static const List<Color> aLIndigo = [
    Color(0xFF0A0B1A), // Almost black with indigo tint
    Color(0xFF5856D6), // Apple Indigo
    Color(0xFFF7F7FF), // Almost white with indigo tint
  ];
  static const List<Color> aLPurple = [
    Color(0xFF1A0A1A), // Almost black with purple tint
    Color(0xFFAF52DE), // Apple Purple
    Color(0xFFFFF7FF), // Almost white with purple tint
  ];
  static const List<Color> aLBlue = [
    Color(0xFF0A0F1A), // Almost black with blue tint
    Color(0xFF007AFF), // Apple Blue
    Color(0xFFF7FAFF), // Almost white with blue tint
  ];
  static const List<Color> aLCyan = [
    Color(0xFF0A1A1A), // Almost black with cyan tint
    Color(0xFF32D74B), // Apple Cyan (adjusted to be more cyan-like)
    Color(0xFFF7FFFF), // Almost white with cyan tint
  ];
  static const List<Color> aLTeal = [
    Color(0xFF0A1A18), // Almost black with teal tint
    Color(0xFF30B0C7), // Apple Teal
    Color(0xFFF7FFFC), // Almost white with teal tint
  ];
  static const List<Color> aLMint = [
    Color(0xFF0F1A14), // Almost black with mint tint
    Color(0xFF00C7BE), // Apple Mint
    Color(0xFFF7FFFC), // Almost white with mint tint
  ];
  static const List<Color> aLGreen = [
    Color(0xFF0F1A0A), // Almost black with green tint
    Color(0xFF34C759), // Apple Green
    Color(0xFFF7FFF7), // Almost white with green tint
  ];
  static const List<Color> aLRed = [
    Color(0xFF1A0A0A), // Almost black with red tint
    Color(0xFFFF3B30), // Apple Red
    Color(0xFFFFF7F7), // Almost white with red tint
  ];
  static const List<Color> aLYellow = [
    Color(0xFF1A1A0A), // Almost black with yellow tint
    Color(0xFFFFCC00), // Apple Yellow
    Color(0xFFFFFFF7), // Almost white with yellow tint
  ];
  static const List<Color> aLPink = [
    Color(0xFF1A0F14), // Almost black with pink tint
    Color(0xFFFF2D92), // Apple Pink
    Color(0xFFFFF7FC), // Almost white with pink tint
  ];
  static const List<Color> aLOrange = [
    Color(0xFF1A0F0A), // Almost black with orange tint
    Color(0xFFFF9500), // Apple Orange
    Color(0xFFFFF9F7), // Almost white with orange tint
  ];
  static const List<Color> aLBrown = [
    Color(0xFF1A1614), // Almost black with brown tint
    Color(0xFFA2845E), // Apple Brown
    Color(0xFFFFFDF9), // Almost white with brown tint
  ];
  static const List<Color> aLNeutral = [
    Color(0xFF0A0A0A), // Almost black neutral
    Color(0xFF8E8E93), // Apple Gray
    Color(0xFFF7F7F7), // Almost white neutral
  ];

  // Accent Colors (Dark Theme) - [Lightest, Base, Darkest]
  static const List<Color> aDIndigo = [
    Color(0xFFF7F7FF), // Almost white with indigo tint
    Color(0xFF5856D6), // Apple Indigo
    Color(0xFF0A0B1A), // Almost black with indigo tint
  ];
  static const List<Color> aDPurple = [
    Color(0xFFFFF7FF), // Almost white with purple tint
    Color(0xFFAF52DE), // Apple Purple
    Color(0xFF1A0A1A), // Almost black with purple tint
  ];
  static const List<Color> aDBlue = [
    Color(0xFFF7FAFF), // Almost white with blue tint
    Color(0xFF007AFF), // Apple Blue
    Color(0xFF0A0F1A), // Almost black with blue tint
  ];
  static const List<Color> aDCyan = [
    Color(0xFFF7FFFF), // Almost white with cyan tint
    Color(0xFF64D2FF), // Apple Cyan (brighter for dark theme)
    Color(0xFF0A1A1A), // Almost black with cyan tint
  ];
  static const List<Color> aDTeal = [
    Color(0xFFF7FFFC), // Almost white with teal tint
    Color(0xFF6AC4DC), // Apple Teal (brighter for dark theme)
    Color(0xFF0A1A18), // Almost black with teal tint
  ];
  static const List<Color> aDMint = [
    Color(0xFFF7FFFC), // Almost white with mint tint
    Color(0xFF63E6E2), // Apple Mint (brighter for dark theme)
    Color(0xFF0F1A14), // Almost black with mint tint
  ];
  static const List<Color> aDGreen = [
    Color(0xFFF7FFF7), // Almost white with green tint
    Color(0xFF30D158), // Apple Green (brighter for dark theme)
    Color(0xFF0F1A0A), // Almost black with green tint
  ];
  static const List<Color> aDRed = [
    Color(0xFFFFF7F7), // Almost white with red tint
    Color(0xFFFF453A), // Apple Red (brighter for dark theme)
    Color(0xFF1A0A0A), // Almost black with red tint
  ];
  static const List<Color> aDYellow = [
    Color(0xFFFFFFF7), // Almost white with yellow tint
    Color(0xFFFFD60A), // Apple Yellow (brighter for dark theme)
    Color(0xFF1A1A0A), // Almost black with yellow tint
  ];
  static const List<Color> aDPink = [
    Color(0xFFFFF7FC), // Almost white with pink tint
    Color(0xFFFF375F), // Apple Pink (brighter for dark theme)
    Color(0xFF1A0F14), // Almost black with pink tint
  ];
  static const List<Color> aDOrange = [
    Color(0xFFFFF9F7), // Almost white with orange tint
    Color(0xFFFF9F0A), // Apple Orange (brighter for dark theme)
    Color(0xFF1A0F0A), // Almost black with orange tint
  ];
  static const List<Color> aDBrown = [
    Color(0xFFFFFDF9), // Almost white with brown tint
    Color(0xFFAC8E68), // Apple Brown (brighter for dark theme)
    Color(0xFF1A1614), // Almost black with brown tint
  ];
  static const List<Color> aDNeutral = [
    Color(0xFFF7F7F7), // Almost white neutral
    Color(0xFF8E8E93), // Apple Gray
    Color(0xFF0A0A0A), // Almost black neutral
  ];
}
