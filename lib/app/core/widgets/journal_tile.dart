import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:open_jot/app/modules/write_journal/write_journal_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';

import '../constants.dart';
import '../models/journal_entry.dart';
import '../theme.dart';

class JournalTile extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;

  const JournalTile({super.key, required this.entry, this.onTap});

  static const List<Map<String, String>> _moods = [
    {'svg': 'assets/1.svg', 'label': 'Very Unpleasant'},
    {'svg': 'assets/2.svg', 'label': 'Unpleasant'},
    {'svg': 'assets/3.svg', 'label': 'Neutral'},
    {'svg': 'assets/4.svg', 'label': 'Pleasant'},
    {'svg': 'assets/5.svg', 'label': 'Very Pleasant'},
  ];

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final plainText = entry.content.toPlainText().trim();
    final hasMedia =
        entry.galleryImages.isNotEmpty || entry.cameraPhotos.isNotEmpty;

    // OPTIMIZATION: Wrapping the entire tile in a RepaintBoundary.
    // This is highly effective for list items. It caches the rendered output of the tile,
    // so Flutter doesn't have to repaint its complex content during scrolling.
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: appThemeColors.grey6,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Media/Text Content Container
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasMedia) _buildMediaPreview(context),
                  if (plainText.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          10.w, hasMedia ? 10.h : 12.h, 10.w, 8.h),
                      child: Text(
                        plainText,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppConstants.font,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                          color: appThemeColors.grey1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            // Footer Container
                Container(
                  padding: EdgeInsetsGeometry.fromLTRB(2.w,4.h,2.w,0.h),
                  decoration: BoxDecoration(
                    color: appThemeColors.grey6,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: appThemeColors.grey5, // choose stroke color
                        width: 1, // stroke thickness
                      ),
                    ),
                  ),
                  child: _buildFooter(appThemeColors),
                ),

              ]),
        ),
      ),
    );
  }

  Widget _buildMediaPreview(BuildContext context) {
    final allImages = [...entry.galleryImages, ...entry.cameraPhotos];
    if (allImages.isEmpty) {
      return const SizedBox.shrink();
    }

    final double spacing = 2.w;
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor = (isDark ? appThemeColors.grey7 : appThemeColors.grey10)
        .withOpacity(0.6);
    final onOverlayColor =
        isDark ? appThemeColors.grey10 : appThemeColors.grey7;

    Widget buildImageContainer(dynamic image, {Widget? overlay}) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: appThemeColors.grey3, width: 1.w),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image is AssetEntity)
                SizedAssetThumbnail(asset: image)
              else if (image is CapturedPhoto)
                Image.file(File(image.file.path), fit: BoxFit.cover),
              if (overlay != null) overlay,
            ],
          ),
        ),
      );
    }

    Widget content;
    if (allImages.length == 1) {
      content = SizedBox(
        height: 250.h,
        width: double.infinity,
        child: buildImageContainer(allImages[0]),
      );
    } else if (allImages.length == 2) {
      content = SizedBox(
        height: 250.h,
        child: Row(
          children: [
            Expanded(child: buildImageContainer(allImages[0])),
            SizedBox(width: spacing),
            Expanded(child: buildImageContainer(allImages[1])),
          ],
        ),
      );
    } else {
      Widget? thirdImageOverlay;
      if (allImages.length > 3) {
        thirdImageOverlay = ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            color: overlayColor,
            child: Center(
              child: Text(
                '+${allImages.length - 3}',
                style: TextStyle(
                    color: onOverlayColor,
                    fontSize: 32.sp,
                    fontFamily: AppConstants.font,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
        );
      }

      content = SizedBox(
        height: 250.h,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: buildImageContainer(allImages[0]),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: buildImageContainer(allImages[1])),
                  SizedBox(height: spacing),
                  Expanded(
                    child: buildImageContainer(
                      allImages[2],
                      overlay: thirdImageOverlay,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return content;
  }

  Widget _buildFooter(AppThemeColors appThemeColors) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 8.h),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Text(
              DateFormat('h:mm a, MMM d').format(entry.createdAt),
              style: TextStyle(
                fontFamily: AppConstants.font,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: appThemeColors.grey3,
              ),
            ),
            VerticalDivider(
              color: appThemeColors.grey5,
              thickness: 1.w,
              width: 16.w, // spacing
            ),
            Row(
              children: [
                if (entry.moodIndex != null)
                  SvgPicture.asset(
                    _moods[entry.moodIndex!]['svg']!,
                    width: 20.w,
                    height: 20.h,
                  ),
                if (entry.isBookmarked)
                  Padding(
                    padding: EdgeInsets.only(left: entry.moodIndex != null ? 8.w : 0),
                    child: Icon(
                      Icons.bookmark_rounded,
                      color: appThemeColors.grey2,
                      size: 20.w,
                    ),
                  ),
              ],
            ),
          ],
        ),
      )

    );
  }
}
