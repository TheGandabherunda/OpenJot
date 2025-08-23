import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/modules/insights/insights_bottomsheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (kDebugMode) {
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
  }

  if (notificationResponse.payload != null &&
      notificationResponse.payload!.isNotEmpty) {
    try {
      final payloadData =
      jsonDecode(notificationResponse.payload!) as Map<String, dynamic>;
      if (payloadData['type'] == 'on_this_day') {
        NotificationService.initialPayload = notificationResponse.payload;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error decoding notification payload: $e');
      }
    }
  }
}

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static String? initialPayload;

  Future<NotificationService> init() async {
    if (kDebugMode) {
      print("[NotificationService] Initializing...");
    }
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_notification');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      initialPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
    }

    if (kDebugMode) {
      print("[NotificationService] Initialization complete.");
    }
    return this;
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null &&
        notificationResponse.payload!.isNotEmpty) {
      try {
        final payloadData =
        jsonDecode(notificationResponse.payload!) as Map<String, dynamic>;
        if (payloadData['type'] == 'on_this_day') {
          final dateStr = payloadData['date'] as String;
          final date = DateTime.parse(dateStr);
          handleOnThisDayTap(date);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error decoding notification payload: $e');
        }
      }
    }
  }

  static void handleOnThisDayTap(DateTime date) {
    if (Get.context != null) {
      showCupertinoModalBottomSheet(
        context: Get.context!,
        expand: false,
        backgroundColor: Colors.transparent,
        // FIX: Removed the undefined 'isOnThisDay' parameter.
        builder: (context) => EntriesForDateBottomSheet(
          date: date,
        ),
      );
    }
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        print("[NotificationService] Requesting notification permissions...");
      }

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

      final PermissionStatus scheduleExactAlarmStatus =
      await Permission.scheduleExactAlarm.request();
      if (kDebugMode) {
        print(
            "[NotificationService] Schedule exact alarm permission status: $scheduleExactAlarmStatus");
      }

      return scheduleExactAlarmStatus.isGranted;
    }
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    if (kDebugMode) {
      print("[NotificationService] Reminder scheduled successfully.");
    }
  }

  Future<void> checkForOnThisDayMemories() async {
    final hiveService = Get.find<HiveService>();
    if (!hiveService.onThisDay) {
      if (kDebugMode) {
        print("[NotificationService] 'On This Day' is disabled. Skipping check.");
      }
      return;
    }

    final now = DateTime.now();
    final allEntries = hiveService.getAllJournalEntries();
    final memories = allEntries.where((entry) {
      return entry.createdAt.month == now.month &&
          entry.createdAt.day == now.day &&
          entry.createdAt.year < now.year;
    }).toList();

    if (memories.isEmpty) {
      if (kDebugMode) {
        print("[NotificationService] No memories found for this day.");
      }
      return;
    }

    memories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final schedulingTime = memories.first.createdAt;

    final scheduledDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      schedulingTime.hour,
      schedulingTime.minute,
    );

    if (scheduledDateTime.isBefore(tz.TZDateTime.now(tz.local))) {
      if (kDebugMode) {
        print(
            "[NotificationService] Memory time for today has already passed. Skipping notification.");
      }
      return;
    }

    if (kDebugMode) {
      print(
          "[NotificationService] Found ${memories.length} memories. Scheduling notification for $scheduledDateTime.");
    }

    String title = AppConstants.onThisDayNotificationTitle;
    String body;
    String? largeIconPath;

    final bool hasMedia =
    memories.any((e) => e.cameraPhotos.isNotEmpty || e.galleryImages.isNotEmpty);

    if (memories.length == 1) {
      body = hasMedia
          ? AppConstants.onThisDaySingleEntryWithMedia
          : AppConstants.onThisDaySingleEntry;
      if (hasMedia) {
        final entryWithMedia = memories.firstWhere((e) =>
        e.cameraPhotos.isNotEmpty || e.galleryImages.isNotEmpty);
        if (entryWithMedia.cameraPhotos.isNotEmpty) {
          largeIconPath = entryWithMedia.cameraPhotos.first.file.path;
        }
      }
    } else {
      body = AppConstants.onThisDayMultipleEntries;
      title = AppConstants.onThisDayGroupedNotification
          .replaceFirst('%d', memories.length.toString());
    }

    final payload = jsonEncode({
      'type': 'on_this_day',
      'date': now.toIso8601String(),
    });

    final androidDetails = AndroidNotificationDetails(
      AppConstants.onThisDayChannelId,
      AppConstants.onThisDayChannelName,
      channelDescription: AppConstants.onThisDayChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      largeIcon:
      largeIconPath != null ? FilePathAndroidBitmap(largeIconPath) : null,
      styleInformation: BigTextStyleInformation(body),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      title,
      body,
      scheduledDateTime,
      NotificationDetails(android: androidDetails),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
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
