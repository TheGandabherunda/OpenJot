import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/app_lock_service.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/notification_service.dart';
import '../../core/theme.dart';
import '../../utils/custom_toast.dart';
import '../app_lock/set_pin_bottomsheet.dart';
import '../app_lock/verify_pin_bottomsheet.dart';

class SettingsScreenController extends GetxController {
  final _hiveService = Get.find<HiveService>();
  final _appLockService = Get.find<AppLockService>();
  final _notificationService = Get.find<NotificationService>();

  var dailyReminder = false.obs;
  var onThisDay = false.obs;
  var excludedOnThisDayEntries = <String>[].obs; // NEW
  var reminderTime = Rx<TimeOfDay?>(null);
  var theme = AppConstants.themeSystem.obs;
  var appLock = false.obs;
  var autoDeleteDraftsDays = 7.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    dailyReminder.value = _hiveService.dailyReminder;
    onThisDay.value = _hiveService.onThisDay;
    excludedOnThisDayEntries.value = _hiveService.excludedOnThisDayEntries; // NEW
    autoDeleteDraftsDays.value = _hiveService.autoDeleteDraftsDays;
    reminderTime.value = _hiveService.reminderTime;
    theme.value = _hiveService.theme;
    appLock.value = _hiveService.appLockEnabled;
  }

  Future<bool> checkAndRequestNotificationPermissions() async {
    final appColors = AppTheme.colorsOf(Get.context!);
    final bool permissionsGranted = await _notificationService.requestPermissions();
    if (!permissionsGranted) {
      CustomToast.showToast(
        AppConstants.notificationPermissionRequired,
        backgroundColor: appColors.grey10,
        textColor: appColors.grey8,
      );
    }
    return permissionsGranted;
  }

  void turnOnDailyReminder(TimeOfDay time) {
    dailyReminder.value = true;
    _hiveService.setDailyReminder(true);
    setReminderTime(time);
  }

  void turnOffDailyReminder() {
    final appColors = AppTheme.colorsOf(Get.context!);
    dailyReminder.value = false;
    _hiveService.setDailyReminder(false);
    _notificationService.cancelAllNotifications();
    CustomToast.showToast(
      AppConstants.notificationCanceled,
      backgroundColor: appColors.grey10,
      textColor: appColors.grey8,
    );
  }

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
        CustomToast.showToast(
          AppConstants.onThisDayOn,
          backgroundColor: appColors.grey10,
          textColor: appColors.grey8,
        );
      } else {
        onThisDay.value = false;
        CustomToast.showToast(
          AppConstants.notificationPermissionRequired,
          backgroundColor: appColors.grey10,
          textColor: appColors.grey8,
        );
      }
    } else {
      onThisDay.value = false;
      _hiveService.setOnThisDay(false);
      _notificationService.cancelAllNotifications();
      CustomToast.showToast(
        AppConstants.onThisDayOff,
        backgroundColor: appColors.grey10,
        textColor: appColors.grey8,
      );
    }
  }

  // --- NEW: Logic to save Excluded Entries ---
  void updateExcludedEntries(List<String> ids) {
    final appColors = AppTheme.colorsOf(Get.context!);
    excludedOnThisDayEntries.value = ids;
    _hiveService.setExcludedOnThisDayEntries(ids);

    // Reschedule so new exclusions take effect immediately
    if (onThisDay.value) {
      _notificationService.checkForOnThisDayMemories();
    }

    CustomToast.showToast(
      AppConstants.saveExclusions,
      backgroundColor: appColors.grey10,
      textColor: appColors.grey8,
    );
  }

  void setAutoDeleteDrafts(int days) {
    final appColors = AppTheme.colorsOf(Get.context!);
    autoDeleteDraftsDays.value = days;
    _hiveService.setAutoDeleteDraftsDays(days);

    String message = days == -1
        ? "Drafts will never be deleted"
        : "Drafts will be deleted after $days days";

    CustomToast.showToast(
      message,
      backgroundColor: appColors.grey10,
      textColor: appColors.grey8,
    );

    // Reload entries so any already expired drafts are cleaned up immediately
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadJournalEntries();
    }
  }

  void setReminderTime(TimeOfDay time) {
    final appColors = AppTheme.colorsOf(Get.context!);
    final timeFormat = time.format(Get.context!);
    final isReschedule = reminderTime.value != null;

    reminderTime.value = time;
    _hiveService.setReminderTime(time);

    if (dailyReminder.value) {
      _notificationService.scheduleDailyJournalReminder(time);
      CustomToast.showToast(
        (isReschedule
            ? AppConstants.notificationRescheduled
            : AppConstants.notificationScheduled)
            .replaceFirst('%s', timeFormat),
        backgroundColor: appColors.grey10,
        textColor: appColors.grey8,
      );
    }
  }

  void changeTheme(String themeValue) {
    final appColors = AppTheme.colorsOf(Get.context!);
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

    CustomToast.showToast(
      AppConstants.themeChanged.replaceFirst('%s', themeValue),
      backgroundColor: appColors.grey10,
      textColor: appColors.grey8,
    );
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
        CustomToast.showToast(
          AppConstants.pinChangedSuccess,
          backgroundColor: appColors.grey10,
          textColor: appColors.grey8,
        );
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