import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:video_player/video_player.dart';

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
  final Set<int> _processingIndexes = {};

  // Default gradient colors
  Color _dominantColor = Colors.black;
  Color _vibrantColor = Colors.grey.shade800;
  bool _isPreloadingInitiated = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload content here, as context is available.
    if (!_isPreloadingInitiated) {
      _preloadInitialContent();
      _isPreloadingInitiated = true;
    }
  }

  void _preloadInitialContent() {
    // We want the UI to be interactive immediately, so we don't wait for this.
    // Fetch the color for the initial item.
    _updateBackgroundColor(_currentIndex);

    // Pre-load colors and images for adjacent items to make scrolling smooth.
    if (_currentIndex > 0) {
      _updateBackgroundColor(_currentIndex - 1);
      _precacheImage(_currentIndex - 1);
    }
    if (_currentIndex < widget.mediaItems.length - 1) {
      _updateBackgroundColor(_currentIndex + 1);
      _precacheImage(_currentIndex + 1);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Pre-caches a specific image to improve scrolling performance.
  void _precacheImage(int index) {
    if (index < 0 || index >= widget.mediaItems.length) return;

    final item = widget.mediaItems[index];
    if (item.type == AssetType.image) {
      ImageProvider? imageProvider;
      try {
        if (item.asset is AssetEntity) {
          imageProvider =
              AssetEntityImageProvider(item.asset as AssetEntity, isOriginal: true);
        } else if (item.asset is CapturedPhoto) {
          imageProvider = FileImage(File((item.asset as CapturedPhoto).file.path));
        }
        if (imageProvider != null && mounted) {
          precacheImage(imageProvider, context);
        }
      } catch (e) {
        debugPrint("Error creating image provider for precaching: $e");
      }
    }
  }

  /// Extracts colors from a media item to create a gradient.
  Future<void> _updateBackgroundColor(int index) async {
    if (index < 0 ||
        index >= widget.mediaItems.length ||
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

      final item = widget.mediaItems[index];
      Uint8List? imageData;
      ImageProvider? imageProvider;

      if (item.asset is AssetEntity) {
        final asset = item.asset as AssetEntity;
        imageData = await asset.thumbnailDataWithSize(
          const ThumbnailSize(150, 150),
          quality: 70,
        );
      } else if (item.asset is CapturedPhoto) {
        final file = File((item.asset as CapturedPhoto).file.path);
        if (item.type == AssetType.video) {
          imageData = await VideoThumbnail.thumbnailData(
            video: file.path,
            maxWidth: 150,
            maxHeight: 150,
            quality: 70,
          );
        } else {
          final bytes = await file.readAsBytes();
          final codec = await ui.instantiateImageCodec(
            bytes,
            targetWidth: 150,
            targetHeight: 150,
          );
          final frame = await codec.getNextFrame();
          final data =
          await frame.image.toByteData(format: ui.ImageByteFormat.png);
          imageData = data?.buffer.asUint8List();
        }
      }

      if (imageData != null) {
        imageProvider = MemoryImage(imageData);
      }

      if (imageProvider != null && mounted) {
        final palette = await PaletteGenerator.fromImageProvider(
          imageProvider,
          size: const Size(75, 75),
          maximumColorCount: 15,
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
      if (mounted) {
        _processingIndexes.remove(index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
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
                        // Update background and precache for smooth scrolling.
                        _updateBackgroundColor(index);
                        if (index > 0) {
                          _updateBackgroundColor(index - 1);
                          _precacheImage(index - 1);
                        }
                        if (index < widget.mediaItems.length - 1) {
                          _updateBackgroundColor(index + 1);
                          _precacheImage(index + 1);
                        }
                      },
                      itemBuilder: (context, index) {
                        final item = widget.mediaItems[index];
                        return Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: _buildMediaContent(item, index),
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
                ))),
      ),
    );
  }

  Widget _buildMediaContent(MediaItem item, int index) {
    if (item.type == AssetType.video) {
      return VideoPlayerItem(
        item: item,
        isActive: index == _currentIndex,
      );
    } else {
      return _buildImageItem(item);
    }
  }

  Widget _buildImageItem(MediaItem item) {
    ImageProvider imageProvider;
    if (item.asset is AssetEntity) {
      imageProvider = AssetEntityImageProvider(item.asset, isOriginal: true);
    } else if (item.asset is CapturedPhoto) {
      imageProvider = FileImage(File((item.asset as CapturedPhoto).file.path));
    } else {
      return const Center(child: Text(AppConstants.unsupportedImageType));
    }

    return InteractiveViewer(
      panEnabled: true,
      minScale: 1.0,
      maxScale: 4.0,
      child: Image(
        image: imageProvider,
        fit: BoxFit.contain,
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
      children: List.generate(widget.mediaItems.length, (index) {
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 48),
            SizedBox(height: 8),
            Text(
              AppConstants.couldNotLoadVideo,
              style: TextStyle(color: Colors.white),
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

