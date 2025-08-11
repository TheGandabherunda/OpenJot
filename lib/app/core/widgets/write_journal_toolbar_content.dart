import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../theme.dart';

class WriteJournalToolbarContent extends StatefulWidget {
  final IconData? selectedToolbarIcon;
  final ScrollController scrollController;

  const WriteJournalToolbarContent({
    super.key,
    required this.selectedToolbarIcon,
    required this.scrollController,
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

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final permission = _getPermissionForSegment(_selectedSegment);
    final status = await permission.request();
    setState(() {
      _permissionStatus = status;
    });
    if (status.isGranted) {
      _fetchMedia();
    }
  }

  Future<void> _fetchMedia() async {
    setState(() {
      _isLoading = true;
      _groupedAssets = {};
    });

    final type = _getRequestTypeForSegment(_selectedSegment);
    final albums = await PhotoManager.getAssetPathList(type: type);
    if (albums.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final List<AssetEntity> assets = [];
    final Set<String> processedAssetIds = <String>{};
    for (final album in albums) {
      final assetList = await album.getAssetListRange(start: 0, end: 1000);
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
      if (grouped[date] == null) {
        grouped[date] = [];
      }
      grouped[date]!.add(asset);
    }

    setState(() {
      _groupedAssets = grouped;
      _isLoading = false;
    });
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
        'June','July',
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
                  color: colors.grey10, decoration: TextDecoration.none),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        CupertinoSlidingSegmentedControl<int>(
          children: const {
            0: Text('Photos',
                style: TextStyle(decoration: TextDecoration.none)),
            1: Text('Video', style: TextStyle(decoration: TextDecoration.none)),
            2: Text('Music', style: TextStyle(decoration: TextDecoration.none)),
          },
          onValueChanged: (int? value) {
            if (value != null) {
              setState(() {
                _selectedSegment = value;
              });
              _requestPermission();
            }
          },
          groupValue: _selectedSegment,
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: _buildMediaGrid(colors),
        ),
      ],
    );
  }

  Widget _buildMediaGrid(AppThemeColors colors) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_permissionStatus == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_permissionStatus!.isGranted) {
      if (_groupedAssets.isEmpty) {
        return Center(
          child: Text(
            'No ${_getTabName(_selectedSegment).toLowerCase()}s found.',
            style: TextStyle(
                color: colors.grey10, decoration: TextDecoration.none),
          ),
        );
      }
      final sortedDates = _groupedAssets.keys.toList()
        ..sort((a, b) => b.compareTo(a));

      return CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          for (final date in sortedDates) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 8.h),
                child: Text(
                  _formatDate(date),
                  style: TextStyle(
                    color: colors.grey10,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final asset = _groupedAssets[date]![index];
                    if (asset.type == AssetType.audio) {
                      return Container(
                        decoration: BoxDecoration(
                          color: colors.grey3,
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
                                      decoration: TextDecoration.none),
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
                                  Icon(Icons.music_note,
                                      color: colors.grey10, size: 16.sp),
                                  SizedBox(width: 4.w),
                                  Text(
                                    _formatDuration(asset.duration),
                                    style: TextStyle(
                                        color: colors.grey10,
                                        fontSize: 12.sp,
                                        decoration: TextDecoration.none),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: FutureBuilder<Uint8List?>(
                        future: asset.thumbnailData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done &&
                              snapshot.data != null) {
                            Widget thumbnail = Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                            if (asset.type == AssetType.video) {
                              // Debug: Print the asset title to see what we're getting
                              print('Video asset title: "${asset.title}"');

                              // Check if it's a GIF by file extension immediately
                              final isGif = asset.title?.toLowerCase().contains('gif') ?? false;
                              print('Is GIF: $isGif');

                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  thumbnail,
                                  if (isGif) ...[
                                    // GIF: Only show GIF icon, no duration, no overlay
                                    Positioned(
                                      bottom: 4.h,
                                      left: 4.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.w,
                                            vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withOpacity(0.7),
                                          borderRadius:
                                          BorderRadius.circular(4.r),
                                        ),
                                        child: Icon(
                                          Icons.gif,
                                          color: Colors.white,
                                          size: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    // Regular video: Show overlay + video icon + duration
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 4.h,
                                      left: 4.w,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.videocam_rounded,
                                            color: Colors.white,
                                            size: 16.sp,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            _formatDuration(asset.duration),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight:
                                                FontWeight.bold,
                                                decoration:
                                                TextDecoration.none),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            }
                            return thumbnail;
                          }
                          return Container(
                            color: colors.grey3,
                          );
                        },
                      ),
                    );
                  },
                  childCount: _groupedAssets[date]!.length,
                ),
              ),
            ),
          ],
        ],
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Permission to access ${_getTabName(_selectedSegment).toLowerCase()} is required to display them.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: colors.grey10, decoration: TextDecoration.none),
            ),
            SizedBox(height: 8.h),
            ElevatedButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text(
                'Open Settings',
                style: TextStyle(decoration: TextDecoration.none),
              ),
            ),
          ],
        ),
      );
    }
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'Photo';
      case 1:
        return 'Video';
      case 2:
        return 'Music';
      default:
        return '';
    }
  }
}