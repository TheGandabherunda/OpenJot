import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/hive_service.dart';

import '../../core/services/notification_service.dart';

class SettingsScreenController extends GetxController {
  final _hiveService = Get.find<HiveService>();

  // Use Get.find() to get the initialized service instance
  final _notificationService = Get.find<NotificationService>();

  var dailyReminder = false.obs;
  var reminderTime = Rx<TimeOfDay?>(null);
  var theme = AppConstants.themeSystem.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    dailyReminder.value = _hiveService.dailyReminder;
    reminderTime.value = _hiveService.reminderTime;
    theme.value = _hiveService.theme;
  }

  void toggleDailyReminder(bool value) async {
    if (value) {
      // Request permission before enabling the reminder
      final bool permissionsGranted =
          await _notificationService.requestPermissions();

      if (permissionsGranted) {
        dailyReminder.value = true;
        _hiveService.setDailyReminder(true); // Save to Hive

        if (reminderTime.value == null) {
          final defaultTime = const TimeOfDay(hour: 20, minute: 0);
          setReminderTime(defaultTime);
        } else {
          _notificationService
              .scheduleDailyJournalReminder(reminderTime.value!);
        }
      } else {
        // If permission is denied, keep the switch off and inform the user
        dailyReminder.value = false;
        Fluttertoast.showToast(
          msg: "Notification permission is required to set reminders.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      // If the switch is turned off, cancel all notifications
      dailyReminder.value = false;
      _hiveService.setDailyReminder(false); // Save to Hive
      _notificationService.cancelAllNotifications();
    }
  }

  void setReminderTime(TimeOfDay time) {
    reminderTime.value = time;
    _hiveService.setReminderTime(time); // Save to Hive

    if (dailyReminder.value) {
      _notificationService.scheduleDailyJournalReminder(time);
    }
  }

  void changeTheme(String themeValue) {
    theme.value = themeValue;
    _hiveService.setTheme(themeValue); // Save to Hive

    ThemeMode themeMode;
    switch (themeValue) {
      case AppConstants.themeLight:
        themeMode = ThemeMode.light;
        break;
      case AppConstants.themeDark:
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
        break;
    }
    Get.changeThemeMode(themeMode);
  }

  // --- Backup and Restore ---
  Future<void> backup() async {
    await _hiveService.backupData();
  }

  Future<void> restore() async {
    await _hiveService.restoreData();
  }
}
