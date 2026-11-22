import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/settings/settings_controller.dart';
import 'package:open_jot/app/utils/mood_helper.dart';

class MoodColorsBottomSheet extends StatefulWidget {
  final int initialMoodIndex;

  const MoodColorsBottomSheet({
    super.key,
    this.initialMoodIndex = 3,
  });

  @override
  State<MoodColorsBottomSheet> createState() => _MoodColorsBottomSheetState();
}

class _MoodColorsBottomSheetState extends State<MoodColorsBottomSheet> {
  late int _selectedMoodIndex;
  final HomeController _homeController = Get.find<HomeController>();

  // Complete Apple System & HIG Color Spectrum (21 colors in 3 harmonious rows of 7)
  static const List<Color> _row1 = [
    Color(0xFFFF3B30), // Apple Red
    Color(0xFFFF9500), // Apple Orange
    Color(0xFFF59E0B), // Apple Amber
    Color(0xFFFFCC00), // Apple Yellow
    Color(0xFF84CC16), // Apple Lime
    Color(0xFF34C759), // Apple Green
    Color(0xFF10B981), // Apple Emerald
  ];

  static const List<Color> _row2 = [
    Color(0xFF00C7BE), // Apple Mint
    Color(0xFF30B0C7), // Apple Teal
    Color(0xFF32ADE6), // Apple Cyan
    Color(0xFF0EA5E9), // Apple Sky
    Color(0xFF007AFF), // Apple Blue
    Color(0xFF5856D6), // Apple Indigo
    Color(0xFFAF52DE), // Apple Purple
  ];

  static const List<Color> _row3 = [
    Color(0xFF7C3AED), // Apple Violet
    Color(0xFFD946EF), // Apple Fuchsia
    Color(0xFFFF2D55), // Apple Pink
    Color(0xFFE11D48), // Apple Rose
    Color(0xFFFF6B6B), // Apple Coral
    Color(0xFFA2845E), // Apple Brown
    Color(0xFF8E8E93), // Apple Gray
  ];

  @override
  void initState() {
    super.initState();
    _selectedMoodIndex =
        widget.initialMoodIndex.clamp(0, MoodHelper.palettes.length - 1);
  }

  void _confirmReset(BuildContext context, AppThemeColors colors) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text(
          AppConstants.resetMoodColors,
          style: TextStyle(fontFamily: AppConstants.font),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            AppConstants.resetMoodColorsConfirm,
            style: TextStyle(fontFamily: AppConstants.font),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              AppConstants.cancel,
              style: TextStyle(
                fontFamily: AppConstants.font,
                color: colors.grey10,
              ),
            ),
            onPressed: () => Navigator.pop(dialogContext),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text(
              AppConstants.reset,
              style: TextStyle(fontFamily: AppConstants.font),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              HapticFeedback.mediumImpact();
              await MoodHelper.resetToDefault();
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
    );
  }

  bool _isColorSelected(Color swatchColor, Color currentAccent, int moodIndex) {
    if (swatchColor.value == currentAccent.value) return true;
    final defaultAccent = MoodHelper.defaultPalettes[moodIndex].accentColor;
    if (currentAccent.value == defaultAccent.value) {
      const defaultSwatchMap = {
        0: Color(0xFFAF52DE), // Purple
        1: Color(0xFFE11D48), // Rose
        2: Color(0xFF007AFF), // Blue
        3: Color(0xFF30B0C7), // Teal
        4: Color(0xFF00C7BE), // Mint
        5: Color(0xFF34C759), // Green
        6: Color(0xFFFFCC00), // Yellow
      };
      return defaultSwatchMap[moodIndex]?.value == swatchColor.value;
    }
    return false;
  }

  Widget _buildColorSwatch(Color color, Color currentAccent) {
    final isSelected =
        _isColorSelected(color, currentAccent, _selectedMoodIndex);
    final isLight = color.computeLuminance() > 0.55;

    return GestureDetector(
      onTap: () async {
        HapticFeedback.selectionClick();
        final newPalette = MoodHelper.createFromColor(color);
        await MoodHelper.setMoodPalette(_selectedMoodIndex, newPalette);
        if (mounted) setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: isLight ? Colors.black87 : Colors.white,
                  width: 2.5,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: isSelected
            ? Center(
                child: Icon(
                  Icons.check_rounded,
                  color: isLight ? Colors.black87 : Colors.white,
                  size: 20.sp,
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsScreenController settingsController =
        Get.find<SettingsScreenController>();
    final colors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = settingsController.pitchBlack.value;

    final backgroundColor = isPitchBlack
        ? (isDark ? Colors.black : Colors.white)
        : colors.grey6;

    final tileBackgroundColor = isPitchBlack
        ? (isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03))
        : colors.grey5;

    final textColor = colors.grey10;
    final currentPalette = MoodHelper.palettes[_selectedMoodIndex];
    final currentAccent = currentPalette.accentColor;
    final moodInfo = AppConstants.moods[_selectedMoodIndex];

    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.62,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            // Drag Handle
            Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 4.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.grey4,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Top Bar with Reset on left, title in center, Done on right
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _confirmReset(context, colors),
                    child: Text(
                      AppConstants.reset,
                      style: TextStyle(
                        color: colors.grey3,
                        fontSize: 16.sp,
                        fontFamily: AppConstants.font,
                      ),
                    ),
                  ),
                  Text(
                    AppConstants.moodColors,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.4,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppConstants.done,
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstants.font,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: colors.grey4.withOpacity(0.4), height: 1),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  children: [
                    // --- 1. Minimal Centered Preview (Mood SVG + Mood Label only) ---
                    SizedBox(height: 6.h),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 68.w,
                            height: 68.w,
                            child: Obx(() {
                              final rasterized = _homeController
                                  .moodImagesLarge[_selectedMoodIndex];
                              if (rasterized != null) {
                                return RawImage(
                                  image: rasterized,
                                  width: 68.w,
                                  height: 68.w,
                                  filterQuality: FilterQuality.medium,
                                );
                              }
                              return MoodHelper.buildMoodSvg(
                                _selectedMoodIndex,
                                width: 68.w,
                                height: 68.w,
                              );
                            }),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            moodInfo['label'] ?? '',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppConstants.font,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- 2. 7-Mood Segment Selector with Prominent Selected Indicator ---
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: tileBackgroundColor,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) {
                          final isSelected = index == _selectedMoodIndex;

                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _selectedMoodIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              curve: Curves.easeOut,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark
                                        ? Colors.white.withOpacity(0.16)
                                        : Colors.white)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: isSelected
                                      ? colors.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              isDark ? 0.3 : 0.08),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: SizedBox(
                                width: 28.w,
                                height: 28.w,
                                child: Obx(() {
                                  final rasterized =
                                      _homeController.moodImages[index];
                                  if (rasterized != null) {
                                    return RawImage(
                                      image: rasterized,
                                      width: 28.w,
                                      height: 28.w,
                                      filterQuality: FilterQuality.medium,
                                    );
                                  }
                                  return MoodHelper.buildMoodSvg(
                                    index,
                                    width: 28.w,
                                    height: 28.w,
                                  );
                                }),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // --- 3. Apple Colors Container (Exact same width & column alignment) ---
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: tileBackgroundColor,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _row1
                                .map((c) => _buildColorSwatch(c, currentAccent))
                                .toList(),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _row2
                                .map((c) => _buildColorSwatch(c, currentAccent))
                                .toList(),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _row3
                                .map((c) => _buildColorSwatch(c, currentAccent))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
