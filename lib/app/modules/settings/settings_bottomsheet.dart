import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/translations/app_translations.dart';
import 'package:open_jot/app/modules/settings/about_screen.dart';
import 'package:open_jot/app/modules/settings/language_bottomsheet.dart';
import 'package:open_jot/app/modules/settings/settings_controller.dart';
import 'package:open_jot/app/modules/settings/terms_and_conditions_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/theme.dart';
import '../../core/widgets/app_alert_dialog.dart';
import '../../utils/mood_helper.dart';
import 'mood_colors_bottomsheet.dart';
import 'reminders_bottomsheet.dart';
import 'exclude_entries_bottomsheet.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({super.key});

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  final SettingsScreenController controller = Get.put(SettingsScreenController());
  String _appVersion = AppConstants.loading.tr;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  void _showThemeSelectionBottomSheet() {
    final appThemeColors = AppTheme.colorsOf(context);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: appThemeColors.grey5,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              AppConstants.changeTheme.tr,
              style: TextStyle(
                fontSize: 16.sp,
                letterSpacing: -0.2,
                color: appThemeColors.grey10,
                fontWeight: FontWeight.bold,
                fontFamily: AppConstants.font,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: ListTile(
                title: Text(AppConstants.themeLight.tr,
                    style: TextStyle(
                        letterSpacing: -0.2,
                        color: appThemeColors.grey10,
                        fontFamily: AppConstants.font)),
                onTap: () {
                  controller.changeTheme(AppConstants.themeLight);
                  Get.back();
                },
                trailing: Obx(() =>
                controller.theme.value == AppConstants.themeLight
                    ? Icon(Icons.check_rounded, color: appThemeColors.primary)
                    : const SizedBox.shrink()),
              ),
            ),
            Divider(color: appThemeColors.grey4, height: 1),
            Material(
              color: Colors.transparent,
              child: ListTile(
                title: Text(AppConstants.themeDark.tr,
                    style: TextStyle(
                        letterSpacing: -0.2,
                        color: appThemeColors.grey10,
                        fontFamily: AppConstants.font)),
                onTap: () {
                  controller.changeTheme(AppConstants.themeDark);
                  Get.back();
                },
                trailing: Obx(() =>
                controller.theme.value == AppConstants.themeDark
                    ? Icon(Icons.check_rounded, color: appThemeColors.primary)
                    : const SizedBox.shrink()),
              ),
            ),
            Divider(color: appThemeColors.grey4, height: 1),
            Material(
              color: Colors.transparent,
              child: ListTile(
                title: Text(AppConstants.themeSystem.tr,
                    style: TextStyle(
                        letterSpacing: -0.2,
                        color: appThemeColors.grey10,
                        fontFamily: AppConstants.font)),
                onTap: () {
                  controller.changeTheme(AppConstants.themeSystem);
                  Get.back();
                },
                trailing: Obx(() =>
                controller.theme.value == AppConstants.themeSystem
                    ? Icon(Icons.check_rounded, color: appThemeColors.primary)
                    : const SizedBox.shrink()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAutoDeleteOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(AppConstants.autoDeleteDrafts.tr,
            style: const TextStyle(fontFamily: AppConstants.font)),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text(AppConstants.days7.tr,
                style: const TextStyle(fontFamily: AppConstants.font)),
            onPressed: () {
              controller.setAutoDeleteDrafts(7);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(AppConstants.never.tr,
                style: const TextStyle(fontFamily: AppConstants.font)),
            onPressed: () {
              controller.setAutoDeleteDrafts(-1);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(AppConstants.custom.tr,
                style: const TextStyle(fontFamily: AppConstants.font)),
            onPressed: () {
              Navigator.pop(context);
              _showCustomDaysDialog();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppConstants.cancel.tr,
              style: const TextStyle(fontFamily: AppConstants.font)),
        ),
      ),
    );
  }

  void _showCustomDaysDialog() {
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = controller.pitchBlack.value;
    final fieldBg = isPitchBlack
        ? (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05))
        : appThemeColors.grey5;
    final textController = TextEditingController();

    showAppAlertDialog<void>(
      context: context,
      title: AppConstants.enterCustomDays.tr,
      content: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fieldBg,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: TextField(
          controller: textController,
          autofocus: true,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            final val = int.tryParse(textController.text.trim());
            if (val != null && val > 0) {
              controller.setAutoDeleteDrafts(val);
            }
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: TextStyle(
            color: appThemeColors.grey10,
            fontFamily: AppConstants.font,
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: appThemeColors.primary,
          decoration: InputDecoration(
            hintText: AppConstants.customDaysExample.tr,
            hintStyle: TextStyle(
              color: appThemeColors.grey2,
              fontFamily: AppConstants.font,
              fontSize: 15.sp,
            ),
            filled: false,
            isDense: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
          ),
        ),
      ),
      actionsBuilder: (dialogContext) => [
        AppAlertAction(
          label: AppConstants.cancel.tr,
          onPressed: () => Navigator.pop(dialogContext),
        ),
        AppAlertAction(
          label: AppConstants.save.tr,
          isDefault: true,
          onPressed: () {
            final val = int.tryParse(textController.text.trim());
            if (val != null && val > 0) {
              controller.setAutoDeleteDrafts(val);
            }
            Navigator.pop(dialogContext);
          },
        ),
      ],
    );
  }

  void _showHideStatsOptions() {
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = controller.pitchBlack.value;

    final tileBackgroundColor = isPitchBlack
        ? (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.04))
        : appThemeColors.grey5;

    showAppAlertDialog<void>(
      context: context,
      title: AppConstants.hideStats.tr,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          color: tileBackgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => _buildDialogTile(
                  label: AppConstants.hideHomeStats.tr,
                  value: controller.hideHomeStats.value,
                  onChanged: controller.toggleHideHomeStats,
                  appThemeColors: appThemeColors,
                  backgroundColor: tileBackgroundColor,
                  showDivider: true,
                ),
              ),
              Obx(
                () => _buildDialogTile(
                  label: AppConstants.hideInsightsStats.tr,
                  value: controller.hideInsightsStats.value,
                  onChanged: controller.toggleHideInsightsStats,
                  appThemeColors: appThemeColors,
                  backgroundColor: tileBackgroundColor,
                  showDivider: false,
                ),
              ),
            ],
          ),
        ),
      ),
      actionsBuilder: (dialogContext) => [
        AppAlertAction(
          label: AppConstants.done.tr,
          isDefault: true,
          onPressed: () => Navigator.pop(dialogContext),
        ),
      ],
    );
  }

  Widget _buildDialogTile({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required dynamic appThemeColors,
    required Color backgroundColor,
    required bool showDivider,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: showDivider
            ? Border(
          bottom: BorderSide(
              color: appThemeColors.grey4.withOpacity(0.4), width: 1.w),
        )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppConstants.font,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: appThemeColors.grey10,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: appThemeColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showImportOptionsBottomSheet() {
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = controller.pitchBlack.value;

    final sheetBackgroundColor = isPitchBlack
        ? (isDark ? Colors.black : Colors.white)
        : appThemeColors.grey6;

    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      expand: true,
      builder: (context) => SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: sheetBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: appThemeColors.grey10,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              AppConstants.importFromAnotherApp.tr,
              style: TextStyle(
                color: appThemeColors.grey10,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Column(
              children: <Widget>[
                GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildImportGridItem(
                    title: "Daily You",
                    icon: Icons.folder_zip_rounded,
                    onTap: () {
                      Navigator.pop(context);
                      controller.importFromDailyYou();
                    },
                  ),
                  _buildImportGridItem(
                    title: AppConstants.askSupport.tr,
                    icon: Icons.contact_support_rounded,
                    onTap: () {
                      Navigator.pop(context);
                      controller.launchURL(
                          'https://github.com/TheGandabherunda/OpenJot/discussions/15');
                    },
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        color: appThemeColors.primary.withOpacity(0.6),
                        size: 20.w),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        AppConstants.importSupportNote.tr,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: appThemeColors.grey10.withOpacity(0.7),
                          height: 1.4,
                          fontFamily: AppConstants.font,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildImportGridItem({
    required String title,
    String? iconPath,
    IconData? icon,
    String? format,
    VoidCallback? onTap,
    bool isPlaceholder = false,
  }) {
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = controller.pitchBlack.value;

    final itemBackgroundColor = isPitchBlack
        ? (isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.03))
        : appThemeColors.grey4.withOpacity(0.3);

    final iconContainerColor = isPitchBlack
        ? (isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.black.withOpacity(0.05))
        : (isPlaceholder ? appThemeColors.grey3 : appThemeColors.grey5);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: itemBackgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
              color: isPitchBlack
                  ? appThemeColors.grey4.withOpacity(0.2)
                  : appThemeColors.grey4,
              width: 1.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: iconContainerColor,
                    shape: BoxShape.circle,
                    boxShadow: isPitchBlack
                        ? null
                        : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: iconPath != null
                      ? Image.asset(iconPath, width: 32.w, height: 32.h)
                      : Icon(icon ?? Icons.help_outline,
                      color: appThemeColors.grey10, size: 32.w),
                ),
                if (format != null)
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: appThemeColors.primary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      format,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: appThemeColors.grey10,
                fontWeight: FontWeight.w500,
                fontFamily: AppConstants.font,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required dynamic appThemeColors,
    required Color backgroundColor,
    required Color textColor,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: showDivider
            ? Border(
          bottom: BorderSide(
              color: appThemeColors.grey4.withOpacity(0.4),
              width: 1.w),
        )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: textColor),
          title: Text(title,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                  fontFamily: AppConstants.font)),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    color: appThemeColors.grey2,
                    fontSize: 12.5.sp,
                    fontFamily: AppConstants.font,
                  ),
                )
              : null,
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isPitchBlack = controller.pitchBlack.value;

      final backgroundColor = isPitchBlack
          ? (isDark ? Colors.black : Colors.white)
          : appThemeColors.grey6;

      final tileBackgroundColor = isPitchBlack
          ? (isDark
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.03))
          : appThemeColors.grey5;

      final textColor = appThemeColors.grey10;

      return Material(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              AppConstants.settings.tr,
              style: TextStyle(
                color: appThemeColors.grey10,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: appThemeColors.grey10,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: ListView(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            children: [
              // General Settings Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.dailyReminder.tr,
                      icon: Icons.notifications_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.reminderTimes.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: appThemeColors.grey4,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  "${controller.reminderTimes.length}",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14.sp,
                                    letterSpacing: -0.4,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppConstants.font,
                                  ),
                                ),
                              ),
                            ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              size: 16, color: appThemeColors.grey2),
                        ],
                      ),
                      onTap: () async {
                        final hasPermission = await controller
                            .checkAndRequestNotificationPermissions();
                        if (hasPermission) {
                          showCupertinoModalBottomSheet(
                            context: context,
                            expand: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const SafeArea(
                              bottom: false,
                              child: RemindersBottomSheet(),
                            ),
                          );
                        }
                      },
                    ),
                    _buildListTile(
                      title: AppConstants.autoDeleteDrafts.tr,
                      icon: Icons.auto_delete_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: (() {
                        final days = controller.autoDeleteDraftsDays.value;
                        String display = days == -1
                            ? AppConstants.never.tr
                            : (days == 7
                            ? AppConstants.days7.tr
                            : "$days ${AppConstants.days.tr}");
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 110.w),
                              child: Text(
                                display,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: appThemeColors.grey2,
                                    fontSize: 14.sp,
                                    fontFamily: AppConstants.font),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Icons.arrow_forward_ios_rounded,
                                size: 16, color: appThemeColors.grey2),
                          ],
                        );
                      })(),
                      onTap: _showAutoDeleteOptions,
                    ),
                    _buildListTile(
                      title: AppConstants.databaseEncryption.tr,
                      subtitle: AppConstants.databaseEncryptionDesc.tr,
                      icon: Icons.enhanced_encryption_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      showDivider: true,
                      trailing: Switch(
                        value: controller.dbEncryption.value,
                        onChanged: controller.toggleDatabaseEncryption,
                        activeColor: appThemeColors.primary,
                      ),
                    ),
                    if (controller.dbEncryption.value) ...[
                      _buildListTile(
                        title: AppConstants.changeMasterPassword.tr,
                        icon: Icons.password_rounded,
                        appThemeColors: appThemeColors,
                        backgroundColor: tileBackgroundColor,
                        textColor: textColor,
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                        onTap: controller.changeMasterPassword,
                        showDivider: controller.canUseBiometrics.value,
                      ),
                      if (controller.canUseBiometrics.value)
                        _buildListTile(
                          title: AppConstants.biometricUnlock.tr,
                          icon: Icons.fingerprint_rounded,
                          appThemeColors: appThemeColors,
                          backgroundColor: tileBackgroundColor,
                          textColor: textColor,
                          showDivider: false,
                          trailing: Switch(
                            value: controller.biometricUnlock.value,
                            onChanged: controller.toggleBiometricUnlock,
                            activeColor: appThemeColors.primary,
                          ),
                        ),
                    ] else ...[
                      _buildListTile(
                        title: AppConstants.appLock.tr,
                        icon: Icons.lock_rounded,
                        appThemeColors: appThemeColors,
                        backgroundColor: tileBackgroundColor,
                        textColor: textColor,
                        showDivider: controller.appLock.value,
                        trailing: Switch(
                          value: controller.appLock.value,
                          onChanged: (bool value) {
                            controller.toggleAppLock(value);
                          },
                          activeColor: appThemeColors.primary,
                        ),
                      ),
                      if (controller.appLock.value)
                        _buildListTile(
                          title: AppConstants.changePin.tr,
                          icon: Icons.password_rounded,
                          appThemeColors: appThemeColors,
                          backgroundColor: tileBackgroundColor,
                          textColor: textColor,
                          onTap: controller.changePin,
                          showDivider: false,
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // On This Day Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.onThisDay.tr,
                      icon: Icons.history_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      showDivider: controller.onThisDay.value,
                      trailing: Switch(
                        value: controller.onThisDay.value,
                        onChanged: controller.toggleOnThisDay,
                        activeColor: appThemeColors.primary,
                      ),
                    ),
                    if (controller.onThisDay.value)
                      _buildListTile(
                        title: AppConstants.excludeEntries.tr,
                        icon: Icons.notifications_off_rounded,
                        appThemeColors: appThemeColors,
                        backgroundColor: tileBackgroundColor,
                        textColor: textColor,
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                        showDivider: false,
                        onTap: () {
                          showCupertinoModalBottomSheet(
                            context: context,
                            expand: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => SafeArea(
                              bottom: false,
                              child: ExcludeEntriesBottomSheet(
                                initialExcludedIds:
                                controller.excludedOnThisDayEntries,
                                onSave: (ids) {
                                  controller.updateExcludedEntries(ids);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // UI Customization Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.hideStats.tr,
                      icon: Icons.visibility_off_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      showDivider: false,
                      onTap: _showHideStatsOptions,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Theme Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.language.tr,
                      icon: Icons.language_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 140.w),
                            child: Text(
                              AppTranslations.displayNameForCode(
                                  controller.localeCode.value),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: appThemeColors.grey2,
                                fontSize: 14.sp,
                                fontFamily: AppConstants.font,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                        ],
                      ),
                      onTap: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          expand: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const SafeArea(
                            bottom: false,
                            child: LanguageBottomSheet(),
                          ),
                        );
                      },
                      showDivider: true,
                    ),
                    _buildListTile(
                      title: AppConstants.theme.tr,
                      icon: Icons.style_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      onTap: _showThemeSelectionBottomSheet,
                      showDivider: true,
                    ),
                    _buildListTile(
                      title: AppConstants.moodColors.tr,
                      icon: Icons.palette_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              MoodHelper.palettes.length,
                              (i) => Container(
                                margin: EdgeInsets.only(right: 3.w),
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: MoodHelper.getAccentColor(i),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                        ],
                      ),
                      onTap: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          expand: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const SafeArea(
                            bottom: false,
                            child: MoodColorsBottomSheet(),
                          ),
                        ).then((_) {
                          if (mounted) setState(() {});
                        });
                      },
                      showDivider: true,
                    ),
                    _buildListTile(
                      title: AppConstants.pitchBlack.tr,
                      icon: Icons.nightlight_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: Switch(
                        value: controller.pitchBlack.value,
                        onChanged: (bool value) {
                          controller.togglePitchBlack(value);
                        },
                        activeColor: appThemeColors.primary,
                      ),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Backup & Restore Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.backup.tr,
                      icon: Icons.cloud_upload_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      onTap: () => controller.backup(),
                    ),
                    _buildListTile(
                      title: AppConstants.restore.tr,
                      icon: Icons.cloud_download_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      onTap: () => controller.restore(),
                      showDivider: true,
                    ),
                    _buildListTile(
                      title: AppConstants.importFromAnotherApp.tr,
                      icon: Icons.download_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      onTap: _showImportOptionsBottomSheet,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // About Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppConstants.termsNConditions.tr,
                      icon: Icons.article_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      onTap: () =>
                          Get.to(() => const TermsAndConditionsScreen()),
                    ),
                    _buildListTile(
                      title: AppConstants.privacyPolicy.tr,
                      icon: Icons.policy_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                      onTap: () => controller.launchURL(
                          'https://thegandabherunda.github.io/OpenJot/privacy_policy'),
                    ),
                    _buildListTile(
                      title: AppConstants.about.tr,
                      icon: Icons.info_rounded,
                      appThemeColors: appThemeColors,
                      backgroundColor: tileBackgroundColor,
                      textColor: textColor,
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      onTap: () => Get.to(() => const AboutScreen()),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 48.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: Text(
                    'v • $_appVersion',
                    style: TextStyle(
                      letterSpacing: -0.4,
                      color: appThemeColors.grey3,
                      fontSize: 16,
                      fontFamily: AppConstants.font,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
