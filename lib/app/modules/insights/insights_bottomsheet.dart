import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';

import '../../core/theme.dart';

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
            'Insights',
            style: TextStyle(
              color: appThemeColors.grey10,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: appThemeColors.grey10,
            ),
            onPressed: () => Navigator.of(context).pop(),
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
              _buildCalendarSection(context),
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
          'Stats',
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
                  'Words Written',
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
                  'Days Journaled',
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
      if (controller.journalEntries.isEmpty) return 1; // Avoid division by zero
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
                      fontFamily: 'Inter',
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
                        text: ' ($totalEntries entries)',
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
                final double maxHeight = 50.h; // Reduced height to fix overflow
                // Calculate bar height relative to the all-time max entries
                final barHeight =
                    (count / allTimeMaxEntries) * maxHeight;

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
            fontFamily: 'Inter', // Assuming 'Inter' is your app's font
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
  Widget _buildCalendarSection(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final now = DateTime.now();
    final daysInMonth =
    DateUtils.getDaysInMonth(_calendarDate.year, _calendarDate.month);
    final firstDayOfMonth = DateTime(_calendarDate.year, _calendarDate.month, 1);
    // Adjust weekday to start from Sunday = 0
    final weekdayOfFirstDay =
    firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calendar',
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
                    return const SizedBox.shrink(); // Empty space for alignment
                  }
                  final day = index - weekdayOfFirstDay + 1;
                  final isToday = day == now.day &&
                      _calendarDate.month == now.month &&
                      _calendarDate.year == now.year;
                  return Container(
                    margin: EdgeInsets.all(3.w),
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
                        color: isToday ? appThemeColors.grey7 : appThemeColors.grey10,
                        fontWeight:
                        isToday ? FontWeight.bold : FontWeight.normal,
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
