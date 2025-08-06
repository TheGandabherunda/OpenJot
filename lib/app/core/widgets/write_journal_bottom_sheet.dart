import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';
import 'custom_button.dart';
import 'text_styling_toolbar.dart';
import 'write_journal_toolbar.dart';
import 'write_journal_toolbar_content.dart';

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

  bool _isDraggableSheetActive = false;
  IconData? _selectedToolbarIcon;
  bool _openingSheetViaToolbar = false;
  double? _activeSheetMinSize;
  double? _activeSheetInitialSize;

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

    _quillController.addListener(() {
      if (mounted) {
        setState(() {});
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
    _quillController.dispose();
    _focusNode.dispose();
    _sheetController.dispose();
    _editorScrollController.dispose();
    super.dispose();
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

  void _handleToolbarItemTap(IconData iconData) {
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

  void _handlePinTap() {
    _focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _handleToolbarItemTap(Icons.image_rounded);
      }
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
    bool hasHeader =
        currentStyle.containsKey(quill.Attribute.h1.key) ||
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
    Future.delayed(const Duration(milliseconds: 50), () {
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
      if (_sheetController.isAttached) {
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
    _resetToolbarFlag(afterKeyboardClose ? 300 : 50);
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
        _isDraggableSheetActive &&
        !_openingSheetViaToolbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            _isDraggableSheetActive &&
            MediaQuery.of(context).viewInsets.bottom > 0 &&
            !_openingSheetViaToolbar) {
          setState(() {
            _isDraggableSheetActive = false;
            _selectedToolbarIcon = null;
            _activeSheetMinSize = null;
            _activeSheetInitialSize = null;
          });
        }
      });
    }
  }

  Widget _buildHeader(AppThemeColors appThemeColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Cancel',
          color: Colors.transparent,
          textColor: appThemeColors.grey1,
          textSize: 16.sp,
          textPadding: EdgeInsets.zero,
        ),
        CustomButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Done',
          color: Colors.transparent,
          textColor: appThemeColors.grey1,
          textSize: 16.sp,
          textPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildTextField(AppThemeColors appThemeColors) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: quill.QuillEditor.basic(
            key: _textFieldKey,
            controller: _quillController,
            focusNode: _focusNode,
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
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            // Center the content
            child: GestureDetector(
              onTap: () {
                _handlemoodTap();
              },
              child: Container(
                width: 32.w, // Adjust size as needed
                height: 32.w, // Adjust size as needed
                decoration: BoxDecoration(
                  color: Colors.transparent, // Example background color
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.transparent, // Example border color
                    width: 2.w,
                  ),
                ),
                child: Icon(
                  Icons.bookmark_outline_rounded, // "Add emoji" icon
                  color: appThemeColors.grey2,
                  size: 28.w, // Adjust icon size as needed
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            // Center the content
            child: GestureDetector(
              onTap: () {
                _handlemoodTap();
              },
              child: Container(
                width: 40.w, // Adjust size as needed
                height: 40.w, // Adjust size as needed
                decoration: BoxDecoration(
                  color: Colors.transparent, // Example background color
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: appThemeColors.grey4, // Example border color
                    width: 2.w,
                  ),
                ),
                child: Icon(
                  Icons.add_reaction_outlined, // "Add emoji" icon
                  color: appThemeColors.grey1,
                  size: 20.w, // Adjust icon size as needed
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
        isTitleActive:
            currentStyle.containsKey(quill.Attribute.h1.key) ||
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

    return LayoutBuilder(
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
                          SizedBox(height: 32.h),
                          _buildMoodField(appThemeColors),
                          SizedBox(height: 32.h),
                          _buildTextField(appThemeColors),
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
    );
  }
}
