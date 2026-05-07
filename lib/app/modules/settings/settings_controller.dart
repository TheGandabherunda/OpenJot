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

  var onThisDay = false.obs;
  var excludedOnThisDayEntries = <String>[].obs; // NEW
  var reminderTimes = <TimeOfDay>[].obs;
  var theme = AppConstants.themeSystem.obs;
  var pitchBlack = false.obs;
  var appLock = false.obs;
  var autoDeleteDraftsDays = 7.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    onThisDay.value = _hiveService.onThisDay;
    excludedOnThisDayEntries.value = _hiveService.excludedOnThisDayEntries; // NEW
    autoDeleteDraftsDays.value = _hiveService.autoDeleteDraftsDays;
    reminderTimes.value = _hiveService.reminderTimes;
    theme.value = _hiveService.theme;
    pitchBlack.value = _hiveService.pitchBlack;
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

  void addReminder(TimeOfDay time) {
    if (!reminderTimes.any((t) => t.hour == time.hour && t.minute == time.minute)) {
      reminderTimes.add(time);
      _updateReminders();
    }
  }

  void removeReminder(int index) {
    if (index >= 0 && index < reminderTimes.length) {
      reminderTimes.removeAt(index);
      _updateReminders();
    }
  }

  void _updateReminders() {
    _hiveService.setReminderTimes(reminderTimes);
    _notificationService.scheduleMultipleReminders(reminderTimes);
  }

  void toggleOnThisDay(bool value) async {
    final appColors = AppTheme.colorsOf(Get.context!);
    if (value) {
      final bool permissionsGranted =
      await _notificationService.requestPermissions();
      if (permissionsGranted) {
        onThisDay.value = true;
        _hiveService.setOnThisDay(true);
        // Use force: true so toggling the switch always triggers a fresh check
        _notificationService.checkForOnThisDayMemories(force: true);
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
      _notificationService.cancelOnThisDayNotification();
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
      _notificationService.checkForOnThisDayMemories(force: true);
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

  void togglePitchBlack(bool value) {
    pitchBlack.value = value;
    _hiveService.setPitchBlack(value);
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