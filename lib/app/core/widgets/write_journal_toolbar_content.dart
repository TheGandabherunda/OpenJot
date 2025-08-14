import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';

import '../theme.dart';

class WriteJournalToolbarContent extends StatefulWidget {
  final IconData? selectedToolbarIcon;
  final ScrollController scrollController;
  final Function(List<AssetEntity> assets)? onAssetsSelected;

  const WriteJournalToolbarContent({
    super.key,
    required this.selectedToolbarIcon,
    required this.scrollController,
    this.onAssetsSelected,
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

    if (widget.selectedToolbarIcon != Icons.image_rounded) {
      final Map<IconData, String> contentMap = {
        Icons.location_on_rounded: 'Content for Location',
        Icons.camera_alt_rounded: 'Content for Camera',
        Icons.mic_rounded: 'Content for Mic',
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
            left: 20.w,
            right: 20.w,
            child: FloatingActionButton.extended(
              onPressed: () {
                widget.onAssetsSelected?.call(_selectedAssets);
                setState(() {
                  _selectedAssets.clear();
                });
              },
              label: Text('Add ${_selectedAssets.length}'),
              icon: const Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
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

      // MODIFICATION: Wrapped the CustomScrollView in a NotificationListener
      // to correctly handle nested scrolling. This stops the parent sheet
      // from moving when the inner grid is scrolled.
      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // By returning true, we are consuming the scroll notification
          // and preventing it from bubbling up to the DraggableScrollableSheet.
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
                        child = _buildAudioItem(asset, colors, isSelected);
                      } else {
                        child =
                            AssetThumbnailItem(asset: asset, colors: colors);
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedSegment == 2) {
                              // Audio tab: allow only one selection
                              if (isSelected) {
                                _selectedAssets.remove(asset);
                              } else {
                                _selectedAssets.clear();
                                _selectedAssets.add(asset);
                              }
                            } else {
                              // Photos/Videos tab: allow multiple selections
                              if (isSelected) {
                                _selectedAssets.remove(asset);
                              } else {
                                _selectedAssets.add(asset);
                              }
                            }
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              child,
                              if (isSelected && asset.type != AssetType.audio)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
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

  Widget _buildAudioItem(
      AssetEntity asset, AppThemeColors colors, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: colors.grey4,
        borderRadius: BorderRadius.circular(8.r),
        border: isSelected
            ? Border.all(color: Theme.of(context).primaryColor, width: 3)
            : null,
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
          if (isSelected)
            Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.white.withOpacity(0.8),
                size: 32.sp,
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

// NEW WIDGET to handle thumbnail loading efficiently and prevent blinking.
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
      // Show a placeholder while loading.
      return Container(color: widget.colors.grey3);
    }

    // Once data is loaded, display the image.
    final thumbnail = Image.memory(
      _thumbnailData!,
      fit: BoxFit.cover,
      gaplessPlayback: true, // Ensures a smooth display without flickering.
    );

    if (widget.asset.type == AssetType.video) {
      return _buildVideoOverlay(widget.asset, thumbnail);
    }

    return thumbnail;
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildVideoOverlay(AssetEntity asset, Widget thumbnail) {
    final isGif = asset.title?.toLowerCase().endsWith('.gif') ?? false;

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
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'GIF',
                style: TextStyle(
                    color: Colors.white,
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
                Icon(Icons.videocam_rounded, color: Colors.white, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  _formatDuration(asset.duration),
                  style: TextStyle(
                      color: Colors.white,
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
