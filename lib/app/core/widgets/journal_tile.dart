import 'dart:async';
import 'dart:io';

import 'package:image/image.dart' as img; // Left safely for compilation compatibility
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/write_journal/write_journal_bottom_sheet.dart';
import 'package:open_jot/app/utils/pdf_generator.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

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
  final bool showMenuIcon;

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
    this.showMenuIcon = true,
  });

  @override
  State<JournalTile> createState() => _JournalTileState();
}

class _JournalTileState extends State<JournalTile> {
  static const _platform = MethodChannel('app.channel.shared.data');
  static final DateFormat _tileDateFormat = DateFormat('MMM d  •  h:mm a');

  final GlobalKey _menuKey = GlobalKey();
  final HomeController _homeController = Get.find<HomeController>();
  late final AudioPlayer _audioPlayer;
  String? _currentlyPlayingPath;
  PlayerState? _playerState;
  StreamSubscription? _playerStateSubscription;

  static const List<Map<String, String>> _moods = [
    {'svg': 'assets/1.svg', 'label': AppConstants.veryUnpleasant},
    {'svg': 'assets/2.svg', 'label': AppConstants.unpleasant},
    {'svg': 'assets/3.svg', 'label': AppConstants.slightlyUnpleasant},
    {'svg': 'assets/4.svg', 'label': AppConstants.neutral},
    {'svg': 'assets/5.svg', 'label': AppConstants.slightlyPleasant},
    {'svg': 'assets/6.svg', 'label': AppConstants.pleasant},
    {'svg': 'assets/7.svg', 'label': AppConstants.veryPleasant},
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = _homeController.audioPlayer;
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
    final allFilePaths = <String>[];

    // Get paths from gallery images
    final galleryImageFiles = await Future.wait(
      widget.entry.galleryImages.map((asset) => asset.file),
    );
    for (final file in galleryImageFiles) {
      if (file != null) {
        allFilePaths.add(file.path);
      }
    }

    // Get paths from camera photos
    for (final photo in widget.entry.cameraPhotos) {
      allFilePaths.add(photo.file.path);
    }

    // Get paths from gallery audios
    final galleryAudioFiles = await Future.wait(
      widget.entry.galleryAudios.map((asset) => asset.file),
    );
    for (final file in galleryAudioFiles) {
      if (file != null) {
        allFilePaths.add(file.path);
      }
    }

    // For recordings, which might be in a private app directory, we copy them
    // to a temporary (shareable) cache location before sharing.
    final tempDir = await getTemporaryDirectory();
    for (final recording in widget.entry.recordings) {
      try {
        final originalFile = File(recording.path);
        if (await originalFile.exists()) {
          final fileName = p.basename(recording.path);
          final newPath = p.join(tempDir.path, fileName);
          final newFile = await originalFile.copy(newPath);
          allFilePaths.add(newFile.path);
        }
      } catch (e) {
        debugPrint("Could not copy recording for sharing: $e");
      }
    }

    try {
      await _platform.invokeMethod('shareContent', {
        'text': plainText.isNotEmpty ? plainText : null,
        'files': allFilePaths.isNotEmpty ? allFilePaths : null,
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to share content: '${e.message}'.");
    }
  }

  void _onDeletePressed() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text(
            AppConstants.pleaseConfirm,
          ),
          content: const Text(
            AppConstants.confirmDeleteJournalEntry,
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              isDefaultAction: false,
              isDestructiveAction: false,
              child: const Text(AppConstants.cancel),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Get.find<HomeController>().deleteJournalEntry(widget.entry.id);
                Navigator.of(ctx).pop();
              },
              isDefaultAction: true,
              isDestructiveAction: true,
              child: const Text(AppConstants.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _JournalTileContent(
      menuKey: _menuKey,
      entry: widget.entry,
      onTap: widget.onTap,
      backgroundColor: widget.backgroundColor,
      dividerColor: widget.dividerColor,
      footerTextColor: widget.footerTextColor,
      reflectionBackground: widget.reflectionBackground,
      showMenuIcon: widget.showMenuIcon,
      plainText: _homeController.plainTextCache[widget.entry.id] ?? '',
      audioPlayer: _audioPlayer,
      currentlyPlayingPath: _currentlyPlayingPath,
      playerState: _playerState,
      onMenuPressed: () {
        final RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        _showMenu(context, position, renderBox);
      },
    );
  }

  void _showMenu(BuildContext context, Offset position, RenderBox renderBox) {
    final appThemeColors = AppTheme.colorsOf(context);
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
              Text(AppConstants.edit,
                  style: TextStyle(
                      color: appThemeColors.grey10,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2)),
            ],
          ),
        ),
        PopupMenuDivider(
            height: 1,
            color: widget.popupDividerColor ??
                appThemeColors.grey6),
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
                    ? AppConstants.removeBookmark
                    : AppConstants.bookmark,
                style: TextStyle(
                    color: appThemeColors.grey10,
                    fontFamily: AppConstants.font,
                    letterSpacing: -0.2),
              ),
            ],
          ),
        ),
        PopupMenuDivider(
            height: 1,
            color: widget.popupDividerColor ??
                appThemeColors.grey6),
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share_outlined,
                  color: appThemeColors.grey10),
              SizedBox(width: 8.w),
              Text(AppConstants.share,
                  style: TextStyle(

                      color: appThemeColors.grey10,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2)),
            ],
          ),
        ),
        PopupMenuDivider(
            height: 1,
            color: widget.popupDividerColor ??
                appThemeColors.grey6),
        PopupMenuItem(
          value: 'pdf',
          child: Row(
            children: [
              Icon(Icons.save_outlined,
                  color: appThemeColors.grey10),
              SizedBox(width: 8.w),
              Text(AppConstants.saveAsPdf,
                  style: TextStyle(
                      color: appThemeColors.grey10,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2)),
            ],
          ),
        ),
        PopupMenuDivider(
            height: 1,
            color: widget.popupDividerColor ??
                appThemeColors.grey6),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline_outlined,
                  color: appThemeColors.error),
              SizedBox(width: 8.w),
              Text(AppConstants.delete,
                  style: TextStyle(
                      color: appThemeColors.error,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2)),
            ],
          ),
        ),
      ],
    ).then((value) async {
      if (value == 'edit') {
        _onEditPressed();
      } else if (value == 'bookmark') {
        Get.find<HomeController>()
            .toggleBookmarkStatus(widget.entry.id);
      } else if (value == 'share') {
        _onSharePressed();
      } else if (value == 'pdf') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Generating PDF...'),
              duration: Duration(seconds: 2)),
        );
        try {
          await PdfGenerator.generateAndSharePdf(widget.entry);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to generate PDF: $e')),
          );
        }
      } else if (value == 'delete') {
        _onDeletePressed();
      }
    });
  }
}

class _JournalTileContent extends StatelessWidget {
  final GlobalKey menuKey;
  final JournalEntry entry;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? dividerColor;
  final Color? footerTextColor;
  final Color? reflectionBackground;
  final bool showMenuIcon;
  final String plainText;
  final AudioPlayer audioPlayer;
  final String? currentlyPlayingPath;
  final PlayerState? playerState;
  final VoidCallback onMenuPressed;

  const _JournalTileContent({
    required this.menuKey,
    required this.entry,
    required this.onTap,
    this.backgroundColor,
    this.dividerColor,
    this.footerTextColor,
    this.reflectionBackground,
    required this.showMenuIcon,
    required this.plainText,
    required this.audioPlayer,
    this.currentlyPlayingPath,
    this.playerState,
    required this.onMenuPressed,
  });

  static final DateFormat _tileDateFormat = DateFormat('MMM d  •  h:mm a');

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final hasMedia = entry.galleryImages.isNotEmpty ||
        entry.cameraPhotos.isNotEmpty;
    final hasAudio = entry.galleryAudios.isNotEmpty ||
        entry.recordings.isNotEmpty;
    final tileColor = backgroundColor ?? appThemeColors.grey6;

    return GestureDetector(
      onTap: onTap,
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
                    child: _buildMediaPreview(context, entry),
                  ),
                if (hasAudio)
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: plainText.isNotEmpty ? 8.h : 0),
                    child: _buildAudioPreviews(context, entry, audioPlayer, currentlyPlayingPath, playerState),
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
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                if (entry.tags.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 8.h),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: entry.tags.map((tag) => Padding(
                          padding: EdgeInsets.only(right: 6.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppTheme.getTagBaseColor(tag, Theme.of(context).brightness, allTags: Get.find<HomeController>().allUniqueTags),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: AppTheme.getTagLightColor(tag, Theme.of(context).brightness, allTags: Get.find<HomeController>().allUniqueTags),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppConstants.font,
                              ),
                            ),
                          ),
                        )).toList(),
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
                  color: dividerColor ?? appThemeColors.grey5,
                  width: 1,
                ),
              ),
            ),
            child: _buildFooter(appThemeColors, context),
          ),
        ]),
      ),
    );
  }

  Widget _buildMediaPreview(BuildContext context, JournalEntry entry) {
    final allMedia = [
      ...entry.galleryImages,
      ...entry.cameraPhotos
    ];
    if (allMedia.isEmpty) {
      return const SizedBox.shrink();
    }

    final double spacing = 2.w;
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor =
    (isDark ? appThemeColors.grey7 : appThemeColors.grey10)
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
                    decoration: TextDecoration.none,
                    letterSpacing: -0.2),
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

  Widget _buildAudioPreviews(BuildContext context, JournalEntry entry, AudioPlayer audioPlayer, String? currentlyPlayingPath, PlayerState? playerState) {
    return Column(
      children: [
        _buildGalleryAudioPreview(context, entry),
        _buildRecordingsPreview(context, entry, audioPlayer, currentlyPlayingPath, playerState),
      ],
    );
  }

  String _formatPreviewDuration(Duration duration) {
    if (duration == Duration.zero) {
      return AppConstants.emptyDuration;
    }
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildGalleryAudioPreview(BuildContext context, JournalEntry entry) {
    if (entry.galleryAudios.isEmpty) {
      return const SizedBox.shrink();
    }
    final appThemeColors = AppTheme.colorsOf(context);
    return Column(
      children: entry.galleryAudios.map((audio) {
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
                    audio.title ?? AppConstants.audioTrack,
                    style: TextStyle(
                      color: appThemeColors.grey10,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2,
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

  Widget _buildRecordingsPreview(BuildContext context, JournalEntry entry, AudioPlayer audioPlayer, String? currentlyPlayingPath, PlayerState? playerState) {
    if (entry.recordings.isEmpty) {
      return const SizedBox.shrink();
    }
    final appThemeColors = AppTheme.colorsOf(context);
    return Column(
      children: entry.recordings.map((recording) {
        final isPlaying = currentlyPlayingPath == recording.path &&
            playerState == PlayerState.playing;
        final isPaused = currentlyPlayingPath == recording.path &&
            playerState == PlayerState.paused;
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
                      await audioPlayer.pause();
                    } else if (isPaused) {
                      await audioPlayer.resume();
                    } else {
                      await audioPlayer
                          .play(DeviceFileSource(recording.path));
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
                          letterSpacing: -0.2,
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
                          letterSpacing: -0.2,
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
        // [FIXED] Removed highly expensive `IntrinsicHeight` which causes heavy speculative layout thrashing per tile.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  _tileDateFormat.format(entry.createdAt),
                  style: TextStyle(
                    fontFamily: AppConstants.font,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: footerTextColor ?? appThemeColors.grey3,
                    letterSpacing: -0.2,
                  ),
                ),
                // [FIXED] Replaced `VerticalDivider` (which requires IntrinsicHeight) with a fixed Container.
                Container(
                  width: 1.w,
                  height: 16.h,
                  color: dividerColor ?? appThemeColors.grey5,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                ),
                Row(
                  children: [
                    if (entry.isReflection)
                      Container(
                        margin: EdgeInsets.only(
                            right: entry.moodIndex != null || entry.isDraft ? 8.w : 0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: reflectionBackground ??
                              appThemeColors.grey5,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Text(
                          AppConstants.reflection,
                          style: TextStyle(
                            color: appThemeColors.grey10,
                            fontSize: 12.sp,
                            fontFamily: AppConstants.font,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    if (entry.isDraft)
                      Container(
                        margin: EdgeInsets.only(
                            right: entry.moodIndex != null ? 8.w : 0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: reflectionBackground ??
                              appThemeColors.grey5,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Text(
                          AppConstants.draft,
                          style: TextStyle(
                            color: appThemeColors.grey10,
                            fontSize: 12.sp,
                            fontFamily: AppConstants.font,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    if (entry.moodIndex != null)
                      SvgPicture.asset(
                        _JournalTileState._moods[entry.moodIndex!]['svg']!,
                        width: 22.w,
                        height: 22.h,
                      ),
                    if (entry.isBookmarked)
                      Padding(
                        padding: EdgeInsets.only(
                            left: entry.moodIndex != null ||
                                entry.isReflection || entry.isDraft
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
            if (showMenuIcon)
              GestureDetector(
                key: menuKey,
                onTap: onMenuPressed,
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: appThemeColors.grey1,
                  size: 28.w,
                ),
              ),
          ],
        ));
  }
}

// [FIXED] Vastly Optimized Media Thumbnail:
// 1. Completely bypassed async platform calls and `setState` blockages for Gallery Assets using native `AssetEntityImageProvider`.
// 2. Used highly performant native rendering (`cacheWidth: 300`) to avoid jitter during CustomScrollView rendering.
class MediaThumbnail extends StatefulWidget {
  final dynamic media; // Can be AssetEntity or CapturedPhoto

  const MediaThumbnail({super.key, required this.media});

  @override
  State<MediaThumbnail> createState() => _MediaThumbnailState();
}

class _MediaThumbnailState extends State<MediaThumbnail> {
  bool _isVideo = false;
  String? _imagePath;
  bool _isAssetEntity = false;

  @override
  void initState() {
    super.initState();
    _initMedia();
  }

  @override
  void didUpdateWidget(covariant MediaThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media != widget.media) {
      _imagePath = null;
      _initMedia();
    }
  }

  Future<String> _getThumbnailPath(String originalPath) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = p.basenameWithoutExtension(originalPath);
    return p.join(tempDir.path, '$fileName.thumb.jpg');
  }

  void _initMedia() {
    _isAssetEntity = widget.media is AssetEntity;

    if (_isAssetEntity) {
      final asset = widget.media as AssetEntity;
      _isVideo = asset.type == AssetType.video;
      // AssetEntityImageProvider handles native memory-efficient thumbnail loading automatically! Zero setState needed!
    } else if (widget.media is CapturedPhoto) {
      final photo = widget.media as CapturedPhoto;
      final path = photo.file.path;
      _isVideo = _isVideoFile(path);

      if (_isVideo) {
        _loadVideoThumbnail(path);
      } else {
        // Skips async block entirely for local images captured from within the app
        _imagePath = path;
      }
    }
  }

  Future<void> _loadVideoThumbnail(String path) async {
    if (!mounted) return;

    final thumbPath = await _getThumbnailPath(path);
    final thumbFile = File(thumbPath);

    if (await thumbFile.exists()) {
      // Use Image.file with cache constraints instead of Image.memory(data)
      // to let the engine manage memory more efficiently.
      if (mounted) {
        setState(() {
          _imagePath = thumbPath;
        });
      }
    } else {
      try {
        final data = await VideoThumbnail.thumbnailData(
          video: path,
          maxWidth: 300,
          quality: 50, // Reduced quality for faster generation and smaller footprint
        );
        if (data != null) {
          await thumbFile.writeAsBytes(data);
          if (mounted) {
            setState(() {
              _imagePath = thumbPath;
            });
          }
        }
      } catch (e) {
        debugPrint("Failed to generate video thumbnail: $e");
      }
    }
  }

  bool _isVideoFile(String path) {
    final lowercasedPath = path.toLowerCase();
    return lowercasedPath.endsWith('.mp4') ||
        lowercasedPath.endsWith('.mov') ||
        lowercasedPath.endsWith('.avi') ||
        lowercasedPath.endsWith('.wmv') ||
        lowercasedPath.endsWith('.mkv') ||
        lowercasedPath.endsWith('.m4v') ||
        lowercasedPath.endsWith('.webm');
  }

  @override
  Widget build(BuildContext context) {
    Widget? imageContent;

    if (_isAssetEntity) {
      imageContent = Image(
        image: AssetEntityImageProvider(
          widget.media as AssetEntity,
          isOriginal: false,
          thumbnailSize: const ThumbnailSize.square(200), // Slightly reduced for even more smoothness
          thumbnailFormat: ThumbnailFormat.jpeg,
        ),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => Container(color: AppTheme.colorsOf(context).grey4),
      );
    } else {
      if (_imagePath != null) {
        imageContent = Image.file(
          File(_imagePath!),
          fit: BoxFit.cover,
          gaplessPlayback: true,
          cacheWidth: 350, // Slightly reduced for even more smoothness
        );
      }
    }

    if (imageContent != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          imageContent,
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

    return Container(color: AppTheme.colorsOf(context).grey4);
  }
}