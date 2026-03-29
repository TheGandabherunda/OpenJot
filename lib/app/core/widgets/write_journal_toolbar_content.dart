import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/widgets/camera_view.dart';
import 'package:open_jot/app/core/widgets/custom_button.dart';
import 'package:open_jot/app/core/widgets/custom_slider.dart';
import 'package:open_jot/app/core/widgets/location_map_view.dart';
import 'package:open_jot/app/modules/media_preview/media_preview_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:progressive_blur/progressive_blur.dart';
import 'package:record/record.dart';
import 'package:shimmer/shimmer.dart';

class WriteJournalToolbarContent extends StatefulWidget {
  const WriteJournalToolbarContent({
    super.key,
    required this.selectedToolbarIcon,
    required this.scrollController,
    this.onAssetsSelected,
    this.onRecordingComplete,
    this.onLocationSelected,
    this.onPhotoTaken,
    this.onMoodChanged,
    this.selectedMoodIndex,
    this.selectedLocation,
    this.onMapMaximizeToggled,
  });

  final IconData? selectedToolbarIcon;
  final ScrollController scrollController;
  final Function(List<AssetEntity> assets)? onAssetsSelected;
  final Function(String path, Duration duration)? onRecordingComplete;
  final Function(LatLng location)? onLocationSelected;
  final Function(XFile photo)? onPhotoTaken;
  final Function(int? moodIndex)? onMoodChanged;
  final int? selectedMoodIndex;
  final LatLng? selectedLocation;
  final ValueChanged<bool>? onMapMaximizeToggled;

  @override
  State<WriteJournalToolbarContent> createState() =>
      WriteJournalToolbarContentState();
}

class WriteJournalToolbarContentState extends State<WriteJournalToolbarContent> {
  int _selectedSegment = 0;
  PermissionStatus? _permissionStatus;
  Map<DateTime, List<AssetEntity>> _groupedAssets = {};
  bool _isLoading = false;
  bool _isLoadingMore = false;
  final List<AssetEntity> _selectedAssets = [];

  // Folder & Pagination Variables
  int _currentPage = 0;
  final int _pageSize = 100;
  bool _hasMore = true;
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _selectedAlbum;

  final GlobalKey<AudioRecorderViewState> _audioRecorderKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    unawaited(_requestPermission());
  }

  @override
  void didUpdateWidget(covariant WriteJournalToolbarContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  bool get hasUnsavedContent {
    if (_selectedAssets.isNotEmpty) return true;
    if (_audioRecorderKey.currentState?.hasUnsavedRecording == true) return true;
    return false;
  }

  void clearUnsavedContent() {
    setState(() {
      _selectedAssets.clear();
    });
    _audioRecorderKey.currentState?.discardRecording(showDialog: false);
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final position = widget.scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _fetchMedia(loadMore: true);
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
        await _fetchMedia();
      }
    }
  }

  Future<void> _fetchMedia({bool loadMore = false}) async {
    if (!mounted || _isLoading || _isLoadingMore) return;
    if (loadMore && !_hasMore) return;

    setState(() {
      if (loadMore) {
        _isLoadingMore = true;
      } else {
        _isLoading = true;
        _groupedAssets = {};
        _currentPage = 0;
        _hasMore = true;
      }
    });

    // ROBUSTNESS: Add a small delay for smooth layout transitions
    if (!loadMore) await Future.delayed(const Duration(milliseconds: 100));

    final type = _getRequestTypeForSegment(_selectedSegment);

    // Fetch all folders if we don't have them loaded for this segment yet
    if (!loadMore && _albums.isEmpty) {
      final filterOption = FilterOptionGroup(
        orders: [
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        ],
      );
      final albums = await PhotoManager.getAssetPathList(
        type: type,
        hasAll: true,
        filterOption: filterOption,
      );

      if (albums.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isLoadingMore = false;
          });
        }
        return;
      }

      // Ensure "All" is always the first chip, and others are sorted alphabetically
      albums.sort((a, b) {
        if (a.isAll) return -1;
        if (b.isAll) return 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      _albums = albums;

      // Explicitly default to the "All" album
      if (_selectedAlbum == null) {
        _selectedAlbum = _albums.firstWhere((a) => a.isAll, orElse: () => _albums.first);
      }
    }

    if (_selectedAlbum == null) return;

    final start = _currentPage * _pageSize;
    final end = start + _pageSize;
    final assets = await _selectedAlbum!.getAssetListRange(start: start, end: end);

    if (assets.isEmpty || assets.length < _pageSize) {
      _hasMore = false;
    }

    if (assets.isNotEmpty) {
      final grouped = Map<DateTime, List<AssetEntity>>.from(_groupedAssets);
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
          _currentPage++;
        });
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
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

  void _openPreview() {
    final mediaItems = _selectedAssets.map((asset) {
      return MediaItem(
        asset: asset,
        type: asset.type,
        id: asset.id,
      );
    }).toList();

    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MediaPreviewBottomSheet(
        mediaItems: mediaItems,
        initialIndex: 0,
        onRemove: (item) {
          setState(() {
            _selectedAssets.removeWhere((asset) => asset.id == item.id);
          });
        },
      ),
    );
  }

  Widget _buildSelectedMediaPreviewStack() {
    if (_selectedAssets.isEmpty) return const SizedBox.shrink();

    final colors = AppTheme.colorsOf(context);
    final int count = _selectedAssets.length;
    final lastAsset = _selectedAssets.last;

    return GestureDetector(
      onTap: _openPreview,
      child: SizedBox(
        width: 56.w,
        height: 56.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (count > 2)
              Positioned(
                top: 2.h,
                left: 2.w,
                child: Transform.rotate(
                  angle: -0.15,
                  child: Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: colors.grey3,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: colors.grey6, width: 2),
                    ),
                  ),
                ),
              ),
            if (count > 1)
              Positioned(
                top: 4.h,
                right: 2.w,
                child: Transform.rotate(
                  angle: 0.15,
                  child: Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: colors.grey4,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: colors.grey6, width: 2),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 2.h,
              child: Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: colors.grey5,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: colors.grey7, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Image(
                    image: AssetEntityImageProvider(
                      lastAsset,
                      isOriginal: false,
                      thumbnailSize: const ThumbnailSize.square(150),
                      thumbnailFormat: ThumbnailFormat.jpeg,
                    ),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      lastAsset.type == AssetType.audio
                          ? Icons.audiotrack
                          : Icons.image,
                      color: colors.grey1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumChips(AppThemeColors colors) {
    if (_albums.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 36.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _albums.length,
        itemBuilder: (context, index) {
          final album = _albums[index];
          final isSelected = album == _selectedAlbum;

          // Provide a friendly name for the album
          String albumName = album.isAll ? 'All' : album.name;
          if (albumName.isEmpty) albumName = 'Folder';

          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () {
                if (!isSelected) {
                  setState(() {
                    _selectedAlbum = album;
                  });
                  _fetchMedia(loadMore: false);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor : colors.grey4,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? Theme.of(context).primaryColor : colors.grey3,
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  albumName,
                  style: TextStyle(
                    color: isSelected ? colors.grey8 : colors.grey10,
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    decoration: TextDecoration.none,
                    fontFamily: AppConstants.font,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);

    if (widget.selectedToolbarIcon == Icons.mic_rounded) {
      return AudioRecorderView(
        key: _audioRecorderKey,
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
        initialLocation: widget.selectedLocation,
        onLocationSelected: (location) {
          widget.onLocationSelected?.call(location);
        },
        onMaximizeToggled: widget.onMapMaximizeToggled,
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
      final contentText = contentMap[widget.selectedToolbarIcon] ??
          AppConstants.noContentSelected;
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
                fontFamily: AppConstants.font,
              ),
            ),
          ),
        ],
      );
    }

    // SLIVER REFACTOR: Combines the headers, media grids, loaders, and empty states
    // entirely into a single CustomScrollView with a ProgressiveBlurWidget to match home screen.
    return Stack(
      children: [
        ProgressiveBlurWidget(
          sigma: 25.0,
          linearGradientBlur: const LinearGradientBlur(
            values: [0, 0, 0.23, 1],
            stops: [0.0, 0.12, 0.88, 1.0],
            start: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          tintColor: colors.grey5.withOpacity(0.15),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              return true;
            },
            child: CustomScrollView(
              controller: widget.scrollController,
              slivers: [
                // 1. Fixed height headers (Segmented Control & Album Chips)
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                    fontFamily: AppConstants.font,
                                  ),
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
                                    fontFamily: AppConstants.font,
                                  ),
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
                                    fontFamily: AppConstants.font,
                                  ),
                                ),
                              ),
                            },
                            onValueChanged: (int? value) {
                              if (value != null) {
                                setState(() {
                                  _selectedSegment = value;
                                  _selectedAssets.clear();
                                  _albums.clear();
                                  _selectedAlbum = null;
                                });
                                unawaited(_requestPermission());
                              }
                            },
                            groupValue: _selectedSegment,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildAlbumChips(colors),
                      if (_albums.isNotEmpty) SizedBox(height: 12.h),
                    ],
                  ),
                ),

                // 2. Dynamic Content States
                if (_isLoading)
                  _buildSkeletonSliver(colors)
                else if (_permissionStatus == null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (!_permissionStatus!.isGranted)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildPermissionDenied(colors),
                    )
                  else if (_groupedAssets.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            AppConstants.noMediaFound.replaceFirst(
                                '%s', _getTabName(_selectedSegment).toLowerCase()),
                            style: TextStyle(
                              color: colors.grey10,
                              decoration: TextDecoration.none,
                              fontFamily: AppConstants.font,
                            ),
                          ),
                        ),
                      )
                    else
                      ..._buildMediaSlivers(colors),

                // 3. Pagination Loader / Bottom Padding
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h, bottom: 80.h),
                    child: _isLoadingMore
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20.h,
          left: 0,
          right: 0,
          // ANIMATION: Animate the appearance and disappearance of the 'Add' button.
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: _selectedAssets.isNotEmpty
                ? Center(
              key: const ValueKey('add_button'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSelectedMediaPreviewStack(),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () {
                      widget.onAssetsSelected?.call(_selectedAssets);
                      setState(() {
                        _selectedAssets.clear();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(60.r),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppConstants.add,
                            style: TextStyle(
                              color: colors.grey8,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppConstants.font,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            constraints: BoxConstraints(
                              minWidth: 26.w,
                              minHeight: 26.w,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            decoration: BoxDecoration(
                              color: colors.error, // Red notification badge
                              borderRadius: BorderRadius.circular(13.w),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${_selectedAssets.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppConstants.font,
                                height: 1.0,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
                : const SizedBox.shrink(key: ValueKey('empty_button')),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonSliver(AppThemeColors colors) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return Shimmer.fromColors(
              baseColor: colors.grey3,
              highlightColor: colors.grey4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  color: colors.grey3,
                ),
              ),
            );
          },
          childCount: 15,
        ),
      ),
    );
  }

  List<Widget> _buildMediaSlivers(AppThemeColors colors) {
    final sortedDates = _groupedAssets.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor =
    (isDark ? colors.grey7 : colors.grey10).withOpacity(0.5);
    final onOverlayColor = isDark ? colors.grey10 : colors.grey7;

    final slivers = <Widget>[];

    for (final date in sortedDates) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 8.h),
            child: Text(
              _formatDate(date),
              style: TextStyle(
                color: colors.grey1,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                fontSize: 15.sp,
                fontFamily: AppConstants.font,
              ),
            ),
          ),
        ),
      );

      slivers.add(
        SliverPadding(
          padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 8.h),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final assetsForDate = _groupedAssets[date];
                if (assetsForDate == null || index >= assetsForDate.length) {
                  return const SizedBox.shrink();
                }

                final asset = assetsForDate[index];
                final isSelected = _selectedAssets.contains(asset);

                Widget child;
                if (asset.type == AssetType.audio) {
                  child = _buildAudioItem(asset, colors);
                } else {
                  child = AssetThumbnailItem(asset: asset, colors: colors);
                }

                return AnimatedGridItem(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
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
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isSelected ? 1.0 : 0.0,
                            curve: Curves.easeOut,
                            child: DecoratedBox(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: _groupedAssets[date]?.length ?? 0,
            ),
          ),
        ),
      );
    }
    return slivers;
  }

  Widget _buildAudioItem(AssetEntity asset, AppThemeColors colors) {
    return DecoratedBox(
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
                  fontFamily: AppConstants.font,
                ),
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
                    fontFamily: AppConstants.font,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDenied(AppThemeColors colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppConstants.permissionRequired.replaceFirst(
              '%s', _getTabName(_selectedSegment).toLowerCase()),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.grey10,
            decoration: TextDecoration.none,
            fontFamily: AppConstants.font,
          ),
        ),
        SizedBox(height: 8.h),
        ElevatedButton(
          onPressed: () {
            unawaited(openAppSettings());
          },
          child: const Text(
            AppConstants.openSettings,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontFamily: AppConstants.font,
            ),
          ),
        ),
      ],
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

// DEFINITIVE FIX FOR GLITCHY LOADING: Replaced Stateful setup with optimized native AssetEntityImageProvider.
class AssetThumbnailItem extends StatelessWidget {
  const AssetThumbnailItem({
    super.key,
    required this.asset,
    required this.colors,
  });

  final AssetEntity asset;
  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    final imageWidget = Image(
      image: AssetEntityImageProvider(
        asset,
        isOriginal: false,
        thumbnailSize: const ThumbnailSize.square(250),
        thumbnailFormat: ThumbnailFormat.jpeg,
      ),
      fit: BoxFit.cover,
      gaplessPlayback: true,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) =>
          Container(color: colors.grey3, child: Icon(Icons.error, color: colors.grey1)),
    );

    return RepaintBoundary(
      key: ValueKey(asset.id),
      child: asset.type == AssetType.video
          ? _buildVideoOverlay(context, asset, imageWidget)
          : imageWidget,
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildVideoOverlay(BuildContext context, AssetEntity asset, Widget thumbnail) {
    final isGif = asset.title?.toLowerCase().endsWith('.gif') ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor =
    (isDark ? colors.grey7 : colors.grey10).withOpacity(0.7);
    final onOverlayColor = isDark ? colors.grey10 : colors.grey7;

    return Stack(
      fit: StackFit.expand,
      children: [
        thumbnail,
        if (isGif)
          Positioned(
            bottom: 4.h,
            right: 4.w,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: overlayColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                child: Text(
                  AppConstants.gif,
                  style: TextStyle(
                    color: onOverlayColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    fontFamily: AppConstants.font,
                  ),
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
  const AudioRecorderView({
    super.key,
    required this.scrollController,
    required this.onRecordingComplete,
  });

  final ScrollController scrollController;
  final Function(String path, Duration duration) onRecordingComplete;

  @override
  State<AudioRecorderView> createState() => AudioRecorderViewState();
}

class AudioRecorderViewState extends State<AudioRecorderView>
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

  bool get hasUnsavedRecording => _isRecording || _isPaused || (_isStopped && _recordingPath != null);

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
    unawaited(_animationController.repeat());
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
    unawaited(_animationController.repeat());
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
      unawaited(_audioPlayer.pause());
      setState(() {
        _isPlayingPreview = false;
      });
    } else if (_recordingPath != null) {
      unawaited(_audioPlayer.play(DeviceFileSource(_recordingPath!)));
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

  void discardRecording({bool showDialog = true}) {
    if (showDialog) {
      unawaited(showCupertinoDialog<void>(
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
                _performDiscard();
              },
            ),
          ],
        ),
      ));
    } else {
      _performDiscard();
    }
  }

  void _performDiscard() {
    _timer?.cancel();
    _animationController.reset();
    if (_isRecording) {
      unawaited(_audioRecorder.stop());
    }
    if (_isPlayingPreview) {
      unawaited(_audioPlayer.stop());
    }
    if (_recordingPath != null) {
      final file = File(_recordingPath!);
      if (file.existsSync()) {
        file.delete();
      }
    }
    _resetStateForNewRecording();
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
              fontSize: 16.sp,
            ),
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
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.error.withOpacity(
                                0.4 - (_animationController.value * 0.4)),
                          ),
                          child: SizedBox(
                            width: 80.w,
                            height: 80.w,
                          ),
                        ),
                      );
                    },
                  ),
                // The button itself
                GestureDetector(
                  onTap: _toggleRecording,
                  onLongPressStart: (_) => unawaited(_handleRecordPressStart()),
                  onLongPressEnd: (_) => unawaited(_handleRecordPressEnd()),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActivelyRecording
                          ? colors.error.withOpacity(0.7)
                          : colors.error,
                    ),
                    child: SizedBox(
                      width: 80.w,
                      height: 80.w,
                      child: Icon(
                        isActivelyRecording ? Icons.pause : Icons.mic,
                        color: colors.grey10,
                        size: 36.sp,
                      ),
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
                  icon: Icon(Icons.stop_circle_rounded,
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
            fontSize: 14.sp,
          ),
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
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.grey3,
              ),
              child: SizedBox(
                width: 80.w,
                height: 80.w,
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
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.error,
              ),
              child: SizedBox(
                width: 44.w,
                height: 44.w,
                child: IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: colors.grey10,
                    size: 24.sp,
                  ),
                  onPressed: () => discardRecording(showDialog: true),
                ),
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
              textPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _MoodSelectorView extends StatefulWidget {
  const _MoodSelectorView({
    required this.scrollController,
    this.onMoodChanged,
    this.initialMoodIndex,
  });

  final ScrollController scrollController;
  final Function(int? moodIndex)? onMoodChanged;
  final int? initialMoodIndex;

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
    unawaited(_rotationController.forward());
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final moodIndex = _currentSliderValue.round().clamp(0, _moods.length - 1);
    final selectedMood = _moods[moodIndex];

    final backgroundColors = [
      colors.aRed[2],
      colors.aOrange[2],
      colors.aYellow[2],
      colors.aGreen[2],
      colors.aTeal[2],
    ];

    final sliderAndTextColors = [
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
              const SizedBox(height: 0), // Space for the clear button
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
              SizedBox(height: 24.h),
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

// NEW WIDGET: A reusable animation widget for grid items.
class AnimatedGridItem extends StatefulWidget {
  const AnimatedGridItem({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    unawaited(_controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}