import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../core/models/journal_entry.dart';
import '../../core/theme.dart';

/// A helper class to unify different media types for the previewer.
class MediaItem {
  final dynamic asset; // Can be AssetEntity or CapturedPhoto
  final AssetType type;
  final String id;

  MediaItem({required this.asset, required this.type, required this.id});
}

/// A full-screen bottom sheet to preview images and videos with an ambient gradient background.
class MediaPreviewBottomSheet extends StatefulWidget {
  final List<MediaItem> mediaItems;
  final int initialIndex;

  const MediaPreviewBottomSheet({
    super.key,
    required this.mediaItems,
    this.initialIndex = 0,
  });

  @override
  MediaPreviewBottomSheetState createState() => MediaPreviewBottomSheetState();
}

class MediaPreviewBottomSheetState extends State<MediaPreviewBottomSheet> {
  late PageController _pageController;
  int _currentIndex = 0;

  // A cache to store generated background colors to prevent re-computation.
  final Map<int, List<Color>> _colorCache = {};

  // Default gradient colors
  Color _dominantColor = Colors.black;
  Color _vibrantColor = Colors.grey.shade800;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    // Generate the background for the initial item after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateBackgroundColor(_currentIndex);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Extracts colors from a media item to create a gradient.
  /// It now uses a cache to avoid re-generating colors for viewed items.
  Future<void> _updateBackgroundColor(int index) async {
    if (index < 0 || index >= widget.mediaItems.length) return;

    // Check the cache first to avoid expensive re-computation.
    if (_colorCache.containsKey(index)) {
      if (mounted) {
        setState(() {
          _vibrantColor = _colorCache[index]![0];
          _dominantColor = _colorCache[index]![1];
        });
      }
      return;
    }

    final item = widget.mediaItems[index];
    Uint8List? imageData;
    ImageProvider? imageProvider;

    try {
      if (item.asset is AssetEntity) {
        final asset = item.asset as AssetEntity;
        imageData = await asset.thumbnailDataWithSize(
          const ThumbnailSize(200, 200),
          quality: 80,
        );
      } else if (item.asset is CapturedPhoto) {
        final file = File((item.asset as CapturedPhoto).file.path);
        if (item.type == AssetType.video) {
          imageData = await VideoThumbnail.thumbnailData(
            video: file.path,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 200,
            quality: 80,
          );
        } else {
          imageData = await file.readAsBytes();
        }
      }

      if (imageData != null) {
        imageProvider = MemoryImage(imageData);
      }

      if (imageProvider != null && mounted) {
        final palette = await PaletteGenerator.fromImageProvider(
          imageProvider,
          size: const Size(100, 100),
          maximumColorCount: 20,
        );

        if (mounted) {
          final dominantColor =
              palette.dominantColor?.color ?? Colors.grey.shade900;
          final vibrantColor = palette.vibrantColor?.color ?? dominantColor;

          // Store the generated colors in the cache.
          _colorCache[index] = [vibrantColor, dominantColor];

          setState(() {
            _dominantColor = dominantColor;
            _vibrantColor = vibrantColor;
          });
        }
      } else {
        // Fallback for videos without thumbnails
        final fallbackColors = [Colors.black, Colors.grey.shade900];
        _colorCache[index] = fallbackColors; // Cache fallback colors
        if (mounted) {
          setState(() {
            _vibrantColor = fallbackColors[0];
            _dominantColor = fallbackColors[1];
          });
        }
      }
    } catch (e) {
      // In case of an error, fall back to default colors.
      final fallbackColors = [Colors.black, Colors.grey.shade900];
      _colorCache[index] = fallbackColors; // Cache fallback colors
      if (mounted) {
        setState(() {
          _vibrantColor = fallbackColors[0];
          _dominantColor = fallbackColors[1];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _vibrantColor.withOpacity(0.7),
              _dominantColor.withOpacity(0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.mediaItems.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                    _updateBackgroundColor(index);
                  },
                  itemBuilder: (context, index) {
                    final item = widget.mediaItems[index];
                    Widget mediaContent;
                    if (item.type == AssetType.video) {
                      mediaContent = VideoPlayerItem(item: item);
                    } else {
                      mediaContent = _buildImageItem(item);
                    }
                    return Padding(
                      padding: EdgeInsets.all(8.w),
                      // Added ClipRRect for corner radius
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: mediaContent,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 10.h,
                  left: 10.w,
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
                if (widget.mediaItems.length > 1)
                  Positioned(
                    bottom: 20.h,
                    left: 0,
                    right: 0,
                    child: _buildPageIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageItem(MediaItem item) {
    ImageProvider imageProvider;
    if (item.asset is AssetEntity) {
      imageProvider = AssetEntityImageProvider(item.asset, isOriginal: true);
    } else if (item.asset is CapturedPhoto) {
      imageProvider = FileImage(File((item.asset as CapturedPhoto).file.path));
    } else {
      return const Center(child: Text('Unsupported Image Type'));
    }

    return InteractiveViewer(
      panEnabled: true,
      minScale: 1.0,
      maxScale: 4.0,
      child: Image(
        image: imageProvider,
        fit: BoxFit.contain,
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
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.mediaItems.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
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

class VideoPlayerItem extends StatefulWidget {
  final MediaItem item;

  const VideoPlayerItem({super.key, required this.item});

  @override
  VideoPlayerItemState createState() => VideoPlayerItemState();
}

class VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    File? file;
    if (widget.item.asset is AssetEntity) {
      file = await (widget.item.asset as AssetEntity).file;
    } else if (widget.item.asset is CapturedPhoto) {
      file = File((widget.item.asset as CapturedPhoto).file.path);
    }

    if (file == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _controller?.setLooping(true);
        }
      });

    _controller?.addListener(() {
      if (mounted) {
        final isPlaying = _controller?.value.isPlaying ?? false;
        if (_isPlaying != isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: Text('Could not load video'));
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
