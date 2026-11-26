import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/services/permission_service.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/widgets/audio_spectrum_waveform.dart';
import 'package:open_jot/app/core/widgets/camera_view.dart';
import 'package:open_jot/app/core/widgets/custom_button.dart';
import 'package:open_jot/app/core/widgets/custom_slider.dart';
import 'package:open_jot/app/core/widgets/location_map_view.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/media_preview/media_preview_bottom_sheet.dart';
import 'package:open_jot/app/utils/mood_helper.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:open_jot/app/core/widgets/progressive_edge_blur.dart';
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
    this.onFilesPicked,
    this.selectedMoodIndex,
    this.selectedLocation,
    this.onMapMaximizeToggled,
    this.isPitchBlack = false,
  });

  final IconData? selectedToolbarIcon;
  final ScrollController scrollController;
  final Function(List<AssetEntity> assets)? onAssetsSelected;
  final Function(String path, Duration duration)? onRecordingComplete;
  final Function(LatLng location)? onLocationSelected;
  final Function(XFile photo)? onPhotoTaken;
  final Function(int? moodIndex)? onMoodChanged;
  final Function(List<String> paths, AssetType type)? onFilesPicked;
  final int? selectedMoodIndex;
  final LatLng? selectedLocation;
  final ValueChanged<bool>? onMapMaximizeToggled;
  final bool isPitchBlack;

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
    if (widget.selectedToolbarIcon == Icons.image_rounded) {
      unawaited(_requestPermission());
    }
  }

  @override
  void didUpdateWidget(covariant WriteJournalToolbarContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
    if (widget.selectedToolbarIcon == Icons.image_rounded &&
        oldWidget.selectedToolbarIcon != Icons.image_rounded &&
        _groupedAssets.isEmpty &&
        !_isLoading) {
      unawaited(_requestPermission());
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
    final status = await PermissionService.requestMediaPermission(_selectedSegment);
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
      _selectedAlbum ??= _albums.firstWhere((a) => a.isAll, orElse: () => _albums.first);
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
      return '${AppConstants.months[date.month - 1]} ${date.day}, ${date.year}';
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
                  child: lastAsset.type == AssetType.audio
                      ? Container(
                          color: Colors.deepPurple.shade800,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.music_note_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        )
                      : Image(
                          image: AssetEntityImageProvider(
                            lastAsset,
                            isOriginal: false,
                            thumbnailSize: const ThumbnailSize.square(300),
                            thumbnailFormat: ThumbnailFormat.jpeg,
                          ),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image,
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

  Future<void> _pickFiles() async {
    FileType type;
    AssetType assetType;
    switch (_selectedSegment) {
      case 0:
        type = FileType.media;
        assetType = AssetType.image;
        break;
      case 1:
        type = FileType.video;
        assetType = AssetType.video;
        break;
      case 2:
        type = FileType.audio;
        assetType = AssetType.audio;
        break;
      default:
        type = FileType.any;
        assetType = AssetType.other;
    }

    final files = await FilePicker.pickFiles(
      type: type,
    );

    if (files.isNotEmpty) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory(p.join(appDocDir.path, 'media'));
      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }
      final paths = <String>[];
      for (final f in files) {
        final targetName = f.name.isNotEmpty
            ? '${DateTime.now().millisecondsSinceEpoch}_${p.basename(f.name)}'
            : '${DateTime.now().millisecondsSinceEpoch}_picked';
        final persistentFile = File(p.join(mediaDir.path, targetName));
        if (f.path != null) {
          final picked = File(f.path!);
          if (await picked.exists()) {
            await picked.copy(persistentFile.path);
            paths.add(persistentFile.path);
          } else {
            paths.add(f.path!);
          }
        } else {
          await persistentFile.writeAsBytes(await f.readAsBytes());
          paths.add(persistentFile.path);
        }
      }
      if (paths.isNotEmpty) {
        widget.onFilesPicked?.call(paths, assetType);
      }
    }
  }

  Widget _buildAlbumChips(AppThemeColors colors) {
    return RepaintBoundary(
      child: SizedBox(
        height: 36.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          cacheExtent: 320.0,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: _albums.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: GestureDetector(
                  onTap: _pickFiles,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: colors.grey4,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: colors.grey3, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.folder_open_rounded,
                          size: 18.sp,
                          color: colors.grey10,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          AppConstants.browse,
                          style: TextStyle(
                            color: colors.grey10,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                            fontFamily: AppConstants.font,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (index == 1) {
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Icon(
                  Icons.more_vert_rounded,
                  size: 20.sp,
                  color: colors.grey2,
                ),
              );
            }

            final album = _albums[index - 2];
            final isSelected = album == _selectedAlbum;

            // Provide a friendly name for the album
            String albumName = album.isAll ? AppConstants.all : album.name;
            if (albumName.isEmpty) albumName = AppConstants.folder;

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
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : colors.grey4,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : colors.grey3,
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    albumName,
                    style: TextStyle(
                      color: isSelected ? colors.grey8 : colors.grey10,
                      fontSize: 13.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      decoration: TextDecoration.none,
                      fontFamily: AppConstants.font,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);

    Widget content;

    if (widget.selectedToolbarIcon == Icons.mic_rounded) {
      content = AudioRecorderView(
        key: _audioRecorderKey,
        scrollController: widget.scrollController,
        onRecordingComplete: (path, duration) {
          widget.onRecordingComplete?.call(path, duration);
        },
      );
    } else if (widget.selectedToolbarIcon == Icons.camera_alt_rounded) {
      content = CameraView(
        scrollController: widget.scrollController,
        onPhotoTaken: (photo) {
          widget.onPhotoTaken?.call(photo);
        },
      );
    } else if (widget.selectedToolbarIcon == Icons.location_on_rounded) {
      content = LocationMapView(
        scrollController: widget.scrollController,
        initialLocation: widget.selectedLocation,
        onLocationSelected: (location) {
          widget.onLocationSelected?.call(location);
        },
        onMaximizeToggled: widget.onMapMaximizeToggled,
      );
    } else if (widget.selectedToolbarIcon == Icons.sentiment_satisfied_rounded) {
      content = MoodSelectorView(
        scrollController: widget.scrollController,
        onMoodChanged: widget.onMoodChanged,
        initialMoodIndex: widget.selectedMoodIndex,
        isPitchBlack: widget.isPitchBlack,
      );
    } else if (widget.selectedToolbarIcon != Icons.image_rounded) {
      final Map<IconData, String> contentMap = {
        Icons.format_quote_rounded: AppConstants.contentForQuote,
      };
      final contentText = contentMap[widget.selectedToolbarIcon] ??
          AppConstants.noContentSelected;
      content = ListView(
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
    } else {
      content = Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              width: double.infinity,
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
                      AppConstants.videos,
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
          if (!_isLoading && _permissionStatus?.isGranted == true) ...[
            _buildAlbumChips(colors),
            SizedBox(height: 12.h),
          ],
          Expanded(
            child: RepaintBoundary(
              child: Stack(
                children: [
                  NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    return true;
                  },
                  child: CustomScrollView(
                    controller: widget.scrollController,
                    slivers: [
                      if (_isLoading)
                        _buildSkeletonSliver(colors)
                      else if (_permissionStatus == null)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: CircularProgressIndicator()),
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
                                  '%s',
                                  _getTabName(_selectedSegment).toLowerCase()),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60.h,
            child: const ProgressiveEdgeBlur(
              edge: ProgressiveBlurEdge.bottom,
              sigma: 12,
              curve: Curves.easeIn,
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 44.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        const BorderRadius.horizontal(
                                      left: Radius.circular(50),
                                      right: Radius.circular(16),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppConstants.add,
                                      textAlign: TextAlign.center,
                                      textHeightBehavior:
                                          const TextHeightBehavior(
                                        applyHeightToFirstAscent: false,
                                        applyHeightToLastDescent: false,
                                      ),
                                      style: TextStyle(
                                        color: colors.grey8,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppConstants.font,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Container(
                                  height: 44.h,
                                  constraints: BoxConstraints(minWidth: 44.h),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        const BorderRadius.horizontal(
                                      left: Radius.circular(16),
                                      right: Radius.circular(50),
                                    ),
                                  ),
                                  child: Center(
                                    widthFactor: 1.0,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        minWidth: 26.w,
                                        minHeight: 26.w,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.error,
                                        borderRadius: BorderRadius.circular(13.w),
                                      ),
                                      child: Center(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: Text(
                                          '${_selectedAssets.length}',
                                          textAlign: TextAlign.center,
                                          textHeightBehavior:
                                              const TextHeightBehavior(
                                            applyHeightToFirstAscent: false,
                                            applyHeightToLastDescent: false,
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: AppConstants.font,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 68.w),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('empty_button')),
            ),
          ),
        ],
              ),
            ),
          ),
        ],
      );
    }

    return KeyedSubtree(
      key: ValueKey(widget.selectedToolbarIcon),
      child: content,
    );
  }

  Widget _buildSkeletonSliver(AppThemeColors colors) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(4.w, 12.h, 4.w, 0),
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

    for (var i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.w, i == 0 ? 0.h : 16.h, 8.w, 8.h),
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
        return AppConstants.audio;
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
        thumbnailSize: const ThumbnailSize.square(400),
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

class AudioRecorderViewState extends State<AudioRecorderView> {
  static const int _liveBarCount = 32;
  static const int _playbackBarCount = 44;
  static const Color _appleRecordRed = Color(0xFFFF3B30);

  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isStopped = false;
  bool _isPlayingPreview = false;
  String? _recordingPath;
  Duration _recordingDuration = Duration.zero;
  Duration _playbackPosition = Duration.zero;
  Timer? _timer;
  Timer? _amplitudeTimer;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  List<double> _liveEqualizerLevels = List<double>.filled(_liveBarCount, 0.06);
  final List<double> _recordedAmplitudes = [];
  List<double> _playbackSpectrumBars = List<double>.filled(_playbackBarCount, 0.08);

  bool get hasUnsavedRecording =>
      _isRecording || _isPaused || (_isStopped && _recordingPath != null);

  @override
  void initState() {
    super.initState();
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
          if (mounted) {
            if (state == PlayerState.completed) {
              setState(() {
                _isPlayingPreview = false;
                _playbackPosition = Duration.zero;
              });
            } else {
              setState(() {
                _isPlayingPreview = state == PlayerState.playing;
              });
            }
          }
        });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _playbackPosition = position;
        });
      }
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted && duration > Duration.zero) {
        setState(() {
          _recordingDuration = duration;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _amplitudeTimer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds.clamp(0, 359999);
    final minutes = totalSeconds ~/ 60;
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _startAmplitudeSampling() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer =
        Timer.periodic(const Duration(milliseconds: 65), (_) async {
      if (!mounted || !_isRecording || _isPaused) return;
      try {
        final amp = await _audioRecorder.getAmplitude();
        final level = AudioSpectrumWaveform.normalizeDb(amp.current);
        if (!mounted || !_isRecording || _isPaused) return;
        setState(() {
          _recordedAmplitudes.add(level);
          _liveEqualizerLevels = [
            ..._liveEqualizerLevels.sublist(1),
            level.clamp(0.06, 1.0),
          ];
        });
      } catch (_) {
        // Ignore transient recorder amplitude read errors during state switches.
      }
    });
  }

  Future<void> _startRecording() async {
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${dir.path}/media');
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    final path =
        '${mediaDir.path}/OpenJot_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(const RecordConfig(), path: path);
    setState(() {
      _isRecording = true;
      _isPaused = false;
      _isStopped = false;
      _recordingPath = path;
      _recordingDuration = Duration.zero;
      _playbackPosition = Duration.zero;
      _recordedAmplitudes.clear();
      _liveEqualizerLevels = List<double>.filled(_liveBarCount, 0.06);
      _playbackSpectrumBars = List<double>.filled(_playbackBarCount, 0.08);
    });
    _startTimer();
    _startAmplitudeSampling();
  }

  Future<void> _pauseRecording() async {
    _timer?.cancel();
    _amplitudeTimer?.cancel();
    await _audioRecorder.pause();
    if (mounted) {
      setState(() {
        _isPaused = true;
      });
    }
  }

  Future<void> _resumeRecording() async {
    await _audioRecorder.resume();
    if (mounted) {
      setState(() {
        _isPaused = false;
      });
    }
    _startTimer();
    _startAmplitudeSampling();
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    _amplitudeTimer?.cancel();
    final path = await _audioRecorder.stop();
    final downsampled = AudioSpectrumWaveform.downsampleLevels(
      _recordedAmplitudes,
      targetCount: _playbackBarCount,
    );
    if (path != null && Get.isRegistered<HiveService>()) {
      AudioSpectrumWaveform.saveWaveform(
        Get.find<HiveService>(),
        path,
        downsampled,
      );
    }
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _isStopped = true;
      _recordingPath = path;
      _playbackPosition = Duration.zero;
      _playbackSpectrumBars = downsampled;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          _recordingDuration += const Duration(seconds: 1);
        });
      }
    });
  }

  Future<void> _togglePreview() async {
    if (_isPlayingPreview) {
      await _audioPlayer.pause();
      if (mounted) {
        setState(() {
          _isPlayingPreview = false;
        });
      }
    } else if (_recordingPath != null) {
      await _audioPlayer.play(DeviceFileSource(_recordingPath!));
      if (_playbackPosition > Duration.zero &&
          _playbackPosition < _recordingDuration) {
        await _audioPlayer.seek(_playbackPosition);
      }
      if (mounted) {
        setState(() {
          _isPlayingPreview = true;
        });
      }
    }
  }

  void _seekToProgress(double progress) {
    if (_recordingDuration <= Duration.zero) return;
    final targetMs = (_recordingDuration.inMilliseconds * progress).round();
    final target = Duration(milliseconds: targetMs);
    setState(() {
      _playbackPosition = target;
    });
    unawaited(_audioPlayer.seek(target));
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
    _amplitudeTimer?.cancel();
    if (_isRecording) {
      unawaited(_audioRecorder.stop());
    }
    if (_isPlayingPreview) {
      unawaited(_audioPlayer.stop());
    }
    if (_recordingPath != null) {
      if (Get.isRegistered<HiveService>()) {
        AudioSpectrumWaveform.deleteWaveform(
          Get.find<HiveService>(),
          _recordingPath!,
        );
      }
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
      _playbackPosition = Duration.zero;
      _recordedAmplitudes.clear();
      _liveEqualizerLevels = List<double>.filled(_liveBarCount, 0.06);
      _playbackSpectrumBars = List<double>.filled(_playbackBarCount, 0.08);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final double playbackProgress = _recordingDuration.inMilliseconds > 0
        ? (_playbackPosition.inMilliseconds / _recordingDuration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
            child: Column(
              children: [
                if (_isStopped) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildHeaderCircleButton(
                        backgroundColor: colors.grey4,
                        icon: Icons.delete_outline_rounded,
                        iconColor: _appleRecordRed,
                        onPressed: () => discardRecording(showDialog: true),
                      ),
                      _buildHeaderCircleButton(
                        backgroundColor: Theme.of(context).primaryColor,
                        icon: Icons.check_rounded,
                        iconColor: colors.grey8,
                        onPressed: _addRecording,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    AppConstants.listen,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.grey1,
                      fontFamily: AppConstants.font,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${_formatDuration(_playbackPosition)} / ${_formatDuration(_recordingDuration)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      fontSize: 18.sp,
                      color: colors.grey10,
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [ui.FontFeature.tabularFigures()],
                      decoration: TextDecoration.none,
                    ),
                  ),
                ] else if (_isRecording) ...[
                  SizedBox(height: 16.h),
                  Text(
                    _isPaused ? AppConstants.paused : 'Recording',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isPaused ? colors.grey1 : _appleRecordRed,
                      fontFamily: AppConstants.font,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatDuration(_recordingDuration),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      fontSize: 18.sp,
                      color: colors.grey10,
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [ui.FontFeature.tabularFigures()],
                      decoration: TextDecoration.none,
                    ),
                  ),
                ] else ...[
                  SizedBox(height: 16.h),
                  Text(
                    _formatDuration(_recordingDuration),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      fontSize: 15.sp,
                      color: colors.grey1,
                      fontWeight: FontWeight.w500,
                      fontFeatures: const [ui.FontFeature.tabularFigures()],
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: _isStopped
                          ? AudioSpectrumWaveform(
                              levels: _playbackSpectrumBars,
                              progress: playbackProgress,
                              activeColor: colors.grey10,
                              inactiveColor: colors.grey3,
                              playheadColor: _appleRecordRed,
                              height: 92.h,
                              onSeek: _seekToProgress,
                            )
                          : _isRecording
                              ? AudioSpectrumWaveform(
                                  levels: _liveEqualizerLevels,
                                  activeColor:
                                      _isPaused ? colors.grey1 : _appleRecordRed,
                                  inactiveColor: colors.grey3,
                                  height: 92.h,
                                )
                              : Text(
                                  'Start Audio Recording',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppConstants.font,
                                    fontSize: 16.sp,
                                    color: colors.grey2,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                    ),
                  ),
                ),
                if (_isStopped)
                  _buildPreviewControls(colors)
                else
                  _buildRecordingControls(colors),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingControls(AppThemeColors colors) {
    if (!_isRecording) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: GestureDetector(
          onTap: () => unawaited(_startRecording()),
          child: Container(
            width: 68.w,
            height: 68.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.grey3,
                width: 2.5,
              ),
            ),
            padding: EdgeInsets.all(4.w),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _appleRecordRed,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 24.w),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.grey4,
                  ),
                  child: SizedBox(
                    width: 44.w,
                    height: 44.w,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        _isPaused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        color: colors.grey10,
                        size: 24.sp,
                      ),
                      onPressed: () {
                        if (_isPaused) {
                          unawaited(_resumeRecording());
                        } else {
                          unawaited(_pauseRecording());
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => unawaited(_stopRecording()),
            child: Container(
              width: 68.w,
              height: 68.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.grey3,
                  width: 2.5,
                ),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: _appleRecordRed,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildHeaderCircleButton({
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        color: iconColor,
        size: 28,
      ),
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
      ),
    );
  }

  Widget _buildPreviewControls(AppThemeColors colors) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Center(
        child: GestureDetector(
          onTap: () => unawaited(_togglePreview()),
          child: Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.grey10,
            ),
            child: Icon(
              _isPlayingPreview
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: colors.grey8,
              size: 32.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class MoodSelectorView extends StatefulWidget {
  const MoodSelectorView({
    super.key,
    required this.scrollController,
    this.onMoodChanged,
    this.initialMoodIndex,
    this.isPitchBlack = false,
  });

  final ScrollController scrollController;
  final Function(int? moodIndex)? onMoodChanged;
  final int? initialMoodIndex;
  final bool isPitchBlack;

  @override
  State<MoodSelectorView> createState() => MoodSelectorViewState();
}

class MoodSelectorViewState extends State<MoodSelectorView>
    with TickerProviderStateMixin {
  late int _currentMoodIndex;
  late double _lastSliderValue;

  // Track total turns for smooth continuous rotation
  double _targetTurns = 0.0;

  static const List<Map<String, String>> _moods = AppConstants.moods;

  @override
  void initState() {
    super.initState();
    _currentMoodIndex = widget.initialMoodIndex ?? 3;
    _lastSliderValue = _currentMoodIndex.toDouble();
    _targetTurns = _currentMoodIndex.toDouble();
    if (widget.initialMoodIndex == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onMoodChanged?.call(3);
        }
      });
    }
  }


  void _updateRotation(int newIndex) {
    // Ensuring an integer number of turns ensures the logo is perfectly upright at each stop.
    _targetTurns = newIndex.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // We use a double mood index for continuous color transitions
    final double displayIndex = _lastSliderValue.clamp(0.0, 6.0);
    final int floorIndex = displayIndex.floor();
    final int ceilIndex = displayIndex.ceil();
    final double t = displayIndex - floorIndex;

    final moodIndex = _currentMoodIndex.clamp(0, _moods.length - 1);
    final selectedMood = _moods[moodIndex];

    // Harmonious theme-aware color lists
    final moodThemeColors = List.generate(
      _moods.length,
      (i) => MoodHelper.getMoodThemeColors(i, colors, isDark),
    );

    final backgroundColors = [
      moodThemeColors[0][2],
      moodThemeColors[1][2],
      moodThemeColors[2][2],
      moodThemeColors[3][2],
      moodThemeColors[4][2],
      moodThemeColors[5][2],
      moodThemeColors[6][2],
    ];

    final normalColors = [
      moodThemeColors[0][1],
      moodThemeColors[1][1],
      moodThemeColors[2][1],
      moodThemeColors[3][1],
      moodThemeColors[4][1],
      moodThemeColors[5][1],
      moodThemeColors[6][1],
    ];

    final accentColors = [
      moodThemeColors[0][0],
      moodThemeColors[1][0],
      moodThemeColors[2][0],
      moodThemeColors[3][0],
      moodThemeColors[4][0],
      moodThemeColors[5][0],
      moodThemeColors[6][0],
    ];

    // Helper to lerp between two indices in the color lists
    Color lerpMoodColor(List<Color> colorList, int i1, int i2, double t) {
      return Color.lerp(colorList[i1], colorList[i2], t)!;
    }

    // Calculate interpolated colors for fluid background "wash"
    final Color currentAccent = lerpMoodColor(accentColors, floorIndex, ceilIndex, t);
    final Color currentNormal = lerpMoodColor(normalColors, floorIndex, ceilIndex, t);
    final Color currentBg = lerpMoodColor(backgroundColors, floorIndex, ceilIndex, t);

    final Color inactiveColor = isDark
        ? currentAccent.withOpacity(0.1)
        : currentAccent.withOpacity(0.12);

    final decoration = widget.isPitchBlack
        ? BoxDecoration(color: isDark ? Colors.black : Colors.white)
        : MoodHelper.buildMoodWashDecoration(
            currentAccent,
            currentNormal,
            currentBg,
            isDark: isDark,
          );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      decoration: decoration,
      child: Stack(
        children: [
          CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 68.h, 24.w, 12.h),
                  child: Column(
                    children: [
                      Text(
                        'How are you feeling?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.grey10,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppConstants.font,
                          decoration: TextDecoration.none,
                          letterSpacing: -0.4,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: AnimatedRotation(
                                turns: _targetTurns,
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.easeOutBack,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Lush Glow behind the icon
                                    Container(
                                      width: 168.w,
                                      height: 168.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: currentAccent.withOpacity(
                                                isDark ? 0.25 : 0.15),
                                            blurRadius: 50,
                                            spreadRadius: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RepaintBoundary(
                                      child: IndexedStack(
                                        index: moodIndex,
                                        alignment: Alignment.center,
                                        children:
                                            List.generate(_moods.length, (idx) {
                                          return Obx(() {
                                            final HomeController controller =
                                                Get.find();
                                            final rasterizedImage =
                                                controller.moodImagesLarge[idx];

                                            if (rasterizedImage != null) {
                                              return RawImage(
                                                image: rasterizedImage,
                                                width: 180.w,
                                                height: 180.w,
                                                filterQuality:
                                                    ui.FilterQuality.high,
                                              );
                                            }

                                            return MoodHelper.buildMoodSvg(
                                              idx,
                                              width: 180.w,
                                              height: 180.w,
                                            );
                                          });
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 18.h),
                            Center(
                              child: SizedBox(
                                height: 36.h,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  layoutBuilder:
                                      (currentChild, previousChildren) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ...previousChildren,
                                        if (currentChild != null) currentChild,
                                      ],
                                    );
                                  },
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0, 0.2),
                                          end: Offset.zero,
                                        ).animate(CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOutCubic,
                                        )),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    selectedMood['label']!,
                                    key: ValueKey(selectedMood['label']),
                                    style: TextStyle(
                                      color: currentAccent,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppConstants.font,
                                      decoration: TextDecoration.none,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 92.h,
                        child: CustomSliderWithTooltip(
                          min: 0,
                          max: 6,
                          divisions: 6,
                          initialValue: _lastSliderValue,
                          showValueTooltip: false,
                          minLabel: AppConstants.veryUnpleasant,
                          maxLabel: AppConstants.veryPleasant,
                          labelTextStyle: TextStyle(
                            color: currentAccent.withOpacity(isDark ? 0.65 : 0.72),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppConstants.font,
                            decoration: TextDecoration.none,
                            letterSpacing: 0.3,
                          ),
                          activeColor: currentAccent,
                          unfocusedActiveColor: currentAccent.withOpacity(0.8),
                          inactiveColor: inactiveColor,
                          dividerColor: isDark ? Colors.white : currentAccent.withOpacity(0.8),
                          focusedTrackHeight: 34.h,
                          unfocusedTrackHeight: 28.h,
                          onChanged: (value) {
                            setState(() {
                              _lastSliderValue = value;
                              final newIndex = value.round();
                              if (newIndex != _currentMoodIndex) {
                                widget.onMoodChanged?.call(newIndex);
                                _updateRotation(newIndex);
                                _currentMoodIndex = newIndex;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (widget.initialMoodIndex != null)
            Positioned(
              top: 8.h,
              right: 16.w,
              child: TextButton(
                onPressed: () {
                  widget.onMoodChanged?.call(null);
                },
                style: TextButton.styleFrom(
                  foregroundColor: currentAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                child: Text(
                  AppConstants.clear,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
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