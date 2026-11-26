import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/theme.dart';

/// Shows an OpenJot-styled custom calendar date picker modal matching the app's
/// Apple-inspired typography, segmented controls, and theme palette.
Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final minDate = firstDate ?? DateTime(2000);
  final maxDate = lastDate ?? DateTime(2101);
  return showGeneralDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.45),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, _, __) {
      return _CustomDatePickerDialog(
        initialDate: initialDate,
        firstDate: minDate,
        lastDate: maxDate,
      );
    },
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Shows an OpenJot-styled custom wheel time picker modal matching the app's
/// Apple-inspired typography, segmented controls, and theme palette.
Future<TimeOfDay?> showCustomTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  bool showNowButton = true,
}) {
  return showGeneralDialog<TimeOfDay>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.45),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, _, __) {
      return _CustomTimePickerDialog(
        initialTime: initialTime,
        showNowButton: showNowButton,
      );
    },
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _PickerPalette {
  final Color dialogSurface;
  final Color controlSurface;
  final Color? borderColor;
  final AppThemeColors themeColors;

  const _PickerPalette({
    required this.dialogSurface,
    required this.controlSurface,
    required this.borderColor,
    required this.themeColors,
  });

  factory _PickerPalette.of(BuildContext context) {
    final themeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack =
        Get.isRegistered<HiveService>() && Get.find<HiveService>().pitchBlack;

    final dialogSurface = isPitchBlack
        ? (isDark ? const Color(0xFF121215) : Colors.white)
        : themeColors.grey6;

    final controlSurface = isPitchBlack
        ? (isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.05))
        : themeColors.grey5;

    final borderColor = isPitchBlack || isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.06);

    return _PickerPalette(
      dialogSurface: dialogSurface,
      controlSurface: controlSurface,
      borderColor: borderColor,
      themeColors: themeColors,
    );
  }
}

class _CustomDatePickerDialog extends StatefulWidget {
  const _CustomDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_CustomDatePickerDialog> createState() =>
      _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<_CustomDatePickerDialog> {
  static const List<String> _weekdayLabels = [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  DateTime? _dateBeforeWheel;
  DateTime? _monthBeforeWheel;
  bool _isPickingMonthYear = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = _clampDate(
      DateTime(
        widget.initialDate.year,
        widget.initialDate.month,
        widget.initialDate.day,
      ),
    );
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  DateTime _clampDate(DateTime d) {
    final min = DateTime(
      widget.firstDate.year,
      widget.firstDate.month,
      widget.firstDate.day,
    );
    final max = DateTime(
      widget.lastDate.year,
      widget.lastDate.month,
      widget.lastDate.day,
    );
    if (d.isBefore(min)) return min;
    if (d.isAfter(max)) return max;
    return d;
  }

  bool _isInRange(DateTime d) {
    final min = DateTime(
      widget.firstDate.year,
      widget.firstDate.month,
      widget.firstDate.day,
    );
    final max = DateTime(
      widget.lastDate.year,
      widget.lastDate.month,
      widget.lastDate.day,
    );
    return !d.isBefore(min) && !d.isAfter(max);
  }

  bool _canGoMonth(int delta) {
    final candidate =
        DateTime(_displayedMonth.year, _displayedMonth.month + delta);
    final minMonth = DateTime(widget.firstDate.year, widget.firstDate.month);
    final maxMonth = DateTime(widget.lastDate.year, widget.lastDate.month);
    return !candidate.isBefore(minMonth) && !candidate.isAfter(maxMonth);
  }

  void _shiftMonth(int delta) {
    if (!_canGoMonth(delta)) return;
    HapticFeedback.selectionClick();
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + delta);
    });
  }

  void _jumpToToday() {
    final now = DateTime.now();
    final today = _clampDate(DateTime(now.year, now.month, now.day));
    HapticFeedback.selectionClick();
    setState(() {
      _selectedDate = today;
      _displayedMonth = DateTime(today.year, today.month);
      _isPickingMonthYear = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = _PickerPalette.of(context);
    final colors = palette.themeColors;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 340.w,
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 16.h),
            decoration: BoxDecoration(
              color: palette.dialogSurface,
              borderRadius: BorderRadius.circular(24.r),
              border: palette.borderColor != null
                  ? Border.all(color: palette.borderColor!, width: 1)
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateFormat('EEE, MMM d, y').format(_selectedDate),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppConstants.font,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.grey2,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          if (!_isPickingMonthYear) {
                            _dateBeforeWheel = _selectedDate;
                            _monthBeforeWheel = _displayedMonth;
                            _isPickingMonthYear = true;
                          } else {
                            _isPickingMonthYear = false;
                            _dateBeforeWheel = null;
                            _monthBeforeWheel = null;
                          }
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 32.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: palette.controlSurface,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(50),
                                right: Radius.circular(6),
                              ),
                            ),
                            child: Text(
                              DateFormat('MMMM y').format(_displayedMonth),
                              style: TextStyle(
                                fontFamily: AppConstants.font,
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.grey10,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            width: 34.w,
                            height: 32.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: palette.controlSurface,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(6),
                                right: Radius.circular(50),
                              ),
                            ),
                            child: AnimatedRotation(
                              turns: _isPickingMonthYear ? 0.25 : 0.0,
                              duration: const Duration(milliseconds: 180),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                size: 19.sp,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!_isPickingMonthYear)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildNavChevronPill(
                            palette: palette,
                            icon: Icons.chevron_left_rounded,
                            enabled: _canGoMonth(-1),
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(50),
                              right: Radius.circular(6),
                            ),
                            onTap: () => _shiftMonth(-1),
                          ),
                          SizedBox(width: 2.w),
                          _buildNavChevronPill(
                            palette: palette,
                            icon: Icons.chevron_right_rounded,
                            enabled: _canGoMonth(1),
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(6),
                              right: Radius.circular(50),
                            ),
                            onTap: () => _shiftMonth(1),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 16.h),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _isPickingMonthYear
                      ? _buildMonthYearWheel(palette)
                      : _buildCalendarGrid(palette),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _jumpToToday,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 9.h,
                        ),
                        decoration: BoxDecoration(
                          color: palette.controlSurface,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Today',
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        if (_isPickingMonthYear) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            if (_dateBeforeWheel != null) {
                              _selectedDate = _dateBeforeWheel!;
                            }
                            if (_monthBeforeWheel != null) {
                              _displayedMonth = _monthBeforeWheel!;
                            }
                            _dateBeforeWheel = null;
                            _monthBeforeWheel = null;
                            _isPickingMonthYear = false;
                          });
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: colors.grey1,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 9.h,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        AppConstants.cancel,
                        style: TextStyle(
                          fontFamily: AppConstants.font,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        if (_isPickingMonthYear) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _dateBeforeWheel = null;
                            _monthBeforeWheel = null;
                            _isPickingMonthYear = false;
                          });
                        } else {
                          Navigator.of(context).pop(_selectedDate);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 9.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          AppConstants.done,
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.onPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavChevronPill({
    required _PickerPalette palette,
    required IconData icon,
    required bool enabled,
    required BorderRadius borderRadius,
    required VoidCallback onTap,
  }) {
    final colors = palette.themeColors;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 34.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: palette.controlSurface,
          borderRadius: borderRadius,
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: enabled ? colors.grey10 : colors.grey3,
        ),
      ),
    );
  }

  Widget _buildMonthYearWheel(_PickerPalette palette) {
    final colors = palette.themeColors;
    final startYear = widget.firstDate.year;
    final endYear = widget.lastDate.year;
    final years = List<int>.generate(
      (endYear - startYear + 1).clamp(1, 300),
      (i) => startYear + i,
    );
    final initialYearIdx =
        years.indexOf(_displayedMonth.year).clamp(0, years.length - 1);

    return SizedBox(
      key: const ValueKey('month_year_wheel'),
      height: 224.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: palette.controlSurface,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: CupertinoPicker(
                  itemExtent: 40.h,
                  selectionOverlay: const SizedBox.shrink(),
                  scrollController: FixedExtentScrollController(
                    initialItem: _displayedMonth.month - 1,
                  ),
                  onSelectedItemChanged: (idx) {
                    HapticFeedback.selectionClick();
                    final newMonth = idx + 1;
                    final maxDay = DateUtils.getDaysInMonth(
                      _displayedMonth.year,
                      newMonth,
                    );
                    setState(() {
                      _displayedMonth = DateTime(_displayedMonth.year, newMonth);
                      _selectedDate = _clampDate(
                        DateTime(
                          _displayedMonth.year,
                          newMonth,
                          _selectedDate.day.clamp(1, maxDay),
                        ),
                      );
                    });
                  },
                  children: AppConstants.months
                      .map(
                        (m) => Center(
                          child: Text(
                            m,
                            style: TextStyle(
                              fontFamily: AppConstants.font,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.grey10,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                flex: 2,
                child: CupertinoPicker(
                  itemExtent: 40.h,
                  selectionOverlay: const SizedBox.shrink(),
                  scrollController: FixedExtentScrollController(
                    initialItem: initialYearIdx,
                  ),
                  onSelectedItemChanged: (idx) {
                    HapticFeedback.selectionClick();
                    final newYear = years[idx];
                    final maxDay = DateUtils.getDaysInMonth(
                      newYear,
                      _displayedMonth.month,
                    );
                    setState(() {
                      _displayedMonth =
                          DateTime(newYear, _displayedMonth.month);
                      _selectedDate = _clampDate(
                        DateTime(
                          newYear,
                          _displayedMonth.month,
                          _selectedDate.day.clamp(1, maxDay),
                        ),
                      );
                    });
                  },
                  children: years
                      .map(
                        (y) => Center(
                          child: Text(
                            y.toString(),
                            style: TextStyle(
                              fontFamily: AppConstants.font,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.grey10,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(_PickerPalette palette) {
    final colors = palette.themeColors;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final firstOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final leadingEmpty = firstOfMonth.weekday % 7; // Sunday = 0
    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final totalCells = ((leadingEmpty + daysInMonth + 6) ~/ 7) * 7;

    return Column(
      key: const ValueKey('calendar_grid'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: _weekdayLabels
              .map(
                (label) => Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontFamily: AppConstants.font,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.grey2,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 8.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.05,
          ),
          itemCount: totalCells,
          itemBuilder: (context, index) {
            final dayNum = index - leadingEmpty + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return const SizedBox.shrink();
            }

            final cellDate = DateTime(
              _displayedMonth.year,
              _displayedMonth.month,
              dayNum,
            );
            final inRange = _isInRange(cellDate);
            final isSelected = cellDate.year == _selectedDate.year &&
                cellDate.month == _selectedDate.month &&
                cellDate.day == _selectedDate.day;
            final isToday = cellDate.year == today.year &&
                cellDate.month == today.month &&
                cellDate.day == today.day;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: inRange
                  ? () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedDate = cellDate;
                      });
                    }
                  : null,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary
                        : (isToday
                            ? palette.controlSurface
                            : Colors.transparent),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$dayNum',
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      fontSize: 14.sp,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: !inRange
                          ? colors.grey3
                          : (isSelected
                              ? colors.onPrimary
                              : (isToday ? colors.primary : colors.grey10)),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CustomTimePickerDialog extends StatefulWidget {
  const _CustomTimePickerDialog({
    required this.initialTime,
    required this.showNowButton,
  });

  final TimeOfDay initialTime;
  final bool showNowButton;

  @override
  State<_CustomTimePickerDialog> createState() =>
      _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<_CustomTimePickerDialog> {
  late int _hour12; // 1..12
  late int _minute; // 0..59
  late bool _isPm;

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  @override
  void initState() {
    super.initState();
    _syncFromTimeOfDay(widget.initialTime, initControllers: true);
  }

  void _syncFromTimeOfDay(
    TimeOfDay time, {
    bool initControllers = false,
  }) {
    final hour24 = time.hour;
    _isPm = hour24 >= 12;
    _hour12 = (hour24 % 12 == 0) ? 12 : hour24 % 12;
    _minute = time.minute;

    if (initControllers) {
      _hourController = FixedExtentScrollController(initialItem: _hour12 - 1);
      _minuteController = FixedExtentScrollController(initialItem: _minute);
      _periodController = FixedExtentScrollController(
        initialItem: _isPm ? 1 : 0,
      );
    } else {
      _hourController.jumpToItem(_hour12 - 1);
      _minuteController.jumpToItem(_minute);
      _periodController.jumpToItem(_isPm ? 1 : 0);
    }
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  TimeOfDay _toTimeOfDay() {
    final hour24 = (_hour12 % 12) + (_isPm ? 12 : 0);
    return TimeOfDay(hour: hour24, minute: _minute);
  }

  void _jumpToNow() {
    HapticFeedback.selectionClick();
    final now = TimeOfDay.now();
    setState(() {
      _syncFromTimeOfDay(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = _PickerPalette.of(context);
    final colors = palette.themeColors;
    final formattedHour = _hour12.toString();
    final formattedMinute = _minute.toString().padLeft(2, '0');
    final periodLabel = _isPm ? 'PM' : 'AM';

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 330.w,
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
            decoration: BoxDecoration(
              color: palette.dialogSurface,
              borderRadius: BorderRadius.circular(24.r),
              border: palette.borderColor != null
                  ? Border.all(color: palette.borderColor!, width: 1)
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Time',
                      style: TextStyle(
                        fontFamily: AppConstants.font,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.grey10,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: palette.controlSurface,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        '$formattedHour:$formattedMinute $periodLabel',
                        style: TextStyle(
                          fontFamily: AppConstants.font,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.primary,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 184.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: palette.controlSurface,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: _hourController,
                              itemExtent: 44.h,
                              looping: true,
                              selectionOverlay: const SizedBox.shrink(),
                              onSelectedItemChanged: (idx) {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _hour12 = idx + 1;
                                });
                              },
                              children: List.generate(
                                12,
                                (i) => Center(
                                  child: Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      fontFamily: AppConstants.font,
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colors.grey10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: Text(
                              ':',
                              style: TextStyle(
                                fontFamily: AppConstants.font,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.grey2,
                              ),
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: _minuteController,
                              itemExtent: 44.h,
                              looping: true,
                              selectionOverlay: const SizedBox.shrink(),
                              onSelectedItemChanged: (idx) {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _minute = idx;
                                });
                              },
                              children: List.generate(
                                60,
                                (i) => Center(
                                  child: Text(
                                    i.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontFamily: AppConstants.font,
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colors.grey10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: _periodController,
                              itemExtent: 44.h,
                              selectionOverlay: const SizedBox.shrink(),
                              onSelectedItemChanged: (idx) {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _isPm = idx == 1;
                                });
                              },
                              children: ['AM', 'PM']
                                  .map(
                                    (pLabel) => Center(
                                      child: Text(
                                        pLabel,
                                        style: TextStyle(
                                          fontFamily: AppConstants.font,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w700,
                                          color: colors.grey10,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    if (widget.showNowButton)
                      GestureDetector(
                        onTap: _jumpToNow,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 9.h,
                          ),
                          decoration: BoxDecoration(
                            color: palette.controlSurface,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            'Now',
                            style: TextStyle(
                              fontFamily: AppConstants.font,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.primary,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.grey1,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 9.h,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        AppConstants.cancel,
                        style: TextStyle(
                          fontFamily: AppConstants.font,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(_toTimeOfDay()),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 9.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          AppConstants.done,
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.onPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
