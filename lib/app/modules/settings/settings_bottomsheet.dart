import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_jot/app/core/constants.dart';

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

  // Function to show the Cupertino time picker
  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        final appThemeColors = AppTheme.colorsOf(context);
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          color: appThemeColors.grey6,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              controller.reminderTime.value?.hour ?? 20,
              controller.reminderTime.value?.minute ?? 0,
            ),
            onDateTimeChanged: (DateTime newDateTime) {
              controller.setReminderTime(TimeOfDay.fromDateTime(newDateTime));
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final tileBackgroundColor = appThemeColors.grey5;
    final textColor = appThemeColors.grey10;

    // Helper function to create a list tile
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
                  // Section for Notifications and Security
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Obx(() {
                      final reminderEnabled = controller.dailyReminder.value;
                      final selectedTime = controller.reminderTime.value;

                      // Format the time to be displayed
                      String formattedTime = '';
                      if (selectedTime != null) {
                        final now = DateTime.now();
                        final dt = DateTime(now.year, now.month, now.day,
                            selectedTime.hour, selectedTime.minute);
                        formattedTime =
                            DateFormat.jm().format(dt); // e.g., 8:00 PM
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

                  // Section for Data Management
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Column(
                      children: [
                        _buildListTile(
                          title: AppConstants.backup,
                          icon: Icons.cloud_upload,
                          trailing:
                          const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {},
                        ),
                        _buildListTile(
                          title: AppConstants.restore,
                          icon: Icons.cloud_download,
                          trailing:
                          const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section for App Info
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
            // App Version at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text(
                AppConstants.version,
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
