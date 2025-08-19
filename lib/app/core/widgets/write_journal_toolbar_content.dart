import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // ADD THIS IMPORT
import 'package:latlong2/latlong.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;
import 'package:record/record.dart';
import 'package:shimmer/shimmer.dart';

import '../theme.dart';
import 'camera_view.dart';
import 'custom_button.dart';
import 'custom_slider.dart';
import 'location_map_view.dart'; // NEW IMPORT

class WriteJournalToolbarContent extends StatefulWidget {
  final IconData? selectedToolbarIcon;
  final ScrollController scrollController;
  final Function(List<AssetEntity> assets)? onAssetsSelected;
  final Function(String path, Duration duration)? onRecordingComplete;
  final Function(LatLng location)? onLocationSelected; // NEW CALLBACK
  final Function(XFile photo)? onPhotoTaken;
  final Function(int? moodIndex)? onMoodChanged;
  final int? selectedMoodIndex;

  const WriteJournalToolbarContent({
    super.key,
    required this.selectedToolbarIcon,
    required this.scrollController,
    this.onAssetsSelected,
    this.onRecordingComplete,
    this.onLocationSelected, // NEW PARAMETER
    this.onPhotoTaken,
    this.onMoodChanged,
    this.selectedMoodIndex,
  });

  @override
  _WriteJournalToolbarContentState createState() =>
      _WriteJournalToolbarContentState();
}

class _WriteJournalToolbarContentState
    extends State<WriteJournalToolbarContent> {
  int _selectedSegment = 0;
  PermissionStatus? _permissionStatus;
  Map<DateTime, List<AssetEntity>> _groupedAssets = {};
  bool _isLoading = false;
  final List<AssetEntity> _selectedAssets = [];

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void didUpdateWidget(covariant WriteJournalToolbarContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedToolbarIcon != oldWidget.selectedToolbarIcon) {
      // Potentially reset state or fetch different content based on icon
    }
  }

  Future<void> _requestPermission() async {
    final permission = _getPermissionForSegment(_selectedSegment);
    final status = await permission.request();
    if (mounted) {
      setState(() {
        _permissionStatus = status;
      });
      if (status.isGranted) {
        _fetchMedia();
      }
    }
  }

  Future<void> _fetchMedia() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _groupedAssets = {};
    });

    final type = _getRequestTypeForSegment(_selectedSegment);
    final albums = await PhotoManager.getAssetPathList(type: type);
    if (albums.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    final List<AssetEntity> assets = [];
    final Set<String> processedAssetIds = <String>{};
    for (final album in albums) {
      final assetList = await album.getAssetListRange(start: 0, end: 2000);
      for (final asset in assetList) {
        if (processedAssetIds.add(asset.id)) {
          assets.add(asset);
        }
      }
    }

    assets.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));

    final Map<DateTime, List<AssetEntity>> grouped = {};
    for (final asset in assets) {
      final date = DateTime(
        asset.createDateTime.year,
        asset.createDateTime.month,
        asset.createDateTime.day,
      );
      grouped.putIfAbsent(date, () => []).add(asset);
    }

    if (mounted) {
      setState(() {
        _groupedAssets = grouped;
        _isLoading = false;
      });
    }
  }

  Permission _getPermissionForSegment(int segment) {
    switch (segment) {
      case 0:
        return Permission.photos;
      case 1:
        return Permission.videos;
      case 2:
        return Permission.audio;
      default:
        return Permission.photos;
    }
  }

  RequestType _getRequestTypeForSegment(int segment) {
    switch (segment) {
      case 0:
        return RequestType.image;
      case 1:
        return RequestType.video;
      case 2:
        return RequestType.audio;
      default:
        return RequestType.image;
    }
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date == today) {
      return AppConstants.today;
    } else if (date == yesterday) {
      return AppConstants.yesterday;
    } else {
      const monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);

    if (widget.selectedToolbarIcon == Icons.mic_rounded) {
      return AudioRecorderView(
        scrollController: widget.scrollController,
        onRecordingComplete: (path, duration) {
          widget.onRecordingComplete?.call(path, duration);
        },
      );
    }

    if (widget.selectedToolbarIcon == Icons.camera_alt_rounded) {
      return CameraView(
        scrollController: widget.scrollController,
        onPhotoTaken: (photo) {
          widget.onPhotoTaken?.call(photo);
        },
      );
    }

    if (widget.selectedToolbarIcon == Icons.location_on_rounded) {
      return LocationMapView(
        scrollController: widget.scrollController,
        onLocationSelected: (location) {
          widget.onLocationSelected?.call(location);
        },
      );
    }

    if (widget.selectedToolbarIcon == Icons.sentiment_satisfied_rounded) {
      return _MoodSelectorView(
        scrollController: widget.scrollController,
        onMoodChanged: widget.onMoodChanged,
        initialMoodIndex: widget.selectedMoodIndex,
      );
    }

    if (widget.selectedToolbarIcon != Icons.image_rounded) {
      final Map<IconData, String> contentMap = {
        Icons.format_quote_rounded: AppConstants.contentForQuote,
      };
      final contentText =
          contentMap[widget.selectedToolbarIcon] ?? AppConstants.noContentSelected;
      return ListView(
        controller: widget.scrollController,
        padding: EdgeInsets.zero,
        children: [
          Center(
            child: Text(
              contentText,
              style: TextStyle(
                  color: colors.grey10,
                  decoration: TextDecoration.none,
                  fontFamily: AppConstants.font),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CupertinoSlidingSegmentedControl<int>(
                  backgroundColor: colors.grey3,
                  thumbColor: colors.grey5,
                  children: {
                    0: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        AppConstants.photos,
                        style: TextStyle(
                            color: colors.grey10,
                            decoration: TextDecoration.none,
                            fontSize: 14.sp,
                            fontFamily: AppConstants.font),
                      ),
                    ),
                    1: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        AppConstants.video,
                        style: TextStyle(
                            color: colors.grey10,
                            decoration: TextDecoration.none,
                            fontSize: 14.sp,
                            fontFamily: AppConstants.font),
                      ),
                    ),
                    2: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        AppConstants.audio,
                        style: TextStyle(
                            color: colors.grey10,
                            decoration: TextDecoration.none,
                            fontSize: 14.sp,
                            fontFamily: AppConstants.font),
                      ),
                    ),
                  },
                  onValueChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        _selectedSegment = value;
                        _selectedAssets.clear();
                      });
                      _requestPermission();
                    }
                  },
                  groupValue: _selectedSegment,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: _buildMediaGrid(colors),
            ),
          ],
        ),
        if (_selectedAssets.isNotEmpty)
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Center(
              child: CustomButton(
                onPressed: () {
                  widget.onAssetsSelected?.call(_selectedAssets);
                  setState(() {
                    _selectedAssets.clear();
                  });
                },
                borderRadius: 56,
                text: '${AppConstants.add} ${_selectedAssets.length}',
                icon: Icons.add,
                iconSize: 24,
                color: Theme.of(context).primaryColor,
                textColor: colors.grey8,
                textPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSkeletonLoading(AppThemeColors colors) {
    return Shimmer.fromColors(
      baseColor: colors.grey3,
      highlightColor: colors.grey4,
      child: GridView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: 15,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              color: colors.grey3,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaGrid(AppThemeColors colors) {
    if (_isLoading) {
      return _buildSkeletonLoading(colors);
    }

    if (_permissionStatus == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_permissionStatus!.isGranted) {
      if (_groupedAssets.isEmpty) {
        return Center(
          child: Text(
            AppConstants.noMediaFound
                .replaceFirst('%s', _getTabName(_selectedSegment).toLowerCase()),
            style: TextStyle(
                color: colors.grey10,
                decoration: TextDecoration.none,
                fontFamily: AppConstants.font),
          ),
        );
      }
      final sortedDates = _groupedAssets.keys.toList()
        ..sort((a, b) => b.compareTo(a));

      final isDark = Theme.of(context).brightness == Brightness.dark;
      final overlayColor =
      (isDark ? colors.grey7 : colors.grey10).withOpacity(0.5);
      final onOverlayColor = isDark ? colors.grey10 : colors.grey7;

      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          return true;
        },
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            for (final date in sortedDates) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 32.h, 8.w, 8.h),
                  child: Text(
                    _formatDate(date),
                    style: TextStyle(
                        color: colors.grey1,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                        fontSize: 15.sp,
                        fontFamily: AppConstants.font),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 80.h),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final asset = _groupedAssets[date]![index];
                      final isSelected = _selectedAssets.contains(asset);

                      Widget child;
                      if (asset.type == AssetType.audio) {
                        child = _buildAudioItem(asset, colors);
                      } else {
                        child =
                            AssetThumbnailItem(asset: asset, colors: colors);
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            // MODIFICATION: Allow multiple selections for all types
                            if (isSelected) {
                              _selectedAssets.remove(asset);
                            } else {
                              _selectedAssets.add(asset);
                            }
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              child,
                              if (isSelected)
                                Container(
                                  decoration: BoxDecoration(
                                    color: overlayColor,
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: onOverlayColor,
                                    size: 24.sp,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: _groupedAssets[date]!.length,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    } else {
      return _buildPermissionDenied(colors);
    }
  }

  Widget _buildAudioItem(AssetEntity asset, AppThemeColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.grey4,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                asset.title ?? '',
                style: TextStyle(
                    color: colors.grey10,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: AppConstants.font),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned(
            bottom: 4.h,
            left: 4.w,
            child: Row(
              children: [
                Icon(Icons.music_note, color: colors.grey10, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  _formatDuration(asset.duration),
                  style: TextStyle(
                      color: colors.grey10,
                      fontSize: 12.sp,
                      decoration: TextDecoration.none,
                      fontFamily: AppConstants.font),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDenied(AppThemeColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppConstants.permissionRequired
                .replaceFirst('%s', _getTabName(_selectedSegment).toLowerCase()),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: colors.grey10,
                decoration: TextDecoration.none,
                fontFamily: AppConstants.font),
          ),
          SizedBox(height: 8.h),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
            },
            child: const Text(
              AppConstants.openSettings,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: AppConstants.font),
            ),
          ),
        ],
      ),
    );
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return AppConstants.photos;
      case 1:
        return AppConstants.videos;
      case 2:
        return AppConstants.audios;
      default:
        return '';
    }
  }
}

class AssetThumbnailItem extends StatefulWidget {
  final AssetEntity asset;
  final AppThemeColors colors;

  const AssetThumbnailItem({
    super.key,
    required this.asset,
    required this.colors,
  });

  @override
  _AssetThumbnailItemState createState() => _AssetThumbnailItemState();
}

class _AssetThumbnailItemState extends State<AssetThumbnailItem> {
  Uint8List? _thumbnailData;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(covariant AssetThumbnailItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.asset.id != oldWidget.asset.id) {
      // If the asset entity itself changes, reload the image data.
      setState(() {
        _thumbnailData = null;
      });
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    if (!mounted) return;
    // *** CHANGE: Request a higher quality thumbnail for the picker grid ***
    final data = await widget.asset.thumbnailDataWithSize(
      const ThumbnailSize(250, 250),
      quality: 90,
    );
    if (mounted) {
      setState(() {
        _thumbnailData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbnailData == null) {
      return Container(color: widget.colors.grey3);
    }

    final thumbnail = Image.memory(
      _thumbnailData!,
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );

    // OPTIMIZATION: Wrapping the thumbnail in a RepaintBoundary.
    // This caches the loaded image and prevents it from being repainted
    // when other parts of the grid update (e.g., when another item is selected).
    final content = RepaintBoundary(
      child: widget.asset.type == AssetType.video
          ? _buildVideoOverlay(context, widget.asset, thumbnail)
          : thumbnail,
    );

    return content;
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildVideoOverlay(
      BuildContext context, AssetEntity asset, Widget thumbnail) {
    final isGif = asset.title?.toLowerCase().endsWith('.gif') ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor =
    (isDark ? widget.colors.grey7 : widget.colors.grey10).withOpacity(0.7);
    final onOverlayColor = isDark ? widget.colors.grey10 : widget.colors.grey7;

    return Stack(
      fit: StackFit.expand,
      children: [
        thumbnail,
        if (isGif)
          Positioned(
            bottom: 4.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: overlayColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                AppConstants.gif,
                style: TextStyle(
                    color: onOverlayColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        else
          Positioned(
            bottom: 4.h,
            left: 4.w,
            right: 4.w,
            child: Row(
              children: [
                Icon(Icons.videocam_rounded,
                    color: onOverlayColor, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  _formatDuration(asset.duration),
                  style: TextStyle(
                      color: onOverlayColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontFamily: AppConstants.font),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// New Audio Recorder Widget
class AudioRecorderView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String path, Duration duration) onRecordingComplete;

  const AudioRecorderView({
    super.key,
    required this.scrollController,
    required this.onRecordingComplete,
  });

  @override
  State<AudioRecorderView> createState() => _AudioRecorderViewState();
}

class _AudioRecorderViewState extends State<AudioRecorderView>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isStopped = false;
  bool _isPlayingPreview = false;
  String? _recordingPath;
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;
  StreamSubscription? _playerStateSubscription;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
          if (mounted && state == PlayerState.completed) {
            setState(() {
              _isPlayingPreview = false;
            });
          }
        });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _playerStateSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _toggleRecording() async {
    if (_isRecording && !_isPaused) {
      await _pauseRecording();
    } else if (_isRecording && _isPaused) {
      await _resumeRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _handleRecordPressStart() async {
    if (_isRecording && _isPaused) {
      await _resumeRecording();
    } else if (!_isRecording) {
      await _startRecording();
    }
  }

  Future<void> _handleRecordPressEnd() async {
    if (_isRecording && !_isPaused) {
      await _pauseRecording();
    }
  }

  Future<void> _startRecording() async {
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      // Handle permission denial
      return;
    }
    final dir = await getApplicationDocumentsDirectory();
    final path =
        '${dir.path}/OpenJot_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(const RecordConfig(), path: path);
    setState(() {
      _isRecording = true;
      _isPaused = false;
      _isStopped = false;
      _recordingDuration = Duration.zero;
    });
    _animationController.repeat();
    _startTimer();
  }

  Future<void> _pauseRecording() async {
    _timer?.cancel();
    await _audioRecorder.pause();
    setState(() {
      _isPaused = true;
    });
    _animationController.stop();
  }

  Future<void> _resumeRecording() async {
    await _audioRecorder.resume();
    setState(() {
      _isPaused = false;
    });
    _animationController.repeat();
    _startTimer();
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    _animationController.reset();
    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _isStopped = true;
      _recordingPath = path;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _recordingDuration += const Duration(seconds: 1);
      });
    });
  }

  void _togglePreview() {
    if (_isPlayingPreview) {
      _audioPlayer.pause();
      setState(() {
        _isPlayingPreview = false;
      });
    } else if (_recordingPath != null) {
      _audioPlayer.play(DeviceFileSource(_recordingPath!));
      setState(() {
        _isPlayingPreview = true;
      });
    }
  }

  void _addRecording() {
    if (_recordingPath != null) {
      widget.onRecordingComplete(_recordingPath!, _recordingDuration);
      _resetStateForNewRecording();
    }
  }

  void _discardRecording() {
    // Show a confirmation dialog before discarding
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => CupertinoAlertDialog(
        title: const Text(AppConstants.deleteRecordingTitle),
        content: const Text(AppConstants.deleteRecordingMessage),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text(AppConstants.cancel),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text(AppConstants.discard),
            onPressed: () {
              Navigator.pop(dialogContext);
              _timer?.cancel();
              _animationController.reset();
              if (_isRecording) {
                _audioRecorder.stop();
              }
              if (_isPlayingPreview) {
                _audioPlayer.stop();
              }
              // Delete the file if it exists
              if (_recordingPath != null) {
                final file = File(_recordingPath!);
                if (file.existsSync()) {
                  file.delete();
                }
              }
              _resetStateForNewRecording();
            },
          ),
        ],
      ),
    );
  }

  void _resetStateForNewRecording() {
    _animationController.reset();
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _isStopped = false;
      _isPlayingPreview = false;
      _recordingPath = null;
      _recordingDuration = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return ListView(
      controller: widget.scrollController,
      children: [
        SizedBox(height: 16.h),
        if (_isStopped)
          Text(
            AppConstants.listen,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: colors.success,
                fontFamily: AppConstants.font,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                fontSize: 16.sp),
          ),
        Text(
          _formatDuration(_recordingDuration),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppConstants.font,
            fontSize: 48.sp,
            color: colors.grey10,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.none,
          ),
        ),
        if (!_isStopped) SizedBox(height: 32.h),
        if (!_isStopped) _buildRecordingControls(colors),
        if (_isStopped) SizedBox(height: 16.h),
        if (_isStopped) _buildPreviewControls(colors),
      ],
    );
  }

  Widget _buildRecordingControls(AppThemeColors colors) {
    final bool isActivelyRecording = _isRecording && !_isPaused;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Stack(
              alignment: Alignment.center,
              children: [
                // Wave animation
                if (isActivelyRecording)
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1 + _animationController.value * 1.2,
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.error.withOpacity(
                                0.4 - (_animationController.value * 0.4)),
                          ),
                        ),
                      );
                    },
                  ),
                // The button itself
                GestureDetector(
                  onTap: _toggleRecording,
                  onLongPressStart: (_) => _handleRecordPressStart(),
                  onLongPressEnd: (_) => _handleRecordPressEnd(),
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActivelyRecording
                          ? colors.error.withOpacity(0.7)
                          : colors.error,
                    ),
                    child: Icon(
                      isActivelyRecording ? Icons.pause : Icons.mic,
                      color: colors.grey10,
                      size: 36.sp,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 3,
              child: _isRecording
                  ? Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.stop_circle_outlined,
                      color: colors.grey10, size: 40.sp),
                  onPressed: _stopRecording,
                ),
              )
                  : const SizedBox(),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          AppConstants.tapAndHold,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: colors.grey1,
              fontFamily: AppConstants.font,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
              fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildPreviewControls(AppThemeColors colors) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.grey3,
              ),
              child: IconButton(
                icon: Icon(
                  _isPlayingPreview
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: colors.grey10,
                  size: 36.sp,
                ),
                onPressed: _togglePreview,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.error,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: colors.grey10,
                  size: 24.sp,
                ),
                onPressed: _discardRecording,
              ),
            ),
            SizedBox(width: 8.w),
            CustomButton(
              onPressed: _addRecording,
              borderRadius: 56,
              text: AppConstants.add,
              icon: Icons.add,
              iconSize: 24,
              color: Theme.of(context).primaryColor,
              textColor: colors.grey8,
              textPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
          ],
        )
      ],
    );
  }
}

class _MoodSelectorView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int? moodIndex)? onMoodChanged;
  final int? initialMoodIndex;

  const _MoodSelectorView({
    required this.scrollController,
    this.onMoodChanged,
    this.initialMoodIndex,
  });

  @override
  State<_MoodSelectorView> createState() => _MoodSelectorViewState();
}

class _MoodSelectorViewState extends State<_MoodSelectorView>
    with TickerProviderStateMixin {
  late double _currentSliderValue;
  late final AnimationController _rotationController;

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
    _currentSliderValue = (widget.initialMoodIndex ?? 2).toDouble();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _triggerRotationAnimation() {
    _rotationController.reset();
    _rotationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final moodIndex = _currentSliderValue.round().clamp(0, _moods.length - 1);
    final selectedMood = _moods[moodIndex];

    final List<Color> backgroundColors = [
      colors.aRed[2],
      colors.aOrange[2],
      colors.aYellow[2],
      colors.aGreen[2],
      colors.aTeal[2],
    ];

    final List<Color> sliderAndTextColors = [
      colors.aRed[0],
      colors.aOrange[0],
      colors.aYellow[0],
      colors.aGreen[0],
      colors.aTeal[0],
    ];

    final currentBackgroundColor = backgroundColors[moodIndex];
    final currentSliderAndTextColor = sliderAndTextColors[moodIndex];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: currentBackgroundColor,
      child: Stack(
        children: [
          ListView(
            controller: widget.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            children: [
              SizedBox(height: 0.h), // Space for the clear button
              Center(
                child: AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    final bounceAnimation =
                    Curves.easeOutBack.transform(_rotationController.value);
                    return Transform.rotate(
                      angle: bounceAnimation * 2 * 3.14159,
                      child: SvgPicture.asset(
                        selectedMood['svg']!,
                        width: 80.w,
                        height: 80.h,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              Center(
                child: SizedBox(
                  height: 32.h,
                  child: Text(
                    selectedMood['label']!,
                    style: TextStyle(
                      color: currentSliderAndTextColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppConstants.font,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 40.h,
                child: CustomSliderWithTooltip(
                  min: 0,
                  max: 4,
                  initialValue: _currentSliderValue,
                  showValueTooltip: false,
                  activeColor: currentSliderAndTextColor,
                  unfocusedActiveColor:
                  currentSliderAndTextColor.withOpacity(0.7),
                  inactiveColor: colors.grey3,
                  focusedTrackHeight: 20.h,
                  unfocusedTrackHeight: 16.h,
                  onChanged: (value) {
                    final newIndex = value.round();
                    if (newIndex != _currentSliderValue.round()) {
                      widget.onMoodChanged?.call(newIndex);
                      _triggerRotationAnimation();
                    }
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
              ),
            ],
          ),
          if (widget.initialMoodIndex != null)
            Positioned(
              top: 16.h,
              right: 16.w,
              child: TextButton(
                onPressed: () {
                  widget.onMoodChanged?.call(null);
                },
                style: TextButton.styleFrom(
                  foregroundColor: currentSliderAndTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: const Text(
                  AppConstants.clear,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppConstants.font,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
