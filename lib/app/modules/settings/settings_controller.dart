import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/app_lock_service.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/notification_service.dart';
import '../../core/theme.dart';
import '../app_lock/set_pin_bottomsheet.dart';
import '../app_lock/verify_pin_bottomsheet.dart';

class SettingsScreenController extends GetxController {
  final _hiveService = Get.find<HiveService>();
  final _appLockService = Get.find<AppLockService>();
  final _notificationService = Get.find<NotificationService>();

  var dailyReminder = false.obs;
  var onThisDay = false.obs; // NEW
  var reminderTime = Rx<TimeOfDay?>(null);
  var theme = AppConstants.themeSystem.obs;
  var appLock = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    dailyReminder.value = _hiveService.dailyReminder;
    onThisDay.value = _hiveService.onThisDay; // NEW
    reminderTime.value = _hiveService.reminderTime;
    theme.value = _hiveService.theme;
    appLock.value = _hiveService.appLockEnabled;
  }

  void toggleDailyReminder(bool value) async {
    final appColors = AppTheme.colorsOf(Get.context!);
    if (value) {
      final bool permissionsGranted =
      await _notificationService.requestPermissions();

      if (permissionsGranted) {
        dailyReminder.value = true;
        _hiveService.setDailyReminder(true);

        if (reminderTime.value == null) {
          final defaultTime = const TimeOfDay(hour: 20, minute: 0);
          setReminderTime(defaultTime);
        } else {
          _notificationService
              .scheduleDailyJournalReminder(reminderTime.value!);
        }
      } else {
        dailyReminder.value = false;
        Fluttertoast.showToast(
          msg: AppConstants.notificationPermissionRequired,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: appColors.grey1,
          textColor: appColors.grey10,
          fontSize: 16.0,
        );
      }
    } else {
      dailyReminder.value = false;
      _hiveService.setDailyReminder(false);
      _notificationService.cancelAllNotifications();
    }
  }

  // --- NEW: Logic for "On This Day" toggle ---
  void toggleOnThisDay(bool value) async {
    final appColors = AppTheme.colorsOf(Get.context!);
    if (value) {
      final bool permissionsGranted =
      await _notificationService.requestPermissions();
      if (permissionsGranted) {
        onThisDay.value = true;
        _hiveService.setOnThisDay(true);
        // Immediately check for memories to schedule a notification if applicable
        _notificationService.checkForOnThisDayMemories();
      } else {
        onThisDay.value = false;
        Fluttertoast.showToast(
          msg: AppConstants.notificationPermissionRequired,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: appColors.grey1,
          textColor: appColors.grey10,
          fontSize: 16.0,
        );
      }
    } else {
      onThisDay.value = false;
      _hiveService.setOnThisDay(false);
      // You might want to cancel only the "On This Day" notification
      // but cancelling all is simpler and safer for now.
      _notificationService.cancelAllNotifications();
    }
  }

  void setReminderTime(TimeOfDay time) {
    reminderTime.value = time;
    _hiveService.setReminderTime(time);

    if (dailyReminder.value) {
      _notificationService.scheduleDailyJournalReminder(time);
    }
  }

  void changeTheme(String themeValue) {
    theme.value = themeValue;
    _hiveService.setTheme(themeValue);

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

  void toggleAppLock(bool value) async {
    if (value) {
      final result = await Get.bottomSheet(
        const SetPinBottomSheet(),
        isScrollControlled: true,
      );
      if (result == true) {
        appLock.value = true;
      }
    } else {
      bool authenticated = false;

      if (await _appLockService.isBiometricAvailable()) {
        authenticated = await _appLockService.authenticate();
      }

      if (!authenticated) {
        final result = await Get.bottomSheet(
          const VerifyPinBottomSheet(),
          isScrollControlled: true,
        );
        if (result == true) {
          authenticated = true;
        }
      }

      if (authenticated) {
        await _hiveService.setAppLock(false);
        appLock.value = false;
      }
    }
  }

  void changePin() async {
    final appColors = AppTheme.colorsOf(Get.context!);
    bool authenticated = false;

    if (await _appLockService.isBiometricAvailable()) {
      authenticated = await _appLockService.authenticate();
    }

    if (!authenticated) {
      final result = await Get.bottomSheet(
        const VerifyPinBottomSheet(),
        isScrollControlled: true,
      );
      if (result == true) {
        authenticated = true;
      }
    }

    if (authenticated) {
      final result = await Get.bottomSheet(
        const SetPinBottomSheet(),
        isScrollControlled: true,
      );
      if (result == true) {
        Fluttertoast.showToast(
            msg: AppConstants.pinChangedSuccess,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: appColors.grey7,
            textColor: appColors.grey10,
            fontSize: 16.0);
      }
    }
  }

  Future<void> backup() async {
    await _hiveService.backupData();
  }

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
    } else {
      // ignore: avoid_print
      print('Could not launch $url');
    }
  }

  Future<void> restore() async {
    await showCupertinoDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(AppConstants.confirmRestoreTitle),
        content: const Text(AppConstants.confirmRestoreMessage),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text(AppConstants.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text(AppConstants.restoreButton),
            onPressed: () async {
              Navigator.of(context).pop();
              final bool success = await _hiveService.restoreData();

              if (success) {
                _loadSettings();
                changeTheme(theme.value);

                if (Get.isRegistered<HomeController>()) {
                  Get.delete<HomeController>(force: true);
                }
                Get.put(HomeController());
              }
            },
          )
        ],
      ),
    );
  }
}
