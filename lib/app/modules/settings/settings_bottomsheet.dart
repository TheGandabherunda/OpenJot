import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/modules/settings/about_screen.dart';
import 'package:open_jot/app/modules/settings/terms_and_conditions_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/theme.dart';
import 'settings_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final tileBackgroundColor = appThemeColors.grey5;
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
            bottom: BorderSide(color: appThemeColors.grey4, width: 1.w),
          )
              : null,
        ),
        child: ListTile(
          leading: Icon(icon, color: textColor),
          title: Text(title,
              style:
              TextStyle(color: textColor,fontWeight: FontWeight.w500,letterSpacing: -0.2, fontFamily: AppConstants.font)),
          trailing: trailing,
          onTap: onTap,
        ),
      );
    }

    return Material(
      child: Scaffold(
        backgroundColor: appThemeColors.grey6,
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Obx(() {
                final reminderEnabled = controller.dailyReminder.value;
                final onThisDayEnabled = controller.onThisDay.value; // NEW
                final selectedTime = controller.reminderTime.value;
                final appLockEnabled = controller.appLock.value;

                String formattedTime = '';
                if (selectedTime != null) {
                  final now = DateTime.now();
                  final dt = DateTime(now.year, now.month, now.day,
                      selectedTime.hour, selectedTime.minute);
                  formattedTime = DateFormat.jm().format(dt);
                }

                return Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.dailyReminder,
                      icon: Icons.notifications,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (reminderEnabled && selectedTime != null)
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
                                  formattedTime,
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
                            value: reminderEnabled,
                            onChanged: (bool value) async {
                              if (value) {
                                final hasPermission = await controller.checkAndRequestNotificationPermissions();
                                if (hasPermission) {
                                  final picked = await _showTimePicker();
                                  if (picked != null) {
                                    // Wait for the dialog to fully close to avoid Overlay context errors
                                    await Future.delayed(const Duration(milliseconds: 300));
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
                      onTap: reminderEnabled ? () async {
                        final picked = await _showTimePicker();
                        if (picked != null && picked != controller.reminderTime.value) {
                          // Wait for the dialog to fully close to avoid Overlay context errors
                          await Future.delayed(const Duration(milliseconds: 300));
                          controller.setReminderTime(picked);
                        }
                      } : null,
                    ),
                    // --- NEW: "On This Day" Toggle ---
                    _buildListTile(
                      title: AppConstants.onThisDay,
                      subtitle: AppConstants.onThisDayDescription,
                      icon: Icons.history,
                      trailing: Switch(
                        value: onThisDayEnabled,
                        onChanged: controller.toggleOnThisDay,
                        activeColor: appThemeColors.primary,
                      ),
                    ),
                    // --- END NEW ---
                    _buildListTile(
                      title: AppConstants.appLock,
                      subtitle: AppConstants.appLockDescription,
                      icon: Icons.lock,
                      trailing: Switch(
                        value: appLockEnabled,
                        onChanged: (bool value) {
                          controller.toggleAppLock(value);
                        },
                        activeColor: appThemeColors.primary,
                      ),
                    ),
                    if (appLockEnabled)
                      _buildListTile(
                        title: AppConstants.changePin,
                        subtitle: AppConstants.changePinDescription,
                        icon: Icons.password,
                        onTap: controller.changePin,
                        showDivider: false,
                      ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Column(
                children: [
                  Obx(() => _buildListTile(
                    title: AppConstants.theme,
                    subtitle:
                    "${controller.theme.value} - ${AppConstants.themeDescription}",
                    icon: Icons.style_rounded,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: _showThemeSelectionBottomSheet,
                    showDivider: false,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Column(
                children: [
                  _buildListTile(
                    title: AppConstants.termsNConditions,
                    subtitle: AppConstants.termsNConditionsDescription,
                    icon: Icons.article_rounded,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () => Get.to(() => const TermsAndConditionsScreen()),
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
            SizedBox(height: 48.h,),
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
  }
}