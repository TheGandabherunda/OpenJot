import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/write_journal/write_journal_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../constants.dart';
import '../models/journal_entry.dart';
import '../theme.dart';

class JournalTile extends StatefulWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? dividerColor;
  final Color? popupDividerColor;
  final Color? footerTextColor;
  final Color? reflectionBackground;
  final Color? bookmarkColor;

  const JournalTile({
    super.key,
    required this.entry,
    this.onTap,
    this.backgroundColor,
    this.bookmarkColor,
    this.reflectionBackground,
    this.footerTextColor,
    this.dividerColor,
    this.popupDividerColor,
  });

  @override
  State<JournalTile> createState() => _JournalTileState();
}

class _JournalTileState extends State<JournalTile> {
  final GlobalKey _menuKey = GlobalKey();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingPath;
  PlayerState? _playerState;
  StreamSubscription? _playerStateSubscription;

  static const List<Map<String, String>> _moods = [
    {'svg': 'assets/1.svg', 'label': 'Very Unpleasant'},
    {'svg': 'assets/2.svg', 'label': 'Unpleasant'},
    {'svg': 'assets/3.svg', 'label': 'Neutral'},
    {'svg': 'assets/4.svg', 'label': 'Pleasant'},
    {'svg': 'assets/5.svg', 'label': 'Very Pleasant'},
  ];

  @override
  void initState() {
    super.initState();
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
          if (mounted) {
            setState(() {
              _playerState = state;
              if (state == PlayerState.completed) {
                _currentlyPlayingPath = null;
              }
            });
          }
        });
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onEditPressed() {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: WriteJournalBottomSheet(entry: widget.entry),
      ),
    );
  }

  void _onSharePressed() async {
    final plainText = widget.entry.content.toPlainText().trim();
    final galleryFileFutures =
    widget.entry.galleryImages.map((asset) => asset.file).toList();
    final galleryFiles = await Future.wait(galleryFileFutures);
    final List<String> imagePaths = [];

    for (final file in galleryFiles) {
      if (file != null) {
        imagePaths.add(file.path);
      }
    }

    for (final photo in widget.entry.cameraPhotos) {
      imagePaths.add(photo.file.path);
    }

    if (imagePaths.isNotEmpty) {
      final imageXFiles = imagePaths.map((path) => XFile(path)).toList();
      await Share.shareXFiles(imageXFiles,
          text: plainText.isNotEmpty ? plainText : null);
    } else if (plainText.isNotEmpty) {
      await Share.share(plainText);
    }
  }

  void _onDeletePressed() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text('Please Confirm'),
          content: const Text(
              'Are you sure you want to delete this journal entry? This action is irreversible.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              isDefaultAction: false,
              isDestructiveAction: false,
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Get.find<HomeController>().deleteJournalEntry(widget.entry.id);
                Navigator.of(ctx).pop();
              },
              isDefaultAction: true,
              isDestructiveAction: true,
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final plainText = widget.entry.content.toPlainText().trim();
    final hasMedia = widget.entry.galleryImages.isNotEmpty ||
        widget.entry.cameraPhotos.isNotEmpty;
    final hasAudio = widget.entry.galleryAudios.isNotEmpty ||
        widget.entry.recordings.isNotEmpty;
    final tileColor = widget.backgroundColor ?? appThemeColors.grey6;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasMedia)
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w,
                          (plainText.isNotEmpty || hasAudio) ? 8.h : 0.h),
                      child: _buildMediaPreview(context),
                    ),
                  if (hasAudio)
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: plainText.isNotEmpty ? 8.h : 0),
                      child: _buildAudioPreviews(),
                    ),
                  if (plainText.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.w,
                          (hasMedia || hasAudio) ? 2.h : 12.h, 10.w, 8.h),
                      child: Text(
                        plainText,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppConstants.font,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: appThemeColors.grey10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsetsGeometry.fromLTRB(2.w, 4.h, 2.w, 0.h),
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                border: Border(
                  top: BorderSide(
                    color: widget.dividerColor ?? appThemeColors.grey5,
                    width: 1,
                  ),
                ),
              ),
              child: _buildFooter(appThemeColors, context),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildMediaPreview(BuildContext context) {
    final allMedia = [
      ...widget.entry.galleryImages,
      ...widget.entry.cameraPhotos
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

    Widget buildMediaContainer(dynamic media, {Widget? overlay}) {
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
              MediaThumbnail(media: media),
              if (overlay != null) overlay,
            ],
          ),
        ),
      );
    }

    Widget content;
    if (allMedia.length == 1) {
      content = SizedBox(
        height: 250.h,
        width: double.infinity,
        child: buildMediaContainer(allMedia[0]),
      );
    } else if (allMedia.length == 2) {
      content = SizedBox(
        height: 250.h,
        child: Row(
          children: [
            Expanded(child: buildMediaContainer(allMedia[0])),
            SizedBox(width: spacing),
            Expanded(child: buildMediaContainer(allMedia[1])),
          ],
        ),
      );
    } else {
      Widget? thirdImageOverlay;
      if (allMedia.length > 3) {
        thirdImageOverlay = ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
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
        );
      }

      content = SizedBox(
        height: 250.h,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: buildMediaContainer(allMedia[0]),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: buildMediaContainer(allMedia[1])),
                  SizedBox(height: spacing),
                  Expanded(
                    child: buildMediaContainer(
                      allMedia[2],
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

  Widget _buildAudioPreviews() {
    return Column(
      children: [
        _buildGalleryAudioPreview(),
        _buildRecordingsPreview(),
      ],
    );
  }

  String _formatPreviewDuration(Duration duration) {
    if (duration == Duration.zero) {
      return '--:--';
    }
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildGalleryAudioPreview() {
    if (widget.entry.galleryAudios.isEmpty) {
      return const SizedBox.shrink();
    }
    final appThemeColors = AppTheme.colorsOf(context);
    return Column(
      children: widget.entry.galleryAudios.map((audio) {
        return Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Container(
            height: 40.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: appThemeColors.grey5,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Icons.music_note_rounded,
                    color: appThemeColors.grey1, size: 24.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    audio.title ?? 'Audio track',
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
        );
      }).toList(),
    );
  }

  Widget _buildRecordingsPreview() {
    if (widget.entry.recordings.isEmpty) {
      return const SizedBox.shrink();
    }
    final appThemeColors = AppTheme.colorsOf(context);
    return Column(
      children: widget.entry.recordings.map((recording) {
        final isPlaying = _currentlyPlayingPath == recording.path &&
            _playerState == PlayerState.playing;
        final isPaused = _currentlyPlayingPath == recording.path &&
            _playerState == PlayerState.paused;
        return Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Container(
            height: 50.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: appThemeColors.grey5,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    color: appThemeColors.grey1,
                    size: 28.sp,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await _audioPlayer.pause();
                    } else if (isPaused) {
                      await _audioPlayer.resume();
                    } else {
                      await _audioPlayer.play(DeviceFileSource(recording.path));
                      setState(() {
                        _currentlyPlayingPath = recording.path;
                      });
                    }
                  },
                ),
                SizedBox(width: 4.w),
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
        );
      }).toList(),
    );
  }

  Widget _buildFooter(AppThemeColors appThemeColors, BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 8.h),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    DateFormat('MMM d  •  h:mm a')
                        .format(widget.entry.createdAt),
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: widget.footerTextColor ?? appThemeColors.grey3,
                    ),
                  ),
                  VerticalDivider(
                    color: widget.dividerColor ?? appThemeColors.grey5,
                    thickness: 1.w,
                    width: 16.w,
                  ),
                  Row(
                    children: [
                      if (widget.entry.isReflection)
                        Container(
                          margin: EdgeInsets.only(
                              right: widget.entry.moodIndex != null ? 8.w : 0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: widget.reflectionBackground ??
                                appThemeColors.grey5,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Text(
                            'Reflection',
                            style: TextStyle(
                              color: appThemeColors.grey10,
                              fontSize: 12.sp,
                              fontFamily: AppConstants.font,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (widget.entry.moodIndex != null)
                        SvgPicture.asset(
                          _moods[widget.entry.moodIndex!]['svg']!,
                          width: 22.w,
                          height: 22.h,
                        ),
                      if (widget.entry.isBookmarked)
                        Padding(
                          padding: EdgeInsets.only(
                              left: widget.entry.moodIndex != null ||
                                  widget.entry.isReflection
                                  ? 8.w
                                  : 0),
                          child: Icon(
                            Icons.bookmark_rounded,
                            color: appThemeColors.grey2,
                            size: 22.w,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                key: _menuKey,
                onTap: () {
                  final RenderBox renderBox =
                  _menuKey.currentContext!.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  showMenu<String>(
                    context: context,
                    color: appThemeColors.grey5,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    position: RelativeRect.fromLTRB(
                      position.dx - renderBox.size.width * 2,
                      position.dy + renderBox.size.height,
                      position.dx,
                      position.dy + renderBox.size.height * 2,
                    ),
                    items: [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: appThemeColors.grey10),
                            SizedBox(width: 8.w),
                            Text('Edit',
                                style: TextStyle(color: appThemeColors.grey10)),
                          ],
                        ),
                      ),
                      PopupMenuDivider(
                          height: 1,
                          color:
                          widget.popupDividerColor ?? appThemeColors.grey6),
                      PopupMenuItem(
                        value: 'bookmark',
                        child: Row(
                          children: [
                            Icon(
                              widget.entry.isBookmarked
                                  ? Icons.bookmark_remove_rounded
                                  : Icons.bookmark_add_outlined,
                              color: appThemeColors.grey10,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              widget.entry.isBookmarked
                                  ? 'Remove Bookmark'
                                  : 'Bookmark',
                              style: TextStyle(color: appThemeColors.grey10),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuDivider(
                          height: 1,
                          color:
                          widget.popupDividerColor ?? appThemeColors.grey6),
                      PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share_outlined,
                                color: appThemeColors.grey10),
                            SizedBox(width: 8.w),
                            Text('Share',
                                style: TextStyle(color: appThemeColors.grey10)),
                          ],
                        ),
                      ),
                      PopupMenuDivider(
                          height: 1,
                          color:
                          widget.popupDividerColor ?? appThemeColors.grey6),
                      PopupMenuItem(
                        value: 'pdf',
                        child: Row(
                          children: [
                            Icon(Icons.save_outlined,
                                color: appThemeColors.grey10),
                            SizedBox(width: 8.w),
                            Text('Save as PDF',
                                style: TextStyle(color: appThemeColors.grey10)),
                          ],
                        ),
                      ),
                      PopupMenuDivider(
                          height: 1,
                          color:
                          widget.popupDividerColor ?? appThemeColors.grey6),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_outlined,
                                color: appThemeColors.error),
                            SizedBox(width: 8.w),
                            Text('Delete',
                                style: TextStyle(color: appThemeColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ).then((value) {
                    if (value == 'edit') {
                      _onEditPressed();
                    } else if (value == 'bookmark') {
                      Get.find<HomeController>()
                          .toggleBookmarkStatus(widget.entry.id);
                    } else if (value == 'share') {
                      _onSharePressed();
                    } else if (value == 'pdf') {
                      // Handle Save as PDF
                    } else if (value == 'delete') {
                      _onDeletePressed();
                    }
                  });
                },
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: appThemeColors.grey1,
                  size: 28.w,
                ),
              ),
            ],
          ),
        ));
  }
}

// *** NEW: Unified thumbnail widget for all media types ***
class MediaThumbnail extends StatefulWidget {
  final dynamic media; // Can be AssetEntity or CapturedPhoto

  const MediaThumbnail({super.key, required this.media});

  @override
  State<MediaThumbnail> createState() => _MediaThumbnailState();
}

class _MediaThumbnailState extends State<MediaThumbnail> {
  Uint8List? _thumbnailData;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(covariant MediaThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    dynamic oldId = oldWidget.media is AssetEntity
        ? oldWidget.media.id
        : oldWidget.media.file.path;
    dynamic newId =
    widget.media is AssetEntity ? widget.media.id : widget.media.file.path;

    if (oldId != newId) {
      _thumbnailData = null; // Invalidate old data
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    if (!mounted) return;

    Uint8List? data;
    const thumbnailSize = ThumbnailSize(500, 500);
    const quality = 95;

    if (widget.media is AssetEntity) {
      final asset = widget.media as AssetEntity;
      _isVideo = asset.type == AssetType.video;
      data = await asset.thumbnailDataWithSize(thumbnailSize, quality: quality);
    } else if (widget.media is CapturedPhoto) {
      final photo = widget.media as CapturedPhoto;
      final path = photo.file.path;
      _isVideo = _isVideoFile(path);
      if (_isVideo) {
        data = await VideoThumbnail.thumbnailData(
          video: path,
          maxWidth: thumbnailSize.width,
          quality: quality,
        );
      } else {
        // For local image files, we can read them directly.
        data = await File(path).readAsBytes();
      }
    }

    if (mounted) {
      setState(() {
        _thumbnailData = data;
      });
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

  @override
  Widget build(BuildContext context) {
    if (_thumbnailData != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(
            _thumbnailData!,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
          if (_isVideo)
            Center(
              child: Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white.withOpacity(0.8),
                size: 48.sp,
              ),
            ),
        ],
      );
    }
    // Consistent placeholder
    return Container(color: AppTheme.colorsOf(context).grey4);
  }
}
