import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/translations/app_translations.dart';
import 'package:open_jot/app/core/widgets/custom_datetime_picker.dart';
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

    Future<TimeOfDay?> _showTimePicker() {
      return showCustomTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 20, minute: 0),
        showNowButton: false,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: textColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppConstants.reminders.tr,
          style: TextStyle(
            color: textColor,
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppConstants.font,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_rounded,
              color: appThemeColors.primary,
            ),
            onPressed: () async {
              final picked = await _showTimePicker();
              if (picked != null) {
                controller.addReminder(picked);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Obx(() {
                  if (controller.reminderTimes.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Text(
                          AppConstants.noRemindersSet.tr,
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
                        final timeStr = AppTranslations.formatJm(dt);

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
    );
  }
}
