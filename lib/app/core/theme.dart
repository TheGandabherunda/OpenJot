import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle

import 'colors.dart'; // Assuming colors.dart is in the same directory or correctly imported

/// Helper function to determine contrasting text color for a given background color
Color _getContrastingTextColor(Color backgroundColor) {
  final luminance = backgroundColor.computeLuminance();
  return luminance > 0.5 ? Colors.black : Colors.white;
}

/// Defines the application's theme data, including light and dark themes.
class AppTheme {
  /// Provides a map of named accent colors based on the current brightness.
  /// This returns the *main* shade (index 0) of each accent color.
  static Map<String, Color> getNamedColors(Brightness brightness) {
    return brightness == Brightness.light
        ? {
            'Indigo': AppColors.aLIndigo[0],
            'Purple': AppColors.aLPurple[0],
            'Blue': AppColors.aLBlue[0],
            'Cyan': AppColors.aLCyan[0],
            'Teal': AppColors.aLTeal[0],
            'Mint': AppColors.aLMint[0],
            'Green': AppColors.aLGreen[0],
            'Red': AppColors.aLRed[0],
            'Yellow': AppColors.aLYellow[0],
            'Pink': AppColors.aLPink[0],
            'Orange': AppColors.aLOrange[0],
            'Brown': AppColors.aLBrown[0],
            'Neutral': AppColors.aLNeutral[0],
          }
        : {
            'Indigo': AppColors.aDIndigo[0],
            'Purple': AppColors.aDPurple[0],
            'Blue': AppColors.aDBlue[0],
            'Cyan': AppColors.aDCyan[0],
            'Teal': AppColors.aDTeal[0],
            'Mint': AppColors.aDMint[0],
            'Green': AppColors.aDGreen[0],
            'Red': AppColors.aDRed[0],
            'Yellow': AppColors.aDYellow[0],
            'Pink': AppColors.aDPink[0],
            'Orange': AppColors.aDOrange[0],
            'Brown': AppColors.aDBrown[0],
            'Neutral': AppColors.aDNeutral[0],
          };
  }

  /// Configures the light theme for the application.
  static ThemeData lightTheme({
    Color? primaryColorOverride,
    Color? secondaryColorOverride,
    Color? tertiaryColorOverride,
  }) {
    // Use the main shade (index 0) for primary, secondary, tertiary colors in ThemeData
    final Color defaultPrimary = getNamedColors(Brightness.light)['Indigo']!;
    final Color defaultSecondary = getNamedColors(Brightness.light)['Green']!;
    final Color defaultTertiary = getNamedColors(Brightness.light)['Orange']!;

    final Color primary = primaryColorOverride ?? defaultPrimary;
    final Color secondary = secondaryColorOverride ?? defaultSecondary;
    final Color tertiary = tertiaryColorOverride ?? defaultTertiary;

    final Color onPrimary = _getContrastingTextColor(primary);
    final Color onSecondary = _getContrastingTextColor(secondary);
    final Color onTertiary = _getContrastingTextColor(tertiary);

    // Define the default text theme with OpenRunde font
    final TextTheme baseTextTheme = const TextTheme().apply(
      bodyColor: AppColors.lightGrey10,
      displayColor: AppColors.lightGrey10,
      fontFamily: 'OpenRunde', // Apply OpenRunde as the default font
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: AppColors.lightGrey7,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        tertiary: tertiary,
        onTertiary: onTertiary,
        surface: AppColors.lightGrey7,
        background: AppColors.lightGrey7,
        error: AppColors.lightError,
        onError: _getContrastingTextColor(AppColors.lightError),
        surfaceTint: primary,
      ),
      textTheme: baseTextTheme,
      // Use the baseTextTheme with OpenRunde
      iconTheme: const IconThemeData(color: AppColors.lightGrey10),
      appBarTheme: AppBarTheme(
        color: primary,
        foregroundColor: onPrimary,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: onPrimary,
        ), // Apply font to app bar title
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGrey6,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightError, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightError, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        hintStyle: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.lightGrey1,
        ),
        // Apply font to hint text
        labelStyle: baseTextTheme.bodyMedium?.copyWith(
          color: primary,
        ), // Apply font to label text
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ), // Apply font to elevated button text
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: baseTextTheme.labelLarge, // Apply font to text button text
        ),
      ),
      // Card Theme - Changed to CardThemeData
      cardTheme: CardThemeData(
        // Changed from CardTheme to CardThemeData
        color: AppColors.lightGrey7,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppThemeColors(
          grey1: AppColors.lightGrey1,
          grey2: AppColors.lightGrey2,
          grey3: AppColors.lightGrey3,
          grey4: AppColors.lightGrey4,
          grey5: AppColors.lightGrey5,
          grey6: AppColors.lightGrey6,
          grey7: AppColors.lightGrey7,
          grey8: AppColors.lightGrey8,
          grey9: AppColors.lightGrey9,
          grey10: AppColors.lightGrey10,
          primary: primary,
          onPrimary: onPrimary,
          secondary: secondary,
          onSecondary: onSecondary,
          tertiary: tertiary,
          onTertiary: onTertiary,
          success: AppColors.lightSuccess,
          error: AppColors.lightError,
          warning: AppColors.lightWarning,
          aIndigo: AppColors.aLIndigo,
          aPurple: AppColors.aLPurple,
          aBlue: AppColors.aLBlue,
          aGreen: AppColors.aLGreen,
          aRed: AppColors.aLRed,
          aYellow: AppColors.aLYellow,
          aPink: AppColors.aLPink,
          aOrange: AppColors.aLOrange,
          aMint: AppColors.aLMint,
          aTeal: AppColors.aLTeal,
          aCyan: AppColors.aLCyan,
          aBrown: AppColors.aLBrown,
          aNeutral: AppColors.aLNeutral,
        ),
      ],
    );
  }

  /// Configures the dark theme for the application.
  static ThemeData darkTheme({
    Color? primaryColorOverride,
    Color? secondaryColorOverride,
    Color? tertiaryColorOverride,
  }) {
    // Use the main shade (index 0) for primary, secondary, tertiary colors in ThemeData
    final Color defaultPrimary = getNamedColors(Brightness.dark)['Indigo']!;
    final Color defaultSecondary = getNamedColors(Brightness.dark)['Green']!;
    final Color defaultTertiary = getNamedColors(Brightness.dark)['Orange']!;

    final Color primary = primaryColorOverride ?? defaultPrimary;
    final Color secondary = secondaryColorOverride ?? defaultSecondary;
    final Color tertiary = tertiaryColorOverride ?? defaultTertiary;

    final Color onPrimary = _getContrastingTextColor(primary);
    final Color onSecondary = _getContrastingTextColor(secondary);
    final Color onTertiary = _getContrastingTextColor(tertiary);

    // Define the default text theme with OpenRunde font for dark theme
    final TextTheme baseTextTheme = const TextTheme().apply(
      bodyColor: AppColors.darkGrey10,
      displayColor: AppColors.darkGrey10,
      fontFamily: 'OpenRunde', // Apply OpenRunde as the default font
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: AppColors.darkGrey7,
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        tertiary: tertiary,
        onTertiary: onTertiary,
        surface: AppColors.darkGrey7,
        background: AppColors.darkGrey7,
        error: AppColors.darkError,
        onError: _getContrastingTextColor(AppColors.darkError),
        surfaceTint: primary,
      ),
      textTheme: baseTextTheme,
      // Use the baseTextTheme with OpenRunde
      iconTheme: const IconThemeData(color: AppColors.darkGrey10),
      appBarTheme: AppBarTheme(
        color: primary,
        foregroundColor: onPrimary,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        // For status bar icons
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: onPrimary,
        ), // Apply font to app bar title
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkGrey6,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkError, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkError, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        hintStyle: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.darkGrey1,
        ),
        // Apply font to hint text
        labelStyle: baseTextTheme.bodyMedium?.copyWith(
          color: primary,
        ), // Apply font to label text
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ), // Apply font to elevated button text
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: baseTextTheme.labelLarge, // Apply font to text button text
        ),
      ),
      // Card Theme - Changed to CardThemeData
      cardTheme: CardThemeData(
        // Changed from CardTheme to CardThemeData
        color: AppColors.darkGrey7,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppThemeColors(
          grey1: AppColors.darkGrey1,
          grey2: AppColors.darkGrey2,
          grey3: AppColors.darkGrey3,
          grey4: AppColors.darkGrey4,
          grey5: AppColors.darkGrey5,
          grey6: AppColors.darkGrey6,
          grey7: AppColors.darkGrey7,
          grey8: AppColors.darkGrey8,
          grey9: AppColors.darkGrey9,
          grey10: AppColors.darkGrey10,
          primary: primary,
          onPrimary: onPrimary,
          secondary: secondary,
          onSecondary: onSecondary,
          tertiary: tertiary,
          onTertiary: onTertiary,
          success: AppColors.darkSuccess,
          error: AppColors.darkError,
          warning: AppColors.darkWarning,
          aIndigo: AppColors.aDIndigo,
          aPurple: AppColors.aDPurple,
          aBlue: AppColors.aDBlue,
          aGreen: AppColors.aDGreen,
          aRed: AppColors.aDRed,
          aYellow: AppColors.aDYellow,
          aPink: AppColors.aDPink,
          aOrange: AppColors.aDOrange,
          aMint: AppColors.aDMint,
          aTeal: AppColors.aDTeal,
          aCyan: AppColors.aDCyan,
          aBrown: AppColors.aDBrown,
          aNeutral: AppColors.aDNeutral,
        ),
      ],
    );
  }

  /// Retrieves the custom AppThemeColors extension from the current BuildContext.
  static AppThemeColors colorsOf(BuildContext context) {
    return Theme.of(context).extension<AppThemeColors>()!;
  }
}

/// Defines custom color properties for the application theme using ThemeExtension.
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color grey1;
  final Color grey2;
  final Color grey3;
  final Color grey4;
  final Color grey5;
  final Color grey6;
  final Color grey7;
  final Color grey8;
  final Color grey9;
  final Color grey10;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color tertiary;
  final Color onTertiary;
  final Color success;
  final Color error;
  final Color warning;
  final List<Color> aIndigo;
  final List<Color> aPurple;
  final List<Color> aBlue;
  final List<Color> aGreen;
  final List<Color> aRed;
  final List<Color> aYellow;
  final List<Color> aPink;
  final List<Color> aOrange;
  final List<Color> aMint;
  final List<Color> aTeal;
  final List<Color> aCyan;
  final List<Color> aBrown;
  final List<Color> aNeutral;

  /// Constructor for AppThemeColors.
  AppThemeColors({
    required this.grey1,
    required this.grey2,
    required this.grey3,
    required this.grey4,
    required this.grey5,
    required this.grey6,
    required this.grey7,
    required this.grey8,
    required this.grey9,
    required this.grey10,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.success,
    required this.error,
    required this.warning,
    required this.aIndigo,
    required this.aPurple,
    required this.aBlue,
    required this.aGreen,
    required this.aRed,
    required this.aYellow,
    required this.aPink,
    required this.aOrange,
    required this.aMint,
    required this.aTeal,
    required this.aCyan,
    required this.aBrown,
    required this.aNeutral,
  });

  /// Creates a copy of AppThemeColors with optional new values.
  @override
  ThemeExtension<AppThemeColors> copyWith({
    Color? grey1,
    Color? grey2,
    Color? grey3,
    Color? grey4,
    Color? grey5,
    Color? grey6,
    Color? grey7,
    Color? grey8,
    Color? grey9,
    Color? grey10,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? tertiary,
    Color? onTertiary,
    Color? success,
    Color? error,
    Color? warning,
    List<Color>? aIndigo,
    List<Color>? aPurple,
    List<Color>? aBlue,
    List<Color>? aGreen,
    List<Color>? aRed,
    List<Color>? aYellow,
    List<Color>? aPink,
    List<Color>? aOrange,
    List<Color>? aMint,
    List<Color>? aTeal,
    List<Color>? aCyan,
    List<Color>? aBrown,
    List<Color>? aNeutral,
  }) {
    return AppThemeColors(
      grey1: grey1 ?? this.grey1,
      grey2: grey2 ?? this.grey2,
      grey3: grey3 ?? this.grey3,
      grey4: grey4 ?? this.grey4,
      grey5: grey5 ?? this.grey5,
      grey6: grey6 ?? this.grey6,
      grey7: grey7 ?? this.grey7,
      grey8: grey8 ?? this.grey8,
      grey9: grey9 ?? this.grey9,
      grey10: grey10 ?? this.grey10,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      aIndigo: aIndigo ?? this.aIndigo,
      aPurple: aPurple ?? this.aPurple,
      aBlue: aBlue ?? this.aBlue,
      aGreen: aGreen ?? this.aGreen,
      aRed: aRed ?? this.aRed,
      aYellow: aYellow ?? this.aYellow,
      aPink: aPink ?? this.aPink,
      aOrange: aOrange ?? this.aOrange,
      aMint: aMint ?? this.aMint,
      aTeal: aTeal ?? this.aTeal,
      aCyan: aCyan ?? this.aCyan,
      aBrown: aBrown ?? this.aBrown,
      aNeutral: aNeutral ?? this.aNeutral,
    );
  }

  /// Linearly interpolates between two AppThemeColors.
  @override
  ThemeExtension<AppThemeColors> lerp(
    ThemeExtension<AppThemeColors>? other,
    double t,
  ) {
    if (other is! AppThemeColors) {
      return this;
    }
    // Helper to lerp a list of colors
    List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
      if (a.length != b.length) {
        int minLength = a.length < b.length ? a.length : b.length;
        return List.generate(
          minLength,
          (index) => Color.lerp(a[index], b[index], t)!,
        );
      }
      return List.generate(
        a.length,
        (index) => Color.lerp(a[index], b[index], t)!,
      );
    }

    return AppThemeColors(
      grey1: Color.lerp(grey1, other.grey1, t)!,
      grey2: Color.lerp(grey2, other.grey2, t)!,
      grey3: Color.lerp(grey3, other.grey3, t)!,
      grey4: Color.lerp(grey4, other.grey4, t)!,
      grey5: Color.lerp(grey5, other.grey5, t)!,
      grey6: Color.lerp(grey6, other.grey6, t)!,
      grey7: Color.lerp(grey7, other.grey7, t)!,
      grey8: Color.lerp(grey8, other.grey8, t)!,
      grey9: Color.lerp(grey9, other.grey9, t)!,
      grey10: Color.lerp(grey10, other.grey10, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      aIndigo: _lerpColorList(aIndigo, other.aIndigo, t),
      aPurple: _lerpColorList(aPurple, other.aPurple, t),
      aBlue: _lerpColorList(aBlue, other.aBlue, t),
      aGreen: _lerpColorList(aGreen, other.aGreen, t),
      aRed: _lerpColorList(aRed, other.aRed, t),
      aYellow: _lerpColorList(aYellow, other.aYellow, t),
      aPink: _lerpColorList(aPink, other.aPink, t),
      aOrange: _lerpColorList(aOrange, other.aOrange, t),
      aMint: _lerpColorList(aMint, other.aMint, t),
      aTeal: _lerpColorList(aTeal, other.aTeal, t),
      aCyan: _lerpColorList(aCyan, other.aCyan, t),
      aBrown: _lerpColorList(aBrown, other.aBrown, t),
      aNeutral: _lerpColorList(aNeutral, other.aNeutral, t),
    );
  }
}
