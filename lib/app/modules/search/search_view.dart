import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/widgets/journal_tile.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/read_journal/read_journal_bottom_sheet.dart';

import '../../core/models/journal_entry.dart';

class SearchView extends StatefulWidget {
  final bool initialBookmarked;
  const SearchView({super.key, this.initialBookmarked = false});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final HomeController _homeController = Get.find();
  List<JournalEntry> _filteredEntries = [];
  StreamSubscription? _journalSubscription;
  StreamSubscription? _draftSubscription;

  bool _isBookmarked = false;
  bool _isTextOnly = false;
  bool _isMediaOnly = false;
  bool _withMood = false;
  bool _withLocation = false;
  bool _isReflection = false;
  bool _isDraft = false;
  final Set<String> _selectedTags = {};

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.initialBookmarked;
    _applyFilters();
    _searchController.addListener(_onSearchChanged);

    _journalSubscription = _homeController.journalEntries.listen((_) {
      if (mounted) {
        _applyFilters();
      }
    });

    _draftSubscription = _homeController.draftEntries.listen((_) {
      if (mounted) {
        _applyFilters();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _journalSubscription?.cancel();
    _draftSubscription?.cancel();
    super.dispose();
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
        final plainText = _homeController.plainTextCache[entry.id] ?? '';
        final content = plainText.toLowerCase();
        final entryTags = entry.tags.map((t) => t.toLowerCase()).toList();

        bool matchesQuery = false;
        if (query.startsWith('#')) {
          // If query starts with #, search specifically in tags
          matchesQuery = entryTags.any((t) => t.contains(query));
        } else {
          // Otherwise search in content OR tags
          matchesQuery = content.contains(query) || entryTags.any((t) => t.contains(query));
        }

        if (_selectedTags.isNotEmpty && !_selectedTags.every((tag) => entry.tags.contains(tag))) {
          return false;
        }

        if (_isBookmarked && !entry.isBookmarked) {
          return false;
        }
        if (_isTextOnly &&
            (entry.galleryImages.isNotEmpty ||
                entry.cameraPhotos.isNotEmpty ||
                entry.galleryAudios.isNotEmpty ||
                entry.recordings.isNotEmpty)) {
          return false;
        }
        if (_isMediaOnly &&
            (entry.galleryImages.isEmpty &&
                entry.cameraPhotos.isEmpty &&
                entry.galleryAudios.isEmpty &&
                entry.recordings.isEmpty)) {
          return false;
        }
        if (_withMood && entry.moodIndex == null) {
          return false;
        }
        if (_withLocation && entry.location == null) {
          return false;
        }
        if (_isReflection && !entry.isReflection) {
          return false;
        }
        if (_isDraft && !entry.isDraft) {
          return false;
        }

        return matchesQuery;
      }).toList();
    });
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

    return Scaffold(
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
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: appThemeColors.grey1),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              controller: _searchController,
              autofocus: true,
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
                  ..._homeController.allUniqueTags.map((tag) => _buildFilterChip(
                    tag,
                    _selectedTags.contains(tag),
                    (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                        _applyFilters();
                      });
                    },
                  )),
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
                    JournalTile(
                      entry: entry,
                      onTap: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          expand: true,
                          backgroundColor: Colors.transparent,
                          builder: (modalContext) {
                            return ReadJournalBottomSheet(entry: entry);
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}