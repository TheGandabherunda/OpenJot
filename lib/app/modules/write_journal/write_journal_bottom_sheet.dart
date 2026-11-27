import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/models/journal_entry.dart';
import 'package:open_jot/app/core/services/permission_service.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/translations/app_translations.dart';
import 'package:open_jot/app/core/widgets/app_alert_dialog.dart';
import 'package:open_jot/app/core/widgets/custom_button.dart';
import 'package:open_jot/app/core/widgets/custom_datetime_picker.dart';
import 'package:open_jot/app/core/widgets/journal_card_grid.dart';
import 'package:open_jot/app/core/widgets/journal_quill_styles.dart';
import 'package:open_jot/app/core/widgets/text_styling_toolbar.dart';
import 'package:open_jot/app/core/widgets/write_journal_toolbar.dart';
import 'package:open_jot/app/core/widgets/write_journal_toolbar_content.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/media_preview/media_preview_bottom_sheet.dart';
import 'package:open_jot/app/utils/custom_toast.dart';
import 'package:open_jot/app/utils/foss_location.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class WriteJournalBottomSheet extends StatefulWidget {
  const WriteJournalBottomSheet({
    super.key,
    this.entry,
    this.initialText,
    this.sharedImagePaths,
    this.sharedVideoPaths,
    this.sharedAudioPaths,
    this.isFromReflection = false,
    this.initialDate,
    this.initialIsCustomDate = false,
    this.initialMoodIndex,
    this.initialLocation,
    this.initialGalleryImages,
    this.initialCameraPhotos,
    this.initialGalleryAudios,
    this.initialRecordings,
  });

  final JournalEntry? entry;
  final String? initialText;
  final List<String>? sharedImagePaths;
  final List<String>? sharedVideoPaths;
  final List<String>? sharedAudioPaths;
  final bool isFromReflection;
  final DateTime? initialDate;
  final bool initialIsCustomDate;
  final int? initialMoodIndex;
  final SelectedLocation? initialLocation;
  final List<AssetEntity>? initialGalleryImages;
  final List<CapturedPhoto>? initialCameraPhotos;
  final List<AssetEntity>? initialGalleryAudios;
  final List<RecordedAudio>? initialRecordings;

  @override
  WriteJournalBottomSheetState createState() => WriteJournalBottomSheetState();
}

enum _SheetTransitionState { none, opening, open }

class WriteJournalBottomSheetState extends State<WriteJournalBottomSheet>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late quill.QuillController _quillController;
  final _focusNode = FocusNode();
  final _sheetController = DraggableScrollableController();
  final _editorScrollController = ScrollController();
  final _mainScrollController = ScrollController();
  final _textFieldKey = GlobalKey();
  final _tagController = TextEditingController();
  final GlobalKey<WriteJournalToolbarContentState> _contentKey = GlobalKey();

  late final AnimationController _sheetAnimController;
  late final CurvedAnimation _sheetSlideCurve;
  bool _isClosingSheet = false;

  DateTime _selectedDate = DateTime.now();
  bool _isBookmarked = false;
  bool _isDraggableSheetActive = false;
  IconData? _selectedToolbarIcon;
  bool _openingSheetViaToolbar = false;
  double? _activeSheetMinSize;
  double? _activeSheetInitialSize;
  double _bodyHeight = 0.0;
  bool _isFormatting = false;
  bool _wasKeyboardVisible = false;
  bool _isShowingDiscardDialog = false;

  List<AssetEntity> _previewImages = [];
  List<CapturedPhoto> _previewPhotos = [];
  List<AssetEntity> _previewAudios = [];
  List<RecordedAudio> _previewRecordings = [];
  List<String> _tags = [];
  SelectedLocation? _selectedLocation;
  int? _selectedMoodIndex;

  _SheetTransitionState _sheetState = _SheetTransitionState.none;
  bool _pendingLocationResume = false;

  bool _isLoadingMedia = false;
  late String _currentEntryId;
  final bool _allowPop = false;
  bool _isSavedOrDiscarded = false;

  static const double _toolbarReservedHeight = 96.0;
  static const double _minFractionWithoutKeyboard = 0.2;
  static const double _keyboardVisibleMinFractionFactor = 1.0;

  double _fullSheetFraction([double? bodyHeight]) {
    final availableHeight =
        bodyHeight ?? (_bodyHeight > 0 ? _bodyHeight : MediaQuery.of(context).size.height);
    if (availableHeight <= 0) return 0.86;
    return ((availableHeight - _toolbarReservedHeight.h) / availableHeight)
        .clamp(0.55, 0.90);
  }

  static const List<IconData> _toolbarIcons = [
    Icons.image_rounded,
    Icons.location_on_rounded,
    Icons.camera_alt_rounded,
    Icons.mic_rounded,
    Icons.sentiment_satisfied_rounded,
  ];

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
    _initializeState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          unawaited(_loadSharedMedia());
        }
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pendingLocationResume) {
      _pendingLocationResume = false;
      unawaited(_resumeLocationFlow());
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      if (!_isSavedOrDiscarded && _hasUnsavedChanges) {
        _saveEntry(isDraft: true);
      }
    }
  }

  Future<void> _resumeLocationFlow() async {
    final isLocationEnabled = await FossLocation.isLocationServiceEnabled();
    if (isLocationEnabled) {
      final status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            unawaited(
              _handleAttachmentTap(
                Icons.location_on_rounded,
                bypassSettingsCheck: true,
              ),
            );
          }
        });
      }
    }
  }

  void _initializeState() {
    if (widget.entry != null) {
      final entry = widget.entry!;
      _currentEntryId = entry.id;
      _quillController = quill.QuillController(
        document: quill.Document.fromJson(entry.content.toDelta().toJson()),
        selection: const TextSelection.collapsed(offset: 0),
      );
      _selectedDate = entry.createdAt;
      _isBookmarked = entry.isBookmarked;
      _selectedMoodIndex = entry.moodIndex;
      _selectedLocation = entry.location;
      _previewImages = List.from(entry.galleryImages);
      _previewPhotos = List.from(entry.cameraPhotos);
      _previewAudios = List.from(entry.galleryAudios);
      _previewRecordings = List.from(entry.recordings);
      _tags = List.from(entry.tags);
    } else {
      _currentEntryId = const Uuid().v4();
      _quillController = quill.QuillController.basic();
      if (widget.initialDate != null) {
        _selectedDate = widget.initialDate!;
      }
      _selectedMoodIndex = widget.initialMoodIndex;
      _selectedLocation = widget.initialLocation;
      if (widget.initialGalleryImages != null) {
        _previewImages = List.from(widget.initialGalleryImages!);
      }
      if (widget.initialCameraPhotos != null) {
        _previewPhotos = List.from(widget.initialCameraPhotos!);
      }
      if (widget.initialGalleryAudios != null) {
        _previewAudios = List.from(widget.initialGalleryAudios!);
      }
      if (widget.initialRecordings != null) {
        _previewRecordings = List.from(widget.initialRecordings!);
      }
      final initialContent = widget.initialText ?? '';
      if (initialContent.isNotEmpty) {
        final delta = quill.Delta()
          ..insert(
            '$initialContent\n',
            widget.initialText != null ? {'header': 2} : null,
          )
          ..insert('\n');
        _quillController.document = quill.Document.fromDelta(delta);
        _quillController.moveCursorToEnd();
      }
    }

    _quillController.addListener(() {
      if (!mounted) return;
      if (_focusNode.hasFocus) {
        final isAtEnd = _quillController.selection.extentOffset >=
            _quillController.document.length - 1;
        if (isAtEnd) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _mainScrollController.hasClients) {
              unawaited(
                _mainScrollController.animateTo(
                  _mainScrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                ),
              );
            }
          });
        }
      }
    });
    _quillController.document.changes.listen(_handleTextChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (widget.initialText == null &&
            widget.sharedImagePaths == null &&
            widget.sharedVideoPaths == null &&
            widget.sharedAudioPaths == null) {
          _focusNode.requestFocus();
        }
      }
    });
  }

  bool get _hasUnsavedChanges {
    final currentText = _quillController.document.toPlainText().trim();
    final isMediaEmpty = _previewImages.isEmpty &&
        _previewPhotos.isEmpty &&
        _previewAudios.isEmpty &&
        _previewRecordings.isEmpty;

    if (widget.entry == null) {
      return currentText.isNotEmpty ||
          !isMediaEmpty ||
          _tags.isNotEmpty ||
          _selectedLocation != null ||
          _selectedMoodIndex != null;
    } else {
      final currentDeltaJson = jsonEncode(_quillController.document.toDelta().toJson());
      final originalDeltaJson = jsonEncode(widget.entry!.content.toDelta().toJson());
      if (currentDeltaJson != originalDeltaJson) {
        return true;
      }

      final originalImages = widget.entry!.galleryImages;
      if (_previewImages.length != originalImages.length ||
          !_previewImages.every((e) => originalImages.any((o) => o.id == e.id))) {
        return true;
      }

      final originalPhotos = widget.entry!.cameraPhotos;
      if (_previewPhotos.length != originalPhotos.length ||
          !_previewPhotos.every((e) => originalPhotos.any((o) => o.file.path == e.file.path))) {
        return true;
      }

      final originalAudios = widget.entry!.galleryAudios;
      if (_previewAudios.length != originalAudios.length ||
          !_previewAudios.every((e) => originalAudios.any((o) => o.id == e.id))) {
        return true;
      }

      final originalRecordings = widget.entry!.recordings;
      if (_previewRecordings.length != originalRecordings.length ||
          !_previewRecordings.every((e) => originalRecordings.any((o) => o.path == e.path))) {
        return true;
      }

      if (_selectedMoodIndex != widget.entry!.moodIndex) {
        return true;
      }
      if (_selectedDate.millisecondsSinceEpoch != widget.entry!.createdAt.millisecondsSinceEpoch) return true;
      if (_isBookmarked != widget.entry!.isBookmarked) return true;
      if (_selectedLocation?.coordinates != widget.entry!.location?.coordinates) return true;

      // Check if tags have changed
      final originalTags = widget.entry!.tags;
      if (_tags.length != originalTags.length ||
          !_tags.every((tag) => originalTags.contains(tag))) {
        return true;
      }

      return false;
    }
  }

  Future<void> _loadSharedMedia() async {
    final hasMediaToLoad = (widget.sharedImagePaths?.isNotEmpty ?? false) ||
        (widget.sharedVideoPaths?.isNotEmpty ?? false) ||
        (widget.sharedAudioPaths?.isNotEmpty ?? false);

    if (!hasMediaToLoad) return;

    setState(() {
      _isLoadingMedia = true;
    });

    final newPhotos = <CapturedPhoto>[];
    if (widget.sharedImagePaths != null) {
      for (final path in widget.sharedImagePaths!) {
        newPhotos.add(
          CapturedPhoto(file: XFile(path), name: AppConstants.sharedImage),
        );
      }
    }
    if (widget.sharedVideoPaths != null) {
      for (final path in widget.sharedVideoPaths!) {
        newPhotos.add(
          CapturedPhoto(file: XFile(path), name: AppConstants.sharedVideo),
        );
      }
    }

    final newRecordings = await _processSharedAudio();

    if (mounted) {
      setState(() {
        _previewPhotos.addAll(newPhotos);
        _previewRecordings.addAll(newRecordings);
        _isLoadingMedia = false;
      });
    }
  }

  Future<List<RecordedAudio>> _processSharedAudio() async {
    if (widget.sharedAudioPaths == null || widget.sharedAudioPaths!.isEmpty) {
      return [];
    }

    final newRecordings = <RecordedAudio>[];
    for (final path in widget.sharedAudioPaths!) {
      final fileName = p.basename(path);
      newRecordings.add(
        RecordedAudio(
          path: path,
          name: fileName,
          duration: Duration.zero,
          isShared: true,
          isMusic: true,
        ),
      );
    }
    return newRecordings;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tagController.dispose();

    try {
      if (!_isSavedOrDiscarded && _hasUnsavedChanges) {
        _saveEntry(isDraft: true);
        CustomToast.showToast(AppConstants.draftSaved.tr);
      }
    } catch (e) {
      debugPrint("Auto-draft save failed in dispose: $e");
    }

    _quillController.document.changes.listen(null);
    _sheetSlideCurve.dispose();
    _sheetAnimController.dispose();
    _quillController.dispose();
    _focusNode.dispose();
    _sheetController.dispose();
    _editorScrollController.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  void _saveEntry({bool isDraft = false}) {
    try {
      final isTextEmpty = _quillController.document.toPlainText().trim().isEmpty;
      final isMediaEmpty = _previewImages.isEmpty &&
          _previewPhotos.isEmpty &&
          _previewAudios.isEmpty &&
          _previewRecordings.isEmpty;
      final hasMetadata =
          _selectedLocation != null || _selectedMoodIndex != null || _tags.isNotEmpty;

      if (isTextEmpty && isMediaEmpty && !hasMetadata && !isDraft) return;

      final homeController = Get.find<HomeController>();
      final documentJson = _quillController.document.toDelta().toJson();
      final cleanDocument = quill.Document.fromJson(documentJson);

      String saveId = _currentEntryId;
      String? originalId = widget.entry?.originalId;

      // Handle non-destructive draft saving for existing journals
      if (isDraft && widget.entry != null && !widget.entry!.isDraft) {
        // Create a new branched draft ID
        saveId = const Uuid().v4();
        originalId = widget.entry!.id;
      }

      // If we are updating an existing entry from a draft that has an originalId
      if (!isDraft && widget.entry != null && widget.entry!.isDraft && widget.entry!.originalId != null) {
        saveId = widget.entry!.originalId!;
        // Delete the draft entry after updating the original
        homeController.deleteJournalEntry(widget.entry!.id);
      }

      // Determine useRtl based on the first block's direction attribute
      bool primaryRtl = false;
      if (cleanDocument.root.children.isNotEmpty) {
        final firstBlock = cleanDocument.root.children.first;
        if (firstBlock is quill.Block) {
          primaryRtl = firstBlock.style.containsKey(quill.Attribute.rtl.key);
        } else if (firstBlock is quill.Line) {
          primaryRtl = firstBlock.style.containsKey(quill.Attribute.rtl.key);
        }
      }

      final updatedEntry = JournalEntry(
        id: saveId,
        content: cleanDocument,
        createdAt: _selectedDate,
        isBookmarked: _isBookmarked,
        isReflection: widget.entry?.isReflection ?? widget.isFromReflection,
        moodIndex: _selectedMoodIndex,
        location: _selectedLocation,
        galleryImages: _previewImages,
        cameraPhotos: _previewPhotos,
        galleryAudios: _previewAudios,
        recordings: _previewRecordings,
        isDraft: isDraft,
        tags: _tags,
        originalId: originalId,
        useRtl: primaryRtl,
      );

      final exists = homeController.journalEntries.any((e) => e.id == saveId) ||
          homeController.draftEntries.any((e) => e.id == saveId);

      if (exists) {
        homeController.updateJournalEntry(updatedEntry);
      } else {
        homeController.addJournalEntry(updatedEntry);
      }
    } catch (e) {
      debugPrint('Error saving entry: $e');
    }
  }

  void _onDonePressed() {
    final isTextEmpty = _quillController.document.toPlainText().trim().isEmpty;
    final isMediaEmpty = _previewImages.isEmpty &&
        _previewPhotos.isEmpty &&
        _previewAudios.isEmpty &&
        _previewRecordings.isEmpty;
    final hasMetadata =
        _selectedLocation != null || _selectedMoodIndex != null || _tags.isNotEmpty;

    if (isTextEmpty && isMediaEmpty && !hasMetadata) {
      CustomToast.showToast(
        AppConstants.journalEntryEmpty.tr,
      );
      return;
    }

    _isSavedOrDiscarded = true;
    final wasDraft = widget.entry?.isDraft ?? false;

    if (!_hasUnsavedChanges && widget.entry == null) {
      Navigator.of(context).pop();
      return;
    }

    if (!_hasUnsavedChanges && widget.entry != null && !wasDraft) {
      Navigator.of(context).pop();
      return;
    }

    _saveEntry(isDraft: false);

    Navigator.of(context).pop(isTextEmpty && isMediaEmpty && !hasMetadata);
  }

  void _handleTextChange(quill.DocChange docChange) {
    if (docChange.source != quill.ChangeSource.local || _isFormatting) {
      return;
    }
    _isFormatting = true;
    Future.microtask(() async {
      try {
        final ops = docChange.change.toList();
        final hasStringInsert =
            ops.any((op) => op.isInsert && op.data is String);
        if (!hasStringInsert) return;

        final urlRegExp = RegExp(
          r'((https?://)|(www\.))\S+',
          caseSensitive: false,
        );
        final emailRegExp = RegExp(
          r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
          caseSensitive: false,
        );
        final phoneRegExp = RegExp(
          r'(\+?\d{1,3}[-.\s]?)?(\(?\d{3}\)?[-.\s]?){1,2}\d{4,}',
          caseSensitive: false,
        );

        var offset = 0;
        for (final op in ops) {
          if (op.isRetain) {
            offset += op.length ?? 0;
            continue;
          }
          if (!op.isInsert) continue;

          final opLen = op.length ?? 0;
          if (op.data is String) {
            final alreadyLinked =
                op.attributes?.containsKey(quill.Attribute.link.key) == true;
            if (!alreadyLinked) {
              final opText = op.data as String;
              final matches = <({int start, int length, String link})>[];

              for (final m in urlRegExp.allMatches(opText)) {
                final text = m.group(0)!;
                final link = text.toLowerCase().startsWith('http')
                    ? text
                    : 'https://$text';
                matches.add((start: m.start, length: text.length, link: link));
              }
              for (final m in emailRegExp.allMatches(opText)) {
                final text = m.group(0)!;
                matches.add(
                    (start: m.start, length: text.length, link: 'mailto:$text'));
              }
              for (final m in phoneRegExp.allMatches(opText)) {
                final text = m.group(0)!;
                matches
                    .add((start: m.start, length: text.length, link: 'tel:$text'));
              }

              for (final match in matches) {
                if (mounted) {
                  _quillController.formatText(
                    offset + match.start,
                    match.length,
                    quill.LinkAttribute(match.link),
                  );
                }
              }
            }
          }
          offset += opLen;
        }
      } finally {
        _isFormatting = false;
      }
    });
  }

  Future<void> _showCalendarPicker() async {
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
    });
  }

  Future<void> _showTimeSelector() async {
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
      });
    }
  }

  double _calculateInitialChildSize(
      BuildContext context, {
        bool afterKeyboardClose = false,
        IconData? iconData,
      }) {
    final availableHeight =
        _bodyHeight > 0 ? _bodyHeight : MediaQuery.of(context).size.height;
    return _fullSheetFraction(availableHeight);
  }

  double _calculateMinChildSize(
      BuildContext context, {
        bool afterKeyboardClose = false,
      }) {
    final availableHeight =
        _bodyHeight > 0 ? _bodyHeight : MediaQuery.of(context).size.height;
    final maxSheetSize = _fullSheetFraction(availableHeight);
    if (afterKeyboardClose) {
      return _minFractionWithoutKeyboard.clamp(0.1, maxSheetSize);
    }
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    double minSize;
    if (keyboardHeight > 0 && _keyboardVisibleMinFractionFactor < 1.0) {
      minSize =
          (_keyboardVisibleMinFractionFactor * keyboardHeight) / availableHeight;
    } else {
      minSize = _minFractionWithoutKeyboard;
    }
    return minSize.clamp(0.1, maxSheetSize);
  }

  void _resizeSheetForTab(IconData iconData) {
    // All tabs render in the full content container without resizing.
  }

  Future<void> _handleAttachmentTap(
      IconData iconData, {
        bool bypassSettingsCheck = false,
      }) async {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    if (_isDraggableSheetActive &&
        !_isClosingSheet &&
        _selectedToolbarIcon == iconData) {
      final didClose = await _handleCloseSheetRequest();
      if (didClose && isKeyboardVisible && mounted) {
        _focusNode.requestFocus();
      }
      return;
    }

    if (iconData == Icons.location_on_rounded) {
      if (!bypassSettingsCheck) {
        final isLocationEnabled = await FossLocation.isLocationServiceEnabled();
        if (!isLocationEnabled) {
          _pendingLocationResume = true;
          await FossLocation.openLocationSettings();
          return;
        }
      }
      final status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        return;
      }
    }

    if (_isDraggableSheetActive && _isClosingSheet) {
      _openSheet(iconData);
      return;
    }

    if (_isDraggableSheetActive && _selectedToolbarIcon != iconData) {
      setState(() {
        _selectedToolbarIcon = iconData;
      });
      _resizeSheetForTab(iconData);
      return;
    }

    if (iconData == Icons.image_rounded) {
      final status = await PermissionService.requestMediaPermission(0);
      if (!status.isGranted) {
        return;
      }
    }
    if (iconData == Icons.camera_alt_rounded) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        return;
      }
    }

    if (iconData == Icons.mic_rounded) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        return;
      }
    }

    if (isKeyboardVisible) {
      _handleSheetOpeningWithKeyboard(iconData);
    } else {
      _handleSheetOpeningWithoutKeyboard(iconData);
    }
  }

  void _handleToolbarItemTap(IconData iconData) async {
    if (iconData == Icons.mic_rounded) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        return;
      }
    }
    if (iconData == Icons.image_rounded ||
        iconData == Icons.camera_alt_rounded ||
        iconData == Icons.location_on_rounded ||
        iconData == Icons.mic_rounded) {
      unawaited(_handleAttachmentTap(iconData));
    } else {
      final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
      if (_isDraggableSheetActive &&
          !_isClosingSheet &&
          _selectedToolbarIcon == iconData) {
        final didClose = await _handleCloseSheetRequest();
        if (didClose && isKeyboardVisible && mounted) {
          _focusNode.requestFocus();
        }
        return;
      }
      if (_isDraggableSheetActive && _isClosingSheet) {
        _openSheet(iconData);
        return;
      }
      if (_isDraggableSheetActive && _selectedToolbarIcon != iconData) {
        setState(() {
          _selectedToolbarIcon = iconData;
        });
        _resizeSheetForTab(iconData);
        return;
      }
      if (isKeyboardVisible) {
        _handleSheetOpeningWithKeyboard(iconData);
      } else {
        _handleSheetOpeningWithoutKeyboard(iconData);
      }
    }
  }

  void _handlePinTap() {
    _focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      unawaited(_handleAttachmentTap(Icons.image_rounded));
    });
  }

  void _handleTextStylingToolbarItemTap(String style) {
    final selection = _quillController.selection;
    final currentStyle = _quillController.getSelectionStyle();
    if (selection.baseOffset < 0) return;
    switch (style) {
      case 'bold':
        _toggleStyle(currentStyle, quill.Attribute.bold);
        break;
      case 'italic':
        _toggleStyle(currentStyle, quill.Attribute.italic);
        break;
      case 'underline':
        _toggleStyle(currentStyle, quill.Attribute.underline);
        break;
      case 'strikethrough':
        _toggleStyle(currentStyle, quill.Attribute.strikeThrough);
        break;
      case 'bullet':
        _toggleListStyle(currentStyle);
        break;
      case 'quote':
        _toggleStyle(currentStyle, quill.Attribute.blockQuote);
        break;
      case 'title':
        _toggleHeaderStyle(currentStyle);
        break;
      case 'rtl':
        final isRtl = currentStyle.containsKey(quill.Attribute.rtl.key);
        if (isRtl) {
          _quillController.formatSelection(
            quill.Attribute.clone(quill.Attribute.rtl, null),
          );
        } else {
          _quillController.formatSelection(quill.Attribute.rtl);
        }
        break;
    }
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
  }

  void _toggleStyle(quill.Style currentStyle, quill.Attribute attribute) {
    if (currentStyle.containsKey(attribute.key)) {
      _quillController.formatSelection(quill.Attribute.clone(attribute, null));
    } else {
      _quillController.formatSelection(attribute);
    }
  }

  void _toggleListStyle(quill.Style currentStyle) {
    if (currentStyle.containsKey(quill.Attribute.ul.key)) {
      _quillController.formatSelection(
        quill.Attribute.clone(quill.Attribute.ul, null),
      );
    } else if (currentStyle.containsKey(quill.Attribute.ol.key)) {
      _quillController.formatSelection(
        quill.Attribute.clone(quill.Attribute.ol, null),
      );
      _quillController.formatSelection(quill.Attribute.ul);
    } else {
      _quillController.formatSelection(quill.Attribute.ul);
    }
  }

  void _toggleHeaderStyle(quill.Style currentStyle) {
    final hasHeader = currentStyle.containsKey(quill.Attribute.h1.key) ||
        currentStyle.containsKey(quill.Attribute.h2.key) ||
        currentStyle.containsKey(quill.Attribute.h3.key);
    if (hasHeader) {
      if (currentStyle.containsKey(quill.Attribute.h1.key)) {
        _quillController.formatSelection(
          quill.Attribute.clone(quill.Attribute.h1, null),
        );
      }
      if (currentStyle.containsKey(quill.Attribute.h2.key)) {
        _quillController.formatSelection(
          quill.Attribute.clone(quill.Attribute.h2, null),
        );
      }
      if (currentStyle.containsKey(quill.Attribute.h3.key)) {
        _quillController.formatSelection(
          quill.Attribute.clone(quill.Attribute.h3, null),
        );
      }
    } else {
      _quillController.formatSelection(quill.Attribute.h2);
    }
  }

  Future<bool> _handleCloseSheetRequest() async {
    if (_isShowingDiscardDialog) return false;

    final contentState = _contentKey.currentState;
    if (contentState != null && contentState.hasUnsavedContent) {
      _isShowingDiscardDialog = true;
      final shouldClose = await _showDiscardDialog();
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

  Future<bool> _showDiscardDialog() async {
    final result = await showAppAlertDialog<bool>(
      context: context,
      title: AppConstants.discardSelectionsTitle.tr,
      message: AppConstants.discardSelectionsMessage.tr,
      actionsBuilder: (dialogContext) => [
        AppAlertAction(
          label: AppConstants.cancel.tr,
          onPressed: () => Navigator.pop(dialogContext, false),
        ),
        AppAlertAction(
          label: AppConstants.discard.tr,
          isDestructive: true,
          onPressed: () => Navigator.pop(dialogContext, true),
        ),
      ],
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
        _openingSheetViaToolbar = false;
        _activeSheetMinSize = null;
        _activeSheetInitialSize = null;
        _sheetState = _SheetTransitionState.none;
      });
    });
  }

  void _handleSheetOpeningWithKeyboard(IconData iconData) {
    _focusNode.unfocus();
    setState(() {
      _sheetState = _SheetTransitionState.opening;
      _selectedToolbarIcon = iconData;
    });
  }

  void _handleSheetOpeningWithoutKeyboard(IconData iconData) {
    _openSheet(iconData);
  }

  void _openSheet(IconData iconData, {bool afterKeyboardClose = false}) {
    if (!mounted) return;
    final newInitialSize = _calculateInitialChildSize(
      context,
      afterKeyboardClose: afterKeyboardClose,
      iconData: iconData,
    );
    final newMinSize = _calculateMinChildSize(
      context,
      afterKeyboardClose: afterKeyboardClose,
    );
    setState(() {
      _isClosingSheet = false;
      _openingSheetViaToolbar = true;
      _selectedToolbarIcon = iconData;
      _isDraggableSheetActive = true;
      _activeSheetInitialSize = newInitialSize;
      _activeSheetMinSize = newMinSize;
    });
    unawaited(_sheetAnimController.forward(from: 0.0));
    _resetToolbarFlag(afterKeyboardClose ? 300 : 550);
  }

  void _resetToolbarFlag(int delayMs) {
    Future.delayed(Duration(milliseconds: delayMs), () {
      _openingSheetViaToolbar = false;
    });
  }

  bool _handleSheetNotification(
      DraggableScrollableNotification notification,
      double screenHeight,
      ) {
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
            if (_sheetController.isAttached && _activeSheetInitialSize != null) {
              // Bounce back safely to initial size to break the drag-down loop
              _sheetController.jumpTo(_activeSheetInitialSize!);
            }

            final shouldClose = await _showDiscardDialog();
            _isShowingDiscardDialog = false;

            if (shouldClose) {
              contentState.clearUnsavedContent();
              _closeSheet();
            } else {
              // User cancelled the drag-dismiss. Ensure keyboard is unfocused
              // so it doesn't flap and trigger another close attempt.
              _focusNode.unfocus();
            }
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_sheetController.isAttached && _activeSheetInitialSize != null) {
              _sheetController.jumpTo(_activeSheetInitialSize!);
            }
          });
        }
      } else {
        _scheduleSheetClose(minSizeForClosingCheck);
      }
    }
    return true;
  }

  void _scheduleSheetClose(double minSizeForClosingCheck) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _isDraggableSheetActive &&
          _sheetController.isAttached &&
          _sheetController.size <= minSizeForClosingCheck + 0.01) {
        _closeSheet();
      }
    });
  }

  void _handleKeyboardInteraction(bool isKeyboardVisible) {
    if (isKeyboardVisible &&
        !_wasKeyboardVisible &&
        _isDraggableSheetActive &&
        !_openingSheetViaToolbar) {

      if (!_focusNode.hasFocus && _selectedToolbarIcon == Icons.location_on_rounded) {
        // Keyboard opened for the search bar -> automatically expand sheet to see results
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_sheetController.isAttached && mounted) {
            _sheetController.animateTo(
              _fullSheetFraction(),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            );
          }
        });
      } else if (_focusNode.hasFocus) {
        // Keyboard opened for main text editor -> ask to close sheet
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted && _isDraggableSheetActive) {
            final didClose = await _handleCloseSheetRequest();
            if (!didClose && mounted) {
              _focusNode.unfocus();
            }
          }
        });
      }
    }
    _wasKeyboardVisible = isKeyboardVisible;
  }

  List<MediaItem> _getAllMediaItems() {
    final items = <MediaItem>[];
    for (final asset in _previewImages) {
      items.add(MediaItem(asset: asset, type: asset.type, id: asset.id));
    }
    for (final photo in _previewPhotos) {
      items.add(MediaItem(
        asset: photo,
        type: _isVideoFile(photo.file.path) ? AssetType.video : AssetType.image,
        id: photo.file.path,
      ));
    }
    if (_selectedLocation != null) {
      items.add(MediaItem.location(_selectedLocation!));
    }
    if (_selectedMoodIndex != null) {
      items.add(MediaItem.mood(_selectedMoodIndex!));
    }
    for (final audio in _previewAudios) {
      items.add(MediaItem(
        asset: audio,
        type: AssetType.audio,
        id: audio.id,
        kind: MediaPreviewKind.audio,
      ));
    }
    for (final rec in _previewRecordings) {
      items.add(MediaItem.recorded(rec));
    }
    return items;
  }

  Future<SelectedLocation?> _handlePreviewEditLocation(
    SelectedLocation current,
  ) async {
    final picked = await showLocationPickerModal(
      context,
      initialLocation: current.coordinates,
    );
    if (picked == null || !mounted) return null;
    setState(() {
      _selectedLocation = picked;
    });
    return picked;
  }

  Future<int?> _handlePreviewEditMood(int currentMoodIndex) async {
    final picked = await showMoodPickerModal(
      context,
      initialMoodIndex: currentMoodIndex,
    );
    if (picked == null || !mounted) return null;
    setState(() {
      _selectedMoodIndex = picked;
    });
    return picked;
  }

  void _openMediaPreview(int initialIndex) {
    final mediaItems = _getAllMediaItems();
    if (mediaItems.isEmpty ||
        initialIndex < 0 ||
        initialIndex >= mediaItems.length) {
      return;
    }

    unawaited(
      showCupertinoModalBottomSheet(
        context: context,
        expand: true,
        backgroundColor: Colors.transparent,
        builder: (context) => MediaPreviewBottomSheet(
          mediaItems: mediaItems,
          initialIndex: initialIndex,
          onEditLocation: _handlePreviewEditLocation,
          onEditMood: _handlePreviewEditMood,
          onRemove: (item) {
            setState(() {
              if (item.kind == MediaPreviewKind.location) {
                _selectedLocation = null;
              } else if (item.kind == MediaPreviewKind.mood) {
                _selectedMoodIndex = null;
              } else if (item.asset is AssetEntity) {
                _previewImages.remove(item.asset);
                _previewAudios.remove(item.asset);
              } else if (item.asset is RecordedAudio) {
                final rec = item.asset as RecordedAudio;
                _previewRecordings.removeWhere((r) => r.path == rec.path);
                if (rec.isVoiceRecording && widget.entry == null) {
                  final file = File(rec.path);
                  if (file.existsSync()) {
                    file.delete();
                  }
                }
              } else if (item.asset is CapturedPhoto) {
                _previewPhotos.removeWhere((p) => p.file.path == item.id);
                _previewRecordings.removeWhere((r) => r.path == item.id);
              }
            });
          },
        ),
      ),
    );
  }

  bool _isVideoFile(String path) {
    final lowercasedPath = path.toLowerCase();
    return lowercasedPath.endsWith('.mp4') ||
        lowercasedPath.endsWith('.mov') ||
        lowercasedPath.endsWith('.avi') ||
        lowercasedPath.endsWith('.wmv') ||
        lowercasedPath.endsWith('.mkv') ||
        lowercasedPath.endsWith('.m4v') ||
        lowercasedPath.endsWith('.webm');
  }

  Widget _buildHeaderPillSegment({
    required AppThemeColors appThemeColors,
    required BorderRadius borderRadius,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: appThemeColors.grey5,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }

  Widget _buildHeader(AppThemeColors appThemeColors) {
    final pillTextStyle = TextStyle(
      fontSize: 13.5.sp,
      fontWeight: FontWeight.w600,
      fontFamily: AppConstants.font,
      color: appThemeColors.grey10,
      decoration: TextDecoration.none,
      letterSpacing: -0.2,
    );

    return SizedBox(
      width: double.infinity,
      height: kToolbarHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isBookmarked = !_isBookmarked;
                });
              },
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  color: _isBookmarked
                      ? appThemeColors.primary
                      : appThemeColors.grey2,
                  size: 28.w,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 56.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderPillSegment(
                    appThemeColors: appThemeColors,
                    borderRadius: const BorderRadiusDirectional.horizontal(
                      start: Radius.circular(50),
                      end: Radius.circular(6),
                    ).resolve(Directionality.of(context)),
                    onTap: () => unawaited(_showCalendarPicker()),
                    child: Text(
                      AppTranslations.formatDate(_selectedDate, 'MMM d'),
                      style: pillTextStyle,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  _buildHeaderPillSegment(
                    appThemeColors: appThemeColors,
                    borderRadius: const BorderRadiusDirectional.horizontal(
                      start: Radius.circular(6),
                      end: Radius.circular(50),
                    ).resolve(Directionality.of(context)),
                    onTap: () => unawaited(_showTimeSelector()),
                    child: Text(
                      AppTranslations.formatJm(_selectedDate),
                      style: pillTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: CustomButton(
              onPressed: _onDonePressed,
              text: widget.entry != null
                  ? AppConstants.updateButton.tr
                  : AppConstants.done.tr,
              color: Colors.transparent,
              textColor: appThemeColors.grey10,
              textSize: 16.sp,
              textPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaLoadingPlaceholder() {
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color baseColor;
    final Color highlightColor;

    if (isDark) {
      baseColor = appThemeColors.grey4;
      highlightColor = appThemeColors.grey3;
    } else {
      baseColor = appThemeColors.grey5;
      highlightColor = appThemeColors.grey4;
    }

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.sharedImagePaths?.isNotEmpty == true ||
                widget.sharedVideoPaths?.isNotEmpty == true)
              Container(
                height: 250.h,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            if (widget.sharedAudioPaths?.isNotEmpty == true) ...[
              SizedBox(height: 8.h),
              ...List.generate(
                widget.sharedAudioPaths!.length,
                    (index) => Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _removeTopCardAt(int index) {
    final allMedia = [..._previewImages, ..._previewPhotos];
    setState(() {
      if (index < allMedia.length) {
        final media = allMedia[index];
        if (media is AssetEntity) {
          _previewImages.remove(media);
        } else if (media is CapturedPhoto) {
          _previewPhotos.remove(media);
        }
        return;
      }
      var remaining = index - allMedia.length;
      if (_selectedLocation != null) {
        if (remaining == 0) {
          _selectedLocation = null;
          return;
        }
        remaining--;
      }
      if (_selectedMoodIndex != null) {
        if (remaining == 0) {
          _selectedMoodIndex = null;
          return;
        }
        remaining--;
      }
      if (remaining < _previewAudios.length) {
        _previewAudios.removeAt(remaining);
        return;
      }
      remaining -= _previewAudios.length;
      if (remaining >= 0 && remaining < _previewRecordings.length) {
        final removed = _previewRecordings.removeAt(remaining);
        if (removed.isVoiceRecording && widget.entry == null) {
          final file = File(removed.path);
          if (file.existsSync()) {
            file.delete();
          }
        }
      }
    });
  }

  Widget _buildImagePreview() {
    final allMedia = [..._previewImages, ..._previewPhotos];
    if (allMedia.isEmpty &&
        _selectedLocation == null &&
        _selectedMoodIndex == null &&
        _previewAudios.isEmpty &&
        _previewRecordings.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
      child: JournalCardGrid(
        mediaItems: allMedia,
        location: _selectedLocation,
        moodIndex: _selectedMoodIndex,
        galleryAudios: _previewAudios,
        recordings: _previewRecordings,
        onCardTap: _openMediaPreview,
        onRemoveCard: _removeTopCardAt,
      ),
    );
  }

  Widget _buildTextField(AppThemeColors appThemeColors) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: quill.QuillEditor.basic(
          key: _textFieldKey,
          controller: _quillController,
          focusNode: _focusNode,
          scrollController: _editorScrollController,
          config: quill.QuillEditorConfig(
            placeholder: AppConstants.startWriting.tr,
            customStyles: buildJournalQuillStyles(
              context,
              appThemeColors,
              includePlaceholder: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagField(AppThemeColors appThemeColors) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _showTagInputDialog(appThemeColors),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: appThemeColors.grey5,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 14.sp, color: appThemeColors.grey1),
                      SizedBox(width: 4.w),
                      Text(
                        AppConstants.addTags.tr,
                        style: TextStyle(
                          color: appThemeColors.grey1,
                          fontSize: 12.sp,
                          fontFamily: AppConstants.font,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_tags.isNotEmpty) SizedBox(width: 8.w),
              ..._tags.map((tag) => Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppTheme.getTagBaseColor(tag, Theme.of(context).brightness),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        tag.startsWith('#') ? tag : '#$tag',
                        style: TextStyle(
                          color: AppTheme.getTagLightColor(tag, Theme.of(context).brightness),
                          fontSize: 12.sp,
                          fontFamily: AppConstants.font,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _tags.remove(tag);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: appThemeColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showTagInputDialog(AppThemeColors appThemeColors) {
    _tagController.clear();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = Get.find<HiveService>().pitchBlack;
    final fieldBg = isPitchBlack
        ? (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05))
        : appThemeColors.grey5;

    showAppAlertDialog<void>(
      context: context,
      title: AppConstants.addTags.tr,
      content: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fieldBg,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            Text(
              '#',
              style: TextStyle(
                color: appThemeColors.grey1,
                fontSize: 18.sp,
                fontFamily: AppConstants.font,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: _tagController,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  _addTag(value);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  fontSize: 15.5.sp,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: appThemeColors.primary,
                decoration: InputDecoration(
                  hintText: AppConstants.tagPlaceholder.replaceAll('#', ''),
                  hintStyle: TextStyle(
                    color: appThemeColors.grey2,
                    fontFamily: AppConstants.font,
                    fontSize: 15.sp,
                  ),
                  filled: false,
                  isDense: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
      actionsBuilder: (dialogContext) => [
        AppAlertAction(
          label: AppConstants.cancel.tr,
          onPressed: () => Navigator.pop(dialogContext),
        ),
        AppAlertAction(
          label: AppConstants.add.tr,
          isDefault: true,
          onPressed: () {
            _addTag(_tagController.text);
            Navigator.pop(dialogContext);
          },
        ),
      ],
    );
  }

  void _addTag(String value) {
    String tag = value.trim();
    if (tag.isEmpty) return;

    // Split by spaces to allow multiple tags at once
    final rawTags = tag.split(RegExp(r'\s+')).where((t) => t.isNotEmpty);

    setState(() {
      for (var t in rawTags) {
        String formattedTag = t.startsWith('#') ? t : '#$t';
        if (!_tags.contains(formattedTag)) {
          _tags.add(formattedTag);
        }
      }
    });
  }

  Widget _buildDraggableSheet(
      double screenHeight,
      double sheetMinSize,
      double sheetInitialSize,
      double keyboardHeight,
      ) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0, // ALWAYS 0 so size fraction is relative to the screen!
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedBuilder(
          animation: _sheetSlideCurve,
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) =>
                _handleSheetNotification(notification, screenHeight),
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

    // Apply keyboard padding directly to the sheet content so it scrolls up naturally
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
        onRecordingComplete: (path, duration) {
          setState(() {
            final recordingName = AppConstants.openJotRecording.replaceFirst(
              '%s',
              (_previewRecordings.where((r) => r.isVoiceRecording).length + 1)
                  .toString()
                  .padLeft(2, '0'),
            );
            _previewRecordings.add(
              RecordedAudio(
                path: path,
                name: recordingName,
                duration: duration,
              ),
            );
          });
          _closeSheet();
        },
        onAssetsSelected: (assets) {
          setState(() {
            final imagesAndVideos = assets
                .where(
                  (a) =>
                      a.type == AssetType.image || a.type == AssetType.video,
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
            audios.removeWhere(
              (asset) => existingAudioIds.contains(asset.id),
            );
            _previewAudios.addAll(audios);
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
          _closeSheet();
        },
        onPhotoTaken: (photo) {
          setState(() {
            final photoName = AppConstants.openJotImage.replaceFirst(
              '%s',
              (_previewPhotos.length + 1).toString(),
            );
            _previewPhotos.add(
              CapturedPhoto(
                file: photo,
                name: photoName,
              ),
            );
          });
          _closeSheet();
        },
        onFilesPicked: (paths, type) {
          setState(() {
            if (type == AssetType.audio) {
              for (final path in paths) {
                final name = p.basename(path);
                _previewRecordings.add(
                  RecordedAudio(
                    path: path,
                    name: name,
                    duration: Duration.zero,
                    isShared: true,
                    isMusic: true,
                  ),
                );
              }
            } else {
              for (final path in paths) {
                final name = p.basename(path);
                _previewPhotos.add(
                  CapturedPhoto(
                    file: XFile(path),
                    name: name,
                  ),
                );
              }
            }
          });
          _closeSheet();
        },
        onMoodChanged: (index) {
          setState(() {
            _selectedMoodIndex = index;
          });
        },
        isPitchBlack: isPitchBlack,
      ),
    );

    return Material(
      color: backgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: EdgeInsets.only(
          left: 0.w,
          right: 0.w,
          top: isCamera ? 8.h : (isMic ? 12.h : 16.h),
          bottom: totalBottomPadding,
        ),
        child: isMic
            ? Stack(
                children: [
                  toolbarContent,
                  Align(
                    alignment: Alignment.topCenter,
                    child: _buildSheetHandle(sheetThemeColors, isPitchBlack),
                  ),
                ],
              )
            : Column(
                children: [
                  _buildSheetHandle(sheetThemeColors, isPitchBlack),
                  SizedBox(height: isCamera ? 8.h : 16.h),
                  Expanded(child: toolbarContent),
                ],
              ),
      ),
    );
  }

  Widget _buildSheetHandle(AppThemeColors colors, [bool isPitchBlack = false]) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 5,
      width: 40,
      decoration: BoxDecoration(
        color: isPitchBlack
            ? (isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1))
            : colors.grey1,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildToolbar() {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final currentStyle = _quillController.getSelectionStyle();
    final hasSelection = !_quillController.selection.isCollapsed;
    final isMainEditorFocused = _focusNode.hasFocus;

    Widget toolbar;
    // Only swap to the TextStylingToolbar if the main editor specifically has focus
    if (isMainEditorFocused && (isKeyboardVisible || hasSelection)) {
      toolbar = TextStylingToolbar(
        key: const ValueKey('TextStylingToolbar'),
        onToolbarItemTap: _handleTextStylingToolbarItemTap,
        onPinTap: _handlePinTap,
        isBoldActive: currentStyle.containsKey(quill.Attribute.bold.key),
        isItalicActive: currentStyle.containsKey(quill.Attribute.italic.key),
        isUnderlineActive:
        currentStyle.containsKey(quill.Attribute.underline.key),
        isStrikethroughActive:
        currentStyle.containsKey(quill.Attribute.strikeThrough.key),
        isTitleActive: currentStyle.containsKey(quill.Attribute.h1.key) ||
            currentStyle.containsKey(quill.Attribute.h2.key) ||
            currentStyle.containsKey(quill.Attribute.h3.key),
        isQuoteActive: currentStyle.containsKey(quill.Attribute.blockQuote.key),
        isBulletActive: currentStyle.containsKey(quill.Attribute.ul.key),
        isRtlActive: currentStyle.containsKey(quill.Attribute.rtl.key),
        onRtlToggle: () {
          final isRtl = currentStyle.containsKey(quill.Attribute.rtl.key);
          if (isRtl) {
            _quillController.formatSelection(
              quill.Attribute.clone(quill.Attribute.rtl, null),
            );
          } else {
            _quillController.formatSelection(quill.Attribute.rtl);
          }
        },
      );
    } else {
      toolbar = WriteJournalToolbar(
        key: const ValueKey('WriteJournalToolbar'),
        toolbarIcons: _toolbarIcons,
        selectedToolbarIcon: _selectedToolbarIcon,
        isDraggableSheetActive: _isDraggableSheetActive,
        onToolbarItemTap: _handleToolbarItemTap,
        isRtlActive: currentStyle.containsKey(quill.Attribute.rtl.key),
        onRtlToggle: () {
          final isRtl = currentStyle.containsKey(quill.Attribute.rtl.key);
          if (isRtl) {
            _quillController.formatSelection(
              quill.Attribute.clone(quill.Attribute.rtl, null),
            );
          } else {
            _quillController.formatSelection(quill.Attribute.rtl);
          }
        },
        onCloseTap: _handleCloseSheetRequest,
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        );
      },
      child: toolbar,
    );
  }

  Future<bool> _onWillPop() async {
    if (_allowPop) return true;

    if (_isDraggableSheetActive) {
      unawaited(_handleCloseSheetRequest());
      return false;
    }

    // Allow graceful dismissal if nothing was changed or entered
    if (!_hasUnsavedChanges && widget.entry == null) {
      return true;
    }

    if (!_hasUnsavedChanges && widget.entry != null) {
      return true;
    }

    // Show Dialog for physical back button
    final action = await showAppAlertDialog<String>(
      context: context,
      title: AppConstants.unsavedChanges.tr,
      message: AppConstants.unsavedChangesMessage.tr,
      actionsBuilder: (dialogContext) => [
        AppAlertAction(
          label: AppConstants.saveAsDraft.tr,
          isDefault: true,
          onPressed: () => Navigator.pop(dialogContext, 'draft'),
        ),
        AppAlertAction(
          label: AppConstants.discardChanges.tr,
          isDestructive: true,
          onPressed: () => Navigator.pop(dialogContext, 'discard'),
        ),
        AppAlertAction(
          label: AppConstants.cancel.tr,
          onPressed: () => Navigator.pop(dialogContext, 'cancel'),
        ),
      ],
    );

    if (action == 'discard') {
      _isSavedOrDiscarded = true;
      if (widget.entry == null) {
        Get.find<HomeController>().deleteJournalEntry(_currentEntryId);
      } else {
        Get.find<HomeController>().updateJournalEntry(widget.entry!);
      }
      return true; // Allow pop
    } else if (action == 'draft') {
      _isSavedOrDiscarded = true;
      _saveEntry(isDraft: true);
      CustomToast.showToast(AppConstants.draftSaved.tr);
      return true; // Allow pop
    }

    return false; // Keep the sheet open if they click 'Cancel'
  }

  @override
  Widget build(BuildContext context) {
    final hiveService = Get.find<HiveService>();
    final isPitchBlack = hiveService.pitchBlack;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appThemeColors = AppTheme.colorsOf(context);

    final backgroundColor = isPitchBlack
        ? (isDark ? Colors.black : Colors.white)
        : appThemeColors.grey6;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          _bodyHeight = screenHeight;
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final isKeyboardVisible = keyboardHeight > 0;

          if (_sheetState == _SheetTransitionState.opening &&
              !isKeyboardVisible &&
              mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _sheetState == _SheetTransitionState.opening) {
                _openSheet(
                  _selectedToolbarIcon!,
                  afterKeyboardClose: true,
                );
                setState(() {
                  _sheetState = _SheetTransitionState.open;
                });
              }
            });
          }

          _handleKeyboardInteraction(isKeyboardVisible);

          final maxSheetSize = _fullSheetFraction(screenHeight);
          final safeBottom = MediaQuery.of(context).padding.bottom;
          final effectiveBottom = math.max(keyboardHeight, safeBottom);

          final behindSheet = RepaintBoundary(
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                backgroundColor: backgroundColor,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: _buildHeader(appThemeColors),
                titleSpacing: 14.w,
              ),
              resizeToAvoidBottomInset: false,
              body: LayoutBuilder(
                builder: (context, editorConstraints) {
                  return SingleChildScrollView(
                    controller: _mainScrollController,
                    padding: EdgeInsets.only(
                      left: 2.w,
                      right: 2.w,
                      bottom: effectiveBottom + 64.h,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: math.max(
                          0.0,
                          editorConstraints.maxHeight -
                              effectiveBottom -
                              64.h,
                        ),
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 16.h),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isLoadingMedia)
                                    _buildMediaLoadingPlaceholder(),
                                  if (!_isLoadingMedia)
                                    _buildImagePreview(),
                                  SizedBox(height: 8.h),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTagField(appThemeColors),
                                  SizedBox(height: 16.h),
                                  Expanded(
                                    child: _buildTextField(appThemeColors),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
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
              AnimatedBuilder(
                animation: Listenable.merge([
                  _sheetController,
                  _sheetSlideCurve,
                  _focusNode,
                  _quillController,
                ]),
                builder: (context, _) {
                  final anim = _sheetSlideCurve.value;
                  final currentSheetSize = _sheetController.isAttached
                      ? _sheetController.size
                      : (_activeSheetInitialSize ?? 0.0);
                  final sheetHeight = _isDraggableSheetActive
                      ? (currentSheetSize * screenHeight) * anim
                      : 0.0;
                  final bottomOffset =
                      math.max(safeBottom, math.max(keyboardHeight, sheetHeight));
                  final sheetGap =
                      (_isDraggableSheetActive && anim > 0.01) ? 2.0 : 0.0;
                  return Positioned(
                    left: 0,
                    right: 0,
                    bottom: bottomOffset + sheetGap,
                    child: _buildToolbar(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  const DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    this.dashWidth = 4,
    this.dashSpace = 4,
    this.fillColor,
  });

  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final Color? fillColor;

  @override
  void paint(Canvas canvas, ui.Size size) {
    final rrect = ui.RRect.fromRectAndRadius(
      ui.Rect.fromLTWH(0, 0, size.width, size.height),
      ui.Radius.circular(size.height / 2),
    );
    if (fillColor != null) {
      final fillPaint = ui.Paint()
        ..color = fillColor!
        ..style = ui.PaintingStyle.fill;
      canvas.drawRRect(rrect, fillPaint);
    }
    final dashPaint = ui.Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = ui.PaintingStyle.stroke;
    final path = ui.Path()..addRRect(rrect);
    final dashPath = ui.Path();
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          ui.Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, dashPaint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.fillColor != fillColor;
  }
}