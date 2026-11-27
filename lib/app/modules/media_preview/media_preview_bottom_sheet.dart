import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/widgets/audio_spectrum_waveform.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/utils/custom_toast.dart';
import 'package:open_jot/app/utils/foss_location.dart';
import 'package:open_jot/app/utils/mood_helper.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../core/models/journal_entry.dart';
import '../../core/theme.dart';

enum MediaPreviewKind { image, video, audio, recording, location, mood }

/// A helper class to unify different media and card types for the previewer.
class MediaItem {
  final dynamic asset; // AssetEntity, CapturedPhoto, RecordedAudio, SelectedLocation, or int
  final AssetType type;
  final String id;
  final MediaPreviewKind kind;

  MediaItem({
    required this.asset,
    required this.type,
    required this.id,
    MediaPreviewKind? kind,
  }) : kind = kind ?? _kindFromAssetType(type);

  MediaItem.location(SelectedLocation location)
      : asset = location,
        type = AssetType.other,
        id = 'location',
        kind = MediaPreviewKind.location;

  MediaItem.mood(int moodIndex)
      : asset = moodIndex,
        type = AssetType.other,
        id = 'mood',
        kind = MediaPreviewKind.mood;

  MediaItem.recorded(RecordedAudio rec)
      : asset = rec,
        type = AssetType.audio,
        id = rec.path,
        kind = rec.isVoiceRecording
            ? MediaPreviewKind.recording
            : MediaPreviewKind.audio;

  static MediaPreviewKind _kindFromAssetType(AssetType assetType) {
    if (assetType == AssetType.video) return MediaPreviewKind.video;
    if (assetType == AssetType.audio) return MediaPreviewKind.audio;
    return MediaPreviewKind.image;
  }
}

/// A full-screen bottom sheet to preview media, locations, and moods with an ambient gradient background.
class MediaPreviewBottomSheet extends StatefulWidget {
  final List<MediaItem> mediaItems;
  final int initialIndex;
  final Function(MediaItem)? onRemove;
  final Future<SelectedLocation?> Function(SelectedLocation current)?
      onEditLocation;
  final Future<int?> Function(int currentMoodIndex)? onEditMood;

  const MediaPreviewBottomSheet({
    super.key,
    required this.mediaItems,
    this.initialIndex = 0,
    this.onRemove,
    this.onEditLocation,
    this.onEditMood,
  });

  @override
  MediaPreviewBottomSheetState createState() => MediaPreviewBottomSheetState();
}

class MediaPreviewBottomSheetState extends State<MediaPreviewBottomSheet> {
  late PageController _pageController;
  int _currentIndex = 0;
  late List<MediaItem> _editableMediaItems;

  // A cache to store generated background colors to prevent re-computation.
  final Map<int, List<Color>> _colorCache = {};
  final Set<int> _processingIndexes = {};

  // Default gradient colors
  Color _dominantColor = Colors.black;
  Color _vibrantColor = Colors.grey.shade800;
  bool _isPreloadingInitiated = false;

  @override
  void initState() {
    super.initState();
    _editableMediaItems = List.from(widget.mediaItems);
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  int _decodeTargetWidth(BuildContext context) {
    final mq = MediaQuery.of(context);
    return (mq.size.width * mq.devicePixelRatio).round().clamp(1080, 1920);
  }

  ImageProvider? _imageProviderFor(MediaItem item, int decodeWidth) {
    if (item.asset is AssetEntity) {
      return AssetEntityImageProvider(
        item.asset as AssetEntity,
        isOriginal: false,
        thumbnailSize: ThumbnailSize.square(decodeWidth),
      );
    }
    if (item.asset is CapturedPhoto) {
      return ResizeImage.resizeIfNeeded(
        decodeWidth,
        null,
        FileImage(File((item.asset as CapturedPhoto).file.path)),
      );
    }
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isPreloadingInitiated) {
      _isPreloadingInitiated = true;
      _applyImmediateColorsIfPossible(_currentIndex);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _preloadInitialContent();
        }
      });
    }
  }

  void _applyImmediateColorsIfPossible(int index) {
    if (index < 0 || index >= _editableMediaItems.length) return;
    final colors = _resolveInstantColors(_editableMediaItems[index]);
    if (colors != null) {
      _colorCache[index] = colors;
      _vibrantColor = colors[0];
      _dominantColor = colors[1];
    }
  }

  List<Color>? _resolveInstantColors(MediaItem item) {
    if (item.kind == MediaPreviewKind.mood) {
      final moodIdx =
          (item.asset as int).clamp(0, AppConstants.moods.length - 1);
      final appColors = AppTheme.colorsOf(context);
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final moodColors =
          MoodHelper.getMoodThemeColors(moodIdx, appColors, isDark);
      return [moodColors[1], moodColors[2]];
    }
    if (item.kind == MediaPreviewKind.location) {
      return const [Color(0xFF4F7EA8), Color(0xFF1F3549)];
    }
    if (item.kind == MediaPreviewKind.recording) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return isDark
          ? const [Color(0xFF1C1C24), Color(0xFF0A0A0F)]
          : const [Color(0xFFFFFFFF), Color(0xFFF2F2F7)];
    }
    if (item.kind == MediaPreviewKind.audio) {
      return [Colors.deepPurple.shade900, Colors.black87];
    }
    return null;
  }

  void _preloadInitialContent() {
    if (!_colorCache.containsKey(_currentIndex)) {
      unawaited(_updateBackgroundColor(_currentIndex));
    }
    _precacheImage(_currentIndex);

    // Defer adjacent palette/image preloads until after the opening slide finishes.
    Future.delayed(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      if (_currentIndex > 0) {
        unawaited(_updateBackgroundColor(_currentIndex - 1));
        _precacheImage(_currentIndex - 1);
      }
      if (_currentIndex < _editableMediaItems.length - 1) {
        unawaited(_updateBackgroundColor(_currentIndex + 1));
        _precacheImage(_currentIndex + 1);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Pre-caches a screen-sized resized image provider matching display decode keys.
  void _precacheImage(int index) {
    if (!mounted || index < 0 || index >= _editableMediaItems.length) return;
    final item = _editableMediaItems[index];
    if (item.kind != MediaPreviewKind.image) return;

    try {
      final provider = _imageProviderFor(item, _decodeTargetWidth(context));
      if (provider != null) {
        unawaited(precacheImage(provider, context));
      }
    } catch (e) {
      debugPrint("Error creating image provider for precaching: $e");
    }
  }

  /// Extracts ambient palette colors from a media item without heavy full-res decoding.
  Future<void> _updateBackgroundColor(int index) async {
    if (index < 0 ||
        index >= _editableMediaItems.length ||
        _processingIndexes.contains(index)) {
      return;
    }

    if (_colorCache.containsKey(index)) {
      if (mounted && index == _currentIndex) {
        final colors = _colorCache[index]!;
        setState(() {
          _vibrantColor = colors[0];
          _dominantColor = colors[1];
        });
      }
      return;
    }

    try {
      _processingIndexes.add(index);
      final item = _editableMediaItems[index];

      final instant = _resolveInstantColors(item);
      if (instant != null) {
        _colorCache[index] = instant;
        if (mounted && index == _currentIndex) {
          setState(() {
            _vibrantColor = instant[0];
            _dominantColor = instant[1];
          });
        }
        return;
      }

      ImageProvider? imageProvider;

      if (item.asset is AssetEntity) {
        final asset = item.asset as AssetEntity;
        final Uint8List? thumbData = await asset.thumbnailDataWithSize(
          const ThumbnailSize(96, 96),
          quality: 60,
        );
        if (thumbData != null) {
          imageProvider = MemoryImage(thumbData);
        }
      } else if (item.asset is CapturedPhoto) {
        final file = File((item.asset as CapturedPhoto).file.path);
        if (item.type == AssetType.video) {
          final Uint8List videoThumb = await VideoThumbnail.thumbnailData(
            video: file.path,
            maxWidth: 96,
            maxHeight: 96,
            quality: 60,
          );
          if (videoThumb.isNotEmpty) {
            imageProvider = MemoryImage(videoThumb);
          }
        } else if (file.existsSync()) {
          imageProvider = ResizeImage(
            FileImage(file),
            width: 64,
            height: 64,
          );
        }
      }

      if (imageProvider != null && mounted) {
        final palette = await PaletteGenerator.fromImageProvider(
          imageProvider,
          size: const Size(48, 48),
          maximumColorCount: 8,
        );

        if (mounted) {
          final dominantColor =
              palette.dominantColor?.color ?? Colors.grey.shade900;
          final vibrantColor = palette.vibrantColor?.color ??
              palette.lightVibrantColor?.color ??
              palette.darkVibrantColor?.color ??
              dominantColor;

          _colorCache[index] = [vibrantColor, dominantColor];

          if (index == _currentIndex) {
            setState(() {
              _vibrantColor = vibrantColor;
              _dominantColor = dominantColor;
            });
          }
        }
      } else {
        final fallbackColors = [Colors.black, Colors.grey.shade900];
        _colorCache[index] = fallbackColors;
        if (mounted && index == _currentIndex) {
          setState(() {
            _vibrantColor = fallbackColors[0];
            _dominantColor = fallbackColors[1];
          });
        }
      }
    } catch (e) {
      final fallbackColors = [Colors.black, Colors.grey.shade900];
      _colorCache[index] = fallbackColors;
      if (mounted && index == _currentIndex) {
        setState(() {
          _vibrantColor = fallbackColors[0];
          _dominantColor = fallbackColors[1];
        });
      }
    } finally {
      _processingIndexes.remove(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final decodeWidth = _decodeTargetWidth(context);

    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: DecoratedBox(
              decoration: const BoxDecoration(color: Colors.black),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _vibrantColor.withOpacity(0.82),
                      _dominantColor.withOpacity(0.92),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _editableMediaItems.length,
                  onPageChanged: (index) {
                    final cachedColors = _colorCache[index];
                    setState(() {
                      _currentIndex = index;
                      if (cachedColors != null) {
                        _vibrantColor = cachedColors[0];
                        _dominantColor = cachedColors[1];
                      }
                    });
                    if (cachedColors == null) {
                      unawaited(_updateBackgroundColor(index));
                    }
                    if (index > 0) {
                      if (!_colorCache.containsKey(index - 1)) {
                        unawaited(_updateBackgroundColor(index - 1));
                      }
                      _precacheImage(index - 1);
                    }
                    if (index < _editableMediaItems.length - 1) {
                      if (!_colorCache.containsKey(index + 1)) {
                        unawaited(_updateBackgroundColor(index + 1));
                      }
                      _precacheImage(index + 1);
                    }
                  },
                  itemBuilder: (context, index) {
                    final item = _editableMediaItems[index];
                    return Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Center(
                        child: RepaintBoundary(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: _buildMediaContent(item, index, decodeWidth),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      top: 10.h,
                      start: 10.w,
                      child: IconButton(
                        icon:
                        const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Colors.black.withOpacity(0.3)),
                        ),
                      ),
                    ),
                    if (_canEditCurrentItem() || widget.onRemove != null)
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        top: 10.h,
                        end: 10.w,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_canEditCurrentItem())
                              GestureDetector(
                                onTap: _handleEditCurrentItem,
                                child: Container(
                                  height: 44.w,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 14.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.35),
                                    borderRadius: BorderRadius.circular(22.w),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.edit_rounded,
                                        color: Colors.white,
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        AppConstants.edit.tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppConstants.font,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (_canEditCurrentItem() &&
                                widget.onRemove != null)
                              SizedBox(width: 8.w),
                            if (widget.onRemove != null)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                onPressed: () {
                                  final currentItem =
                                      _editableMediaItems[_currentIndex];
                                  widget.onRemove!(currentItem);
                                  setState(() {
                                    _editableMediaItems
                                        .removeAt(_currentIndex);
                                    if (_editableMediaItems.isEmpty) {
                                      Navigator.of(context).pop();
                                    } else {
                                      if (_currentIndex >=
                                          _editableMediaItems.length) {
                                        _currentIndex =
                                            _editableMediaItems.length - 1;
                                      }
                                      _colorCache.clear();
                                      _updateBackgroundColor(_currentIndex);
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.black.withOpacity(0.3)),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (_editableMediaItems.length > 1)
                        Positioned(
                          bottom: MediaQuery.of(context).padding.bottom + 16.h,
                          left: 0,
                          right: 0,
                          child: _buildPageIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  bool _canEditCurrentItem() {
    if (_editableMediaItems.isEmpty) return false;
    final item = _editableMediaItems[_currentIndex];
    if (item.kind == MediaPreviewKind.location) {
      return widget.onEditLocation != null;
    }
    if (item.kind == MediaPreviewKind.mood) {
      return widget.onEditMood != null;
    }
    return false;
  }

  Future<void> _handleEditCurrentItem() async {
    if (_editableMediaItems.isEmpty) return;
    final index = _currentIndex;
    final item = _editableMediaItems[index];

    if (item.kind == MediaPreviewKind.location &&
        widget.onEditLocation != null) {
      final updated =
          await widget.onEditLocation!(item.asset as SelectedLocation);
      if (updated != null && mounted) {
        setState(() {
          _editableMediaItems[index] = MediaItem.location(updated);
        });
      }
    } else if (item.kind == MediaPreviewKind.mood &&
        widget.onEditMood != null) {
      final updated = await widget.onEditMood!(item.asset as int);
      if (updated != null && mounted) {
        setState(() {
          _editableMediaItems[index] = MediaItem.mood(updated);
          _colorCache.remove(index);
        });
        unawaited(_updateBackgroundColor(index));
      }
    }
  }

  Widget _buildMediaContent(MediaItem item, int index, int decodeWidth) {
    switch (item.kind) {
      case MediaPreviewKind.video:
        return VideoPlayerItem(
          item: item,
          isActive: index == _currentIndex,
        );
      case MediaPreviewKind.audio:
      case MediaPreviewKind.recording:
        return AudioPlayerItem(
          item: item,
          isActive: index == _currentIndex,
        );
      case MediaPreviewKind.location:
        return _LocationPreviewItem(location: item.asset as SelectedLocation);
      case MediaPreviewKind.mood:
        return _MoodPreviewItem(moodIndex: item.asset as int);
      case MediaPreviewKind.image:
        return _buildImageItem(item, decodeWidth);
    }
  }

  Widget _buildImageItem(MediaItem item, int decodeWidth) {
    final imageProvider = _imageProviderFor(item, decodeWidth);
    if (imageProvider == null) {
      return Center(child: Text(AppConstants.unsupportedImageType.tr));
    }

    return InteractiveViewer(
      panEnabled: true,
      minScale: 1.0,
      maxScale: 4.0,
      child: Image(
        image: imageProvider,
        fit: BoxFit.contain,
        gaplessPlayback: true,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: child,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 48,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_editableMediaItems.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: _currentIndex == index ? 24.w : 8.w,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}

// Widget to handle Video assets
class VideoPlayerItem extends StatefulWidget {
  final MediaItem item;
  final bool isActive;

  const VideoPlayerItem({
    super.key,
    required this.item,
    this.isActive = false,
  });

  @override
  VideoPlayerItemState createState() => VideoPlayerItemState();
}

class VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(VideoPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isActive &&
        _controller != null &&
        _controller!.value.isPlaying) {
      _controller!.pause();
    }
  }

  Future<void> _initializePlayer() async {
    if (!mounted) return;

    File? file;
    try {
      if (widget.item.asset is AssetEntity) {
        file = await (widget.item.asset as AssetEntity).file;
      } else if (widget.item.asset is CapturedPhoto) {
        file = File((widget.item.asset as CapturedPhoto).file.path);
      }

      if (file == null || !file.existsSync()) {
        if (mounted) setState(() {_isLoading = false; _hasError = true;});
        return;
      }

      _controller = VideoPlayerController.file(file);
      await _controller!.initialize();

      if (mounted) {
        setState(() => _isLoading = false);
        _controller!.setLooping(true);
      }
      _controller!.addListener(_videoListener);
    } catch (e) {
      if (mounted) setState(() {_isLoading = false; _hasError = true;});
    }
  }

  void _videoListener() {
    if (!mounted) return;
    final isPlaying = _controller?.value.isPlaying ?? false;
    if (_isPlaying != isPlaying) {
      setState(() => _isPlaying = isPlaying);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError || _controller == null || !_controller!.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 8),
            Text(
              AppConstants.couldNotLoadVideo.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    final appThemeColors = AppTheme.colorsOf(context);

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          AnimatedOpacity(
            opacity: _isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: appThemeColors.grey10,
                size: 60.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to handle Audio assets with robust timing & visibility fixes
class AudioPlayerItem extends StatefulWidget {
  final MediaItem item;
  final bool isActive;

  const AudioPlayerItem({
    super.key,
    required this.item,
    this.isActive = false,
  });

  @override
  AudioPlayerItemState createState() => AudioPlayerItemState();
}

class AudioPlayerItemState extends State<AudioPlayerItem> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _hasError = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _sourcePath;
  List<double>? _spectrumLevels;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    // Use AssetEntity duration as a guaranteed initial fallback to prevent '00:00'
    if (widget.item.asset is AssetEntity) {
      final int durationInSeconds = (widget.item.asset as AssetEntity).duration;
      if (durationInSeconds > 0) {
        _duration = Duration(seconds: durationInSeconds);
      }
    }
    _initPlayer();
  }

  @override
  void didUpdateWidget(AudioPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isActive && _isPlaying) {
      _audioPlayer.pause();
    }
  }

  bool get _isVoiceRecording => widget.item.kind == MediaPreviewKind.recording;

  Future<File?> _resolveLocalAudioFile(String rawPath) async {
    final direct = File(rawPath);
    if (direct.existsSync()) return direct;

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final basename = p.basename(rawPath);
      final mediaCandidate = File(p.join(appDocDir.path, 'media', basename));
      if (mediaCandidate.existsSync()) return mediaCandidate;

      final rootCandidate = File(p.join(appDocDir.path, basename));
      if (rootCandidate.existsSync()) return rootCandidate;

      final mediaDir = Directory(p.join(appDocDir.path, 'media'));
      if (mediaDir.existsSync()) {
        for (final entity in mediaDir.listSync()) {
          if (entity is File && p.basename(entity.path).endsWith(basename)) {
            return entity;
          }
        }
      }
    } catch (e) {
      debugPrint('Audio fallback path resolution error: $e');
    }
    return null;
  }

  Future<void> _initPlayer() async {
    if (!mounted) return;

    File? file;
    try {
      if (widget.item.asset is AssetEntity) {
        var asset = widget.item.asset as AssetEntity;
        file = await asset.file;
        if (file == null || !file.existsSync()) {
          file = await asset.originFile;
        }
        if (file == null || !file.existsSync()) {
          final refreshed = await AssetEntity.fromId(asset.id);
          if (refreshed != null) {
            asset = refreshed;
            file = await asset.file ?? await asset.originFile;
          }
        }
      } else if (widget.item.asset is CapturedPhoto) {
        final rawPath = (widget.item.asset as CapturedPhoto).file.path;
        file = await _resolveLocalAudioFile(rawPath);
      } else if (widget.item.asset is RecordedAudio) {
        final rec = widget.item.asset as RecordedAudio;
        file = await _resolveLocalAudioFile(rec.path);
        if (_duration == Duration.zero && rec.duration > Duration.zero) {
          _duration = rec.duration;
        }
      }

      if (file == null || !file.existsSync()) {
        debugPrint(
          'AudioPlayerItem: file missing for id=${widget.item.id} (${widget.item.asset.runtimeType})',
        );
        if (mounted) setState(() { _isLoading = false; _hasError = true; });
        return;
      }

      _sourcePath = file.path;

      if (_isVoiceRecording) {
        List<double>? loaded;
        if (Get.isRegistered<HiveService>()) {
          loaded = AudioSpectrumWaveform.loadWaveform(
            Get.find<HiveService>(),
            file.path,
          );
        }
        _spectrumLevels =
            (loaded != null && loaded.isNotEmpty)
                ? loaded
                : AudioSpectrumWaveform.fallbackLevelsForKey(
                    file.path,
                    targetCount: 44,
                  );
      }

      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      // Important: DeviceFileSource provides the best compatibility for local files
      await _audioPlayer.setSource(DeviceFileSource(file.path));

      _durationSubscription = _audioPlayer.onDurationChanged.listen((d) {
        if (mounted && d > Duration.zero) setState(() => _duration = d);
      });

      _positionSubscription = _audioPlayer.onPositionChanged.listen((p) {
        if (mounted) setState(() => _position = p);
      });

      _playerStateSubscription =
          _audioPlayer.onPlayerStateChanged.listen((state) {
        if (!mounted) return;
        if (state == PlayerState.completed) {
          setState(() {
            _isPlaying = false;
            _position = Duration.zero;
          });
        } else {
          setState(() => _isPlaying = state == PlayerState.playing);
        }
      });

      // Fetch immediately just in case the event stream missed the initial broadcast
      final explicitDuration = await _audioPlayer.getDuration();
      if (explicitDuration != null && explicitDuration > Duration.zero && mounted) {
        setState(() => _duration = explicitDuration);
      }

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("Audio Player Error: $e");
      if (mounted) setState(() { _isLoading = false; _hasError = true; });
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      return;
    }
    final path = _sourcePath;
    if (path == null) return;

    if (_audioPlayer.state == PlayerState.paused) {
      await _audioPlayer.resume();
    } else {
      final seekTarget =
          (_position > Duration.zero && _position < _duration)
              ? _position
              : Duration.zero;
      await _audioPlayer.play(DeviceFileSource(path));
      if (seekTarget > Duration.zero) {
        await _audioPlayer.seek(seekTarget);
      }
    }
  }

  void _seekTo(Duration target) {
    setState(() => _position = target);
    unawaited(_audioPlayer.seek(target));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color statusFgColor = _isVoiceRecording
        ? (isDark ? Colors.white : const Color(0xFF1C1C1E))
        : Colors.white;

    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: statusFgColor));
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: statusFgColor, size: 48),
            const SizedBox(height: 8),
            Text(
              AppConstants.couldNotLoadAudio.tr,
              style: TextStyle(color: statusFgColor),
            ),
          ],
        ),
      );
    }

    String title = _isVoiceRecording
        ? AppConstants.voiceRecording.tr
        : AppConstants.audioRecording.tr;
    if (widget.item.asset is AssetEntity) {
      title = (widget.item.asset as AssetEntity).title ?? title;
    } else if (widget.item.asset is CapturedPhoto) {
      title = (widget.item.asset as CapturedPhoto).name;
    } else if (widget.item.asset is RecordedAudio) {
      title = (widget.item.asset as RecordedAudio).name;
    }

    double maxDuration = _duration.inMilliseconds.toDouble();
    if (maxDuration <= 0) maxDuration = 1.0; // Prevent assertion error in slider
    double currentPos = _position.inMilliseconds.toDouble().clamp(0.0, maxDuration);

    if (_isVoiceRecording) {
      final Color surfaceColor =
          isDark ? const Color(0xFF1C1C1E) : Colors.white;
      final Color inkPrimary =
          isDark ? Colors.white : const Color(0xFF1C1C1E);
      final Color inkSecondary =
          isDark ? const Color(0xFFAEAEB2) : const Color(0xFF636366);
      final Color appleRecordRed =
          isDark ? const Color(0xFFFF453A) : const Color(0xFFFF3B30);
      final levels = _spectrumLevels ??
          AudioSpectrumWaveform.fallbackLevelsForKey(title, targetCount: 44);

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: surfaceColor,
          border: isDark
              ? Border.all(color: Colors.white.withOpacity(0.10), width: 1)
              : null,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96.w,
              height: 96.w,
              decoration: BoxDecoration(
                color: appleRecordRed.withOpacity(isDark ? 0.18 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic_rounded,
                color: appleRecordRed,
                size: 48.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: inkPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppConstants.font,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 28.h),
            AudioSpectrumWaveform(
              levels: levels,
              progress: maxDuration > 0
                  ? (currentPos / maxDuration).clamp(0.0, 1.0)
                  : 0.0,
              activeColor: inkPrimary,
              inactiveColor: isDark
                  ? Colors.white.withOpacity(0.22)
                  : inkSecondary.withOpacity(0.28),
              playheadColor: appleRecordRed,
              height: 84.h,
              onSeek: (progress) {
                _seekTo(
                  Duration(milliseconds: (maxDuration * progress).round()),
                );
              },
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: TextStyle(
                    color: inkSecondary,
                    fontSize: 12.sp,
                    fontFamily: AppConstants.font,
                  ),
                ),
                Text(
                  _formatDuration(_duration),
                  style: TextStyle(
                    color: inkSecondary,
                    fontSize: 12.sp,
                    fontFamily: AppConstants.font,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: inkPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                  size: 32.sp,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.music_note_rounded,
              color: Colors.white,
              size: 64.sp,
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 32.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
              trackHeight: 4.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
            ),
            child: Slider(
              min: 0.0,
              max: maxDuration,
              value: currentPos,
              onChanged: (value) {
                _seekTo(Duration(milliseconds: value.toInt()));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
                Text(
                  _formatDuration(_duration),
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: 64.w,
              height: 64.w,
              decoration: const BoxDecoration(
                color: Colors.white, // Hardcoded to white to pop on the purple gradient
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.black, // Dark icon for contrast
                size: 32.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationPreviewItem extends StatefulWidget {
  final SelectedLocation location;

  const _LocationPreviewItem({required this.location});

  @override
  State<_LocationPreviewItem> createState() => _LocationPreviewItemState();
}

class _LocationPreviewItemState extends State<_LocationPreviewItem> {
  final MapController _mapController = MapController();
  String? _placeName;

  @override
  void initState() {
    super.initState();
    _loadPlaceName();
  }

  @override
  void didUpdateWidget(covariant _LocationPreviewItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location.coordinates != widget.location.coordinates) {
      _loadPlaceName();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(widget.location.coordinates, 17);
        }
      });
    }
  }

  void _loadPlaceName() {
    final target = widget.location.coordinates;
    _placeName = FossLocation.getCachedPlaceName(target);
    if (_placeName == null) {
      unawaited(FossLocation.getPlaceName(target).then((resolved) {
        if (!mounted ||
            resolved == null ||
            widget.location.coordinates != target) {
          return;
        }
        setState(() {
          _placeName = resolved;
        });
      }));
    }
  }

  Future<void> _openInMaps() async {
    final uri = Uri.parse(widget.location.link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      CustomToast.showToast(
        AppConstants.couldNotOpenMap.tr,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final coords = widget.location.coordinates;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxCardHeight = constraints.maxHeight * 0.58;
        final cardSize = constraints.maxWidth < maxCardHeight
            ? constraints.maxWidth
            : maxCardHeight;
        final textTop = (constraints.maxHeight + cardSize) / 2 + 18.h;

        return Stack(
          children: [
            Center(
              child: SizedBox(
                width: cardSize,
                height: cardSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: coords,
                          initialZoom: 17,
                          minZoom: 4,
                          maxZoom: 19,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.pinchZoom |
                                InteractiveFlag.doubleTapZoom,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'org.thegandabherunda.openjot',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 48.w,
                                height: 48.w,
                                point: coords,
                                child: Icon(
                                  Icons.location_pin,
                                  color: colors.aOrange[1],
                                  size: 42.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        right: 14.w,
                        bottom: 14.h,
                        child: GestureDetector(
                          onTap: _openInMaps,
                          child: Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: const Color(0xCC1C1C1E),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.22),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_outward_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: textTop,
              left: 12.w,
              right: 12.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _placeName ?? 'Pinned Location',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppConstants.font,
                      height: 1.2,
                      letterSpacing: -0.2,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${coords.latitude.toStringAsFixed(4)}, ${coords.longitude.toStringAsFixed(4)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppConstants.font,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MoodPreviewItem extends StatelessWidget {
  final int moodIndex;

  const _MoodPreviewItem({required this.moodIndex});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final safeIdx = moodIndex.clamp(0, AppConstants.moods.length - 1);
    final moodColors = MoodHelper.getMoodThemeColors(safeIdx, appColors, isDark);
    final label = (AppConstants.moods[safeIdx]['label'] ?? '').tr;
    final homeController = Get.find<HomeController>();

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: MoodHelper.buildMoodWashDecoration(
          moodColors[0],
          moodColors[1],
          moodColors[2],
          isDark: isDark,
          borderRadius: BorderRadius.circular(22.r),
        ),
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                final rasterized = homeController.moodImagesLarge[safeIdx] ??
                    homeController.moodImages[safeIdx];
                if (rasterized != null) {
                  return RawImage(
                    image: rasterized,
                    width: 150.w,
                    height: 150.w,
                    filterQuality: ui.FilterQuality.high,
                  );
                }
                return MoodHelper.buildMoodSvg(
                  safeIdx,
                  width: 150.w,
                  height: 150.w,
                );
              }),
              if (label.isNotEmpty) ...[
                SizedBox(height: 16.h),
                Text(
                  label,
                  style: TextStyle(
                    color: moodColors[0],
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.font,
                    letterSpacing: -0.3,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}