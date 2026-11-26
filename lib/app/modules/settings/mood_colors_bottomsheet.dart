import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/widgets/app_alert_dialog.dart';
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
  late List<MoodPalette> _initialPalettes;
  late List<MoodPalette> _draftPalettes;
  final HomeController _homeController = Get.find<HomeController>();

  // Cached pre-rasterized images for 100% lag-free rendering
  final Map<int, ui.Image> _draftImagesSmall = {};
  final Map<int, ui.Image> _draftImagesLarge = {};

  bool _isSaving = false;

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
    _initialPalettes = List<MoodPalette>.from(MoodHelper.palettes);
    _draftPalettes = List<MoodPalette>.from(MoodHelper.palettes);

    // Seed immediately from HomeController's pre-rasterized caches (0ms overhead on open!)
    _draftImagesSmall.addAll(_homeController.moodImages);
    _draftImagesLarge.addAll(_homeController.moodImagesLarge);
  }

  bool get _hasUnsavedChanges {
    if (_isSaving) return false;
    for (int i = 0; i < _initialPalettes.length; i++) {
      if (_draftPalettes[i].accent.toUpperCase() !=
          _initialPalettes[i].accent.toUpperCase()) {
        return true;
      }
    }
    return false;
  }

  static Future<ui.Image> _renderPictureToImage(
      PictureInfo pictureInfo, double targetSize) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final scale = targetSize / pictureInfo.size.width;
    canvas.scale(scale);
    canvas.drawPicture(pictureInfo.picture);

    return recorder.endRecording().toImage(
          targetSize.toInt(),
          targetSize.toInt(),
        );
  }

  Future<void> _reRasterizeDraftMood(int moodIndex, MoodPalette palette) async {
    try {
      final svgString = MoodHelper.getSvgStringForPalette(moodIndex, palette);
      final loader = SvgStringLoader(svgString);
      final pictureInfo = await vg.loadPicture(loader, null);

      final small = await _renderPictureToImage(pictureInfo, 66.0);
      final large = await _renderPictureToImage(pictureInfo, 480.0);

      if (mounted) {
        setState(() {
          _draftImagesSmall[moodIndex] = small;
          _draftImagesLarge[moodIndex] = large;
        });
      }
    } catch (_) {}
  }

  Future<bool> _showUnsavedChangesDialog() async {
    final result = await showAppAlertDialog<String>(
      context: context,
      title: AppConstants.unsavedChanges,
      message:
          "You have unsaved mood color changes. Would you like to save them before closing?",
      actionsBuilder: (dialogContext) => [
        AppAlertAction(
          label: AppConstants.save,
          isDefault: true,
          onPressed: () => Navigator.pop(dialogContext, 'save'),
        ),
        AppAlertAction(
          label: AppConstants.discard,
          isDestructive: true,
          onPressed: () => Navigator.pop(dialogContext, 'discard'),
        ),
        AppAlertAction(
          label: AppConstants.cancel,
          onPressed: () => Navigator.pop(dialogContext, 'cancel'),
        ),
      ],
    );

    if (result == 'save') {
      _isSaving = true;
      HapticFeedback.mediumImpact();
      await MoodHelper.saveAllPalettes(_draftPalettes);
      return true;
    } else if (result == 'discard') {
      return true;
    } else {
      return false;
    }
  }

  void _confirmReset(BuildContext context, AppThemeColors colors) {
    showAppAlertDialog<void>(
      context: context,
      title: AppConstants.resetMoodColors,
      message: AppConstants.resetMoodColorsConfirm,
      actionsBuilder: (dialogContext) => [
        AppAlertAction(
          label: AppConstants.cancel,
          onPressed: () => Navigator.pop(dialogContext),
        ),
        AppAlertAction(
          label: AppConstants.reset,
          isDestructive: true,
          onPressed: () {
            Navigator.pop(dialogContext);
            HapticFeedback.mediumImpact();
            setState(() {
              _draftPalettes =
                  List<MoodPalette>.from(MoodHelper.defaultPalettes);
            });
            for (int i = 0; i < 7; i++) {
              _reRasterizeDraftMood(i, MoodHelper.defaultPalettes[i]);
            }
          },
        ),
      ],
    );
  }

  Future<void> _handleClose() async {
    if (!_hasUnsavedChanges) {
      Navigator.pop(context);
      return;
    }
    final shouldPop = await _showUnsavedChangesDialog();
    if (shouldPop && mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _saveAndClose() async {
    _isSaving = true;
    HapticFeedback.mediumImpact();
    await MoodHelper.saveAllPalettes(_draftPalettes);
    if (mounted) {
      Navigator.pop(context);
    }
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
      onTap: () {
        HapticFeedback.selectionClick();
        final newPalette = MoodHelper.createFromColor(color);
        setState(() {
          _draftPalettes[_selectedMoodIndex] = newPalette;
        });
        _reRasterizeDraftMood(_selectedMoodIndex, newPalette);
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
    final currentDraftPalette = _draftPalettes[_selectedMoodIndex];
    final currentAccent = currentDraftPalette.accentColor;
    final moodInfo = AppConstants.moods[_selectedMoodIndex];

    final largePreviewImage = _draftImagesLarge[_selectedMoodIndex];

    return WillPopScope(
      onWillPop: () async {
        if (!_hasUnsavedChanges) return true;
        return _showUnsavedChangesDialog();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: textColor,
            ),
            onPressed: _handleClose,
          ),
          title: Text(
            AppConstants.moodColors,
            style: TextStyle(
              color: textColor,
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                color: colors.grey2,
              ),
              tooltip: AppConstants.reset,
              onPressed: () => _confirmReset(context, colors),
            ),
            TextButton(
              onPressed: _saveAndClose,
              child: Text(
                AppConstants.save,
                style: TextStyle(
                  color: colors.primary,
                  fontFamily: AppConstants.font,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - 40.h).clamp(0.0, double.infinity),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      // --- 1. Minimal Centered Preview (Mood SVG + Mood Label only) ---
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 68.w,
                              height: 68.w,
                              child: largePreviewImage != null
                                  ? RawImage(
                                      image: largePreviewImage,
                                      width: 68.w,
                                      height: 68.w,
                                      filterQuality: FilterQuality.medium,
                                    )
                                  : MoodHelper.buildMoodSvgForPalette(
                                      _selectedMoodIndex,
                                      currentDraftPalette,
                                      width: 68.w,
                                      height: 68.w,
                                    ),
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
                            final smallImage = _draftImagesSmall[index];

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
                                  child: smallImage != null
                                      ? RawImage(
                                          image: smallImage,
                                          width: 28.w,
                                          height: 28.w,
                                          filterQuality: FilterQuality.medium,
                                        )
                                      : MoodHelper.buildMoodSvgForPalette(
                                          index,
                                          _draftPalettes[index],
                                          width: 28.w,
                                          height: 28.w,
                                        ),
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
                                  .map((c) =>
                                      _buildColorSwatch(c, currentAccent))
                                  .toList(),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _row2
                                  .map((c) =>
                                      _buildColorSwatch(c, currentAccent))
                                  .toList(),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _row3
                                  .map((c) =>
                                      _buildColorSwatch(c, currentAccent))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
}
