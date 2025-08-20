import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';

import '../../core/services/notification_service.dart';

class SettingsScreenController extends GetxController {
  // Observable for the daily reminder switch state
  var dailyReminder = false.obs;

  // Observable for the selected reminder time
  var reminderTime = Rx<TimeOfDay?>(null);

  // Observable for the theme
  var theme = AppConstants.themeSystem.obs;

  final NotificationService _notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    // Set a default time when the controller is initialized if reminder is on
    if (dailyReminder.value) {
      reminderTime.value =
      const TimeOfDay(hour: 20, minute: 0); // Default to 8:00 PM
    }
  }

  // Toggles the daily reminder and handles time picking
  void toggleDailyReminder(bool value) {
    dailyReminder.value = value;
    if (value) {
      // If turned on, show time picker and set a default time if none is selected
      if (reminderTime.value == null) {
        reminderTime.value = const TimeOfDay(hour: 20, minute: 0);
      }
      // Here you would schedule the notification
      _notificationService.scheduleDailyJournalReminder(reminderTime.value!);
      print(AppConstants.notificationScheduled
          .replaceFirst('%s', reminderTime.value!.format(Get.context!)));
    } else {
      // If turned off, cancel any scheduled notification
      _notificationService.cancelAllNotifications();
      print(AppConstants.notificationCanceled);
    }
  }

  // Sets the reminder time
  void setReminderTime(TimeOfDay time) {
    reminderTime.value = time;
    if (dailyReminder.value) {
      // Reschedule notification with the new time
      _notificationService.scheduleDailyJournalReminder(time);
      print(AppConstants.notificationRescheduled
          .replaceFirst('%s', reminderTime.value!.format(Get.context!)));
    }
  }

  // Changes the application theme
  void changeTheme(String themeValue) {
    theme.value = themeValue;
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
}
