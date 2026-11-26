import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/models/journal_entry.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/widgets/journal_audio_card.dart';
import 'package:open_jot/app/core/widgets/journal_tile.dart';
import 'package:open_jot/app/core/widgets/location_card_content.dart';
import 'package:open_jot/app/core/widgets/location_map_view.dart';
import 'package:open_jot/app/core/widgets/write_journal_toolbar_content.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/utils/mood_helper.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;

/// Renders the mood preview box used in the home feed tiles as well as the
/// read and write bottom sheets.
class JournalMoodCardContent extends StatelessWidget {
  final int moodIndex;
  final bool compact;

  const JournalMoodCardContent({
    super.key,
    required this.moodIndex,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final homeController = Get.find<HomeController>();
    final moodColors = MoodHelper.getMoodThemeColors(
      moodIndex,
      appThemeColors,
      isDark,
    );
    final label = AppConstants.moods[moodIndex]['label'] ?? '';
    final iconSize = compact ? 44.w : 60.w;

    final iconWidget = Obx(() {
      final rasterized = homeController.moodImagesLarge[moodIndex] ??
          homeController.moodImages[moodIndex];
      if (rasterized != null) {
        return RawImage(
          image: rasterized,
          width: iconSize,
          height: iconSize,
          filterQuality: ui.FilterQuality.high,
        );
      }
      return RepaintBoundary(
        child: MoodHelper.buildMoodSvg(
          moodIndex,
          width: iconSize,
          height: iconSize,
        ),
      );
    });

    final decoration = MoodHelper.buildMoodWashDecoration(
      moodColors[0],
      moodColors[1],
      moodColors[2],
      isDark: isDark,
      center: compact ? Alignment.center : const Alignment(0, -0.15),
    );

    if (compact) {
      return Container(
        decoration: decoration,
        child: Center(child: iconWidget),
      );
    }

    return Container(
      decoration: decoration,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            if (label.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  color: moodColors[0],
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Unified Apple Journal-style card grid for media, location, mood, and audio.
/// Every item count shares the exact same 2:1 container height:
/// - 1 item: single full-width card
/// - 2 items: two equal 1:1 squares
/// - 3–4 items: left hero card + 2 stacked 1:1 right squares (+1 badge on 4)
/// - 5+ items: left 1:1 hero square + 2x2 stacked 1:1 right squares
class JournalCardGrid extends StatelessWidget {
  final List<dynamic> mediaItems;
  final SelectedLocation? location;
  final int? moodIndex;
  final List<AssetEntity> galleryAudios;
  final List<RecordedAudio> recordings;
  final ValueChanged<int>? onCardTap;
  final ValueChanged<int>? onRemoveCard;

  const JournalCardGrid({
    super.key,
    required this.mediaItems,
    this.location,
    this.moodIndex,
    this.galleryAudios = const [],
    this.recordings = const [],
    this.onCardTap,
    this.onRemoveCard,
  });

  @override
  Widget build(BuildContext context) {
    final hasLocation = location != null;
    final hasMood = moodIndex != null;
    final int totalCards = mediaItems.length +
        (hasLocation ? 1 : 0) +
        (hasMood ? 1 : 0) +
        galleryAudios.length +
        recordings.length;

    if (totalCards == 0) {
      return const SizedBox.shrink();
    }

    final spacing = 2.w;
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor =
        (isDark ? appThemeColors.grey7 : appThemeColors.grey10)
            .withOpacity(0.6);
    final onOverlayColor =
        isDark ? appThemeColors.grey10 : appThemeColors.grey7;

    Widget buildCardContentAt(int index, {bool compact = false}) {
      if (index < mediaItems.length) {
        return MediaThumbnail(media: mediaItems[index]);
      }
      var remaining = index - mediaItems.length;
      if (hasLocation) {
        if (remaining == 0) {
          return LocationCardContent(
            coordinates: location!.coordinates,
            compact: compact,
          );
        }
        remaining--;
      }
      if (hasMood) {
        if (remaining == 0) {
          return JournalMoodCardContent(
            moodIndex: moodIndex!,
            compact: compact,
          );
        }
        remaining--;
      }
      if (remaining < galleryAudios.length) {
        final audio = galleryAudios[remaining];
        return JournalMusicCardContent(
          title: audio.title ?? AppConstants.audioTrack,
          duration: Duration(seconds: audio.duration),
          compact: compact,
        );
      }
      remaining -= galleryAudios.length;
      final rec = recordings[remaining];
      if (rec.isVoiceRecording) {
        return JournalRecordingCardContent(
          title: rec.name,
          duration: rec.duration,
          filePath: rec.path,
          compact: compact,
        );
      }
      return JournalMusicCardContent(
        title: rec.name,
        duration: rec.duration,
        compact: compact,
      );
    }

    Widget buildCardAt(int index, {Widget? overlay, bool compact = false}) {
      final card = ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            buildCardContentAt(index, compact: compact),
            if (overlay != null) overlay,
            if (onRemoveCard != null && overlay == null)
              Positioned(
                top: 4.w,
                right: 4.w,
                child: GestureDetector(
                  onTap: () => onRemoveCard!(index),
                  child: Container(
                    padding: EdgeInsets.all(compact ? 3 : 4),
                    decoration: BoxDecoration(
                      color: overlayColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: onOverlayColor,
                      size: compact ? 12.sp : 18.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );

      if (onCardTap == null) return card;
      return GestureDetector(
        onTap: () => onCardTap!(index),
        child: card,
      );
    }

    Widget buildCountOverlay(int extraCount, {bool compactBadge = false}) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          color: overlayColor,
          child: Center(
            child: Text(
              '+$extraCount',
              style: TextStyle(
                color: onOverlayColor,
                fontSize: compactBadge ? 22.sp : 28.sp,
                fontFamily: AppConstants.font,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      );
    }

    Widget buildStackedColumn(
      int topIndex,
      int bottomIndex, {
      Widget? bottomOverlay,
    }) {
      return Column(
        children: [
          Expanded(child: buildCardAt(topIndex, compact: true)),
          SizedBox(height: spacing),
          Expanded(
            child: buildCardAt(
              bottomIndex,
              overlay: bottomOverlay,
              compact: true,
            ),
          ),
        ],
      );
    }

    final Widget gridContent;

    if (totalCards == 1) {
      gridContent = buildCardAt(0);
    } else if (totalCards == 2) {
      gridContent = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: buildCardAt(0)),
          SizedBox(width: spacing),
          Expanded(child: buildCardAt(1)),
        ],
      );
    } else if (totalCards <= 4) {
      gridContent = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: buildCardAt(0),
          ),
          SizedBox(width: spacing),
          Expanded(
            flex: 1,
            child: buildStackedColumn(
              1,
              2,
              bottomOverlay: totalCards > 3
                  ? buildCountOverlay(totalCards - 3, compactBadge: true)
                  : null,
            ),
          ),
        ],
      );
    } else {
      gridContent = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: buildCardAt(0),
          ),
          SizedBox(width: spacing),
          Expanded(
            flex: 1,
            child: buildStackedColumn(1, 2),
          ),
          SizedBox(width: spacing),
          Expanded(
            flex: 1,
            child: buildStackedColumn(
              3,
              4,
              bottomOverlay: totalCards > 5
                  ? buildCountOverlay(totalCards - 5, compactBadge: true)
                  : null,
            ),
          ),
        ],
      );
    }

    return AspectRatio(
      aspectRatio: 2.0,
      child: gridContent,
    );
  }
}

/// Opens the standalone location picker modal and returns a [SelectedLocation]
/// when the user confirms a pin.
Future<SelectedLocation?> showLocationPickerModal(
  BuildContext context, {
  LatLng? initialLocation,
}) async {
  final colors = AppTheme.colorsOf(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final isPitchBlack = Get.find<HiveService>().pitchBlack;
  final sheetColor =
      isPitchBlack ? (isDark ? Colors.black : Colors.white) : colors.grey6;
  final scrollController = ScrollController();

  final picked = await showCupertinoModalBottomSheet<SelectedLocation>(
    context: context,
    expand: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) => SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: sheetColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.close_rounded, color: colors.grey10),
            onPressed: () => Navigator.of(modalContext).pop(),
          ),
          title: Text(
            'Location',
            style: TextStyle(
              color: colors.grey10,
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
            ),
          ),
        ),
        body: LocationMapView(
          scrollController: scrollController,
          initialLocation: initialLocation,
          onLocationSelected: (coords) {
            final link =
                'geo:${coords.latitude},${coords.longitude}?q=${coords.latitude},${coords.longitude}';
            Navigator.of(modalContext).pop(
              SelectedLocation(coordinates: coords, link: link),
            );
          },
        ),
      ),
    ),
  );

  scrollController.dispose();
  return picked;
}

/// Opens the standalone mood selector modal and returns the confirmed mood
/// index, or `null` if cancelled or cleared.
Future<int?> showMoodPickerModal(
  BuildContext context, {
  int? initialMoodIndex,
}) async {
  final colors = AppTheme.colorsOf(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final isPitchBlack = Get.find<HiveService>().pitchBlack;
  final sheetColor =
      isPitchBlack ? (isDark ? Colors.black : Colors.white) : colors.grey6;
  final scrollController = ScrollController();
  int selectedMood = initialMoodIndex ?? 3;

  final result = await showCupertinoModalBottomSheet<int>(
    context: context,
    expand: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) => SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: sheetColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.close_rounded, color: colors.grey10),
            onPressed: () => Navigator.of(modalContext).pop(),
          ),
          title: Text(
            'State of Mind',
            style: TextStyle(
              color: colors.grey10,
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(modalContext).pop(selectedMood),
              child: Text(
                AppConstants.done,
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
        body: MoodSelectorView(
          scrollController: scrollController,
          initialMoodIndex: initialMoodIndex,
          isPitchBlack: isPitchBlack,
          onMoodChanged: (index) {
            if (index != null) {
              selectedMood = index;
            } else {
              Navigator.of(modalContext).pop();
            }
          },
        ),
      ),
    ),
  );

  scrollController.dispose();
  return result;
}
