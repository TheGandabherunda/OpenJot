import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/write_journal/write_journal_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants.dart';
import '../../core/models/journal_entry.dart';
import '../../core/theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/journal_tile.dart';
import '../../utils/custom_toast.dart';
import '../media_preview/media_preview_bottom_sheet.dart';
import '../../core/services/hive_service.dart';

class ReadJournalBottomSheet extends StatefulWidget {
  final JournalEntry entry;

  const ReadJournalBottomSheet({super.key, required this.entry});

  @override
  ReadJournalBottomSheetState createState() => ReadJournalBottomSheetState();
}

class ReadJournalBottomSheetState extends State<ReadJournalBottomSheet> {
  late JournalEntry _currentEntry;
  late quill.QuillController _quillController;

  static const List<Map<String, String>> _moods = AppConstants.moods;

  @override
  void initState() {
    super.initState();
    _currentEntry = widget.entry;
    _initializeController();
  }

  void _initializeController() {
    final document =
    quill.Document.fromJson(_currentEntry.content.toDelta().toJson());
    _quillController = quill.QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  void _onEditPressed() async {
    final homeController = Get.find<HomeController>();
    // Find the most current version of the entry before editing.
    final entryToEdit = homeController.journalEntries
        .firstWhereOrNull((e) => e.id == _currentEntry.id);

    // If the entry is somehow gone before we even edit, just close.
    if (entryToEdit == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final wasDeleted = await showCupertinoModalBottomSheet<bool>(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: WriteJournalBottomSheet(entry: entryToEdit),
      ),
    );

    // If the edit sheet returns true, it means the entry was cleared and is now deleted.
    if (wasDeleted == true && mounted) {
      Navigator.of(context).pop();
      return;
    }

    // After the edit sheet closes, refresh the data from the controller.
    if (mounted) {
      // Find the latest version of the entry from the controller's list.
      final latestEntry = homeController.journalEntries
          .firstWhereOrNull((e) => e.id == widget.entry.id);

      if (latestEntry != null) {
        // If the entry still exists, update the state to reflect the changes.
        setState(() {
          _currentEntry = latestEntry;
          _quillController.dispose();
          _initializeController();
        });
      } else {
        // If it's null, it was deleted, so close the read sheet.
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _launchLocationLink() async {
    if (_currentEntry.location != null) {
      final Uri uri = Uri.parse(_currentEntry.location!.link);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (!mounted) return;
        CustomToast.showToast(
          AppConstants.couldNotOpenMap,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
        );
      }
    }
  }

  bool _isVideoFile(String path) {
    final lowercasedPath = path.toLowerCase();
    return lowercasedPath.endsWith('.mp4') ||
        lowercasedPath.endsWith('.mov') ||
        lowercasedPath.endsWith('.avi') ||
        lowercasedPath.endsWith('.wmv') ||
        lowercasedPath.endsWith('.mkv');
  }

  List<MediaItem> _getAllMediaItems() {
    final items = <MediaItem>[];
    for (final asset in _currentEntry.galleryImages) {
      items.add(MediaItem(asset: asset, type: asset.type, id: asset.id));
    }
    for (final photo in _currentEntry.cameraPhotos) {
      items.add(MediaItem(
        asset: photo,
        type: _isVideoFile(photo.file.path) ? AssetType.video : AssetType.image,
        id: photo.file.path,
      ));
    }
    for (final audio in _currentEntry.galleryAudios) {
      items.add(MediaItem(asset: audio, type: AssetType.audio, id: audio.id));
    }
    for (final rec in _currentEntry.recordings) {
      items.add(MediaItem(
        asset: CapturedPhoto(file: XFile(rec.path), name: rec.name),
        type: AssetType.audio,
        id: rec.path,
      ));
    }
    return items;
  }

  void _openMediaPreview(int initialIndex) {
    final mediaItems = _getAllMediaItems();
    if (mediaItems.isEmpty) return;

    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MediaPreviewBottomSheet(
        mediaItems: mediaItems,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hiveService = Get.find<HiveService>();
    final isPitchBlack = hiveService.pitchBlack;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appThemeColors = AppTheme.colorsOf(context);

    final backgroundColor = isPitchBlack
        ? (isDark ? Colors.black : Colors.white)
        : appThemeColors.grey6;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: _buildHeader(appThemeColors),
        titleSpacing: 16.w,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildImagePreview(),
                  if ((_currentEntry.galleryImages.isNotEmpty ||
                      _currentEntry.cameraPhotos.isNotEmpty) &&
                      _currentEntry.galleryAudios.isNotEmpty)
                    SizedBox(height: 2.h),
                  _buildAudioPreview(),
                  if ((_currentEntry.galleryImages.isNotEmpty ||
                      _currentEntry.cameraPhotos.isNotEmpty ||
                      _currentEntry.galleryAudios.isNotEmpty) &&
                      _currentEntry.recordings.isNotEmpty)
                    SizedBox(height: 2.h),
                  _buildRecordingsPreview(),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _buildMoodField(appThemeColors),
            SizedBox(height: 16.h),
            _buildTextField(appThemeColors),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppThemeColors appThemeColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          _currentEntry.isBookmarked
              ? Icons.bookmark_rounded
              : Icons.bookmark_outline_rounded,
          color: _currentEntry.isBookmarked
              ? appThemeColors.primary
              : appThemeColors.grey2,
          size: 28.w,
        ),
        Text(
          DateFormat('EEEE, MMM d').format(_currentEntry.createdAt),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppConstants.font,
            decoration: TextDecoration.none,
            color: appThemeColors.grey10.withAlpha((255 * 0.6).round()),
          ),
        ),
        CustomButton(
          onPressed: _onEditPressed,
          text: AppConstants.edit,
          color: Colors.transparent,
          textColor: appThemeColors.grey10,
          textSize: 16.sp,
          textPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    final allMedia = [
      ..._currentEntry.galleryImages,
      ..._currentEntry.cameraPhotos
    ];
    if (allMedia.isEmpty) {
      return const SizedBox.shrink();
    }
    final double spacing = 2.w;
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor = (isDark ? appThemeColors.grey7 : appThemeColors.grey10)
        .withOpacity(0.6);
    final onOverlayColor =
    isDark ? appThemeColors.grey10 : appThemeColors.grey7;

    Widget buildMediaContainer(dynamic media,
        {Widget? overlay, required VoidCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: appThemeColors.grey3, width: 1.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.5.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                MediaThumbnail(media: media),
                if (overlay != null) overlay,
              ],
            ),
          ),
        ),
      );
    }

    Widget content;
    if (allMedia.length == 1) {
      content = SizedBox(
        height: 250.h,
        width: double.infinity,
        child: buildMediaContainer(
          allMedia[0],
          onTap: () => _openMediaPreview(0),
        ),
      );
    } else if (allMedia.length == 2) {
      content = SizedBox(
        height: 250.h,
        child: Row(
          children: [
            Expanded(
              child: buildMediaContainer(
                allMedia[0],
                onTap: () => _openMediaPreview(0),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: buildMediaContainer(
                allMedia[1],
                onTap: () => _openMediaPreview(1),
              ),
            ),
          ],
        ),
      );
    } else {
      Widget? thirdImageOverlay;
      if (allMedia.length > 3) {
        thirdImageOverlay = GestureDetector(
          onTap: () => _openMediaPreview(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.5.r),
            child: ui.BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: overlayColor,
                child: Center(
                  child: Text(
                    '+${allMedia.length - 3}',
                    style: TextStyle(
                        color: onOverlayColor,
                        fontSize: 32.sp,
                        fontFamily: AppConstants.font,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none),
                  ),
                ),
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
              child: buildMediaContainer(
                allMedia[0],
                onTap: () => _openMediaPreview(0),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: buildMediaContainer(
                      allMedia[1],
                      onTap: () => _openMediaPreview(1),
                    ),
                  ),
                  SizedBox(height: spacing),
                  Expanded(
                    child: buildMediaContainer(
                      allMedia[2],
                      overlay: thirdImageOverlay,
                      onTap: () => _openMediaPreview(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
      child: content,
    );
  }

  Widget _buildAudioPreview() {
    if (_currentEntry.galleryAudios.isEmpty) {
      return const SizedBox.shrink();
    }
    final appThemeColors = AppTheme.colorsOf(context);
    final baseIndex = _currentEntry.galleryImages.length + _currentEntry.cameraPhotos.length;

    return Column(
      children: _currentEntry.galleryAudios.asMap().entries.map((entry) {
        final index = entry.key;
        final audio = entry.value;
        final globalIndex = baseIndex + index;

        return Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: GestureDetector(
            onTap: () => _openMediaPreview(globalIndex),
            child: Container(
              height: 50.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: appThemeColors.grey4,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.music_note_rounded,
                    color: appThemeColors.grey1,
                    size: 28.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      audio.title ?? AppConstants.audioTrack,
                      style: TextStyle(
                        color: appThemeColors.grey10,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: AppConstants.font,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatPreviewDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildRecordingsPreview() {
    if (_currentEntry.recordings.isEmpty) {
      return const SizedBox.shrink();
    }
    final appThemeColors = AppTheme.colorsOf(context);
    final baseIndex = _currentEntry.galleryImages.length +
        _currentEntry.cameraPhotos.length +
        _currentEntry.galleryAudios.length;

    return Column(
      children: _currentEntry.recordings.asMap().entries.map((entry) {
        final index = entry.key;
        final recording = entry.value;
        final globalIndex = baseIndex + index;

        return Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: GestureDetector(
            onTap: () => _openMediaPreview(globalIndex),
            child: Container(
              height: 50.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: appThemeColors.grey4,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.music_note_rounded,
                    color: appThemeColors.grey1,
                    size: 28.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recording.name,
                          style: TextStyle(
                            color: appThemeColors.grey10,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: AppConstants.font,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          _formatPreviewDuration(recording.duration),
                          style: TextStyle(
                            color: appThemeColors.grey1,
                            fontSize: 12.sp,
                            decoration: TextDecoration.none,
                            fontFamily: AppConstants.font,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMoodField(AppThemeColors appThemeColors) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _currentEntry.tags.map((tag) => Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppTheme.getTagBaseColor(tag, Theme.of(context).brightness),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: AppTheme.getTagLightColor(tag, Theme.of(context).brightness),
                          fontSize: 12.sp,
                          fontFamily: AppConstants.font,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_currentEntry.location != null)
                  GestureDetector(
                    onTap: _launchLocationLink,
                    child: Container(
                      height: 38.w,
                      padding: EdgeInsets.only(right: 12.w, left: 8.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: appThemeColors.grey3,
                            size: 20.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '${_currentEntry.location!.coordinates.latitude.toStringAsFixed(4)}, ${_currentEntry.location!.coordinates.longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                              color: appThemeColors.grey1,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                              fontFamily: AppConstants.font,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_currentEntry.moodIndex != null)
                  Padding(
                    padding: EdgeInsets.only(right: 12.w, left: 12.w),
                    child: Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: appThemeColors.grey6,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Obx(() {
                          final HomeController controller = Get.find();
                          final rasterizedImage = controller.moodImages[_currentEntry.moodIndex!];
                          if (rasterizedImage != null) {
                            return RawImage(
                              image: rasterizedImage,
                              width: 28.w,
                              height: 28.h,
                              filterQuality: ui.FilterQuality.high,
                            );
                          }
                          return SvgPicture.asset(
                            _moods[_currentEntry.moodIndex!]['svg']!,
                            width: 28.w,
                            height: 28.h,
                          );
                        }),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(AppThemeColors appThemeColors) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: IgnorePointer(
          child: quill.QuillEditor.basic(
            controller: _quillController,
            focusNode: FocusNode(),
            config: quill.QuillEditorConfig(
              autoFocus: false,
              expands: false,
              padding: EdgeInsets.zero,
              customStyles: quill.DefaultStyles(
                paragraph: quill.DefaultTextBlockStyle(
                  TextStyle(
                    fontSize: 16.sp,
                    color: appThemeColors.grey10,
                    height: 1.5,
                  ),
                  quill.HorizontalSpacing.zero,
                  quill.VerticalSpacing.zero,
                  quill.VerticalSpacing.zero,
                  null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper extension to find an item in a list safely without throwing an error.
extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}