import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

// This is the callback that will be executed when a notification is tapped.
// It needs to be a top-level function (not a class method) to be accessible from the background.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
  if (kDebugMode) {
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
  }
  if (notificationResponse.input?.isNotEmpty ?? false) {
    if (kDebugMode) {
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }
}

class NotificationService {
  // Singleton pattern
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    if (kDebugMode) {
      print("[NotificationService] Initializing...");
    }
    // Initialization settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_notification');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        // Handle notification tapped while app is in the foreground or background
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    if (kDebugMode) {
      print("[NotificationService] Initialization complete.");
    }
    return this;
  }

  /// Requests notification and exact alarm permissions from the user for Android.
  /// Returns true if permissions are granted, false otherwise.
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        print("[NotificationService] Requesting notification permissions...");
      }

      // Request standard notification permission
      final PermissionStatus notificationStatus =
      await Permission.notification.request();
      if (kDebugMode) {
        print(
            "[NotificationService] Notification permission status: $notificationStatus");
      }
      if (notificationStatus.isDenied ||
          notificationStatus.isPermanentlyDenied) {
        return false;
      }

      // Request exact alarm permission for reliable scheduling on Android 12+
      final PermissionStatus scheduleExactAlarmStatus =
      await Permission.scheduleExactAlarm.request();
      if (kDebugMode) {
        print(
            "[NotificationService] Schedule exact alarm permission status: $scheduleExactAlarmStatus");
      }

      return scheduleExactAlarmStatus.isGranted;
    }
    // Default to false if not on Android
    return false;
  }

  Future<void> scheduleDailyJournalReminder(TimeOfDay time) async {
    final tz.TZDateTime scheduledDateTime = _nextInstanceOfTime(time);
    if (kDebugMode) {
      print(
          "[NotificationService] Scheduling daily reminder for: $scheduledDateTime");
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      AppConstants.notificationTitle,
      AppConstants.notificationBody,
      scheduledDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.notificationChannelId,
          AppConstants.notificationChannelName,
          channelDescription: AppConstants.notificationChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      // Use exact scheduling for more reliability
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    if (kDebugMode) {
      print("[NotificationService] Reminder scheduled successfully.");
    }
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    if (kDebugMode) {
      print("[NotificationService] Current timezone: ${tz.local.name}");
    }
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    if (kDebugMode) {
      print("[NotificationService] Cancelling all notifications.");
    }
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
