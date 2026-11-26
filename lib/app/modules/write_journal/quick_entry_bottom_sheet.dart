import 'dart:async';
import 'dart:math' as math;
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
import 'package:open_jot/app/core/widgets/custom_datetime_picker.dart';
import 'package:open_jot/app/core/widgets/journal_audio_card.dart';
import 'package:open_jot/app/core/widgets/journal_tile.dart';
import 'package:open_jot/app/core/widgets/location_card_content.dart';
import 'package:open_jot/app/core/widgets/write_journal_toolbar.dart';
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

class _QuickEntryBottomSheetState extends State<QuickEntryBottomSheet>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final HomeController _homeController = Get.find<HomeController>();
  final PageController _pageController = PageController(viewportFraction: 0.72);
  final GlobalKey _moreMenuKey = GlobalKey();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final GlobalKey<WriteJournalToolbarContentState> _contentKey = GlobalKey();

  static const double _toolbarReservedHeight = 96.0;
  static const double _minFractionWithoutKeyboard = 0.2;
  static const List<IconData> _toolbarIcons = [
    Icons.image_rounded,
    Icons.location_on_rounded,
    Icons.camera_alt_rounded,
    Icons.mic_rounded,
    Icons.sentiment_satisfied_rounded,
  ];

  DateTime _selectedDate = DateTime.now();
  bool _isCustomDate = false;
  int? _selectedMoodIndex;
  SelectedLocation? _selectedLocation;
  final List<AssetEntity> _previewImages = [];
  final List<CapturedPhoto> _previewPhotos = [];
  final List<AssetEntity> _previewAudios = [];
  final List<RecordedAudio> _previewRecordings = [];
  int _currentPage = 0;

  late final AnimationController _sheetAnimController;
  late final CurvedAnimation _sheetSlideCurve;
  bool _isDraggableSheetActive = false;
  bool _isClosingSheet = false;
  IconData? _selectedToolbarIcon;
  double? _activeSheetMinSize;
  double? _activeSheetInitialSize;
  double _bodyHeight = 0.0;
  bool _isShowingDiscardDialog = false;
  bool _pendingLocationResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sheetAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
      reverseDuration: const Duration(milliseconds: 240),
    );
    _sheetSlideCurve = CurvedAnimation(
      parent: _sheetAnimController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sheetSlideCurve.dispose();
    _sheetAnimController.dispose();
    _pageController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pendingLocationResume) {
      _pendingLocationResume = false;
      unawaited(_resumeLocationFlow());
    }
  }

  Future<void> _resumeLocationFlow() async {
    final isLocationEnabled = await FossLocation.isLocationServiceEnabled();
    if (!isLocationEnabled) return;
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted && mounted) {
      unawaited(
        _handleAttachmentTap(
          Icons.location_on_rounded,
          bypassSettingsCheck: true,
        ),
      );
    }
  }

  double _fullSheetFraction([double? bodyHeight]) {
    final availableHeight = bodyHeight ??
        (_bodyHeight > 0 ? _bodyHeight : MediaQuery.of(context).size.height);
    if (availableHeight <= 0) return 0.86;
    return ((availableHeight - _toolbarReservedHeight.h) / availableHeight)
        .clamp(0.55, 0.90);
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
        type: rec.isVoiceRecording
            ? _PreviewCardType.recording
            : _PreviewCardType.audio,
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

  String? _buildSummaryText() {
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
      return null;
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

  Future<void> _pickDate() async {
    final pickedDate = await showCustomDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        _selectedDate.hour,
        _selectedDate.minute,
      );
      _isCustomDate = true;
    });
  }

  Future<void> _pickTime() async {
    final pickedTime = await showCustomTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (pickedTime != null && mounted) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _isCustomDate = true;
      });
    }
  }

  Future<bool> _ensurePermissionForTool(
    IconData icon, {
    bool bypassLocationSettingsCheck = false,
  }) async {
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
      if (!bypassLocationSettingsCheck) {
        final enabled = await FossLocation.isLocationServiceEnabled();
        if (!enabled) {
          _pendingLocationResume = true;
          await FossLocation.openLocationSettings();
          return false;
        }
      }
      final status = await Permission.locationWhenInUse.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> _handleAttachmentTap(
    IconData iconData, {
    bool bypassSettingsCheck = false,
  }) async {
    if (_isDraggableSheetActive &&
        !_isClosingSheet &&
        _selectedToolbarIcon == iconData) {
      await _handleCloseSheetRequest();
      return;
    }

    final granted = await _ensurePermissionForTool(
      iconData,
      bypassLocationSettingsCheck: bypassSettingsCheck,
    );
    if (!granted || !mounted) return;

    if (_isDraggableSheetActive && _isClosingSheet) {
      _openSheet(iconData);
      return;
    }

    if (_isDraggableSheetActive && _selectedToolbarIcon != iconData) {
      setState(() {
        _selectedToolbarIcon = iconData;
      });
      return;
    }

    _openSheet(iconData);
  }

  void _openSheet(IconData iconData) {
    if (!mounted) return;
    final availableHeight =
        _bodyHeight > 0 ? _bodyHeight : MediaQuery.of(context).size.height;
    final newInitialSize = _fullSheetFraction(availableHeight);
    final newMinSize =
        _minFractionWithoutKeyboard.clamp(0.1, newInitialSize);

    setState(() {
      _isClosingSheet = false;
      _selectedToolbarIcon = iconData;
      _isDraggableSheetActive = true;
      _activeSheetInitialSize = newInitialSize;
      _activeSheetMinSize = newMinSize;
    });

    unawaited(_sheetAnimController.forward(from: 0.0));
  }

  Future<bool> _handleCloseSheetRequest() async {
    if (_isShowingDiscardDialog) return false;

    final contentState = _contentKey.currentState;
    if (contentState != null && contentState.hasUnsavedContent) {
      _isShowingDiscardDialog = true;
      final shouldClose = await _showSheetDiscardDialog();
      _isShowingDiscardDialog = false;

      if (shouldClose) {
        contentState.clearUnsavedContent();
        _closeSheet();
        return true;
      }
      return false;
    } else {
      _closeSheet();
      return true;
    }
  }

  Future<bool> _showSheetDiscardDialog() async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text(AppConstants.discardSelectionsTitle),
        content: const Text(AppConstants.discardSelectionsMessage),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext, false),
            isDefaultAction: true,
            child: const Text(AppConstants.cancel),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext, true),
            isDestructiveAction: true,
            child: const Text(AppConstants.discard),
          ),
        ],
      ),
    );
    return result == true;
  }

  void _closeSheet() {
    if (!mounted || !_isDraggableSheetActive || _isClosingSheet) return;
    _isClosingSheet = true;
    _sheetAnimController.reverse().then((_) {
      if (!mounted || !_isClosingSheet) return;
      setState(() {
        _isClosingSheet = false;
        _isDraggableSheetActive = false;
        _selectedToolbarIcon = null;
        _activeSheetMinSize = null;
        _activeSheetInitialSize = null;
      });
    });
  }

  bool _handleSheetNotification(DraggableScrollableNotification notification) {
    if (!mounted || !_isDraggableSheetActive || _activeSheetMinSize == null) {
      return true;
    }
    final minSizeForClosingCheck = _activeSheetMinSize!;
    if (notification.extent <= minSizeForClosingCheck + 0.01) {
      final contentState = _contentKey.currentState;
      if (contentState != null && contentState.hasUnsavedContent) {
        if (!_isShowingDiscardDialog) {
          _isShowingDiscardDialog = true;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (_sheetController.isAttached &&
                _activeSheetInitialSize != null) {
              _sheetController.jumpTo(_activeSheetInitialSize!);
            }
            final shouldClose = await _showSheetDiscardDialog();
            _isShowingDiscardDialog = false;
            if (shouldClose) {
              contentState.clearUnsavedContent();
              _closeSheet();
            }
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_sheetController.isAttached &&
                _activeSheetInitialSize != null) {
              _sheetController.jumpTo(_activeSheetInitialSize!);
            }
          });
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              _isDraggableSheetActive &&
              _sheetController.isAttached &&
              _sheetController.size <= minSizeForClosingCheck + 0.02) {
            _closeSheet();
          }
        });
      }
    }
    return true;
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
      onWillPop: () async {
        if (_isDraggableSheetActive) {
          await _handleCloseSheetRequest();
          return false;
        }
        return _confirmDiscardIfNeeded();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          _bodyHeight = screenHeight;
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final maxSheetSize = _fullSheetFraction(screenHeight);

          final behindSheet = Scaffold(
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
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          final pillBg = isPitchBlack
                              ? (isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.black.withOpacity(0.05))
                              : colors.grey5;
                          final pillStyle = TextStyle(
                            fontFamily: AppConstants.font,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: colors.grey10,
                            letterSpacing: -0.2,
                          );
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () => unawaited(_pickDate()),
                                  child: Container(
                                    height: 36.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: pillBg,
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        left: Radius.circular(50),
                                        right: Radius.circular(6),
                                      ),
                                    ),
                                    child: Text(
                                      DateFormat('EEEE, MMM d')
                                          .format(_selectedDate),
                                      style: pillStyle,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                GestureDetector(
                                  onTap: () => unawaited(_pickTime()),
                                  child: Container(
                                    height: 36.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: pillBg,
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        left: Radius.circular(6),
                                        right: Radius.circular(50),
                                      ),
                                    ),
                                    child: Text(
                                      DateFormat('h:mm a')
                                          .format(_selectedDate),
                                      style: pillStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (_buildSummaryText() case final summary?) ...[
                        SizedBox(height: 8.h),
                        Text(
                          summary,
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontSize: 13.sp,
                            color: colors.grey2,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
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
          );

          return Stack(
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_sheetController, _sheetSlideCurve]),
                child: behindSheet,
                builder: (context, cachedBehindSheet) {
                  final currentSheetSize = _sheetController.isAttached
                      ? _sheetController.size
                      : (_activeSheetInitialSize ?? 0.0);
                  final pushBackProgress =
                      _isDraggableSheetActive && maxSheetSize > 0
                          ? ((currentSheetSize / maxSheetSize) *
                                  _sheetSlideCurve.value)
                              .clamp(0.0, 1.0)
                          : 0.0;
                  final behindScale = 1.0 - 0.06 * pushBackProgress;
                  final behindTopOffset = 8.h * pushBackProgress;
                  final behindRadius = 16.r * pushBackProgress;

                  return Stack(
                    children: [
                      if (pushBackProgress > 0.01)
                        Positioned.fill(
                          child: ColoredBox(
                            color: Colors.black
                                .withOpacity(0.55 * pushBackProgress),
                          ),
                        ),
                      Transform.translate(
                        offset: Offset(0, behindTopOffset),
                        child: Transform.scale(
                          scale: behindScale,
                          alignment: Alignment.topCenter,
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(behindRadius),
                            ),
                            child: Stack(
                              children: [
                                cachedBehindSheet!,
                                if (pushBackProgress > 0.01)
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: _handleCloseSheetRequest,
                                      child: ColoredBox(
                                        color: Colors.black.withOpacity(
                                            0.28 * pushBackProgress),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (_isDraggableSheetActive &&
                  _activeSheetMinSize != null &&
                  _activeSheetInitialSize != null)
                _buildDraggableSheet(
                  screenHeight,
                  _activeSheetMinSize!,
                  _activeSheetInitialSize!,
                  keyboardHeight,
                ),
              if (_isDraggableSheetActive)
                AnimatedBuilder(
                  animation: Listenable.merge([_sheetController, _sheetSlideCurve]),
                  builder: (context, _) {
                    final anim = _sheetSlideCurve.value;
                    final currentSheetSize = _sheetController.isAttached
                        ? _sheetController.size
                        : (_activeSheetInitialSize ?? 0.0);
                    final sheetHeight = (currentSheetSize * screenHeight) * anim;
                    return Positioned(
                      left: 0,
                      right: 0,
                      bottom: sheetHeight + 2.0,
                      child: Opacity(
                        opacity: (anim / 0.25).clamp(0.0, 1.0),
                        child: WriteJournalToolbar(
                          toolbarIcons: _toolbarIcons,
                          selectedToolbarIcon: _selectedToolbarIcon,
                          isDraggableSheetActive: _isDraggableSheetActive,
                          onToolbarItemTap: (icon) =>
                              unawaited(_handleAttachmentTap(icon)),
                          isRtlActive: false,
                          onRtlToggle: () {},
                          onCloseTap: _handleCloseSheetRequest,
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDraggableSheet(
    double screenHeight,
    double sheetMinSize,
    double sheetInitialSize,
    double keyboardHeight,
  ) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedBuilder(
          animation: _sheetSlideCurve,
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: _handleSheetNotification,
            child: DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: sheetInitialSize,
              minChildSize: sheetMinSize,
              maxChildSize: _fullSheetFraction(screenHeight),
              snap: true,
              snapSizes: [sheetMinSize, _fullSheetFraction(screenHeight)],
              snapAnimationDuration: const Duration(milliseconds: 180),
              expand: false,
              builder: (context, scrollController) =>
                  _buildSheetContainer(context, scrollController, keyboardHeight),
            ),
          ),
          builder: (context, sheetChild) {
            final currentSize = _sheetController.isAttached
                ? _sheetController.size
                : sheetInitialSize;
            final translateY =
                (1.0 - _sheetSlideCurve.value) * (currentSize * screenHeight);
            return Transform.translate(
              offset: Offset(0, translateY),
              child: sheetChild,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSheetContainer(
    BuildContext context,
    ScrollController scrollController,
    double keyboardHeight,
  ) {
    final hiveService = Get.find<HiveService>();
    final isPitchBlack = hiveService.pitchBlack;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetThemeColors = AppTheme.colorsOf(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isCamera = _selectedToolbarIcon == Icons.camera_alt_rounded;
    final isMic = _selectedToolbarIcon == Icons.mic_rounded;

    final totalBottomPadding = isCamera
        ? math.max(keyboardHeight, bottomPadding > 0 ? bottomPadding : 8.h)
        : math.max(keyboardHeight, bottomPadding > 0 ? bottomPadding + 8.h : 16.h);

    final backgroundColor = isPitchBlack
        ? (isDark ? Colors.black : Colors.white)
        : sheetThemeColors.grey5;

    final toolbarContent = RepaintBoundary(
      child: WriteJournalToolbarContent(
        key: _contentKey,
        selectedToolbarIcon: _selectedToolbarIcon,
        scrollController: scrollController,
        selectedMoodIndex: _selectedMoodIndex,
        selectedLocation: _selectedLocation?.coordinates,
        isPitchBlack: isPitchBlack,
        onAssetsSelected: (assets) {
          setState(() {
            final imagesAndVideos = assets
                .where(
                  (a) => a.type == AssetType.image || a.type == AssetType.video,
                )
                .toList();
            final audios =
                assets.where((a) => a.type == AssetType.audio).toList();
            final existingImageIds = _previewImages.map((e) => e.id).toSet();
            imagesAndVideos.removeWhere(
              (asset) => existingImageIds.contains(asset.id),
            );
            _previewImages.addAll(imagesAndVideos);

            final existingAudioIds = _previewAudios.map((e) => e.id).toSet();
            audios.removeWhere((asset) => existingAudioIds.contains(asset.id));
            _previewAudios.addAll(audios);
          });
          _closeSheet();
        },
        onFilesPicked: (paths, type) {
          setState(() {
            if (type == AssetType.audio) {
              for (final path in paths) {
                _previewRecordings.add(
                  RecordedAudio(
                    path: path,
                    name: p.basename(path),
                    duration: Duration.zero,
                    isShared: true,
                    isMusic: true,
                  ),
                );
              }
            } else {
              for (final path in paths) {
                _previewPhotos.add(
                  CapturedPhoto(
                    file: XFile(path),
                    name: p.basename(path),
                  ),
                );
              }
            }
          });
          _closeSheet();
        },
        onPhotoTaken: (photo) {
          setState(() {
            final name = AppConstants.openJotImage.replaceFirst(
              '%s',
              (_previewPhotos.length + 1).toString(),
            );
            _previewPhotos.add(
              CapturedPhoto(
                file: photo,
                name: name,
              ),
            );
          });
          _closeSheet();
        },
        onRecordingComplete: (path, duration) {
          setState(() {
            final name = AppConstants.openJotRecording.replaceFirst(
              '%s',
              (_previewRecordings.where((r) => r.isVoiceRecording).length + 1)
                  .toString()
                  .padLeft(2, '0'),
            );
            _previewRecordings.add(
              RecordedAudio(
                path: path,
                name: name,
                duration: duration,
              ),
            );
          });
          _closeSheet();
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
          _closeSheet();
        },
        onMoodChanged: (index) {
          setState(() {
            _selectedMoodIndex = index;
          });
        },
      ),
    );

    final handle = Container(
      height: 5,
      width: 40,
      decoration: BoxDecoration(
        color: isPitchBlack
            ? (isDark
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.1))
            : sheetThemeColors.grey1,
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Material(
      color: backgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: EdgeInsets.only(
          top: isCamera ? 8.h : (isMic ? 12.h : 16.h),
          bottom: totalBottomPadding,
        ),
        child: isMic
            ? Stack(
                children: [
                  toolbarContent,
                  Align(
                    alignment: Alignment.topCenter,
                    child: handle,
                  ),
                ],
              )
            : Column(
                children: [
                  handle,
                  SizedBox(height: isCamera ? 8.h : 16.h),
                  Expanded(child: toolbarContent),
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
          value: 'record',
          child: _buildMenuOptionRow(
            colors: colors,
            label: 'Record',
            icon: Icons.mic_rounded,
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
        unawaited(_handleAttachmentTap(Icons.image_rounded));
      } else if (value == 'location') {
        unawaited(_handleAttachmentTap(Icons.location_on_rounded));
      } else if (value == 'record') {
        unawaited(_handleAttachmentTap(Icons.mic_rounded));
      } else if (value == 'mood') {
        unawaited(_handleAttachmentTap(Icons.sentiment_satisfied_rounded));
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
        if (item.payload is AssetEntity) {
          final asset = item.payload as AssetEntity;
          content = JournalMusicCardContent(
            title: asset.title ?? AppConstants.audioTrack,
            duration: Duration(seconds: asset.duration),
          );
        } else {
          final rec = item.payload as RecordedAudio;
          content = JournalMusicCardContent(
            title: rec.name,
            duration: rec.duration,
          );
        }
        break;
      case _PreviewCardType.recording:
        final rec = item.payload as RecordedAudio;
        content = JournalRecordingCardContent(
          title: rec.name,
          duration: rec.duration,
          filePath: rec.path,
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
                'Add media, location, recording, or mood from menu',
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
}
