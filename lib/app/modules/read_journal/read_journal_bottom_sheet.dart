import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
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
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../core/constants.dart';
import '../../core/models/journal_entry.dart';
import '../../core/theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/journal_tile.dart';
import '../media_preview/media_preview_bottom_sheet.dart';

class ReadJournalBottomSheet extends StatefulWidget {
  final JournalEntry entry;

  const ReadJournalBottomSheet({super.key, required this.entry});

  @override
  ReadJournalBottomSheetState createState() => ReadJournalBottomSheetState();
}

class ReadJournalBottomSheetState extends State<ReadJournalBottomSheet> {
  late JournalEntry _currentEntry;
  late quill.QuillController _quillController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  // --- CHANGE START: Renamed to track by ID for both recordings and gallery audio ---
  String? _currentlyPlayingId;
  // --- CHANGE END ---
  PlayerState? _playerState;
  StreamSubscription? _playerStateSubscription;

  static const List<Map<String, String>> _moods = [
    {'svg': 'assets/1.svg', 'label': AppConstants.veryUnpleasant},
    {'svg': 'assets/2.svg', 'label': AppConstants.unpleasant},
    {'svg': 'assets/3.svg', 'label': AppConstants.neutral},
    {'svg': 'assets/4.svg', 'label': AppConstants.pleasant},
    {'svg': 'assets/5.svg', 'label': AppConstants.veryPleasant},
  ];

  @override
  void initState() {
    super.initState();
    _currentEntry = widget.entry;
    _initializeController();
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
          if (mounted) {
            setState(() {
              _playerState = state;
              if (state == PlayerState.completed) {
                // --- CHANGE START: Updated variable name ---
                _currentlyPlayingId = null;
                // --- CHANGE END ---
              }
            });
          }
        });
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
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onEditPressed() async {
    final homeController = Get.find<HomeController>();
    final entryToEdit = homeController.journalEntries.firstWhere(
            (e) => e.id == _currentEntry.id,
        orElse: () => _currentEntry);

    await showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: WriteJournalBottomSheet(entry: entryToEdit),
      ),
    );

    if (mounted) {
      final latestEntry = homeController.journalEntries.firstWhere(
            (e) => e.id == widget.entry.id,
        orElse: () => _currentEntry,
      );
      setState(() {
        _currentEntry = latestEntry;
        _quillController.dispose();
        _initializeController();
      });
    }
  }

  Future<void> _launchLocationLink() async {
    if (_currentEntry.location != null) {
      final Uri uri = Uri.parse(_currentEntry.location!.link);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppConstants.couldNotOpenMap)),
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

  void _openMediaPreview(List<dynamic> allMedia, int initialIndex) {
    final mediaItems = allMedia.map((m) {
      if (m is AssetEntity) {
        return MediaItem(asset: m, type: m.type, id: m.id);
      } else if (m is CapturedPhoto) {
        return MediaItem(
            asset: m,
            type:
            _isVideoFile(m.file.path) ? AssetType.video : AssetType.image,
            id: m.file.path);
      }
      return null;
    }).whereType<MediaItem>().toList();

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

  // --- CHANGE START: Added function to handle gallery audio playback ---
  void _toggleGalleryAudio(AssetEntity audio) async {
    final isPlaying = _currentlyPlayingId == audio.id &&
        _playerState == PlayerState.playing;
    final isPaused = _currentlyPlayingId == audio.id &&
        _playerState == PlayerState.paused;

    if (isPlaying) {
      await _audioPlayer.pause();
    } else if (isPaused) {
      await _audioPlayer.resume();
    } else {
      final file = await audio.file;
      if (file != null) {
        await _audioPlayer.play(DeviceFileSource(file.path));
        if (mounted) {
          setState(() {
            _currentlyPlayingId = audio.id;
          });
        }
      }
    }
  }
  // --- CHANGE END ---

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    return Scaffold(
      backgroundColor: appThemeColors.grey6,
      appBar: AppBar(
        backgroundColor: appThemeColors.grey6,
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
                  if (_currentEntry.galleryImages.isNotEmpty ||
                      _currentEntry.cameraPhotos.isNotEmpty)
                    SizedBox(height: 2.h),
                  _buildAudioPreview(),
                  if (_currentEntry.galleryAudios.isNotEmpty)
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
    final overlayColor =
    (isDark ? appThemeColors.grey7 : appThemeColors.grey10)
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
                // *** CHANGE: Using the new unified MediaThumbnail widget ***
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
          onTap: () => _openMediaPreview(allMedia, 0),
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
                onTap: () => _openMediaPreview(allMedia, 0),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: buildMediaContainer(
                allMedia[1],
                onTap: () => _openMediaPreview(allMedia, 1),
              ),
            ),
          ],
        ),
      );
    } else {
      Widget? thirdImageOverlay;
      if (allMedia.length > 3) {
        thirdImageOverlay = GestureDetector(
          onTap: () => _openMediaPreview(allMedia, 2),
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
                onTap: () => _openMediaPreview(allMedia, 0),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: buildMediaContainer(
                      allMedia[1],
                      onTap: () => _openMediaPreview(allMedia, 1),
                    ),
                  ),
                  SizedBox(height: spacing),
                  Expanded(
                    child: buildMediaContainer(
                      allMedia[2],
                      overlay: thirdImageOverlay,
                      onTap: () => _openMediaPreview(allMedia, 2),
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

  // --- CHANGE START: Updated widget to include play/pause controls ---
  Widget _buildAudioPreview() {
    if (_currentEntry.galleryAudios.isEmpty) {
      return const SizedBox.shrink();
    }
    final appThemeColors = AppTheme.colorsOf(context);
    return Column(
      children: _currentEntry.galleryAudios.map((audio) {
        final isPlaying = _currentlyPlayingId == audio.id &&
            _playerState == PlayerState.playing;

        return Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Container(
            height: 50.h, // Matched height with recordings preview
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: appThemeColors.grey4,
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
                  onPressed: () => _toggleGalleryAudio(audio),
                ),
                SizedBox(width: 4.w),
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
        );
      }).toList(),
    );
  }
  // --- CHANGE END ---


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
    return Column(
      children: _currentEntry.recordings.map((recording) {
        // --- CHANGE START: Updated variable name ---
        final isPlaying = _currentlyPlayingId == recording.path &&
            _playerState == PlayerState.playing;
        final isPaused = _currentlyPlayingId == recording.path &&
            _playerState == PlayerState.paused;
        // --- CHANGE END ---
        return Padding(
          padding: EdgeInsets.only(bottom: 4.h),
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
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    color: appThemeColors.grey1,
                    size: 28.sp,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      _audioPlayer.pause();
                    } else if (isPaused) {
                      _audioPlayer.resume();
                    } else {
                      _audioPlayer.play(DeviceFileSource(recording.path));
                      setState(() {
                        // --- CHANGE START: Updated variable name ---
                        _currentlyPlayingId = recording.path;
                        // --- CHANGE END ---
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

  Widget _buildMoodField(AppThemeColors appThemeColors) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
                    child: SvgPicture.asset(
                      _moods[_currentEntry.moodIndex!]['svg']!,
                      width: 28.w,
                      height: 28.h,
                    ),
                  ),
                ),
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
