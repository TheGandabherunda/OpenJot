import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:record/record.dart';
import 'package:shimmer/shimmer.dart';

import '../theme.dart';
import 'custom_button.dart';

class WriteJournalToolbarContent extends StatefulWidget {
  final IconData? selectedToolbarIcon;
  final ScrollController scrollController;
  final Function(List<AssetEntity> assets)? onAssetsSelected;
  final Function(String path, Duration duration)? onRecordingComplete;

  const WriteJournalToolbarContent({
    super.key,
    required this.selectedToolbarIcon,
    required this.scrollController,
    this.onAssetsSelected,
    this.onRecordingComplete,
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
      return 'Today';
    } else if (date == yesterday) {
      return 'Yesterday';
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

    if (widget.selectedToolbarIcon != Icons.image_rounded) {
      final Map<IconData, String> contentMap = {
        Icons.location_on_rounded: 'Content for Location',
        Icons.camera_alt_rounded: 'Content for Camera',
        Icons.format_quote_rounded: 'Content for Quote',
        Icons.sentiment_satisfied_rounded: 'Content for Emoji',
      };
      final contentText =
          contentMap[widget.selectedToolbarIcon] ?? 'No content selected.';
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
                        'Photos',
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
                        'Video',
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
                        'Audio',
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
                text: 'Add ${_selectedAssets.length}',
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
            'No ${_getTabName(_selectedSegment).toLowerCase()} found.',
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
            'Permission to access ${_getTabName(_selectedSegment).toLowerCase()} is required to display them.',
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
              'Open Settings',
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
        return 'Photos';
      case 1:
        return 'Videos';
      case 2:
        return 'Audios';
      default:
        return '';
    }
  }
}

class AssetThumbnailItem extends StatefulWidget {
  final AssetEntity asset;
  final AppThemeColors colors;

  const AssetThumbnailItem({
    Key? key,
    required this.asset,
    required this.colors,
  }) : super(key: key);

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

  Future<void> _loadThumbnail() async {
    if (!mounted) return;
    final data = await widget.asset.thumbnailData;
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

    if (widget.asset.type == AssetType.video) {
      return _buildVideoOverlay(context, widget.asset, thumbnail);
    }

    return thumbnail;
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
                'GIF',
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

class _AudioRecorderViewState extends State<AudioRecorderView> {
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
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _playerStateSubscription?.cancel();
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
    _startTimer();
  }

  Future<void> _pauseRecording() async {
    _timer?.cancel();
    await _audioRecorder.pause();
    setState(() {
      _isPaused = true;
    });
  }

  Future<void> _resumeRecording() async {
    await _audioRecorder.resume();
    setState(() {
      _isPaused = false;
    });
    _startTimer();
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
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
    _timer?.cancel();
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
  }

  void _resetStateForNewRecording() {
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
            "Listen",
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 3),
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.error,
          ),
          child: IconButton(
            icon: Icon(
              _isRecording && !_isPaused ? Icons.pause : Icons.mic,
              color: colors.grey10,
              size: 36.sp,
            ),
            onPressed: _toggleRecording,
          ),
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
    );
  }

  Widget _buildPreviewControls(AppThemeColors colors) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
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
                color: colors.grey3,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: colors.error,
                  size: 24.sp,
                ),
                onPressed: _discardRecording,
              ),
            ),
            SizedBox(width: 8.w),
            CustomButton(
              onPressed: _addRecording,
              borderRadius: 56,
              text: 'Add',
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
