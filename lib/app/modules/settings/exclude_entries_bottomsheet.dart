import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/widgets/journal_tile.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';

import '../../core/models/journal_entry.dart';

enum SortOption { none, mutedFirst, unmutedFirst }

class ExcludeEntriesBottomSheet extends StatefulWidget {
  final List<String> initialExcludedIds;
  final Function(List<String>) onSave;

  const ExcludeEntriesBottomSheet({
    super.key,
    required this.initialExcludedIds,
    required this.onSave,
  });

  @override
  State<ExcludeEntriesBottomSheet> createState() => _ExcludeEntriesBottomSheetState();
}

class _ExcludeEntriesBottomSheetState extends State<ExcludeEntriesBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final HomeController _homeController = Get.find();
  final GlobalKey _sortMenuKey = GlobalKey(); // Key for positioning the menu

  List<JournalEntry> _filteredEntries = [];
  Set<String> _selectedIds = {};

  bool _isBookmarked = false;
  bool _isTextOnly = false;
  bool _isMediaOnly = false;
  bool _withMood = false;
  bool _withLocation = false;
  bool _isReflection = false;
  bool _isDraft = false;
  bool _isSaving = false; // Flag to bypass exit dialog when saving

  SortOption _currentSort = SortOption.none;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set.from(widget.initialExcludedIds);
    _applyFilters();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // --- UNSAVED CHANGES LOGIC ---
  bool get _hasUnsavedChanges {
    if (_isSaving) return false; // Bypass if the user explicitly clicked "Save"
    if (_selectedIds.length != widget.initialExcludedIds.length) return true;
    for (final id in widget.initialExcludedIds) {
      if (!_selectedIds.contains(id)) return true;
    }
    return false;
  }

  Future<bool> _showUnsavedChangesDialog() async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(AppConstants.unsavedChanges),
        content: const Text("You have unsaved changes. Are you sure you want to discard them and exit?"),
        actions: [
          CupertinoDialogAction(
            child: const Text(AppConstants.cancel),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text(AppConstants.discard),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _handleClose() async {
    if (!_hasUnsavedChanges) {
      Navigator.pop(context);
      return;
    }
    final shouldPop = await _showUnsavedChangesDialog();
    if (shouldPop) {
      if (mounted) Navigator.pop(context);
    }
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      final allEntries = [
        ..._homeController.journalEntries,
        ..._homeController.draftEntries,
      ];

      _filteredEntries = allEntries.where((entry) {
        final content = entry.content.toPlainText().toLowerCase();
        bool matchesQuery = content.contains(query);

        if (_isBookmarked && !entry.isBookmarked) return false;
        if (_isTextOnly &&
            (entry.galleryImages.isNotEmpty ||
                entry.cameraPhotos.isNotEmpty ||
                entry.galleryAudios.isNotEmpty ||
                entry.recordings.isNotEmpty)) return false;
        if (_isMediaOnly &&
            (entry.galleryImages.isEmpty &&
                entry.cameraPhotos.isEmpty &&
                entry.galleryAudios.isEmpty &&
                entry.recordings.isEmpty)) return false;
        if (_withMood && entry.moodIndex == null) return false;
        if (_withLocation && entry.location == null) return false;
        if (_isReflection && !entry.isReflection) return false;
        if (_isDraft && !entry.isDraft) return false;

        return matchesQuery;
      }).toList();

      // Apply Sorting Logic
      _filteredEntries.sort((a, b) {
        if (_currentSort == SortOption.mutedFirst) {
          final aSelected = _selectedIds.contains(a.id);
          final bSelected = _selectedIds.contains(b.id);
          if (aSelected && !bSelected) return -1;
          if (!aSelected && bSelected) return 1;
        } else if (_currentSort == SortOption.unmutedFirst) {
          final aSelected = _selectedIds.contains(a.id);
          final bSelected = _selectedIds.contains(b.id);
          if (!aSelected && bSelected) return -1;
          if (aSelected && !bSelected) return 1;
        }

        // Fallback or default sorting by creation date (newest first)
        return b.createdAt.compareTo(a.createdAt);
      });
    });
  }

  PopupMenuItem<SortOption> _buildSortMenuItem(
      SortOption value, String text, AppThemeColors appThemeColors) {
    final isSelected = _currentSort == value;
    return PopupMenuItem<SortOption>(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: AppConstants.font,
              color: appThemeColors.grey10,
              letterSpacing: -0.2,
            ),
          ),
          if (isSelected)
            Icon(Icons.check_rounded, color: appThemeColors.primary, size: 20.sp),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      String label, bool isSelected, ValueChanged<bool> onSelected) {
    final appThemeColors = AppTheme.colorsOf(context);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: appThemeColors.grey6,
      selectedColor: appThemeColors.primary,
      labelStyle: TextStyle(
        fontFamily: AppConstants.font,
        letterSpacing: -0.2,
        color: isSelected ? appThemeColors.onPrimary : appThemeColors.grey1,
      ),
      shape: const StadiumBorder(),
      side: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);

    final Brightness platformBrightness = Theme.of(context).brightness;
    final Brightness iconBrightness =
    platformBrightness == Brightness.dark ? Brightness.light : Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        if (!_hasUnsavedChanges) return true;
        return await _showUnsavedChangesDialog();
      },
      child: Scaffold(
        backgroundColor: appThemeColors.grey7,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: iconBrightness,
            systemNavigationBarColor: appThemeColors.grey7,
            systemNavigationBarIconBrightness: iconBrightness,
          ),
          backgroundColor: appThemeColors.grey7,
          elevation: 0,
          title: Text(
            AppConstants.excludeEntries,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontFamily: AppConstants.font,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: appThemeColors.grey1),
          leading: IconButton(
            icon: Icon(Icons.close, color: appThemeColors.grey10),
            onPressed: _handleClose, // Triggers confirmation dialog logic
          ),
          actions: [
            TextButton(
              onPressed: () {
                _isSaving = true; // Signal safe exit to WillPopScope
                widget.onSave(_selectedIds.toList());
                Navigator.pop(context);
              },
              child: Text(
                AppConstants.save,
                style: TextStyle(
                  color: appThemeColors.primary,
                  fontFamily: AppConstants.font,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                          color: appThemeColors.grey10,
                          fontFamily: AppConstants.font,
                          letterSpacing: -0.2),
                      decoration: InputDecoration(
                        hintText: AppConstants.searchJournalsHint,
                        hintStyle: TextStyle(
                            color: appThemeColors.grey3,
                            fontFamily: AppConstants.font,
                            letterSpacing: -0.2),
                        filled: true,
                        fillColor: appThemeColors.grey6,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                        suffixIcon: Icon(
                          Icons.search,
                          color: appThemeColors.grey3,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    key: _sortMenuKey,
                    decoration: BoxDecoration(
                      color: appThemeColors.grey6,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.sort_rounded, color: appThemeColors.grey10),
                      onPressed: () {
                        final RenderBox renderBox = _sortMenuKey.currentContext!.findRenderObject() as RenderBox;
                        final position = renderBox.localToGlobal(Offset.zero);

                        showMenu<SortOption>(
                          context: context,
                          color: appThemeColors.grey5,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          position: RelativeRect.fromLTRB(
                            position.dx - 150.w,
                            position.dy + renderBox.size.height + 8.h,
                            MediaQuery.of(context).size.width - (position.dx + renderBox.size.width),
                            position.dy + renderBox.size.height + 200.h,
                          ),
                          items: [
                            _buildSortMenuItem(SortOption.none, 'Default', appThemeColors),
                            PopupMenuDivider(height: 1, color: appThemeColors.grey6),
                            _buildSortMenuItem(SortOption.mutedFirst, 'Muted first', appThemeColors),
                            PopupMenuDivider(height: 1, color: appThemeColors.grey6),
                            _buildSortMenuItem(SortOption.unmutedFirst, 'Unmuted first', appThemeColors),
                          ],
                        ).then((option) {
                          if (option != null) {
                            setState(() {
                              _currentSort = option;
                              _applyFilters();
                            });
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Wrap(
                  spacing: 8.w,
                  children: [
                    _buildFilterChip(AppConstants.bookmark, _isBookmarked,
                            (selected) {
                          setState(() {
                            _isBookmarked = selected;
                            _applyFilters();
                          });
                        }),
                    _buildFilterChip(AppConstants.reflection, _isReflection,
                            (selected) {
                          setState(() {
                            _isReflection = selected;
                            _applyFilters();
                          });
                        }),
                    _buildFilterChip(AppConstants.drafts, _isDraft,
                            (selected) {
                          setState(() {
                            _isDraft = selected;
                            _applyFilters();
                          });
                        }),
                    _buildFilterChip(AppConstants.textOnly, _isTextOnly,
                            (selected) {
                          setState(() {
                            _isTextOnly = selected;
                            _applyFilters();
                          });
                        }),
                    _buildFilterChip(AppConstants.withMedia, _isMediaOnly,
                            (selected) {
                          setState(() {
                            _isMediaOnly = selected;
                            _applyFilters();
                          });
                        }),
                    _buildFilterChip(AppConstants.withMood, _withMood,
                            (selected) {
                          setState(() {
                            _withMood = selected;
                            _applyFilters();
                          });
                        }),
                    _buildFilterChip(AppConstants.withLocation, _withLocation,
                            (selected) {
                          setState(() {
                            _withLocation = selected;
                            _applyFilters();
                          });
                        }),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _filteredEntries.isEmpty
                  ? Center(
                child: Text(
                  AppConstants.noResultsFound,
                  style: TextStyle(
                    fontFamily: AppConstants.font,
                    letterSpacing: -0.2,
                    color: appThemeColors.grey3,
                    fontSize: 16.sp,
                  ),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: _filteredEntries.isEmpty ? 0 : _filteredEntries.length * 2 - 1,
                itemBuilder: (context, index) {
                  if (index.isOdd) return SizedBox(height: 32.h);

                  final itemIndex = index ~/ 2;
                  final entry = _filteredEntries[itemIndex];
                  final prevEntry = itemIndex > 0 ? _filteredEntries[itemIndex - 1] : null;

                  bool showYearDivider = prevEntry == null || entry.createdAt.year != prevEntry.createdAt.year;
                  bool showMonthDivider = prevEntry == null || entry.createdAt.month != prevEntry.createdAt.month || entry.createdAt.year != prevEntry.createdAt.year;

                  // --- SELECTION LOGIC ---
                  final isSelected = _selectedIds.contains(entry.id);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showYearDivider) ...[
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
                          child: Text(
                            entry.createdAt.year.toString(),
                            style: TextStyle(
                              fontFamily: AppConstants.font,
                              fontWeight: FontWeight.bold,
                              fontSize: 28.sp,
                              color: appThemeColors.grey10,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ],
                      if (showMonthDivider) ...[
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 16.h,
                              top: showYearDivider ? 0 : 8.h),
                          child: Text(
                            DateFormat('MMMM').format(entry.createdAt),
                            style: TextStyle(
                              fontFamily: AppConstants.font,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              color: appThemeColors.grey2,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedIds.remove(entry.id);
                            } else {
                              _selectedIds.add(entry.id);
                            }

                            if (_currentSort != SortOption.none) {
                              _applyFilters();
                            }
                          });
                        },
                        child: Stack(
                          children: [
                            IgnorePointer(
                              ignoring: true,
                              child: JournalTile(
                                entry: entry,
                                showMenuIcon: false,
                              ),
                            ),
                            Positioned(
                              top: 12.h,
                              right: 12.w,
                              child: Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: appThemeColors.grey6.withOpacity(0.95),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isSelected ? Icons.notifications_off_rounded : Icons.notifications_active_rounded,
                                  color: isSelected ? appThemeColors.error : appThemeColors.success,
                                  size: 22.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}