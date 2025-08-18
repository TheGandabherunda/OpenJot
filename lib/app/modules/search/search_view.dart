import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/widgets/journal_tile.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/read_journal/read_journal_bottom_sheet.dart';

import '../../core/models/journal_entry.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final HomeController _homeController = Get.find();
  List<JournalEntry> _filteredEntries = [];

  bool _isBookmarked = false;
  bool _isTextOnly = false;
  bool _isMediaOnly = false;
  bool _withMood = false;
  bool _withLocation = false;

  @override
  void initState() {
    super.initState();
    _applyFilters();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredEntries = _homeController.journalEntries.where((entry) {
        final content = entry.content.toPlainText().toLowerCase();
        bool matchesQuery = content.contains(query);

        if (_isBookmarked && !entry.isBookmarked) {
          return false;
        }
        if (_isTextOnly &&
            (entry.galleryImages.isNotEmpty || entry.cameraPhotos.isNotEmpty)) {
          return false;
        }
        if (_isMediaOnly &&
            (entry.galleryImages.isEmpty && entry.cameraPhotos.isEmpty)) {
          return false;
        }
        if (_withMood && entry.moodIndex == null) {
          return false;
        }
        // Filter for entries that have a location
        if (_withLocation && entry.location == null) {
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
        color: isSelected ? appThemeColors.onPrimary : appThemeColors.grey1,
      ),
      // Set the shape to StadiumBorder for a circular (pill) shape
      shape: const StadiumBorder(),
      // Remove the border by setting the side to BorderSide.none
      side: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: appThemeColors.grey7, // Match your background color
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return SafeArea(
        top: true, // This ensures status bar space is preserved
        child: Scaffold(
          backgroundColor: appThemeColors.grey7,
          appBar: AppBar(
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
                  style: TextStyle(color: appThemeColors.grey10),
                  decoration: InputDecoration(
                    hintText: 'Search journals...',
                    hintStyle: TextStyle(color: appThemeColors.grey3),
                    filled: true,
                    fillColor: appThemeColors.grey6,
                    // Explicitly define the border for the enabled and focused states
                    // to ensure no border or underline appears.
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
                      _buildFilterChip('Bookmark', _isBookmarked, (selected) {
                        setState(() {
                          _isBookmarked = selected;
                          _applyFilters();
                        });
                      }),
                      _buildFilterChip('Text Only', _isTextOnly, (selected) {
                        setState(() {
                          _isTextOnly = selected;
                          _applyFilters();
                        });
                      }),
                      _buildFilterChip('Media Only', _isMediaOnly, (selected) {
                        setState(() {
                          _isMediaOnly = selected;
                          _applyFilters();
                        });
                      }),
                      _buildFilterChip('With Mood', _withMood, (selected) {
                        setState(() {
                          _withMood = selected;
                          _applyFilters();
                        });
                      }),
                      _buildFilterChip('With Location', _withLocation,
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
                          'No results found',
                          style: TextStyle(
                            color: appThemeColors.grey3,
                            fontSize: 16.sp,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        itemCount: _filteredEntries.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final entry = _filteredEntries[index];
                          return JournalTile(
                            entry: entry,
                            onTap: () {
                              showCupertinoModalBottomSheet(
                                context: context,
                                expand: true,
                                backgroundColor: Colors.transparent,
                                builder: (modalContext) {
                                  return SafeArea(
                                    child: ReadJournalBottomSheet(entry: entry),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ));
  }
}
