import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/modules/settings/settings_controller.dart';

class RemindersBottomSheet extends StatelessWidget {
  const RemindersBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsScreenController controller = Get.find<SettingsScreenController>();
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = controller.pitchBlack.value;

    final backgroundColor = isPitchBlack
        ? (isDark ? Colors.black : Colors.white)
        : appThemeColors.grey6;

    final tileBackgroundColor = isPitchBlack
        ? (isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03))
        : appThemeColors.grey5;

    final textColor = appThemeColors.grey10;

    Future<TimeOfDay?> _showTimePicker() async {
      return await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 20, minute: 0),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: appThemeColors.grey6,
                hourMinuteTextColor: appThemeColors.grey10,
                hourMinuteColor: appThemeColors.grey4,
                dayPeriodTextColor: appThemeColors.grey10,
                dayPeriodColor: appThemeColors.grey4,
                dialHandColor: appThemeColors.primary,
                dialBackgroundColor: appThemeColors.grey5,
                entryModeIconColor: appThemeColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                hourMinuteShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              colorScheme: Theme.of(context).colorScheme.copyWith(
                surface: appThemeColors.grey5,
                onSurface: appThemeColors.grey10,
                primary: appThemeColors.primary,
                onPrimary: appThemeColors.onPrimary,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: appThemeColors.primary,
                ),
              ),
              dialogBackgroundColor: appThemeColors.grey6,
            ),
            child: child!,
          );
        },
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: appThemeColors.grey4,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstants.reminders,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.5,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      final picked = await _showTimePicker();
                      if (picked != null) {
                        controller.addReminder(picked);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: appThemeColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: appThemeColors.primary,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Obx(() {
                  if (controller.reminderTimes.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Text(
                          "No reminders set.",
                          style: TextStyle(
                            color: appThemeColors.grey3,
                            fontSize: 16.sp,
                            fontFamily: AppConstants.font,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    );
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(controller.reminderTimes.length, (index) {
                        final time = controller.reminderTimes[index];
                        final now = DateTime.now();
                        final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                        final timeStr = DateFormat.jm().format(dt);

                        final isLast = index == controller.reminderTimes.length - 1;

                        return Container(
                          decoration: BoxDecoration(
                            color: tileBackgroundColor,
                            border: !isLast
                                ? Border(
                                    bottom: BorderSide(
                                        color: appThemeColors.grey4.withOpacity(0.4),
                                        width: 1.w),
                                  )
                                : null,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: ListTile(
                              leading: Icon(Icons.access_time, color: textColor),
                              title: Text(
                                timeStr,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppConstants.font,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              trailing: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => controller.removeReminder(index),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: appThemeColors.error.withOpacity(0.9),
                                  size: 24.sp,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
