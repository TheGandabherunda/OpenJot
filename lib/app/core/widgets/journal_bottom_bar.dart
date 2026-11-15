import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/theme.dart';

/// Fixed bottom bar for the journal screen: a search pill that expands into a
/// full input on tap, plus a round write button on the right.
///
/// Shape and behaviour follow the approved design; colours come from
/// `AppThemeColors` so the bar respects light/dark theme. No Anchor code is
/// copied — the Dart is written new for OpenJot (Apache-2.0).
class JournalBottomBar extends StatefulWidget {
  /// Fired whenever the search query changes (including when cleared).
  final ValueChanged<String> onQueryChanged;

  /// Fired when the round write button is tapped.
  final VoidCallback onWrite;

  /// Hint shown inside the pill when idle.
  final String hintText;

  const JournalBottomBar({
    super.key,
    required this.onQueryChanged,
    required this.onWrite,
    this.hintText = 'Search entries or #tag',
  });

  @override
  State<JournalBottomBar> createState() => _JournalBottomBarState();
}

class _JournalBottomBarState extends State<JournalBottomBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onQueryChanged)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    widget.onQueryChanged(_controller.text);
  }

  void _toggleSearch() {
    setState(() {
      _searching = !_searching;
    });
    if (_searching) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
      _controller.clear();
      widget.onQueryChanged('');
    }
  }

  void _clearQuery() {
    _controller.clear();
    widget.onQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final pillBgColor = colors.grey6.withOpacity(0.9);
    final borderColor = Colors.white.withOpacity(0.12);
    final hintColor = colors.grey1;
    final activeTextColor = colors.grey10;

    return SafeArea(
      top: false,
      child: RepaintBoundary(
        child: Container(
          height: 72.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: colors.grey7.withOpacity(0.82),
          ),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Row(
              children: [
                // --- Search pill (tappable to open search) ---
                Expanded(
                  child: GestureDetector(
                    onTap: _toggleSearch,
                    child: Semantics(
                      button: true,
                      label: AppConstants.searchHintText,
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: pillBgColor,
                          borderRadius: BorderRadius.circular(23.r),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23.r),
                          child: Row(
                            children: [
                              SizedBox(width: 16.w),
                              Icon(
                                Icons.search,
                                size: 20.sp,
                                color: hintColor,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _searching
                                    ? TextField(
                                        controller: _controller,
                                        focusNode: _focusNode,
                                        style: TextStyle(
                                          color: activeTextColor,
                                          fontSize: 13.sp,
                                          fontFamily: AppConstants.font,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: widget.hintText,
                                          hintStyle: TextStyle(
                                            color: hintColor.withOpacity(0.7),
                                            fontSize: 13.sp,
                                            fontFamily: AppConstants.font,
                                          ),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                          isCollapsed: true,
                                        ),
                                        onSubmitted: (_) =>
                                            _focusNode.unfocus(),
                                      )
                                    : Text(
                                        widget.hintText,
                                        style: TextStyle(
                                          color: hintColor,
                                          fontSize: 13.sp,
                                          fontFamily: AppConstants.font,
                                        ),
                                      ),
                              ),
                              if (_controller.text.isNotEmpty &&
                                  _searching)
                                GestureDetector(
                                  onTap: _clearQuery,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 12.w),
                                    child: Icon(
                                      Icons.close,
                                      size: 18.sp,
                                      color: hintColor,
                                    ),
                                  ),
                                ),
                              if (_searching && _controller.text.isEmpty)
                                SizedBox(width: 12.w),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_searching) ...[
                  SizedBox(width: 10.w),
                  // --- Cancel (visible only while searching) ---
                  GestureDetector(
                    onTap: _toggleSearch,
                    child: Semantics(
                      button: true,
                      label: AppConstants.cancel,
                      child: Container(
                        width: 46.h,
                        height: 46.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          AppConstants.cancel,
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppConstants.font,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(width: 10.w),
                // --- Round write button ---
                GestureDetector(
                  onTap: widget.onWrite,
                  child: Semantics(
                    button: true,
                    label: AppConstants.addEntryButton,
                    child: Container(
                      width: 46.h,
                      height: 46.h,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.edit,
                        color: colors.onPrimary,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
