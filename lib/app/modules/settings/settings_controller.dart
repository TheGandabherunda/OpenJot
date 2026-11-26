import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/app_lock_service.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/services/daily_you_migration_service.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

import '../../core/services/notification_service.dart';
import '../../core/theme.dart';
import '../../utils/custom_toast.dart';
import '../app_lock/master_password_bottomsheet.dart';
import '../app_lock/set_pin_bottomsheet.dart';
import '../app_lock/verify_pin_bottomsheet.dart';

class SettingsScreenController extends GetxController {
  final _hiveService = Get.find<HiveService>();
  final _appLockService = Get.find<AppLockService>();
  final _notificationService = Get.find<NotificationService>();
  final _migrationService = Get.put(DailyYouMigrationService());

  var onThisDay = false.obs;
  var excludedOnThisDayEntries = <String>[].obs;
  var reminderTimes = <TimeOfDay>[].obs;
  var theme = AppConstants.themeSystem.obs;
  var pitchBlack = false.obs;
  var appLock = false.obs;
  var dbEncryption = false.obs;
  var biometricUnlock = false.obs;
  var canUseBiometrics = false.obs;
  var autoDeleteDraftsDays = 7.obs;
  var hideHomeStats = false.obs;
  var hideInsightsStats = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _refreshBiometricAvailability();
  }

  Future<void> _refreshBiometricAvailability() async {
    canUseBiometrics.value = await _appLockService.isBiometricAvailable();
  }

  void _loadSettings() {
    onThisDay.value = _hiveService.onThisDay;
    excludedOnThisDayEntries.value = _hiveService.excludedOnThisDayEntries;
    autoDeleteDraftsDays.value = _hiveService.autoDeleteDraftsDays;
    reminderTimes.value = _hiveService.reminderTimes;
    theme.value = _hiveService.theme;
    pitchBlack.value = _hiveService.pitchBlack;
    appLock.value = _hiveService.appLockEnabled;
    dbEncryption.value = _hiveService.dbEncryptionEnabled;
    biometricUnlock.value = _hiveService.encryptionBiometricEnabled;
    hideHomeStats.value = _hiveService.hideHomeStats;
    hideInsightsStats.value = _hiveService.hideInsightsStats;
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

  void updateExcludedEntries(List<String> ids) {
    final appColors = AppTheme.colorsOf(Get.context!);
    excludedOnThisDayEntries.value = ids;
    _hiveService.setExcludedOnThisDayEntries(ids);

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

  void toggleHideHomeStats(bool value) {
    hideHomeStats.value = value;
    _hiveService.setHideHomeStats(value);
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadSettings();
    }
  }

  void toggleHideInsightsStats(bool value) {
    hideInsightsStats.value = value;
    _hiveService.setHideInsightsStats(value);
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadSettings();
    }
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

  Future<T?> _showBottomSheetWithKeyboardPush<T>(Widget child) {
    return showModalBottomSheet<T>(
      context: Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => child,
    );
  }

  Future<void> toggleDatabaseEncryption(bool enable) async {
    final appColors = AppTheme.colorsOf(Get.context!);
    final result = await _showBottomSheetWithKeyboardPush<bool>(
      MasterPasswordBottomSheet(
        mode: enable
            ? MasterPasswordSheetMode.enableEncryption
            : MasterPasswordSheetMode.disableEncryption,
        canUseBiometrics: canUseBiometrics.value,
      ),
    );

    if (result == true) {
      _loadSettings();
      CustomToast.showToast(
        enable
            ? AppConstants.databaseEncryptedSuccess
            : AppConstants.databaseDecryptedSuccess,
        backgroundColor: appColors.grey10,
        textColor: appColors.grey8,
      );
    }
  }

  Future<void> changeMasterPassword() async {
    final appColors = AppTheme.colorsOf(Get.context!);
    final result = await _showBottomSheetWithKeyboardPush<bool>(
      const MasterPasswordBottomSheet(
        mode: MasterPasswordSheetMode.changePassword,
      ),
    );

    if (result == true) {
      CustomToast.showToast(
        AppConstants.masterPasswordChangedSuccess,
        backgroundColor: appColors.grey10,
        textColor: appColors.grey8,
      );
    }
  }

  Future<void> toggleBiometricUnlock(bool enable) async {
    if (!enable) {
      await _appLockService.setBiometricUnlockForEncryptedDb(enabled: false);
      biometricUnlock.value = false;
      return;
    }

    final result = await _showBottomSheetWithKeyboardPush<bool>(
      const MasterPasswordBottomSheet(
        mode: MasterPasswordSheetMode.verifyForBiometrics,
      ),
    );
    if (result == true) {
      biometricUnlock.value = true;
    }
  }

  Future<void> backup() async {
    final option = await _showBottomSheetWithKeyboardPush<BackupExportOption>(
      const BackupOptionsBottomSheet(),
    );
    if (option == null) return;

    String? backupPassword;
    if (option == BackupExportOption.encrypted) {
      backupPassword = await _showBottomSheetWithKeyboardPush<String>(
        const MasterPasswordBottomSheet(
          mode: MasterPasswordSheetMode.createBackupPassword,
        ),
      );
      if (backupPassword == null || backupPassword.isEmpty) return;
    }

    final statusText = AppConstants.takingBackup.obs;
    final appColors = AppTheme.colorsOf(Get.context!);
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    final dialogBg = pitchBlack.value
        ? (isDark ? Colors.black : Colors.white)
        : appColors.grey6;

    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              decoration: BoxDecoration(
                color: dialogBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoActivityIndicator(
                      radius: 15,
                      color: appColors.primary,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      statusText.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppConstants.font,
                        color: appColors.grey10,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      await _hiveService.backupData(
        encryptionPassword: backupPassword,
        onStatusUpdate: (s) => statusText.value = s,
      );
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
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
              final bool success = await _hiveService.restoreData(
                onRequestBackupPassword: () async {
                  return _showBottomSheetWithKeyboardPush<String>(
                    const MasterPasswordBottomSheet(
                      mode: MasterPasswordSheetMode.enterBackupPassword,
                    ),
                  );
                },
              );

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

  Future<void> importFromDailyYou() async {
    final appColors = AppTheme.colorsOf(Get.context!);
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        dialogTitle: AppConstants.selectDailyYouBackup,
      );

      if (file == null) return;

      String zipPath;
      if (file.path != null) {
        zipPath = file.path!;
      } else {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File(p.join(tempDir.path, file.name.isNotEmpty ? file.name : 'daily_you_backup.zip'));
        await tempFile.writeAsBytes(await file.readAsBytes());
        zipPath = tempFile.path;
      }

      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final importedCount = await _migrationService.importFromDailyYou(
        zipPath,
        onStatusUpdate: (status) {
          debugPrint("Migration status: $status");
        },
      );

      Get.back(); // Close loading dialog

      if (importedCount > 0) {
        CustomToast.showToast(
          AppConstants.importSuccess.replaceFirst('%d', importedCount.toString()),
          backgroundColor: appColors.grey10,
          textColor: appColors.grey8,
        );
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().loadJournalEntries();
        }
      } else {
        CustomToast.showToast(
          AppConstants.noEntriesToImport,
          backgroundColor: appColors.grey10,
          textColor: appColors.grey8,
        );
      }
    } catch (e) {
      if (Get.isOverlaysOpen) Get.back();
      CustomToast.showToast(
        AppConstants.importFailed.replaceFirst('%s', e.toString()),
        backgroundColor: appColors.grey10,
        textColor: appColors.grey8,
      );
    }
  }
}
