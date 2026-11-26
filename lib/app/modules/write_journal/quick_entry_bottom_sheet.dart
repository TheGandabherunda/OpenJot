import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/models/journal_entry.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/services/permission_service.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/widgets/journal_tile.dart';
import 'package:open_jot/app/core/widgets/location_card_content.dart';
import 'package:open_jot/app/core/widgets/write_journal_toolbar_content.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/write_journal/write_journal_bottom_sheet.dart';
import 'package:open_jot/app/utils/custom_toast.dart';
import 'package:open_jot/app/utils/foss_location.dart';
import 'package:open_jot/app/utils/mood_helper.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;
import 'package:uuid/uuid.dart';

/// Apple Journal-style pre-compose modal shown when tapping the home `+` button.
/// Lets users attach media, location, date/time, and mood, then either save directly
/// without writing text or continue into the full editor.
class QuickEntryBottomSheet extends StatefulWidget {
  const QuickEntryBottomSheet({super.key});

  @override
  State<QuickEntryBottomSheet> createState() => _QuickEntryBottomSheetState();
}

enum _PreviewCardType { media, audio, recording, location, mood }

class _PreviewCardItem {
  final _PreviewCardType type;
  final dynamic payload;
  final VoidCallback onRemove;

  const _PreviewCardItem({
    required this.type,
    required this.payload,
    required this.onRemove,
  });
}

class _QuickEntryBottomSheetState extends State<QuickEntryBottomSheet> {
  final HomeController _homeController = Get.find<HomeController>();
  final PageController _pageController = PageController(viewportFraction: 0.72);
  final GlobalKey _moreMenuKey = GlobalKey();

  DateTime _selectedDate = DateTime.now();
  bool _isCustomDate = false;
  int? _selectedMoodIndex;
  SelectedLocation? _selectedLocation;
  final List<AssetEntity> _previewImages = [];
  final List<CapturedPhoto> _previewPhotos = [];
  final List<AssetEntity> _previewAudios = [];
  final List<RecordedAudio> _previewRecordings = [];
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _hasAnyItem =>
      _previewImages.isNotEmpty ||
      _previewPhotos.isNotEmpty ||
      _previewAudios.isNotEmpty ||
      _previewRecordings.isNotEmpty ||
      _selectedLocation != null ||
      _selectedMoodIndex != null;

  bool get _hasUnsavedSelections => _hasAnyItem || _isCustomDate;

  List<_PreviewCardItem> _buildPreviewItems() {
    final items = <_PreviewCardItem>[];

    for (final asset in _previewImages) {
      items.add(_PreviewCardItem(
        type: _PreviewCardType.media,
        payload: asset,
        onRemove: () => setState(() => _previewImages.remove(asset)),
      ));
    }
    for (final photo in _previewPhotos) {
      items.add(_PreviewCardItem(
        type: _PreviewCardType.media,
        payload: photo,
        onRemove: () => setState(() => _previewPhotos.remove(photo)),
      ));
    }
    for (final audio in _previewAudios) {
      items.add(_PreviewCardItem(
        type: _PreviewCardType.audio,
        payload: audio,
        onRemove: () => setState(() => _previewAudios.remove(audio)),
      ));
    }
    for (final rec in _previewRecordings) {
      items.add(_PreviewCardItem(
        type: _PreviewCardType.recording,
        payload: rec,
        onRemove: () => setState(() => _previewRecordings.remove(rec)),
      ));
    }
    if (_selectedLocation != null) {
      items.add(_PreviewCardItem(
        type: _PreviewCardType.location,
        payload: _selectedLocation,
        onRemove: () => setState(() => _selectedLocation = null),
      ));
    }
    if (_selectedMoodIndex != null) {
      items.add(_PreviewCardItem(
        type: _PreviewCardType.mood,
        payload: _selectedMoodIndex,
        onRemove: () => setState(() => _selectedMoodIndex = null),
      ));
    }

    return items;
  }

  String _buildSummaryText() {
    final parts = <String>[];
    if (_selectedLocation != null) {
      parts.add(
        FossLocation.getCachedPlaceName(_selectedLocation!.coordinates) ??
            '1 Location',
      );
    }
    final visualCount = _previewImages.length + _previewPhotos.length;
    if (visualCount > 0) {
      parts.add('$visualCount Media');
    }
    final audioCount = _previewAudios.length + _previewRecordings.length;
    if (audioCount > 0) {
      parts.add('$audioCount ${audioCount == 1 ? 'Audio' : 'Audios'}');
    }
    if (_selectedMoodIndex != null) {
      parts.add(AppConstants.moods[_selectedMoodIndex!]['label'] ?? 'Mood');
    }
    if (parts.isEmpty) {
      return DateFormat('h:mm a').format(_selectedDate);
    }
    return parts.join('  •  ');
  }

  Future<bool> _confirmDiscardIfNeeded() async {
    if (!_hasUnsavedSelections) return true;
    final colors = AppTheme.colorsOf(context);
    final discard = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text(
          AppConstants.discardChanges,
          style: TextStyle(fontFamily: AppConstants.font),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text(
            'Discard the selected items for this entry?',
            style: TextStyle(fontFamily: AppConstants.font),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              AppConstants.cancel,
              style: TextStyle(
                fontFamily: AppConstants.font,
                color: colors.grey10,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              AppConstants.discard,
              style: TextStyle(fontFamily: AppConstants.font),
            ),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  Future<void> _handleClose() async {
    final shouldPop = await _confirmDiscardIfNeeded();
    if (shouldPop && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDateTime() async {
    final appThemeColors = AppTheme.colorsOf(context);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: appThemeColors.grey6,
              headerBackgroundColor: appThemeColors.grey5,
              headerForegroundColor: appThemeColors.grey10,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              surface: appThemeColors.grey5,
              onSurface: appThemeColors.grey10,
              primary: appThemeColors.primary,
              onPrimary: appThemeColors.onPrimary,
            ),
            dialogBackgroundColor: appThemeColors.grey5,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: appThemeColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: appThemeColors.grey6,
              hourMinuteTextColor: appThemeColors.grey10,
              hourMinuteColor: appThemeColors.grey4,
              dayPeriodTextColor: appThemeColors.grey10,
              dayPeriodColor: appThemeColors.grey4,
              dialHandColor: appThemeColors.primary,
              dialBackgroundColor: appThemeColors.grey5,
              entryModeIconColor: appThemeColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              surface: appThemeColors.grey5,
              onSurface: appThemeColors.grey10,
              primary: appThemeColors.primary,
              onPrimary: appThemeColors.onPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: appThemeColors.primary,
              ),
            ),
            dialogBackgroundColor: appThemeColors.grey6,
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && mounted) {
      setState(() {
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _isCustomDate = true;
      });
    }
  }

  Future<bool> _ensurePermissionForTool(IconData icon) async {
    if (icon == Icons.image_rounded) {
      final status = await PermissionService.requestMediaPermission(0);
      return status.isGranted;
    }
    if (icon == Icons.camera_alt_rounded) {
      final status = await Permission.camera.request();
      return status.isGranted;
    }
    if (icon == Icons.mic_rounded) {
      final status = await Permission.microphone.request();
      return status.isGranted;
    }
    if (icon == Icons.location_on_rounded) {
      final enabled = await FossLocation.isLocationServiceEnabled();
      if (!enabled) {
        await FossLocation.openLocationSettings();
        return false;
      }
      final status = await Permission.locationWhenInUse.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> _openMediaSheet() async {
    final hasLibrary = await _ensurePermissionForTool(Icons.image_rounded);
    if (!hasLibrary || !mounted) return;
    await _openToolPickerSheet(Icons.image_rounded, allowMediaSwitch: true);
  }

  Future<void> _openLocationSheet() async {
    final granted = await _ensurePermissionForTool(Icons.location_on_rounded);
    if (!granted || !mounted) return;
    await _openToolPickerSheet(Icons.location_on_rounded);
  }

  Future<void> _openMoodSheet() async {
    await _openToolPickerSheet(Icons.sentiment_satisfied_rounded);
  }

  Future<void> _openToolPickerSheet(
    IconData initialIcon, {
    bool allowMediaSwitch = false,
  }) async {
    final colors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = Get.find<HiveService>().pitchBlack;
    final sheetColor = isPitchBlack
        ? (isDark ? Colors.black : Colors.white)
        : colors.grey6;

    IconData activeIcon = initialIcon;
    final scrollController = ScrollController();

    await showCupertinoModalBottomSheet<void>(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final title = _titleForTool(activeIcon);
            return SafeArea(
              child: Scaffold(
                backgroundColor: sheetColor,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  surfaceTintColor: Colors.transparent,
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.close_rounded, color: colors.grey10),
                    onPressed: () => Navigator.of(modalContext).pop(),
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: colors.grey10,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2,
                    ),
                  ),
                  actions: [
                    if (allowMediaSwitch) ...[
                      IconButton(
                        icon: Icon(
                          Icons.photo_library_rounded,
                          color: activeIcon == Icons.image_rounded
                              ? colors.primary
                              : colors.grey2,
                        ),
                        onPressed: () async {
                          if (await _ensurePermissionForTool(
                              Icons.image_rounded)) {
                            setModalState(
                                () => activeIcon = Icons.image_rounded);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt_rounded,
                          color: activeIcon == Icons.camera_alt_rounded
                              ? colors.primary
                              : colors.grey2,
                        ),
                        onPressed: () async {
                          if (await _ensurePermissionForTool(
                              Icons.camera_alt_rounded)) {
                            setModalState(
                                () => activeIcon = Icons.camera_alt_rounded);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.mic_rounded,
                          color: activeIcon == Icons.mic_rounded
                              ? colors.primary
                              : colors.grey2,
                        ),
                        onPressed: () async {
                          if (await _ensurePermissionForTool(
                              Icons.mic_rounded)) {
                            setModalState(() => activeIcon = Icons.mic_rounded);
                          }
                        },
                      ),
                    ],
                    if (activeIcon == Icons.sentiment_satisfied_rounded)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedMoodIndex ??= 3;
                          });
                          Navigator.of(modalContext).pop();
                        },
                        child: Text(
                          AppConstants.done,
                          style: TextStyle(
                            color: colors.primary,
                            fontFamily: AppConstants.font,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                  ],
                ),
                body: WriteJournalToolbarContent(
                  selectedToolbarIcon: activeIcon,
                  scrollController: scrollController,
                  selectedMoodIndex: _selectedMoodIndex,
                  selectedLocation: _selectedLocation?.coordinates,
                  isPitchBlack: isPitchBlack,
                  onAssetsSelected: (assets) {
                    setState(() {
                      final imagesAndVideos = assets
                          .where((a) =>
                              a.type == AssetType.image ||
                              a.type == AssetType.video)
                          .toList();
                      final audios =
                          assets.where((a) => a.type == AssetType.audio).toList();
                      final existingImageIds =
                          _previewImages.map((e) => e.id).toSet();
                      imagesAndVideos.removeWhere(
                          (asset) => existingImageIds.contains(asset.id));
                      _previewImages.addAll(imagesAndVideos);

                      final existingAudioIds =
                          _previewAudios.map((e) => e.id).toSet();
                      audios.removeWhere(
                          (asset) => existingAudioIds.contains(asset.id));
                      _previewAudios.addAll(audios);
                    });
                    Navigator.of(modalContext).pop();
                  },
                  onFilesPicked: (paths, type) {
                    setState(() {
                      if (type == AssetType.audio) {
                        for (final path in paths) {
                          _previewRecordings.add(RecordedAudio(
                            path: path,
                            name: p.basename(path),
                            duration: Duration.zero,
                            isShared: true,
                          ));
                        }
                      } else {
                        for (final path in paths) {
                          _previewPhotos.add(CapturedPhoto(
                            file: XFile(path),
                            name: p.basename(path),
                          ));
                        }
                      }
                    });
                    Navigator.of(modalContext).pop();
                  },
                  onPhotoTaken: (photo) {
                    setState(() {
                      final name = AppConstants.openJotImage.replaceFirst(
                        '%s',
                        (_previewPhotos.length + 1).toString(),
                      );
                      _previewPhotos.add(CapturedPhoto(
                        file: photo,
                        name: name,
                      ));
                    });
                    Navigator.of(modalContext).pop();
                  },
                  onRecordingComplete: (path, duration) {
                    setState(() {
                      final name = AppConstants.openJotRecording.replaceFirst(
                        '%s',
                        (_previewRecordings.length + 1).toString(),
                      );
                      _previewRecordings.add(RecordedAudio(
                        path: path,
                        name: name,
                        duration: duration,
                      ));
                    });
                    Navigator.of(modalContext).pop();
                  },
                  onLocationSelected: (location) {
                    setState(() {
                      final link =
                          'geo:${location.latitude},${location.longitude}?q=${location.latitude},${location.longitude}';
                      _selectedLocation =
                          SelectedLocation(coordinates: location, link: link);
                    });
                    unawaited(FossLocation.getPlaceName(location).then((_) {
                      if (mounted) setState(() {});
                    }));
                    Navigator.of(modalContext).pop();
                  },
                  onMoodChanged: (index) {
                    setState(() {
                      _selectedMoodIndex = index;
                    });
                    if (index == null) {
                      Navigator.of(modalContext).pop();
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(scrollController.dispose);
  }

  String _titleForTool(IconData icon) {
    if (icon == Icons.camera_alt_rounded) return 'Camera';
    if (icon == Icons.mic_rounded) return 'Record Audio';
    if (icon == Icons.location_on_rounded) return 'Add Location';
    if (icon == Icons.sentiment_satisfied_rounded) return 'Select Mood';
    return 'Add Media';
  }

  void _startWriting() {
    HapticFeedback.lightImpact();
    final navigator = Navigator.of(context);
    final rootContext = navigator.context;
    navigator.pop();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCupertinoModalBottomSheet(
        context: rootContext,
        expand: true,
        backgroundColor: null,
        bounce: true,
        animationCurve: Curves.easeOutCubic,
        duration: const Duration(milliseconds: 400),
        builder: (modalContext) {
          return SafeArea(
            child: WriteJournalBottomSheet(
              initialDate: _selectedDate,
              initialIsCustomDate: _isCustomDate,
              initialMoodIndex: _selectedMoodIndex,
              initialLocation: _selectedLocation,
              initialGalleryImages: List.from(_previewImages),
              initialCameraPhotos: List.from(_previewPhotos),
              initialGalleryAudios: List.from(_previewAudios),
              initialRecordings: List.from(_previewRecordings),
            ),
          );
        },
      );
    });
  }

  void _saveWithoutWriting() {
    if (!_hasAnyItem) {
      CustomToast.showToast('Add media, location, or mood first');
      return;
    }

    HapticFeedback.mediumImpact();
    final entry = JournalEntry(
      id: const Uuid().v4(),
      content: quill.Document(),
      createdAt: _selectedDate,
      moodIndex: _selectedMoodIndex,
      location: _selectedLocation,
      galleryImages: List.from(_previewImages),
      cameraPhotos: List.from(_previewPhotos),
      galleryAudios: List.from(_previewAudios),
      recordings: List.from(_previewRecordings),
    );
    _homeController.addJournalEntry(entry);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = Get.find<HiveService>().pitchBlack;

    final backgroundColor = isPitchBlack
        ? (isDark ? Colors.black : Colors.white)
        : colors.grey6;
    final tileBackgroundColor = isPitchBlack
        ? (isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.black.withOpacity(0.04))
        : colors.grey5;

    final previewItems = _buildPreviewItems();
    if (_currentPage >= previewItems.length && previewItems.isNotEmpty) {
      _currentPage = previewItems.length - 1;
    }

    return WillPopScope(
      onWillPop: _confirmDiscardIfNeeded,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.close_rounded, color: colors.grey10),
            onPressed: _handleClose,
          ),
          title: Text(
            'New Entry',
            style: TextStyle(
              color: colors.grey10,
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
            ),
          ),
          actions: [
            IconButton(
              key: _moreMenuKey,
              icon: Icon(Icons.more_horiz_rounded, color: colors.grey10),
              onPressed: () => _showAddOptionsMenu(context),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickDateTime,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('EEEE, MMM d').format(_selectedDate),
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp,
                            color: colors.grey10,
                            letterSpacing: -0.4,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.edit_rounded,
                          size: 16.sp,
                          color: colors.primary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _buildSummaryText(),
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      fontSize: 13.sp,
                      color: colors.grey2,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: _buildPreviewCarousel(
                  previewItems,
                  colors,
                  tileBackgroundColor,
                ),
              ),
            ),
            _buildBottomActions(colors),
          ],
        ),
      ),
    );
  }

  void _showAddOptionsMenu(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final renderBox =
        _moreMenuKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      color: colors.grey5,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      position: RelativeRect.fromLTRB(
        position.dx - renderBox.size.width * 2,
        position.dy + renderBox.size.height + 8,
        position.dx + renderBox.size.width,
        position.dy + renderBox.size.height * 2,
      ),
      items: [
        PopupMenuItem(
          value: 'media',
          child: _buildMenuOptionRow(
            colors: colors,
            label: 'Media',
            icon: Icons.perm_media_rounded,
          ),
        ),
        PopupMenuDivider(height: 1, color: colors.grey6),
        PopupMenuItem(
          value: 'location',
          child: _buildMenuOptionRow(
            colors: colors,
            label: 'Location',
            icon: Icons.location_on_rounded,
          ),
        ),
        PopupMenuDivider(height: 1, color: colors.grey6),
        PopupMenuItem(
          value: 'date',
          child: _buildMenuOptionRow(
            colors: colors,
            label: 'Date',
            icon: Icons.calendar_today_rounded,
          ),
        ),
        PopupMenuDivider(height: 1, color: colors.grey6),
        PopupMenuItem(
          value: 'mood',
          child: _buildMenuOptionRow(
            colors: colors,
            label: 'Mood',
            icon: Icons.sentiment_satisfied_rounded,
          ),
        ),
      ],
    ).then((value) {
      if (value == 'media') {
        unawaited(_openMediaSheet());
      } else if (value == 'location') {
        unawaited(_openLocationSheet());
      } else if (value == 'date') {
        unawaited(_pickDateTime());
      } else if (value == 'mood') {
        unawaited(_openMoodSheet());
      }
    });
  }

  Widget _buildMenuOptionRow({
    required AppThemeColors colors,
    required String label,
    required IconData icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.grey10,
            fontFamily: AppConstants.font,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(width: 12.w),
        Icon(icon, color: colors.grey10),
      ],
    );
  }

  Widget _buildPreviewCarousel(
    List<_PreviewCardItem> items,
    AppThemeColors colors,
    Color tileBackgroundColor,
  ) {
    if (items.isEmpty) {
      return _buildEmptyCarousel(colors, tileBackgroundColor);
    }

    final double cardSize = 0.72.sw - 12.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: cardSize,
          child: PageView.builder(
            controller: _pageController,
            itemCount: items.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: _buildPreviewCard(item, colors, tileBackgroundColor),
                ),
              );
            },
          ),
        ),
        if (items.length > 1) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (index) {
              final active = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: active ? 7.w : 6.w,
                height: active ? 7.w : 6.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? colors.grey10 : colors.grey3,
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildPreviewCard(
    _PreviewCardItem item,
    AppThemeColors colors,
    Color tileBackgroundColor,
  ) {
    Widget content;
    switch (item.type) {
      case _PreviewCardType.media:
        content = MediaThumbnail(media: item.payload);
        break;
      case _PreviewCardType.audio:
        final asset = item.payload as AssetEntity;
        content = _buildIconCardContent(
          colors: colors,
          backgroundColor: tileBackgroundColor,
          icon: Icons.audiotrack_rounded,
          title: asset.title ?? 'Audio Track',
          subtitle: _formatDuration(Duration(seconds: asset.duration)),
        );
        break;
      case _PreviewCardType.recording:
        final rec = item.payload as RecordedAudio;
        content = _buildIconCardContent(
          colors: colors,
          backgroundColor: tileBackgroundColor,
          icon: Icons.mic_rounded,
          title: rec.name,
          subtitle: _formatDuration(rec.duration),
        );
        break;
      case _PreviewCardType.location:
        final loc = item.payload as SelectedLocation;
        content = LocationCardContent(coordinates: loc.coordinates);
        break;
      case _PreviewCardType.mood:
        final moodIdx = item.payload as int;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final moodColors = MoodHelper.getMoodThemeColors(moodIdx, colors, isDark);
        final rasterized = _homeController.moodImagesLarge[moodIdx];
        content = Container(
          decoration: MoodHelper.buildMoodWashDecoration(
            moodColors[0],
            moodColors[1],
            moodColors[2],
            isDark: isDark,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (rasterized != null)
                  RawImage(
                    image: rasterized,
                    width: 72.w,
                    height: 72.w,
                    filterQuality: ui.FilterQuality.medium,
                  )
                else
                  MoodHelper.buildMoodSvg(
                    moodIdx,
                    width: 72.w,
                    height: 72.w,
                  ),
                SizedBox(height: 10.h),
                Text(
                  AppConstants.moods[moodIdx]['label'] ?? '',
                  style: TextStyle(
                    fontFamily: AppConstants.font,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: moodColors[0],
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        );
        break;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          content,
          Positioned(
            top: 10.h,
            right: 10.w,
            child: GestureDetector(
              onTap: item.onRemove,
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconCardContent({
    required AppThemeColors colors,
    required Color backgroundColor,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: colors.grey4.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28.sp, color: colors.primary),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppConstants.font,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: colors.grey10,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppConstants.font,
              fontSize: 13.sp,
              color: colors.grey2,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCarousel(AppThemeColors colors, Color tileBackgroundColor) {
    // Official Google Material Symbols Rounded `note_stack_add` icon path.
    const noteStackAddRoundedSvg =
        '<svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 -960 960 960" width="24"><path d="M280-160v-441q0-33 24-56t57-23h439q33 0 56.5 23.5T880-600v287q0 16-6 30.5T857-257L703-103q-11 11-25.5 17T647-80H360q-33 0-56.5-23.5T280-160ZM81-710q-6-33 13-59.5t52-32.5l434-77q32-6 58 13.5t34 51.5l7 31q5 20-6 32t-26 14q-15 2-28.5-5.5T600-770l-7-30-433 77 60 344q3 17-6 30.5T188-332q-17 3-30-6.5T142-365L81-710Zm279 110v440h280l160-160v-280H360Zm220 220Zm-40 40v80q0 17 11.5 28.5T580-220q17 0 28.5-11.5T620-260v-80h80q17 0 28.5-11.5T740-380q0-17-11.5-28.5T700-420h-80v-80q0-17-11.5-28.5T580-540q-17 0-28.5 11.5T540-500v80h-80q-17 0-28.5 11.5T420-380q0 17 11.5 28.5T460-340h80Z"/></svg>';

    final double cardSize = 0.72.sw - 12.w;

    return SizedBox(
      width: cardSize,
      height: cardSize,
      child: GestureDetector(
        onTap: () => _showAddOptionsMenu(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          decoration: BoxDecoration(
            color: tileBackgroundColor,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.string(
                noteStackAddRoundedSvg,
                width: 44.w,
                height: 44.w,
                colorFilter: ColorFilter.mode(
                  colors.grey2,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Select moments to journal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppConstants.font,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.grey10,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Add media, location, date, or mood from menu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppConstants.font,
                  fontSize: 13.sp,
                  color: colors.grey2,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(AppThemeColors colors) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom > mediaQuery.viewPadding.bottom
        ? mediaQuery.padding.bottom
        : mediaQuery.viewPadding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        8.h,
        20.w,
        (bottomPadding > 0 ? bottomPadding : 16.h) + 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: _startWriting,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                'Write Something',
                style: TextStyle(
                  fontFamily: AppConstants.font,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          TextButton(
            onPressed: _saveWithoutWriting,
            child: Text(
              'Save Without Writing',
              style: TextStyle(
                fontFamily: AppConstants.font,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: _hasAnyItem ? colors.primary : colors.grey2,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return AppConstants.emptyDuration;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
