import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_jot/app/core/constants.dart';
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
  bool _appLock = false;
  String _appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  /// Fetches and sets the application version.
  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  void _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          controller.reminderTime.value ?? const TimeOfDay(hour: 20, minute: 0),
    );
    if (picked != null && picked != controller.reminderTime.value) {
      controller.setReminderTime(picked);
    }
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
            ListTile(
              title: Text(AppConstants.themeLight,
                  style: TextStyle(color: appThemeColors.grey10)),
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
                  style: TextStyle(color: appThemeColors.grey10)),
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
                  style: TextStyle(color: appThemeColors.grey10)),
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
    }) {
      return Container(
        decoration: BoxDecoration(
          color: tileBackgroundColor,
          border: Border(
            bottom: BorderSide(color: appThemeColors.grey4, width: 1.w),
          ),
        ),
        child: ListTile(
          leading: Icon(icon, color: textColor),
          title: Text(title, style: TextStyle(color: textColor)),
          subtitle: subtitle != null
              ? Text(subtitle, style: TextStyle(color: appThemeColors.grey2))
              : null,
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
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Obx(() {
                      final reminderEnabled = controller.dailyReminder.value;
                      final selectedTime = controller.reminderTime.value;

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
                            subtitle: reminderEnabled && selectedTime != null
                                ? formattedTime
                                : null,
                            icon: Icons.notifications,
                            trailing: Switch(
                              value: reminderEnabled,
                              onChanged: (bool value) {
                                controller.toggleDailyReminder(value);
                                if (value) {
                                  _showTimePicker();
                                }
                              },
                              activeColor: appThemeColors.primary,
                            ),
                            onTap: reminderEnabled ? _showTimePicker : null,
                          ),
                          _buildListTile(
                            title: AppConstants.appLock,
                            icon: Icons.lock,
                            trailing: Switch(
                              value: _appLock,
                              onChanged: (bool value) {
                                setState(() {
                                  _appLock = value;
                                });
                              },
                              activeColor: appThemeColors.primary,
                            ),
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
                              subtitle: controller.theme.value,
                              icon: Icons.style_rounded,
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 18),
                              onTap: _showThemeSelectionBottomSheet,
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
                          icon: Icons.cloud_upload,
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () => controller.backup(),
                        ),
                        _buildListTile(
                          title: AppConstants.restore,
                          icon: Icons.cloud_download,
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () => controller.restore(),
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
                          title: AppConstants.privacyPolicy,
                          icon: Icons.privacy_tip,
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {},
                        ),
                        _buildListTile(
                          title: AppConstants.about,
                          icon: Icons.info,
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text(
                'v $_appVersion',
                style: TextStyle(
                  color: appThemeColors.grey3,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
