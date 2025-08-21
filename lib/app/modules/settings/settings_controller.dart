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

  // Use Get.find() to get the initialized service instance
  final _notificationService = Get.find<NotificationService>();

  var dailyReminder = false.obs;
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
    reminderTime.value = _hiveService.reminderTime;
    theme.value = _hiveService.theme;
    appLock.value = _hiveService.appLockEnabled;
  }

  void toggleDailyReminder(bool value) async {
    final appColors = AppTheme.colorsOf(Get.context!);
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
          msg: AppConstants.notificationPermissionRequired,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: appColors.grey1,
          textColor: appColors.grey10,
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

      // Try biometric auth first if available
      if (await _appLockService.isBiometricAvailable()) {
        authenticated = await _appLockService.authenticate();
      }

      // If biometric auth failed or is not available, fall back to PIN verification
      if (!authenticated) {
        final result = await Get.bottomSheet(
          const VerifyPinBottomSheet(),
          isScrollControlled: true,
        );
        if (result == true) {
          authenticated = true;
        }
      }

      // If user is authenticated, disable the app lock
      if (authenticated) {
        await _hiveService.setAppLock(false);
        appLock.value = false;
      }
    }
  }

  void changePin() async {
    final appColors = AppTheme.colorsOf(Get.context!);
    bool authenticated = false;

    // Try biometric auth first if available
    if (await _appLockService.isBiometricAvailable()) {
      authenticated = await _appLockService.authenticate();
    }

    // If biometric auth failed or is not available, fall back to PIN verification
    if (!authenticated) {
      final result = await Get.bottomSheet(
        const VerifyPinBottomSheet(),
        isScrollControlled: true,
      );
      if (result == true) {
        authenticated = true;
      }
    }

    // If user is authenticated (by either method), show the set pin sheet
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

  // --- Backup and Restore ---
  Future<void> backup() async {
    await _hiveService.backupData();
  }

  // Helper function to launch URLs in the default browser or custom tab
  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
    } else {
      // Log the error to the console.
      print('Could not launch $url');
    }
  }

  Future<void> restore() async {
    // A confirmation dialog before starting the restore process.
    await showCupertinoDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(AppConstants.confirmRestoreTitle),
        content: const Text(AppConstants.confirmRestoreMessage),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text(AppConstants.cancel),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text(AppConstants.restoreButton),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog before starting restore
              final bool success = await _hiveService.restoreData();

              if (success) {
                _loadSettings();
                changeTheme(theme.value);

                // FIX: Reset the HomeController to force a complete reload of journal data
                // and re-attachment of database listeners. This is more robust than
                // simply calling a refresh method.
                if (Get.isRegistered<HomeController>()) {
                  Get.delete<HomeController>(force: true);
                }
                // Re-initialize the HomeController. Its onInit method will handle loading the new data.
                Get.put(HomeController());
              }
            },
          )
        ],
      ),
    );
  }
}
