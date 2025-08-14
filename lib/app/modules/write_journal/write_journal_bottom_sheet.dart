import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/text_styling_toolbar.dart';
import '../../core/widgets/write_journal_toolbar.dart';
import '../../core/widgets/write_journal_toolbar_content.dart';

class RecordedAudio {
  final String path;
  final String name;
  final Duration duration;

  RecordedAudio(
      {required this.path, required this.name, required this.duration});
}

class WriteJournalBottomSheet extends StatefulWidget {
  const WriteJournalBottomSheet({super.key});

  @override
  WriteJournalBottomSheetState createState() => WriteJournalBottomSheetState();
}

class WriteJournalBottomSheetState extends State<WriteJournalBottomSheet> {
  late quill.QuillController _quillController;
  final _focusNode = FocusNode();
  final _sheetController = DraggableScrollableController();
  final _editorScrollController = ScrollController();
  final _textFieldKey = GlobalKey();
  final _dateMenuKey = GlobalKey();

  DateTime? _selectedDate;
  bool _isCustomDate = false;
  bool _isDraggableSheetActive = false;
  IconData? _selectedToolbarIcon;
  bool _openingSheetViaToolbar = false;
  double? _activeSheetMinSize;
  double? _activeSheetInitialSize;
  bool _isFormatting = false;
  bool _wasKeyboardVisible = false;
  List<AssetEntity> _previewImages = [];
  List<AssetEntity> _previewAudios = [];
  List<RecordedAudio> _previewRecordings = [];

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingPath;
  PlayerState? _playerState;
  StreamSubscription? _playerStateSubscription;

  static const double _maxChildSize = 0.7;
  static const double _minFractionWithoutKeyboard = 0.2;
  static const double _initialFractionWithoutKeyboard = 0.38;
  static const double _keyboardVisibleMinFractionFactor = 1.0;
  static const double _keyboardVisibleInitialFractionFactor = 1.0;

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
    _quillController = quill.QuillController.basic();
    _selectedDate = DateTime.now();

    _quillController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _quillController.document.changes.listen(_handleTextChange);

    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
          if (state == PlayerState.completed) {
            _currentlyPlayingPath = null;
          }
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _quillController.document.changes.listen(null);
    _quillController.dispose();
    _focusNode.dispose();
    _sheetController.dispose();
    _editorScrollController.dispose();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleTextChange(quill.DocChange docChange) {
    if (docChange.source != quill.ChangeSource.remote || _isFormatting) {
      return;
    }

    _isFormatting = true;
    Future.microtask(() async {
      try {
        final insertedText = docChange.change
            .toList()
            .where((op) => op.isInsert && op.data is String)
            .map((op) => op.data as String)
            .join();

        if (insertedText.isEmpty) {
          return;
        }

        final urlRegExp = RegExp(
          r'((https?:\/\/)|(www\.))[^\s]+',
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

        final List<RegExpMatch> matches = [
          ...urlRegExp.allMatches(insertedText),
          ...emailRegExp.allMatches(insertedText),
          ...phoneRegExp.allMatches(insertedText),
        ];

        if (matches.isEmpty) {
          return;
        }

        matches.sort((a, b) => a.start.compareTo(b.start));

        int offset = 0;
        docChange.change.toList().where((op) => op.isInsert).forEach((op) {
          if (op.data is String) {
            final opText = op.data as String;
            for (final match in matches) {
              if (opText.contains(match.group(0)!)) {
                final matchStart = opText.indexOf(match.group(0)!);
                final matchedString = match.group(0)!;
                String link;
                if (urlRegExp.hasMatch(matchedString)) {
                  link = matchedString.startsWith('http')
                      ? matchedString
                      : 'https://$matchedString';
                } else if (emailRegExp.hasMatch(matchedString)) {
                  link = 'mailto:$matchedString';
                } else if (phoneRegExp.hasMatch(matchedString)) {
                  link = 'tel:$matchedString';
                } else {
                  link = matchedString;
                }

                final style = quill.LinkAttribute(link);
                _quillController.formatText(
                  offset + matchStart,
                  matchedString.length,
                  style,
                );
              }
            }
          }
          offset += op.length ?? 0;
        });
      } finally {
        _isFormatting = false;
      }
    });
  }

  Future<void> _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _isCustomDate = true;
      });
    }
  }

  double _calculateInitialChildSize(
    BuildContext context, {
    bool afterKeyboardClose = false,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (afterKeyboardClose) {
      return _initialFractionWithoutKeyboard.clamp(
        _minFractionWithoutKeyboard,
        _maxChildSize,
      );
    }

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    double initialSize;

    if (keyboardHeight > 0 && _keyboardVisibleInitialFractionFactor < 1.0) {
      initialSize =
          (_keyboardVisibleInitialFractionFactor * keyboardHeight + 200.h) /
              screenHeight;
    } else {
      initialSize = _initialFractionWithoutKeyboard;
    }

    return initialSize.clamp(
      _calculateMinChildSize(context, afterKeyboardClose: afterKeyboardClose),
      _maxChildSize,
    );
  }

  double _calculateMinChildSize(
    BuildContext context, {
    bool afterKeyboardClose = false,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (afterKeyboardClose) {
      return _minFractionWithoutKeyboard.clamp(0.1, _maxChildSize);
    }

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    double minSize;

    if (keyboardHeight > 0 && _keyboardVisibleMinFractionFactor < 1.0) {
      minSize =
          (_keyboardVisibleMinFractionFactor * keyboardHeight) / screenHeight;
    } else {
      minSize = _minFractionWithoutKeyboard;
    }

    return minSize.clamp(0.1, _maxChildSize);
  }

  Future<void> _handleAttachmentTap(IconData iconData) async {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    if (_isDraggableSheetActive && _selectedToolbarIcon == iconData) {
      _closeSheet();
      if (isKeyboardVisible) {
        _focusNode.requestFocus();
      }
      return;
    }

    if (_isDraggableSheetActive && _selectedToolbarIcon != iconData) {
      setState(() {
        _selectedToolbarIcon = iconData;
      });
      return;
    }

    if (iconData == Icons.image_rounded ||
        iconData == Icons.camera_alt_rounded) {
      var status = await Permission.photos.request();
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
      var status = await Permission.microphone.request();
      if (!status.isGranted) {
        // Optionally show a message to the user
        return;
      }
    }

    if (iconData == Icons.image_rounded ||
        iconData == Icons.camera_alt_rounded ||
        iconData == Icons.location_on_rounded ||
        iconData == Icons.mic_rounded) {
      _handleAttachmentTap(iconData);
    } else {
      final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

      if (_isDraggableSheetActive && _selectedToolbarIcon == iconData) {
        _closeSheet();
        if (isKeyboardVisible) {
          _focusNode.requestFocus();
        }
        return;
      }

      if (_isDraggableSheetActive && _selectedToolbarIcon != iconData) {
        setState(() {
          _selectedToolbarIcon = iconData;
        });
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
      _handleAttachmentTap(Icons.image_rounded);
    });
  }

  void _handlemoodTap() {
    _focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _handleToolbarItemTap(Icons.sentiment_satisfied_rounded);
      }
    });
  }

  void _handlelocationTap() {
    _focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _handleToolbarItemTap(Icons.location_on_rounded);
      }
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
    bool hasHeader = currentStyle.containsKey(quill.Attribute.h1.key) ||
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

  void _closeSheet() {
    if (!mounted) return;
    setState(() {
      _isDraggableSheetActive = false;
      _selectedToolbarIcon = null;
      _openingSheetViaToolbar = false;
      _activeSheetMinSize = null;
      _activeSheetInitialSize = null;
    });
  }

  void _handleSheetOpeningWithKeyboard(IconData iconData) {
    _focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        _openSheet(iconData, afterKeyboardClose: true);
      }
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
    );
    final newMinSize = _calculateMinChildSize(
      context,
      afterKeyboardClose: afterKeyboardClose,
    );

    setState(() {
      _openingSheetViaToolbar = true;
      _selectedToolbarIcon = iconData;
      _isDraggableSheetActive = true;
      _activeSheetInitialSize = newInitialSize;
      _activeSheetMinSize = newMinSize;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_sheetController.isAttached && mounted) {
        if (afterKeyboardClose) {
          _sheetController.jumpTo(newInitialSize);
        } else {
          _sheetController.animateTo(
            newInitialSize,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
    _resetToolbarFlag(afterKeyboardClose ? 300 : 550);
  }

  void _resetToolbarFlag(int delayMs) {
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) {
        setState(() {
          _openingSheetViaToolbar = false;
        });
      }
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
      _scheduleSheetClose(minSizeForClosingCheck);
    }
    return true;
  }

  void _scheduleSheetClose(double minSizeForClosingCheck) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _isDraggableSheetActive &&
          _sheetController.isAttached &&
          _sheetController.size <= minSizeForClosingCheck + 0.01) {
        setState(() {
          _isDraggableSheetActive = false;
          _selectedToolbarIcon = null;
          _activeSheetMinSize = null;
          _activeSheetInitialSize = null;
        });
      }
    });
  }

  void _handleKeyboardInteraction(bool isKeyboardVisible) {
    if (isKeyboardVisible &&
        !_wasKeyboardVisible &&
        _isDraggableSheetActive &&
        !_openingSheetViaToolbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isDraggableSheetActive) {
          _closeSheet();
        }
      });
    }
    _wasKeyboardVisible = isKeyboardVisible;
  }

  Widget _buildHeader(AppThemeColors appThemeColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            _handlemoodTap();
          },
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.transparent,
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.bookmark_outline_rounded,
              color: appThemeColors.grey2,
              size: 28.w,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: GestureDetector(
            onTap: () {
              final RenderBox renderBox =
                  _dateMenuKey.currentContext!.findRenderObject() as RenderBox;
              final position = renderBox.localToGlobal(Offset.zero);
              showMenu(
                context: context,
                color: appThemeColors.grey5,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                position: RelativeRect.fromLTRB(
                  position.dx + (renderBox.size.width / 2) - 80.w,
                  position.dy + renderBox.size.height + 10.h,
                  MediaQuery.of(context).size.width -
                      (position.dx + (renderBox.size.width / 2) - 80.w),
                  position.dy + renderBox.size.height + 200.h,
                ),
                items: [
                  PopupMenuItem(
                    value: 'entry_date',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Today date',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppConstants.font,
                                color: appThemeColors.grey10)),
                        Text(
                          DateFormat('EEEE, MMM d').format(DateTime.now()),
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppConstants.font,
                              color: appThemeColors.grey1),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    enabled: false,
                    padding: EdgeInsets.zero,
                    height: 4,
                    child: Divider(
                      color: appThemeColors.grey6,
                      thickness: 1,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'custom_date',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Custom Date',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppConstants.font,
                                color: appThemeColors.grey10)),
                        if (_isCustomDate && _selectedDate != null)
                          Text(
                            DateFormat('EEEE, MMM d').format(_selectedDate!),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: appThemeColors.grey1,
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    enabled: false,
                    padding: EdgeInsets.zero,
                    height: 4,
                    child: Divider(
                      color: appThemeColors.grey6,
                      thickness: 1,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'remove',
                    child: Text(
                      'Remove',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppConstants.font,
                          color: appThemeColors.error),
                    ),
                  ),
                ],
              ).then((value) {
                if (value == 'entry_date') {
                  setState(() {
                    _selectedDate = DateTime.now();
                    _isCustomDate = false;
                  });
                } else if (value == 'custom_date') {
                  _showDatePicker();
                } else if (value == 'remove') {
                  setState(() {
                    _selectedDate = null;
                    _isCustomDate = false;
                  });
                }
              });
            },
            child: Container(
              key: _dateMenuKey,
              child: Text(
                _selectedDate != null
                    ? DateFormat('EEEE, MMM d').format(_selectedDate!)
                    : 'Select Date',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppConstants.font,
                  color: appThemeColors.grey10.withAlpha((255 * 0.6).round()),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
        CustomButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Done',
          color: Colors.transparent,
          textColor: appThemeColors.grey10,
          textSize: 16.sp,
          textPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (_previewImages.isEmpty) {
      return const SizedBox.shrink();
    }

    final double spacing = 2.w;
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor = (isDark ? appThemeColors.grey7 : appThemeColors.grey10)
        .withOpacity(0.6);
    final onOverlayColor =
        isDark ? appThemeColors.grey10 : appThemeColors.grey7;

    Widget buildImageContainer(AssetEntity asset, {Widget? overlay}) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: appThemeColors.grey3, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.5.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SizedAssetThumbnail(asset: asset),
              if (overlay != null) overlay,
              Positioned(
                top: 4.w,
                right: 4.w,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _previewImages.remove(asset);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: overlayColor,
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.close, color: onOverlayColor, size: 18.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget content;
    if (_previewImages.length == 1) {
      content = SizedBox(
        height: 250.h,
        width: double.infinity,
        child: buildImageContainer(_previewImages[0]),
      );
    } else if (_previewImages.length == 2) {
      content = SizedBox(
        height: 250.h,
        child: Row(
          children: [
            Expanded(child: buildImageContainer(_previewImages[0])),
            SizedBox(width: spacing),
            Expanded(child: buildImageContainer(_previewImages[1])),
          ],
        ),
      );
    } else {
      Widget? thirdImageOverlay;
      if (_previewImages.length > 3) {
        thirdImageOverlay = ClipRRect(
          // Use ClipRRect to constrain the blur effect to the rounded corners.
          borderRadius: BorderRadius.circular(10.5.r),
          // Match the parent's border radius.
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            // This applies the blur. You can adjust the sigma values.
            child: Container(
              color: overlayColor,
              // This color sits on top of the blurred image.
              child: Center(
                child: Text(
                  '+${_previewImages.length - 3}',
                  style: TextStyle(
                      color: onOverlayColor,
                      fontSize: 32.sp,
                      fontFamily: AppConstants.font,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
          ),
        );
      }

      content = SizedBox(
        height: 250.h,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: buildImageContainer(_previewImages[0]),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: buildImageContainer(_previewImages[1])),
                  SizedBox(height: spacing),
                  Expanded(
                    child: buildImageContainer(
                      _previewImages[2],
                      overlay: thirdImageOverlay,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
      child: content,
    );
  }

  Widget _buildAudioPreview() {
    if (_previewAudios.isEmpty) {
      return const SizedBox.shrink();
    }

    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor = (isDark ? appThemeColors.grey7 : appThemeColors.grey10)
        .withOpacity(0.6);
    final onOverlayColor =
        isDark ? appThemeColors.grey10 : appThemeColors.grey7;

    return Column(
      children: _previewAudios.map((audio) {
        return Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Container(
            height: 40.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: appThemeColors.grey4,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Icons.music_note_rounded,
                    color: appThemeColors.grey1, size: 24.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    audio.title ?? 'Audio track',
                    style: TextStyle(
                      color: appThemeColors.grey10,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: AppConstants.font,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _previewAudios.remove(audio);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: overlayColor,
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.close, color: onOverlayColor, size: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatPreviewDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildRecordingsPreview() {
    if (_previewRecordings.isEmpty) {
      return const SizedBox.shrink();
    }

    final appThemeColors = AppTheme.colorsOf(context);

    return Column(
      children: _previewRecordings.map((recording) {
        final isPlaying = _currentlyPlayingPath == recording.path &&
            _playerState == PlayerState.playing;
        final isPaused = _currentlyPlayingPath == recording.path &&
            _playerState == PlayerState.paused;

        return Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Container(
            height: 50.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: appThemeColors.grey4,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    color: appThemeColors.grey1,
                    size: 28.sp,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      _audioPlayer.pause();
                    } else if (isPaused) {
                      _audioPlayer.resume();
                    } else {
                      _audioPlayer.play(DeviceFileSource(recording.path));
                      setState(() {
                        _currentlyPlayingPath = recording.path;
                      });
                    }
                  },
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recording.name,
                        style: TextStyle(
                          color: appThemeColors.grey10,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: AppConstants.font,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        _formatPreviewDuration(recording.duration),
                        style: TextStyle(
                          color: appThemeColors.grey1,
                          fontSize: 12.sp,
                          decoration: TextDecoration.none,
                          fontFamily: AppConstants.font,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  icon: Icon(Icons.close,
                      color: appThemeColors.grey1, size: 20.sp),
                  onPressed: () {

                    if (_currentlyPlayingPath == recording.path) {
                      _audioPlayer.stop();
                      _currentlyPlayingPath = null;
                    }
                    setState(() {
                      _previewRecordings.remove(recording);
                      // also delete the file
                      final file = File(recording.path);
                      if(file.existsSync()){
                        file.delete();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
            placeholder: ' Start writing...',
            customStyles: quill.DefaultStyles(
              placeHolder: quill.DefaultTextBlockStyle(
                TextStyle(
                  fontSize: 16.sp,
                  color: appThemeColors.grey2,
                ),
                quill.HorizontalSpacing.zero,
                quill.VerticalSpacing.zero,
                quill.VerticalSpacing.zero,
                null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodField(AppThemeColors appThemeColors) {
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: GestureDetector(
              onTap: () {
                _handlemoodTap();
              },
              child: CustomPaint(
                painter: DashedBorderPainter(
                  color: appThemeColors.grey5,
                  strokeWidth: 2.w,
                  fillColor: appThemeColors.grey6,
                ),
                child: SizedBox(
                  width: 38.w,
                  height: 38.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_reaction_outlined,
                        color: appThemeColors.grey4,
                        size: 28.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: GestureDetector(
              onTap: () {
                _handlelocationTap();
              },
              child: CustomPaint(
                painter: DashedBorderPainter(
                  color: appThemeColors.grey5,
                  strokeWidth: 2.w,
                  fillColor: appThemeColors.grey6,
                ),
                child: SizedBox(
                  width: 38.w,
                  height: 38.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_location_alt_outlined,
                        color: appThemeColors.grey4,
                        size: 28.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableSheet(
    double screenHeight,
    double sheetMinSize,
    double sheetInitialSize,
  ) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) =>
              _handleSheetNotification(notification, screenHeight),
          child: DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: _openingSheetViaToolbar
                ? sheetInitialSize
                : (_sheetController.isAttached
                    ? _sheetController.size
                    : sheetInitialSize),
            minChildSize: sheetMinSize,
            maxChildSize: _maxChildSize,
            expand: false,
            builder: (context, scrollController) =>
                _buildSheetContainer(context, scrollController),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetContainer(
    BuildContext context,
    ScrollController scrollController,
  ) {
    final sheetThemeColors = AppTheme.colorsOf(context);
    final sheetKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: sheetThemeColors.grey5,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: (sheetKeyboardHeight > 0 ? sheetKeyboardHeight : 0) + 16.h,
      ),
      child: Column(
        children: [
          _buildSheetHandle(sheetThemeColors),
          Expanded(
            child: WriteJournalToolbarContent(
              selectedToolbarIcon: _selectedToolbarIcon,
              scrollController: scrollController,
              onRecordingComplete: (path, duration) {
                setState(() {
                  final recordingName =
                      'OpenJot recording (${_previewRecordings.length + 1})';
                  _previewRecordings.add(RecordedAudio(
                      path: path, name: recordingName, duration: duration));
                });
                _closeSheet();
              },
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
                _closeSheet();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetHandle(AppThemeColors colors) {
    return Center(
      child: Container(
        height: 5,
        width: 40,
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: colors.grey1,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final currentStyle = _quillController.getSelectionStyle();
    final hasSelection = !_quillController.selection.isCollapsed;

    if (isKeyboardVisible || hasSelection) {
      return TextStylingToolbar(
        onToolbarItemTap: _handleTextStylingToolbarItemTap,
        onPinTap: _handlePinTap,
        isBoldActive: currentStyle.containsKey(quill.Attribute.bold.key),
        isItalicActive: currentStyle.containsKey(quill.Attribute.italic.key),
        isUnderlineActive: currentStyle.containsKey(
          quill.Attribute.underline.key,
        ),
        isStrikethroughActive: currentStyle.containsKey(
          quill.Attribute.strikeThrough.key,
        ),
        isTitleActive: currentStyle.containsKey(quill.Attribute.h1.key) ||
            currentStyle.containsKey(quill.Attribute.h2.key) ||
            currentStyle.containsKey(quill.Attribute.h3.key),
        isQuoteActive: currentStyle.containsKey(quill.Attribute.blockQuote.key),
        isBulletActive: currentStyle.containsKey(quill.Attribute.ul.key),
      );
    } else {
      return WriteJournalToolbar(
        toolbarIcons: _toolbarIcons,
        selectedToolbarIcon: _selectedToolbarIcon,
        isDraggableSheetActive: _isDraggableSheetActive,
        onToolbarItemTap: _handleToolbarItemTap,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);

    return PopScope(
      canPop: !_isDraggableSheetActive,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        _closeSheet();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;

          return AnimatedBuilder(
            animation: Listenable.merge([
              _sheetController,
              _focusNode,
              _quillController,
            ]),
            builder: (context, child) {
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              final isKeyboardVisible = keyboardHeight > 0;

              _handleKeyboardInteraction(isKeyboardVisible);

              final sheetHeight =
                  (_isDraggableSheetActive && _sheetController.isAttached)
                      ? _sheetController.size * screenHeight
                      : 0.0;

              final bottomOffset = math.max(keyboardHeight, sheetHeight);

              return Container(
                color: appThemeColors.grey6,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: bottomOffset,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 16.h,
                          left: 2.w,
                          right: 2.w,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: _buildHeader(appThemeColors),
                            ),
                            SizedBox(height: 16.h),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minHeight: constraints.maxHeight),
                                      child: IntrinsicHeight(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 14.w),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  _buildImagePreview(),
                                                  if (_previewImages
                                                          .isNotEmpty &&
                                                      _previewAudios.isNotEmpty)
                                                    SizedBox(height: 2.h),
                                                  _buildAudioPreview(),
                                                  if ((_previewImages
                                                              .isNotEmpty ||
                                                          _previewAudios
                                                              .isNotEmpty) &&
                                                      _previewRecordings
                                                          .isNotEmpty)
                                                    SizedBox(height: 2.h),
                                                  _buildRecordingsPreview(),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 16.h),
                                            _buildMoodField(appThemeColors),
                                            SizedBox(height: 16.h),
                                            Expanded(
                                              child: _buildTextField(
                                                  appThemeColors),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildToolbar(),
                          ],
                        ),
                      ),
                    ),
                    if (_isDraggableSheetActive &&
                        _activeSheetMinSize != null &&
                        _activeSheetInitialSize != null)
                      _buildDraggableSheet(
                        screenHeight,
                        _activeSheetMinSize!,
                        _activeSheetInitialSize!,
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// NEW WIDGET to handle image loading efficiently and prevent blinking.
class SizedAssetThumbnail extends StatefulWidget {
  final AssetEntity asset;

  const SizedAssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  @override
  _SizedAssetThumbnailState createState() => _SizedAssetThumbnailState();
}

class _SizedAssetThumbnailState extends State<SizedAssetThumbnail> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant SizedAssetThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.asset.id != oldWidget.asset.id) {
      // If the asset entity itself changes, reload the image data.
      setState(() {
        _imageData = null;
      });
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (!mounted) return;
    // Fetches the thumbnail data with a specific size and quality.
    final data = await widget.asset.thumbnailDataWithSize(
      const ThumbnailSize(500, 500),
      quality: 95,
    );
    if (mounted) {
      setState(() {
        _imageData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageData != null) {
      // Display the image once loaded.
      return Image.memory(
        _imageData!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        gaplessPlayback: true, // Ensures a smooth display without flickering.
      );
    }
    // Show a placeholder while the image is loading.
    final appThemeColors = AppTheme.colorsOf(context);
    return Container(color: appThemeColors.grey4);
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final Color? fillColor;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    this.dashWidth = 4,
    this.dashSpace = 4,
    this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    );

    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, fillPaint);
    }

    final dashPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()..addRRect(rrect);

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
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
