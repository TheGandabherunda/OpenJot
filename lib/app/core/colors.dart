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

  static const Color darkGrey10 = Color(0xFFFFFEFF); // White with purple hint
  static const Color darkGrey1 = Color(0xFF8E8E97);  // Subtle purple tint
  static const Color darkGrey2 = Color(0xFF63636C);  // Subtle purple tint
  static const Color darkGrey3 = Color(0xFF484850);  // Subtle purple tint
  static const Color darkGrey4 = Color(0xFF3A3A42);  // Subtle purple tint
  static const Color darkGrey5 = Color(0xFF2C2C34);  // Subtle purple tint
  static const Color darkGrey6 = Color(0xFF1C1C24);  // Subtle purple tint
  static const Color darkGrey7 = Color(0xFF030006); // Black with purple hint
  static const Color darkGrey8 = Color(0xFF030006); // Black with purple hint
  static const Color darkGrey9 = Color(0xFF1C1C24);

  // Core Colors
  static const Color lightSuccess = Color(0xFF2E7D32);
  static const Color lightError = Color(0xFFB71C1C);
  static const Color lightWarning = Color(0xFFFF8F00);

  static const Color darkSuccess = Color(0xFF4CAF50);
  static const Color darkError = Color(0xFFE53935);
  static const Color darkWarning = Color(0xFFFFB300);

  // Accent Colors (Light Theme) - [Darkest, Base, Lightest]
  static const List<Color> aLIndigo = [
    Color(0xFF1E1A4D), // Almost black with indigo tint
    Color(0xFF615FFF), // Apple Indigo
    Color(0xFFEEF2FF), // Almost white with indigo tint
  ];
  static const List<Color> aLPurple = [
    Color(0xFF3C0366), // Almost black with purple tint
    Color(0xFFAD46FF), // Apple Purple
    Color(0xFFFAF5FF), // Almost white with purple tint
  ];
  static const List<Color> aLBlue = [
    Color(0xFF052F4A), // Almost black with blue tint
    Color(0xFF00A6F4), // Apple Blue
    Color(0xFFF0F9FF), // Almost white with blue tint
  ];
  static const List<Color> aLCyan = [
    Color(0xFF053345), // Almost black with cyan tint
    Color(0xFF00B8DB), // Apple Cyan (adjusted to be more cyan-like)
    Color(0xFFECFEFF), // Almost white with cyan tint
  ];
  static const List<Color> aLTeal = [
    Color(0xFF032F2E), // Almost black with teal tint
    Color(0xFF00BBA7), // Apple Teal
    Color(0xFFF0FDFA), // Almost white with teal tint
  ];
  static const List<Color> aLMint = [
    Color(0xFF002C22), // Almost black with mint tint
    Color(0xFF00BC7D), // Apple Mint
    Color(0xFFECFDF5), // Almost white with mint tint
  ];
  static const List<Color> aLGreen = [
    Color(0xFF032E15), // Almost black with green tint
    Color(0xFF00C950), // Apple Green
    Color(0xFFF0FDF4), // Almost white with green tint
  ];
  static const List<Color> aLRed = [
    Color(0xFF460809), // Almost black with red tint
    Color(0xFFFB2C36), // Apple Red
    Color(0xFFFEF2F2), // Almost white with red tint
  ];
  static const List<Color> aLYellow = [
    Color(0xFF1A1A0A), // Almost black with yellow tint
    Color(0xFFF0B100), // Apple Yellow
    Color(0xFFFFFFF7), // Almost white with yellow tint
  ];
  static const List<Color> aLPink = [
    Color(0xFF510424), // Almost black with pink tint
    Color(0xFFF6339A), // Apple Pink
    Color(0xFFFDF2F8), // Almost white with pink tint
  ];
  static const List<Color> aLOrange = [
    Color(0xFF441306), // Almost black with orange tint
    Color(0xFFFF5A1F), // Apple Orange
    Color(0xFFFFF8F1), // Almost white with orange tint
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
    Color(0xFFEEF2FF), // Almost white with indigo tint
    Color(0xFF615FFF), // Apple Indigo
    Color(0xFF1E1A4D), // Almost black with indigo tint
  ];
  static const List<Color> aDPurple = [
    Color(0xFFFAF5FF), // Almost white with purple tint
    Color(0xFFAD46FF), // Apple Purple
    Color(0xFF3C0366), // Almost black with purple tint
  ];
  static const List<Color> aDBlue = [
    Color(0xFFF0F9FF), // Almost white with blue tint
    Color(0xFF00A6F4), // Apple Blue
    Color(0xFF052F4A), // Almost black with blue tint
  ];
  static const List<Color> aDCyan = [
    Color(0xFFECFEFF), // Almost white with cyan tint
    Color(0xFF00B8DB), // Apple Cyan (adjusted to be more cyan-like)
    Color(0xFF053345), // Almost black with cyan tint
  ];
  static const List<Color> aDTeal = [
    Color(0xFFF0FDFA), // Almost white with teal tint
    Color(0xFF00BBA7), // Apple Teal
    Color(0xFF032F2E), // Almost black with teal tint
  ];
  static const List<Color> aDMint = [
    Color(0xFFECFDF5), // Almost white with mint tint
    Color(0xFF00BC7D), // Apple Mint
    Color(0xFF002C22), // Almost black with mint tint
  ];
  static const List<Color> aDGreen = [
    Color(0xFFF0FDF4), // Almost white with green tint
    Color(0xFF00C950), // Apple Green
    Color(0xFF032E15), // Almost black with green tint
  ];
  static const List<Color> aDRed = [
    Color(0xFFFEF2F2), // Almost white with red tint
    Color(0xFFFB2C36), // Apple Red
    Color(0xFF460809), // Almost black with red tint
  ];
  static const List<Color> aDYellow = [
    Color(0xFFFFFFF7), // Almost white with yellow tint
    Color(0xFFF0B100), // Apple Yellow
    Color(0xFF1A1A0A), // Almost black with yellow tint
  ];
  static const List<Color> aDPink = [
    Color(0xFFFDF2F8), // Almost white with pink tint
    Color(0xFFF6339A), // Apple Pink
    Color(0xFF510424), // Almost black with pink tint
  ];
  static const List<Color> aDOrange = [
    Color(0xFFFFF8F1), // Almost white with orange tint
    Color(0xFFFF5A1F), // Apple Orange
    Color(0xFF441306), // Almost black with orange tint
  ];
  static const List<Color> aDBrown = [
    Color(0xFFFFFDF9), // Almost white with brown tint
    Color(0xFFA2845E), // Apple Brown
    Color(0xFF1A1614), // Almost black with brown tint
  ];
  static const List<Color> aDNeutral = [
    Color(0xFFF7F7F7), // Almost white neutral
    Color(0xFF8E8E93), // Apple Gray
    Color(0xFF0A0A0A), // Almost black neutral
  ];
}
