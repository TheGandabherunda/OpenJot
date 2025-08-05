import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../theme.dart';
import 'custom_button.dart';
import 'rich_text_editing_controller.dart';
import 'text_styling_toolbar.dart';
import 'write_journal_toolbar.dart';
import 'write_journal_toolbar_content.dart';

class WriteJournalBottomSheet extends StatefulWidget {
  const WriteJournalBottomSheet({super.key});

  @override
  WriteJournalBottomSheetState createState() => WriteJournalBottomSheetState();
}

class WriteJournalBottomSheetState extends State<WriteJournalBottomSheet> {
  // Controllers and Focus
  late final RichTextEditingController _textController;
  final _focusNode = FocusNode();
  final _sheetController = DraggableScrollableController();
  final _textFieldKey = GlobalKey();

  // State Variables
  bool _isDraggableSheetActive = false;
  IconData? _selectedToolbarIcon;
  bool _openingSheetViaToolbar = false;
  double? _activeSheetMinSize;
  double? _activeSheetInitialSize;
  bool _isTextSelected = false;
  bool _isHandlingStyle = false;
  bool _titleStyleManuallySet = false;

  // Configuration Constants
  static const double _maxChildSize = 0.7;
  static const double _minFractionWithoutKeyboard = 0.2;
  static const double _initialFractionWithoutKeyboard = 0.38;
  static const double _keyboardVisibleMinFractionFactor = 1.0;
  static const double _keyboardVisibleInitialFractionFactor = 1.0;

  // Toolbar Icons
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appThemeColors = AppTheme.colorsOf(context);
    _textController = RichTextEditingController(appThemeColors: appThemeColors);
    _textController.addListener(_handleTextSelectionChange);
    _textController.addListener(_handleHeadingStyle);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _handleHeadingStyle(); // Initial style check
    });
  }

  @override
  void dispose() {
    _textController.removeListener(_handleTextSelectionChange);
    _textController.removeListener(_handleHeadingStyle);
    _textController.dispose();
    _focusNode.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _handleTextSelectionChange() {
    final isSelected = _textController.selection.baseOffset !=
        _textController.selection.extentOffset;

    // Always call setState to rebuild the toolbar and reflect the current style.
    setState(() {
      _isTextSelected = isSelected;
    });
  }

  // ============================================================================
  // HEADING STYLE HANDLER
  // ============================================================================

  void _handleHeadingStyle() {
    if (_isHandlingStyle || _titleStyleManuallySet) return;
    _isHandlingStyle = true;

    try {
      final text = _textController.text;
      const style = 'title';
      final titleStyle =
          const TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
      final firstNewline = text.indexOf('\n');
      final firstLineEnd = firstNewline == -1 ? text.length : firstNewline;
      final firstLineRange = TextRange(start: 0, end: firstLineEnd);

      // Add title style to the first line if it's not empty, or if the text is empty
      // and the cursor is at the beginning (initial state).
      if (firstLineRange.textInside(text).isNotEmpty ||
          (text.isEmpty && _textController.selection.start == 0)) {
        _textController.addStyle(style, titleStyle, firstLineRange);
      } else {
        // Remove the style if the first line is empty.
        _textController.removeStyle(style, firstLineRange);
      }

      // Ensure text after the first line does not have the title style.
      if (firstNewline != -1) {
        final restOfTextRange =
            TextRange(start: firstNewline, end: text.length);
        if (restOfTextRange.textInside(text).isNotEmpty) {
          _textController.removeStyle(style, restOfTextRange);
        } else {
          // If the user presses enter, ensure the new line doesn't carry over the title style.
          _textController.removeStyle(
              style, TextRange(start: firstNewline, end: firstNewline + 1));
        }
      }
    } finally {
      _isHandlingStyle = false;
    }
  }

  // ============================================================================
  // SIZE CALCULATION METHODS
  // ============================================================================

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

  // ============================================================================
  // TOOLBAR INTERACTION METHODS
  // ============================================================================

  void _handleToolbarItemTap(IconData iconData) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    // Scenario 1: Tapping the same icon to close the sheet.
    if (_isDraggableSheetActive && _selectedToolbarIcon == iconData) {
      _closeSheet();
      if (isKeyboardVisible) {
        _focusNode.requestFocus();
      }
      return;
    }

    // Scenario 2: Switching to a different icon while a sheet is already active.
    if (_isDraggableSheetActive && _selectedToolbarIcon != iconData) {
      setState(() {
        _selectedToolbarIcon = iconData; // Just update the content
      });
      return;
    }

    // Scenario 3: Opening the sheet from a closed state.
    if (isKeyboardVisible) {
      _handleSheetOpeningWithKeyboard(iconData);
    } else {
      _handleSheetOpeningWithoutKeyboard(iconData);
    }
  }

  void _handlePinTap() {
    // Unfocusing the text field and clearing the selection will cause the
    // main WriteJournalToolbar to be shown instead of the TextStylingToolbar.
    _focusNode.unfocus();
    setState(() {
      _isTextSelected = false;
    });

    // We add a short delay to allow the UI to update from showing the
    // TextStylingToolbar to the WriteJournalToolbar before we initiate
    // the bottom sheet opening. This prevents visual glitches.
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        // Call the existing handler for opening the sheet with the image icon.
        _handleToolbarItemTap(Icons.image_rounded);
      }
    });
  }

  void _handleTextStylingToolbarItemTap(String style) {
    final appThemeColors = AppTheme.colorsOf(context);
    if (style == 'title') {
      _titleStyleManuallySet = true;
    }
    switch (style) {
      case 'bold':
        _textController.toggleStyle(
          'bold',
          const TextStyle(fontWeight: FontWeight.bold),
        );
        break;
      case 'italic':
        _textController.toggleStyle(
          'italic',
          const TextStyle(fontStyle: FontStyle.italic),
        );
        break;
      case 'underline':
        _textController.toggleStyle(
          'underline',
          const TextStyle(decoration: TextDecoration.underline),
        );
        break;
      case 'strikethrough':
        _textController.toggleStyle(
          'strikethrough',
          const TextStyle(decoration: TextDecoration.lineThrough),
        );
        break;
      case 'bullet':
        _textController.toggleBulletPoints();
        break;
      case 'quote':
        _textController.toggleStyle(
          'quote',
          TextStyle(
            fontStyle: FontStyle.italic,
            color: appThemeColors.grey1,
          ),
        );
        break;
      case 'title':
        _textController.toggleStyle(
          'title',
          const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        );
        break;
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
    _focusNode.unfocus(); // Close keyboard

    // Delay to allow keyboard to start closing
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

  // ============================================================================
  // SHEET NOTIFICATION HANDLER
  // ============================================================================

  bool _handleSheetNotification(
    DraggableScrollableNotification notification,
    double screenHeight,
  ) {
    if (!mounted || !_isDraggableSheetActive || _activeSheetMinSize == null) {
      return true;
    }

    // Handle sheet closing when dragged to minimum
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

  // ============================================================================
  // KEYBOARD INTERACTION HANDLER
  // ============================================================================

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

  // ============================================================================
  // UI BUILDER METHODS
  // ============================================================================

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
          child: TextField(
            key: _textFieldKey,
            controller: _textController,
            focusNode: _focusNode,
            autofocus: true,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontSize: 18.sp,
              fontFamily: AppConstants.font,
              decoration: TextDecoration.none,
            ),
            cursorColor: appThemeColors.primary,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Start writing...',
              hintStyle: TextStyle(color: appThemeColors.grey3),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            expands: true,
          ),
        ),
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
                ? sheetInitialSize // Use passed-in fixed initial size
                : (_sheetController.isAttached
                    ? _sheetController.size
                    : sheetInitialSize),
            minChildSize: sheetMinSize,
            // Use passed-in fixed min size
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
        color: sheetThemeColors.grey4,
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

  // ============================================================================
  // MAIN BUILD METHOD
  // =================================_buildToolbar
  // ============================================================================

  Widget _buildToolbar() {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardVisible || _isTextSelected) {
      return TextStylingToolbar(
        onToolbarItemTap: _handleTextStylingToolbarItemTap,
        onPinTap: _handlePinTap,
        isBoldActive: _textController.isStyleActive('bold'),
        isItalicActive: _textController.isStyleActive('italic'),
        isUnderlineActive: _textController.isStyleActive('underline'),
        isStrikethroughActive: _textController.isStyleActive('strikethrough'),
        isTitleActive: _textController.isStyleActive('title'),
        isQuoteActive: _textController.isStyleActive('quote'),
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

    // Using a LayoutBuilder to get the screen height, which is more robust
    // inside build methods than MediaQuery.
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;

        return AnimatedBuilder(
          animation:
              Listenable.merge([_sheetController, _focusNode, _textController]),
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
