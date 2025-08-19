import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/read_journal/read_journal_bottom_sheet.dart';

import '../../core/models/journal_entry.dart';
import '../../core/theme.dart';
import '../../core/widgets/journal_tile.dart';

class InsightsBottomSheet extends StatefulWidget {
  const InsightsBottomSheet({super.key});

  @override
  State<InsightsBottomSheet> createState() => _InsightsBottomSheetState();
}

class _InsightsBottomSheetState extends State<InsightsBottomSheet> {
  late DateTime _selectedYearDate;
  late DateTime _calendarDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYearDate = now;
    _calendarDate = DateTime(now.year, now.month);
  }

  /// Changes the year for the bar chart.
  void _changeYear(int yearDelta) {
    setState(() {
      _selectedYearDate = DateTime(
        _selectedYearDate.year + yearDelta,
        _selectedYearDate.month,
        _selectedYearDate.day,
      );
    });
  }

  /// Changes the month for the calendar view.
  void _changeMonth(int monthDelta) {
    setState(() {
      _calendarDate = DateTime(
        _calendarDate.year,
        _calendarDate.month + monthDelta,
      );
    });
  }

  /// Shows a bottom sheet with journal entries for the selected date.
  void _showEntriesForDate(
      BuildContext context, DateTime date, HomeController controller) {
    // The list of entries is now fetched reactively inside the bottom sheet itself.
    showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return _EntriesForDateBottomSheet(
          date: date,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    // Find the already existing HomeController instance to access stats
    final HomeController controller = Get.find();

    return Material(
      child: Scaffold(
        backgroundColor: appThemeColors.grey6,
        appBar: AppBar(
          backgroundColor: appThemeColors.grey6,
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppConstants.insights,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          leading: Padding(
            // Add padding around the container to "shrink" it visually
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: appThemeColors.grey5,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                // The icon button's own padding might need to be removed
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close),
                iconSize: 24,
                color: appThemeColors.grey10,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Stats Section ---
              _buildStatsSection(context, controller),
              SizedBox(height: 32.h),
              // --- Calendar Section ---
              _buildCalendarSection(context, controller),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the stats section with the 1-over-2 grid layout.
  Widget _buildStatsSection(BuildContext context, HomeController controller) {
    final appThemeColors = AppTheme.colorsOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.stats,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: appThemeColors.grey10,
          ),
        ),
        SizedBox(height: 16.h),
        // Top container (full width) - Now a bar chart
        _buildYearlyEntriesChart(context, controller),
        SizedBox(height: 16.h),
        // Bottom two containers (half width each)
        Row(
          children: [
            Expanded(
              child: Container(
                height: 150.h,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: appThemeColors.grey7,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: _buildStatItem(
                  AppConstants.wordsWritten,
                  Obx(() => Text(controller.totalWordsWritten.toString())),
                  Icons.format_quote_rounded,
                  appThemeColors,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Container(
                height: 150.h,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: appThemeColors.grey7,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: _buildStatItem(
                  AppConstants.daysJournaled,
                  Obx(() => Text(controller.daysJournaled.toString())),
                  Icons.calendar_today_rounded,
                  appThemeColors,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the interactive bar chart for yearly entries.
  Widget _buildYearlyEntriesChart(
      BuildContext context, HomeController controller) {
    final appThemeColors = AppTheme.colorsOf(context);
    final monthlyData =
    controller.getMonthlyEntriesForYear(_selectedYearDate.year);
    final totalEntries =
    monthlyData.values.fold(0, (sum, count) => sum + count);

    // Calculate the max entries for a single month across ALL journal entries
    final allTimeMaxEntries = () {
      if (controller.journalEntries.isEmpty)
        return 1; // Avoid division by zero
      final Map<String, int> allMonthlyCounts = {};
      for (final entry in controller.journalEntries) {
        final key = '${entry.createdAt.year}-${entry.createdAt.month}';
        allMonthlyCounts[key] = (allMonthlyCounts[key] ?? 0) + 1;
      }
      if (allMonthlyCounts.isEmpty) return 1;
      // Return the highest value found, or 1 if none exist.
      return allMonthlyCounts.values.reduce(max);
    }();

    return Container(
      height: 150.h,
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: appThemeColors.grey7,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Header with year navigation and total count
          SizedBox(
            height: 24.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _changeYear(-1),
                  child: Icon(Icons.chevron_left,
                      color: appThemeColors.grey2, size: 24.sp),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      color: appThemeColors.grey10,
                    ),
                    children: [
                      TextSpan(
                        text: DateFormat('yyyy').format(_selectedYearDate),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      TextSpan(
                        text: ' ($totalEntries ${AppConstants.entriesSuffix})',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: appThemeColors.grey2,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _changeYear(1),
                  child: Icon(Icons.chevron_right,
                      color: appThemeColors.grey2, size: 24.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          // Bar chart visualization
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (index) {
                final month = index + 1;
                final count = monthlyData[month] ?? 0;
                // Max height for the bar area itself
                final double maxHeight =
                    50.h; // Reduced height to fix overflow
                // Calculate bar height relative to the all-time max entries
                final barHeight = (count / allTimeMaxEntries) * maxHeight;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Container to hold the bar and the text above it
                    Container(
                      height: maxHeight + 16.h, // Space for bar + text
                      width: 24.w, // Wider to fit text
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none, // Allow text to overflow
                        children: [
                          // The bar
                          Container(
                            width: 12.w,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: appThemeColors.primary.withOpacity(0.8),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(4.r),
                              ),
                            ),
                          ),
                          // The count text, positioned above the bar
                          if (count > 0)
                            Positioned(
                              bottom: barHeight + 2.h,
                              child: Text(
                                count.toString(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: appThemeColors.grey2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Month initial
                    Text(
                      DateFormat('MMM').format(DateTime(0, month))[0],
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: appThemeColors.grey2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget for a single statistic item inside a container.
  Widget _buildStatItem(
      String label, Widget valueWidget, IconData icon, AppThemeColors colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: colors.grey2,
          size: 32.sp,
        ),
        SizedBox(height: 8.h),
        DefaultTextStyle(
          style: TextStyle(
            fontFamily: AppConstants.font,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
            color: colors.grey10,
          ),
          child: valueWidget,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: colors.grey2,
          ),
        ),
      ],
    );
  }

  /// Builds the calendar section.
  Widget _buildCalendarSection(
      BuildContext context, HomeController controller) {
    final appThemeColors = AppTheme.colorsOf(context);
    final now = DateTime.now();
    final daysInMonth =
    DateUtils.getDaysInMonth(_calendarDate.year, _calendarDate.month);
    final firstDayOfMonth =
    DateTime(_calendarDate.year, _calendarDate.month, 1);
    // Adjust weekday to start from Sunday = 0
    final weekdayOfFirstDay =
    firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.calendar,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: appThemeColors.grey10,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: appThemeColors.grey7,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              // Header with month and year
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _changeMonth(-1),
                    child: Icon(Icons.chevron_left,
                        color: appThemeColors.grey2, size: 24.sp),
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(_calendarDate),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: appThemeColors.grey10,
                    ),
                  ),
                  InkWell(
                    onTap: () => _changeMonth(1),
                    child: Icon(Icons.chevron_right,
                        color: appThemeColors.grey2, size: 24.sp),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Row for days of the week
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .map((day) => Text(day,
                    style: TextStyle(
                        color: appThemeColors.grey2,
                        fontWeight: FontWeight.bold)))
                    .toList(),
              ),
              SizedBox(height: 8.h),
              // Grid for the calendar days
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: daysInMonth + weekdayOfFirstDay,
                itemBuilder: (context, index) {
                  if (index < weekdayOfFirstDay) {
                    return const SizedBox
                        .shrink(); // Empty space for alignment
                  }
                  final day = index - weekdayOfFirstDay + 1;
                  final currentDate =
                  DateTime(_calendarDate.year, _calendarDate.month, day);
                  final isToday = day == now.day &&
                      _calendarDate.month == now.month &&
                      _calendarDate.year == now.year;

                  // Check if there is a journal entry for this date.
                  final hasJournalEntry =
                  controller.journaledDates.contains(currentDate);

                  return GestureDetector(
                    onTap: () =>
                        _showEntriesForDate(context, currentDate, controller),
                    child: Container(
                      margin: EdgeInsets.all(2.w),
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background container for journal entries
                          if (hasJournalEntry)
                            Container(
                              decoration: BoxDecoration(
                                color: appThemeColors.grey4,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          // The day number with a circle for 'today'
                          Container(
                            width: 32.w,
                            height: 32.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isToday
                                  ? appThemeColors.primary.withOpacity(0.8)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$day',
                              style: TextStyle(
                                color: isToday
                                    ? appThemeColors.grey7
                                    : appThemeColors.grey10,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A bottom sheet that displays journal entries for a specific date.
class _EntriesForDateBottomSheet extends StatelessWidget {
  final DateTime date;

  const _EntriesForDateBottomSheet({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    // --- FIX: Get the controller to access the reactive list of entries ---
    final HomeController controller = Get.find();

    return Material(
      child: Scaffold(
        backgroundColor: appThemeColors.grey6,
        appBar: AppBar(
          backgroundColor: appThemeColors.grey6,
          elevation: 0,
          centerTitle: true,
          title: Text(
            DateFormat('MMMM d, yyyy').format(date),
            style: TextStyle(
              color: appThemeColors.grey10,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: appThemeColors.grey5,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close),
                iconSize: 24,
                color: appThemeColors.grey10,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        // --- FIX: Wrap the body in an Obx to make it reactive ---
        body: Obx(() {
          // --- FIX: Filter the entries list inside Obx to get the latest data ---
          final entriesForDate = controller.journalEntries.where((entry) {
            final entryDate = entry.createdAt;
            return entryDate.year == date.year &&
                entryDate.month == date.month &&
                entryDate.day == date.day;
          }).toList();

          return entriesForDate.isEmpty
              ? Center(
            child: Text(
              AppConstants.noEntriesForDate,
              style: TextStyle(
                color: appThemeColors.grey2,
                fontSize: 16.sp,
              ),
            ),
          )
              : ListView.separated(
            padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: entriesForDate.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final entry = entriesForDate[index];
              return JournalTile(
                reflectionBackground: appThemeColors.grey3,
                backgroundColor: appThemeColors.grey5,
                dividerColor: appThemeColors.grey3,
                footerTextColor: appThemeColors.grey2,
                entry: entry,
                onTap: () {
                  // Pop the current bottom sheet first
                  Navigator.of(context).pop();
                  // Then show the read journal sheet
                  showCupertinoModalBottomSheet(
                    context: Get.context!,
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
          );
        }),
      ),
    );
  }
}
