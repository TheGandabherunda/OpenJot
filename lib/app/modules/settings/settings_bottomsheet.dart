import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/modules/settings/about_screen.dart';
import 'package:open_jot/app/modules/settings/terms_and_conditions_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/theme.dart';
import 'settings_controller.dart';
import 'exclude_entries_bottomsheet.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({super.key});

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  final SettingsScreenController controller =
  Get.put(SettingsScreenController());
  String _appVersion = AppConstants.loading;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<TimeOfDay?> _showTimePicker() async {
    final appThemeColors = AppTheme.colorsOf(context);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          controller.reminderTime.value ?? const TimeOfDay(hour: 20, minute: 0),
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
    return picked;
  }

  void _showThemeSelectionBottomSheet() {
    final appThemeColors = AppTheme.colorsOf(context);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: appThemeColors.grey5,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              AppConstants.changeTheme,
              style: TextStyle(
                fontSize: 16.sp,
                letterSpacing: -0.2,
                color: appThemeColors.grey10,
                fontWeight: FontWeight.bold,
                fontFamily: AppConstants.font,
              ),
            ),
            ListTile(
              title: Text(AppConstants.themeLight,
                  style: TextStyle(
                      letterSpacing: -0.2,
                      color: appThemeColors.grey10,
                      fontFamily: AppConstants.font)),
              onTap: () {
                controller.changeTheme(AppConstants.themeLight);
                Get.back();
              },
              trailing: Obx(() =>
                controller.theme.value == AppConstants.themeLight
                    ? Icon(Icons.check, color: appThemeColors.primary)
                    : const SizedBox.shrink()),
            ),
            Divider(color: appThemeColors.grey4, height: 1),
            ListTile(
              title: Text(AppConstants.themeDark,
                  style: TextStyle(
                      letterSpacing: -0.2,
                      color: appThemeColors.grey10,
                      fontFamily: AppConstants.font)),
              onTap: () {
                controller.changeTheme(AppConstants.themeDark);
                Get.back();
              },
              trailing: Obx(() =>
                controller.theme.value == AppConstants.themeDark
                    ? Icon(Icons.check, color: appThemeColors.primary)
                    : const SizedBox.shrink()),
            ),
            Divider(color: appThemeColors.grey4, height: 1),
            ListTile(
              title: Text(AppConstants.themeSystem,
                  style: TextStyle(
                      letterSpacing: -0.2,
                      color: appThemeColors.grey10,
                      fontFamily: AppConstants.font)),
              onTap: () {
                controller.changeTheme(AppConstants.themeSystem);
                Get.back();
              },
              trailing: Obx(() =>
                controller.theme.value == AppConstants.themeSystem
                    ? Icon(Icons.check, color: appThemeColors.primary)
                    : const SizedBox.shrink()),
            ),
          ],
        ),
      ),
    );
  }

  void _showAutoDeleteOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(AppConstants.autoDeleteDrafts,
            style: TextStyle(fontFamily: AppConstants.font)),
        message: Text(AppConstants.autoDeleteDraftsDescription,
            style: TextStyle(fontFamily: AppConstants.font)),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text(AppConstants.days7,
                style: TextStyle(fontFamily: AppConstants.font)),
            onPressed: () {
              controller.setAutoDeleteDrafts(7);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(AppConstants.never,
                style: TextStyle(fontFamily: AppConstants.font)),
            onPressed: () {
              controller.setAutoDeleteDrafts(-1);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(AppConstants.custom,
                style: TextStyle(fontFamily: AppConstants.font)),
            onPressed: () {
              Navigator.pop(context);
              _showCustomDaysDialog();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppConstants.cancel,
              style: TextStyle(fontFamily: AppConstants.font)),
        ),
      ),
    );
  }

  void _showCustomDaysDialog() {
    final appThemeColors = AppTheme.colorsOf(context);
    final textController = TextEditingController();

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(AppConstants.enterCustomDays),
            content: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: CupertinoTextField(
                controller: textController,
                keyboardType: TextInputType.number,
                placeholder: AppConstants.customDaysExample,
                style: TextStyle(
                    color: appThemeColors.grey10, fontFamily: AppConstants.font),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: appThemeColors.grey6,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text(AppConstants.cancel),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text(AppConstants.save),
                onPressed: () {
                  final val = int.tryParse(textController.text.trim());
                  if (val != null && val > 0) {
                    controller.setAutoDeleteDrafts(val);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
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

      Widget _buildListTile({
        required String title,
        required IconData icon,
        Widget? trailing,
        VoidCallback? onTap,
        String? subtitle,
        bool showDivider = true,
      }) {
        return Container(
          decoration: BoxDecoration(
            color: tileBackgroundColor,
            border: showDivider
                ? Border(
                    bottom: BorderSide(
                        color: appThemeColors.grey4.withOpacity(0.4),
                        width: 1.w),
                  )
                : null,
          ),
          child: ListTile(
            leading: Icon(icon, color: textColor),
            title: Text(title,
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                    fontFamily: AppConstants.font)),
            trailing: trailing,
            onTap: onTap,
          ),
        );
      }

      return Material(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              AppConstants.settings,
              style: TextStyle(
                color: appThemeColors.grey10,
                fontWeight: FontWeight.bold,
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: appThemeColors.grey10,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            children: [
              // General Settings Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.dailyReminder,
                      icon: Icons.notifications,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.dailyReminder.value &&
                              controller.reminderTime.value != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: appThemeColors.grey4,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  (() {
                                    final selectedTime =
                                        controller.reminderTime.value!;
                                    final now = DateTime.now();
                                    final dt = DateTime(now.year, now.month,
                                        now.day, selectedTime.hour,
                                        selectedTime.minute);
                                    return DateFormat.jm().format(dt);
                                  })(),
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14.sp,
                                    letterSpacing: -0.4,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppConstants.font,
                                  ),
                                ),
                              ),
                            ),
                          Switch(
                            value: controller.dailyReminder.value,
                            onChanged: (bool value) async {
                              if (value) {
                                final hasPermission = await controller
                                    .checkAndRequestNotificationPermissions();
                                if (hasPermission) {
                                  final picked = await _showTimePicker();
                                  if (picked != null) {
                                    // Wait for the dialog to fully close to avoid Overlay context errors
                                    await Future.delayed(
                                        const Duration(milliseconds: 300));
                                    controller.turnOnDailyReminder(picked);
                                  }
                                }
                              } else {
                                controller.turnOffDailyReminder();
                              }
                            },
                            activeColor: appThemeColors.primary,
                          ),
                        ],
                      ),
                      onTap: controller.dailyReminder.value
                          ? () async {
                              final picked = await _showTimePicker();
                              if (picked != null &&
                                  picked != controller.reminderTime.value) {
                                // Wait for the dialog to fully close to avoid Overlay context errors
                                await Future.delayed(
                                    const Duration(milliseconds: 300));
                                controller.setReminderTime(picked);
                              }
                            }
                          : null,
                    ),
                    _buildListTile(
                      title: AppConstants.autoDeleteDrafts,
                      subtitle: AppConstants.autoDeleteDraftsDescription,
                      icon: Icons.auto_delete_outlined,
                      trailing: (() {
                        final days = controller.autoDeleteDraftsDays.value;
                        String display = days == -1
                            ? AppConstants.never
                            : (days == 7
                                ? AppConstants.days7
                                : "$days ${AppConstants.days}");
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(display,
                                style: TextStyle(
                                    color: appThemeColors.grey2,
                                    fontSize: 14.sp,
                                    fontFamily: AppConstants.font)),
                            SizedBox(width: 8.w),
                            Icon(Icons.arrow_forward_ios,
                                size: 16, color: appThemeColors.grey2),
                          ],
                        );
                      })(),
                      onTap: _showAutoDeleteOptions,
                    ),
                    _buildListTile(
                      title: AppConstants.appLock,
                      subtitle: AppConstants.appLockDescription,
                      icon: Icons.lock,
                      showDivider: controller
                          .appLock.value, // Hide divider if changePin isn't shown
                      trailing: Switch(
                        value: controller.appLock.value,
                        onChanged: (bool value) {
                          controller.toggleAppLock(value);
                        },
                        activeColor: appThemeColors.primary,
                      ),
                    ),
                    if (controller.appLock.value)
                      _buildListTile(
                        title: AppConstants.changePin,
                        subtitle: AppConstants.changePinDescription,
                        icon: Icons.password,
                        onTap: controller.changePin,
                        showDivider: false,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // On This Day Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.onThisDay,
                      subtitle: AppConstants.onThisDayDescription,
                      icon: Icons.history,
                      showDivider: controller
                          .onThisDay.value, // Hide divider if no items follow
                      trailing: Switch(
                        value: controller.onThisDay.value,
                        onChanged: controller.toggleOnThisDay,
                        activeColor: appThemeColors.primary,
                      ),
                    ),
                    if (controller.onThisDay.value)
                      _buildListTile(
                        title: AppConstants.excludeEntries,
                        subtitle: AppConstants.excludeEntriesDescription,
                        icon: Icons.notifications_off_outlined,
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        showDivider: false, // Last item in section
                        onTap: () {
                          showCupertinoModalBottomSheet(
                            context: context,
                            expand: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => SafeArea(
                              child: ExcludeEntriesBottomSheet(
                                initialExcludedIds:
                                    controller.excludedOnThisDayEntries,
                                onSave: (ids) {
                                  controller.updateExcludedEntries(ids);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Theme Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.theme,
                      subtitle:
                          "${controller.theme.value} - ${AppConstants.themeDescription}",
                      icon: Icons.style_rounded,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: _showThemeSelectionBottomSheet,
                      showDivider: true,
                    ),
                    _buildListTile(
                      title: AppConstants.pitchBlack,
                      subtitle: AppConstants.pitchBlackDescription,
                      icon: Icons.nightlight_round,
                      trailing: Switch(
                        value: controller.pitchBlack.value,
                        onChanged: (bool value) {
                          controller.togglePitchBlack(value);
                        },
                        activeColor: appThemeColors.primary,
                      ),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Backup & Restore Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.backup,
                      subtitle: AppConstants.backupDescription,
                      icon: Icons.cloud_upload,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () => controller.backup(),
                    ),
                    _buildListTile(
                      title: AppConstants.restore,
                      subtitle: AppConstants.restoreDescription,
                      icon: Icons.cloud_download,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () => controller.restore(),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // About Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.termsNConditions,
                      subtitle: AppConstants.termsNConditionsDescription,
                      icon: Icons.article_rounded,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () =>
                          Get.to(() => const TermsAndConditionsScreen()),
                    ),
                    _buildListTile(
                      title: AppConstants.privacyPolicy,
                      subtitle: AppConstants.privacyPolicyDescription,
                      icon: Icons.policy,
                      trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                      onTap: () => controller.launchURL(
                          'https://thegandabherunda.github.io/OpenJot/privacy_policy'),
                    ),
                    _buildListTile(
                      title: AppConstants.about,
                      subtitle: AppConstants.aboutDescription,
                      icon: Icons.info,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () => Get.to(() => const AboutScreen()),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 48.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: Text(
                    'v • $_appVersion',
                    style: TextStyle(
                      letterSpacing: -0.4,
                      color: appThemeColors.grey3,
                      fontSize: 16,
                      fontFamily: AppConstants.font,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}