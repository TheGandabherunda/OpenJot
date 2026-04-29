import 'dart:collection';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/models/journal_entry.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/read_journal/read_journal_bottom_sheet.dart';

import '../../core/theme.dart';
import '../../core/widgets/journal_tile.dart';

enum CalendarType { standard, media, mood }

class InsightsBottomSheet extends StatefulWidget {
  final DateTime? openOnThisDayDate;

  const InsightsBottomSheet({super.key, this.openOnThisDayDate});

  @override
  State<InsightsBottomSheet> createState() => _InsightsBottomSheetState();
}

class _InsightsBottomSheetState extends State<InsightsBottomSheet> {
  late DateTime _selectedYearDate;
  late DateTime _calendarDate;
  CalendarType _selectedCalendarType = CalendarType.standard;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYearDate = now;
    _calendarDate = DateTime(now.year, now.month);

    if (widget.openOnThisDayDate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showEntriesForDate(
          context,
          widget.openOnThisDayDate!,
          Get.find<HomeController>(),
        );
      });
    }
  }

  void _changeYear(int yearDelta) {
    setState(() {
      _selectedYearDate = DateTime(
        _selectedYearDate.year + yearDelta,
        _selectedYearDate.month,
        _selectedYearDate.day,
      );
    });
  }

  void _changeMonth(int monthDelta) {
    setState(() {
      _calendarDate = DateTime(
        _calendarDate.year,
        _calendarDate.month + monthDelta,
      );
    });
  }

  void _showEntriesForDate(
      BuildContext context, DateTime date, HomeController controller) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return EntriesForDateBottomSheet(
          date: date,
          calendarType: _selectedCalendarType,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
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
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
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
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsSection(context, controller),
              SizedBox(height: 32.h),
              _buildCalendarSection(context, controller),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

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
            fontFamily: AppConstants.font,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 16.h),
        _buildYearlyEntriesChart(context, controller),
        SizedBox(height: 16.h),
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

  Widget _buildYearlyEntriesChart(
      BuildContext context, HomeController controller) {
    final appThemeColors = AppTheme.colorsOf(context);
    final monthlyData =
    controller.getMonthlyEntriesForYear(_selectedYearDate.year);
    final totalEntries =
    monthlyData.values.fold(0, (sum, count) => sum + count);

    final allTimeMaxEntries = () {
      if (controller.journalEntries.isEmpty) return 1;
      final Map<String, int> allMonthlyCounts = {};
      for (final entry in controller.journalEntries) {
        final key = '${entry.createdAt.year}-${entry.createdAt.month}';
        allMonthlyCounts[key] = (allMonthlyCounts[key] ?? 0) + 1;
      }
      if (allMonthlyCounts.isEmpty) return 1;
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
                      letterSpacing: -0.2,
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (index) {
                final month = index + 1;
                final count = monthlyData[month] ?? 0;
                final double maxHeight = 50.h;
                final barHeight = (count / allTimeMaxEntries) * maxHeight;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: maxHeight + 16.h,
                      width: 24.w,
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
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
                          if (count > 0)
                            Positioned(
                              bottom: barHeight + 2.h,
                              child: Text(
                                count.toString(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: appThemeColors.grey2,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppConstants.font,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('MMM').format(DateTime(0, month))[0],
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: appThemeColors.grey2,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppConstants.font,
                        letterSpacing: -0.2,
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
            letterSpacing: -0.2,
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
            fontFamily: AppConstants.font,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection(
      BuildContext context, HomeController controller) {
    final appThemeColors = AppTheme.colorsOf(context);
    final now = DateTime.now();
    final daysInMonth =
    DateUtils.getDaysInMonth(_calendarDate.year, _calendarDate.month);
    final firstDayOfMonth =
    DateTime(_calendarDate.year, _calendarDate.month, 1);
    final weekdayOfFirstDay =
    firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppConstants.calendar,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: appThemeColors.grey10,
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(
              width: 200.w,
              child: CupertinoSlidingSegmentedControl<CalendarType>(
                backgroundColor: appThemeColors.grey5,
                thumbColor: appThemeColors.grey7,
                groupValue: _selectedCalendarType,
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCalendarType = value;
                    });
                  }
                },
                children: {
                  CalendarType.standard: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      AppConstants.standard,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: AppConstants.font,
                        color: appThemeColors.grey10,
                      ),
                    ),
                  ),
                  CalendarType.media: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      AppConstants.media,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: AppConstants.font,
                        color: appThemeColors.grey10,
                      ),
                    ),
                  ),
                  CalendarType.mood: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      AppConstants.mood,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: AppConstants.font,
                        color: appThemeColors.grey10,
                      ),
                    ),
                  ),
                },
              ),
            ),
          ],
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
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .map((day) => Text(day,
                    style: TextStyle(
                        color: appThemeColors.grey2,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstants.font,
                        letterSpacing: -0.2)))
                    .toList(),
              ),
              SizedBox(height: 8.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: daysInMonth + weekdayOfFirstDay,
                itemBuilder: (context, index) {
                  if (index < weekdayOfFirstDay) {
                    return const SizedBox.shrink();
                  }
                  final day = index - weekdayOfFirstDay + 1;
                  final currentDate =
                  DateTime(_calendarDate.year, _calendarDate.month, day);
                  final isToday = day == now.day &&
                      _calendarDate.month == now.month &&
                      _calendarDate.year == now.year;

                  final entriesForDay = controller.journalEntries.where((e) {
                    return e.createdAt.year == currentDate.year &&
                        e.createdAt.month == currentDate.month &&
                        e.createdAt.day == currentDate.day;
                  }).toList();

                  final hasJournalEntry = entriesForDay.isNotEmpty;

                  int? averageMood;
                  if (_selectedCalendarType == CalendarType.mood && hasJournalEntry) {
                    final moods = entriesForDay.map((e) => e.moodIndex).whereType<int>().toList();
                    if (moods.isNotEmpty) {
                      averageMood = (moods.reduce((a, b) => a + b) / moods.length).round();
                    }
                  }

                  return GestureDetector(
                    onTap: () =>
                        _showEntriesForDate(context, currentDate, controller),
                    child: Container(
                      margin: EdgeInsets.all(2.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_selectedCalendarType == CalendarType.standard && hasJournalEntry)
                            Container(
                              decoration: BoxDecoration(
                                color: appThemeColors.grey4,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          if (_selectedCalendarType == CalendarType.media && hasJournalEntry)
                            _buildMediaCell(entriesForDay),
                          if (_selectedCalendarType == CalendarType.mood && averageMood != null)
                            _buildMoodCell(averageMood, appThemeColors),

                          Container(
                            width: 32.w,
                            height: 32.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isToday && _selectedCalendarType == CalendarType.standard
                                  ? appThemeColors.primary.withOpacity(0.8)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: isToday && _selectedCalendarType != CalendarType.standard
                                  ? Border.all(color: appThemeColors.primary, width: 2)
                                  : null,
                            ),
                            child: Text(
                              '$day',
                              style: TextStyle(
                                color: isToday && _selectedCalendarType == CalendarType.standard
                                    ? appThemeColors.grey7
                                    : appThemeColors.grey10,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontFamily: AppConstants.font,
                                letterSpacing: -0.2,
                                shadows: _selectedCalendarType != CalendarType.standard && hasJournalEntry ? [
                                  const Shadow(
                                    color: Colors.black,
                                    offset: Offset.zero, // Fixed offset constructor
                                    blurRadius: 4,
                                  )
                                ] : null,
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

  Widget _buildMediaCell(List<JournalEntry> entries) {
    for (var entry in entries) {
      if (entry.galleryImages.isNotEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Opacity(
            opacity: 0.6,
            child: MediaThumbnail(media: entry.galleryImages.first),
          ),
        );
      }
      if (entry.cameraPhotos.isNotEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Opacity(
            opacity: 0.6,
            child: MediaThumbnail(media: entry.cameraPhotos.first),
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildMoodCell(int moodIndex, AppThemeColors colors) {
    final HomeController controller = Get.find();

    final accentColors = [
      colors.aPurple[0],
      colors.aPink[0],
      colors.aBlue[0],
      colors.aTeal[0],
      colors.aMint[0],
      colors.aGreen[0],
      colors.aYellow[0],
    ];

    final bgColor = accentColors[moodIndex.clamp(0, 6)].withOpacity(0.6);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Opacity(
          opacity: 0.8,
          child: Obx(() {
            final rasterizedImage = controller.moodImages[moodIndex];
            if (rasterizedImage != null) {
              return RawImage(
                image: rasterizedImage,
                width: 24.w,
                height: 24.h,
                filterQuality: ui.FilterQuality.high,
              );
            }
            return SvgPicture.asset(
              AppConstants.moods[moodIndex]['svg']!,
              width: 24.w,
              height: 24.h,
            );
          }),
        ),
      ),
    );
  }
}

class EntriesForDateBottomSheet extends StatefulWidget {
  final DateTime date;
  final CalendarType calendarType;

  const EntriesForDateBottomSheet({
    super.key,
    required this.date,
    this.calendarType = CalendarType.standard,
  });

  @override
  State<EntriesForDateBottomSheet> createState() => _EntriesForDateBottomSheetState();
}

enum _ViewType { tiles, graph }

class _EntriesForDateBottomSheetState extends State<EntriesForDateBottomSheet> {
  _ViewType _selectedView = _ViewType.tiles;

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final HomeController controller = Get.find();

    final String title = DateFormat('MMMM d').format(widget.date);

    return Material(
      child: Scaffold(
        backgroundColor: appThemeColors.grey6,
        appBar: AppBar(
          backgroundColor: appThemeColors.grey6,
          elevation: 0,
          centerTitle: true,
          title: Text(
            title,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
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
        body: Obx(() {
          final entriesToShow = controller.journalEntries.where((entry) {
            final isSameDay = entry.createdAt.month == widget.date.month &&
                entry.createdAt.day == widget.date.day;
            if (!isSameDay) return false;

            if (widget.calendarType == CalendarType.media) {
              return entry.galleryImages.isNotEmpty || entry.cameraPhotos.isNotEmpty;
            } else if (widget.calendarType == CalendarType.mood) {
              return entry.moodIndex != null;
            }
            return true;
          }).toList();

          if (entriesToShow.isEmpty) {
            return Center(
              child: Text(
                AppConstants.noEntriesForDate,
                style: TextStyle(
                  color: appThemeColors.grey2,
                  fontSize: 16.sp,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2,
                ),
              ),
            );
          }

          final hasMoods = entriesToShow.any((e) => e.moodIndex != null);

          return Column(
            children: [
              if (hasMoods)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoSlidingSegmentedControl<_ViewType>(
                      backgroundColor: appThemeColors.grey5,
                      thumbColor: appThemeColors.grey7,
                      groupValue: _selectedView,
                      onValueChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedView = value;
                          });
                        }
                      },
                      children: {
                        _ViewType.tiles: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: Text(
                            AppConstants.tiles,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: AppConstants.font,
                              color: appThemeColors.grey10,
                            ),
                          ),
                        ),
                        _ViewType.graph: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: Text(
                            AppConstants.graph,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: AppConstants.font,
                              color: appThemeColors.grey10,
                            ),
                          ),
                        ),
                      },
                    ),
                  ),
                ),
              Expanded(
                child: _selectedView == _ViewType.tiles
                    ? _buildTilesView(entriesToShow, appThemeColors)
                    : _buildGraphView(entriesToShow, appThemeColors),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildGraphView(List<JournalEntry> entries, AppThemeColors colors) {
    final groupedByYear = _groupEntriesByYear(entries);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: groupedByYear.length,
      itemBuilder: (context, index) {
        final year = groupedByYear.keys.elementAt(index);
        final entriesInYear = groupedByYear[year]!;

        final moods = entriesInYear.map((e) => e.moodIndex).whereType<int>().toList();
        final int? avgMoodIndex = moods.isNotEmpty 
            ? (moods.reduce((a, b) => a + b) / moods.length).round() 
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 24.h, top: index > 0 ? 32.h : 8.h),
              child: Text(
                year.toString(),
                style: TextStyle(
                  color: colors.grey1,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            if (avgMoodIndex != null) ...[
              Center(child: _buildCenteredMoodSummary(avgMoodIndex, AppConstants.averageForThisYear, colors)),
              SizedBox(height: 32.h),
            ],
            Container(
              height: 220.h,
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colors.grey7,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: MoodGraph(entries: entriesInYear),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCenteredMoodSummary(int moodIndex, String description, AppThemeColors colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMoodIcon(moodIndex, 64.w),
        SizedBox(height: 12.h),
        Text(
          "${AppConstants.mostly} ${AppConstants.moods[moodIndex]['label']}",
          style: TextStyle(
            color: colors.grey10,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.font,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          description,
          style: TextStyle(
            color: colors.grey2,
            fontSize: 14.sp,
            fontFamily: AppConstants.font,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTilesView(List<JournalEntry> entriesToShow, AppThemeColors appThemeColors) {
    final groupedByYear = _groupEntriesByYear(entriesToShow);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: groupedByYear.length,
      itemBuilder: (context, index) {
        final year = groupedByYear.keys.elementAt(index);
        final entriesInYear = groupedByYear[year]!;
        entriesInYear.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        final moods = entriesInYear.map((e) => e.moodIndex).whereType<int>().toList();
        final int? avgMoodIndex = moods.isNotEmpty 
            ? (moods.reduce((a, b) => a + b) / moods.length).round() 
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: 24.h, top: index > 0 ? 32.h : 8.h),
              child: Text(
                year.toString(),
                style: TextStyle(
                  color: appThemeColors.grey1,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            if (avgMoodIndex != null) ...[
              Center(child: _buildCenteredMoodSummary(avgMoodIndex, AppConstants.averageForThisYear, appThemeColors)),
              SizedBox(height: 32.h),
            ],
            ...entriesInYear.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: JournalTile(
                  reflectionBackground: appThemeColors.grey3,
                  backgroundColor: appThemeColors.grey5,
                  dividerColor: appThemeColors.grey3,
                  footerTextColor: appThemeColors.grey2,
                  entry: entry,
                  onTap: () => _onEntryTap(context, entry),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  SplayTreeMap<int, List<JournalEntry>> _groupEntriesByYear(List<JournalEntry> entries) {
    final grouped = SplayTreeMap<int, List<JournalEntry>>.from({}, (a, b) => b.compareTo(a));
    for (final entry in entries) {
      final year = entry.createdAt.year;
      if (!grouped.containsKey(year)) {
        grouped[year] = [];
      }
      grouped[year]!.add(entry);
    }
    return grouped;
  }

  Widget _buildMoodIcon(int moodIndex, double size) {
    final HomeController controller = Get.find();
    return Obx(() {
      final rasterizedImage = controller.moodImages[moodIndex];
      if (rasterizedImage != null) {
        return RawImage(
          image: rasterizedImage,
          width: size,
          height: size,
          filterQuality: ui.FilterQuality.high,
        );
      }
      return SvgPicture.asset(
        AppConstants.moods[moodIndex]['svg']!,
        width: size,
        height: size,
      );
    });
  }

  void _onEntryTap(BuildContext context, JournalEntry entry) {
    Navigator.of(context).pop();
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
  }
}

class MoodGraph extends StatelessWidget {
  final List<JournalEntry> entries;

  const MoodGraph({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    
    final sortedEntries = List<JournalEntry>.from(entries)
      ..sort((a, b) {
        final timeA = a.createdAt.hour * 60 + a.createdAt.minute;
        final timeB = b.createdAt.hour * 60 + b.createdAt.minute;
        return timeA.compareTo(timeB);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _MoodGraphPainter(
                  entries: sortedEntries,
                  colors: appThemeColors,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _timeLabel('12 AM', appThemeColors),
            _timeLabel('6 AM', appThemeColors),
            _timeLabel('12 PM', appThemeColors),
            _timeLabel('6 PM', appThemeColors),
            _timeLabel('11:59 PM', appThemeColors),
          ],
        ),
      ],
    );
  }

  Widget _timeLabel(String text, AppThemeColors colors) => Text(
    text,
    style: TextStyle(
      color: colors.grey2,
      fontSize: 9.sp,
      fontFamily: AppConstants.font,
      fontWeight: FontWeight.w600,
    ),
  );
}

class _MoodGraphPainter extends CustomPainter {
  final List<JournalEntry> entries;
  final AppThemeColors colors;

  _MoodGraphPainter({required this.entries, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final accentColors = [
      colors.aPurple[1],
      colors.aPink[1],
      colors.aBlue[1],
      colors.aTeal[1],
      colors.aMint[1],
      colors.aGreen[1],
      colors.aYellow[1],
    ];

    // Grid lines - horizontal only for mood levels
    final gridPaint = Paint()
      ..color = colors.grey3.withOpacity(0.2)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 6; i++) {
      final y = size.height - (i / 6.0 * size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Pass 1: Collect points and their mood indices to ensure alignment
    final List<({Offset pos, int moodIndex})> points = [];
    for (var entry in entries) {
      if (entry.moodIndex == null) continue;

      final timeInMinutes = entry.createdAt.hour * 60 + entry.createdAt.minute;
      final x = (timeInMinutes / (24 * 60.0)) * size.width;
      final y = size.height - (entry.moodIndex! / 6.0 * size.height);
      points.add((pos: Offset(x, y), moodIndex: entry.moodIndex!));
    }

    if (points.isEmpty) return;

    // Draw Smooth Curve (Thread Style)
    final path = Path();
    path.moveTo(points.first.pos.dx, points.first.pos.dy);

    if (points.length > 1) {
      // 1. Calculate Slopes between points
      final List<double> slopes = [];
      for (int i = 0; i < points.length - 1; i++) {
        final dX = points[i + 1].pos.dx - points[i].pos.dx;
        final dY = points[i + 1].pos.dy - points[i].pos.dy;
        slopes.add(dX == 0 ? 0 : dY / dX);
      }

      // 2. Calculate Tangents at points (C1 continuity)
      final List<double> tangents = List.filled(points.length, 0);
      for (int i = 0; i < points.length; i++) {
        if (i == 0) {
          tangents[i] = slopes[0];
        } else if (i == points.length - 1) {
          tangents[i] = slopes[i - 1];
        } else {
          // Weighted average for smoother transitions
          final s0 = slopes[i - 1];
          final s1 = slopes[i];
          if (s0 * s1 <= 0) {
            tangents[i] = 0; // Maintain monotonicity
          } else {
            tangents[i] = (s0 + s1) / 2.0;
          }
        }
      }

      // 3. Draw Path using Monotone-preserving Cubic Bezier
      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i].pos;
        final p1 = points[i + 1].pos;
        final dX = p1.dx - p0.dx;
        
        // Control points positioned at 1/3 horizontal distance
        // Vertical offset derived from the tangents
        final cp1 = Offset(p0.dx + dX / 3.0, p0.dy + (dX * tangents[i]) / 3.0);
        final cp2 = Offset(p1.dx - dX / 3.0, p1.dy - (dX * tangents[i + 1]) / 3.0);

        path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
      }

      // Draw Gradient Fill under the curve (Very subtle for thread style)
      final fillPath = Path.from(path);
      fillPath.lineTo(points.last.pos.dx, size.height);
      fillPath.lineTo(points.first.pos.dx, size.height);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, size.height * 0.4),
          Offset(0, size.height),
          [
            colors.primary.withOpacity(0.12),
            colors.primary.withOpacity(0.0),
          ],
        )
        ..style = PaintingStyle.fill;
      canvas.drawPath(fillPath, fillPaint);

      // Thread Shadow (Increased blur for thicker line)
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.black.withOpacity(0.25)
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Thread Line (The "Thread") - Increased thickness
      final linePaint = Paint()
        ..color = colors.primary
        ..strokeWidth = 2.0 // Slightly thicker for better visibility
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, linePaint);
    }

    // Draw dots for each mood
    final dotPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final color = accentColors[point.moodIndex.clamp(0, 6)];
      
      // Outer border for the dot (Increased size)
      canvas.drawCircle(point.pos, 5.r, Paint()..color = colors.grey7);
      
      // Inner colored dot (Increased size)
      canvas.drawCircle(point.pos, 3.5.r, dotPaint..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
