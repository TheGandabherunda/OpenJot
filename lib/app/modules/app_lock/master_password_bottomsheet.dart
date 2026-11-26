import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/app_lock_service.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/widgets/custom_button.dart';
import 'package:smooth_corner/smooth_corner.dart';

enum MasterPasswordSheetMode {
  enableEncryption,
  changePassword,
  disableEncryption,
  verifyForBiometrics,
  createBackupPassword,
  enterBackupPassword,
}

class MasterPasswordBottomSheet extends StatefulWidget {
  final MasterPasswordSheetMode mode;
  final bool canUseBiometrics;
  final String? initialError;

  const MasterPasswordBottomSheet({
    super.key,
    required this.mode,
    this.canUseBiometrics = false,
    this.initialError,
  });

  @override
  State<MasterPasswordBottomSheet> createState() =>
      _MasterPasswordBottomSheetState();
}

class _MasterPasswordBottomSheetState extends State<MasterPasswordBottomSheet> {
  final _appLockService = Get.find<AppLockService>();
  final _hiveService = Get.find<HiveService>();
  final _currentCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _enableBiometrics = false;
  bool _isBusy = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _errorText = widget.initialError;
    _enableBiometrics = widget.canUseBiometrics;
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool get _needsCurrentField =>
      widget.mode == MasterPasswordSheetMode.changePassword;

  bool get _needsConfirmField =>
      widget.mode == MasterPasswordSheetMode.enableEncryption ||
      widget.mode == MasterPasswordSheetMode.changePassword ||
      widget.mode == MasterPasswordSheetMode.createBackupPassword;

  bool get _showBiometricsRow =>
      widget.mode == MasterPasswordSheetMode.enableEncryption &&
      widget.canUseBiometrics;

  String get _title {
    switch (widget.mode) {
      case MasterPasswordSheetMode.enableEncryption:
        return 'Encrypt Database';
      case MasterPasswordSheetMode.changePassword:
        return AppConstants.changeMasterPassword;
      case MasterPasswordSheetMode.disableEncryption:
        return 'Disable Encryption';
      case MasterPasswordSheetMode.verifyForBiometrics:
        return AppConstants.biometricUnlock;
      case MasterPasswordSheetMode.createBackupPassword:
        return 'Backup Password';
      case MasterPasswordSheetMode.enterBackupPassword:
        return 'Encrypted Backup';
    }
  }

  String get _subtitle {
    switch (widget.mode) {
      case MasterPasswordSheetMode.enableEncryption:
        return 'Protect all journal notes locally with AES-256-GCM encryption. If you forget your master password, your encrypted data cannot be recovered.';
      case MasterPasswordSheetMode.changePassword:
        return 'Enter your current master password and choose a new password (minimum 6 characters).';
      case MasterPasswordSheetMode.disableEncryption:
        return 'Enter your master password to decrypt your database on disk and turn off encryption.';
      case MasterPasswordSheetMode.verifyForBiometrics:
        return 'Enter your master password once to store an unlock key in secure hardware storage for biometric quick-unlock.';
      case MasterPasswordSheetMode.createBackupPassword:
        return 'Set a strong password to encrypt this .openjot backup. You will need this password to restore it on any device.';
      case MasterPasswordSheetMode.enterBackupPassword:
        return 'Enter the password used when this .openjot backup was created.';
    }
  }

  String get _primaryButtonText {
    switch (widget.mode) {
      case MasterPasswordSheetMode.enableEncryption:
        return 'Encrypt Database';
      case MasterPasswordSheetMode.changePassword:
        return 'Update Password';
      case MasterPasswordSheetMode.disableEncryption:
        return 'Decrypt & Disable';
      case MasterPasswordSheetMode.verifyForBiometrics:
        return 'Enable Biometrics';
      case MasterPasswordSheetMode.createBackupPassword:
        return 'Create Backup';
      case MasterPasswordSheetMode.enterBackupPassword:
        return 'Decrypt Backup';
    }
  }

  String get _passwordHint {
    switch (widget.mode) {
      case MasterPasswordSheetMode.changePassword:
        return 'New master password';
      case MasterPasswordSheetMode.createBackupPassword:
      case MasterPasswordSheetMode.enterBackupPassword:
        return 'Backup password';
      default:
        return 'Master password';
    }
  }

  Future<void> _submit() async {
    if (_isBusy) return;
    final currentPw = _currentCtrl.text;
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    if (_needsCurrentField && currentPw.isEmpty) {
      setState(() => _errorText = 'Please enter your current master password.');
      return;
    }

    if (password.isEmpty) {
      setState(() => _errorText = 'Password cannot be empty.');
      return;
    }

    if (_needsConfirmField) {
      if (password.length < 6) {
        setState(
          () => _errorText = 'Password must be at least 6 characters long.',
        );
        return;
      }
      if (password != confirm) {
        setState(() => _errorText = 'Passwords do not match.');
        return;
      }
    }

    if (widget.mode == MasterPasswordSheetMode.createBackupPassword ||
        widget.mode == MasterPasswordSheetMode.enterBackupPassword) {
      Navigator.of(context).pop(password);
      return;
    }

    setState(() {
      _isBusy = true;
      _errorText = null;
    });

    try {
      switch (widget.mode) {
        case MasterPasswordSheetMode.enableEncryption:
          await _appLockService.enableDatabaseEncryption(
            masterPassword: password,
            enableBiometrics: widget.canUseBiometrics && _enableBiometrics,
          );
          if (mounted) Navigator.of(context).pop(true);
          break;

        case MasterPasswordSheetMode.changePassword:
          final changed = await _appLockService.changeMasterPassword(
            currentPassword: currentPw,
            newPassword: password,
          );
          if (!mounted) return;
          if (changed) {
            Navigator.of(context).pop(true);
          } else {
            setState(() {
              _isBusy = false;
              _errorText = AppConstants.incorrectMasterPassword;
            });
          }
          break;

        case MasterPasswordSheetMode.disableEncryption:
          final disabled =
              await _appLockService.disableDatabaseEncryption(password);
          if (!mounted) return;
          if (disabled) {
            Navigator.of(context).pop(true);
          } else {
            setState(() {
              _isBusy = false;
              _errorText = AppConstants.incorrectMasterPassword;
            });
          }
          break;

        case MasterPasswordSheetMode.verifyForBiometrics:
          final ok = await _appLockService.setBiometricUnlockForEncryptedDb(
            enabled: true,
            masterPassword: password,
          );
          if (!mounted) return;
          if (ok) {
            Navigator.of(context).pop(true);
          } else {
            setState(() {
              _isBusy = false;
              _errorText = AppConstants.incorrectMasterPassword;
            });
          }
          break;

        case MasterPasswordSheetMode.createBackupPassword:
        case MasterPasswordSheetMode.enterBackupPassword:
          break;
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isBusy = false;
        _errorText = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = _hiveService.pitchBlack;

    final sheetBg = isPitchBlack
        ? (isDark ? Colors.black : Colors.white)
        : appColors.grey6;
    final segmentBg = isPitchBlack
        ? (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05))
        : appColors.grey5;

    final isDestructive =
        widget.mode == MasterPasswordSheetMode.disableEncryption;
    final buttonBg = isDestructive ? appColors.error : appColors.primary;
    final buttonFg =
        isDestructive ? Colors.white : appColors.onPrimary;

    final gap = 3.w;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.r),
              topRight: Radius.circular(32.r),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: _isBusy
                                ? null
                                : () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.close_rounded,
                              color: appColors.grey10,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48.w),
                          child: Text(
                            _title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppConstants.font,
                              color: appColors.grey10,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      _subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppConstants.font,
                        color: appColors.grey2,
                        fontSize: 13.5.sp,
                        height: 1.35,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  if (_needsCurrentField) ...[
                    SegmentedPasswordInput(
                      controller: _currentCtrl,
                      hint: 'Current master password',
                      obscure: _obscureCurrent,
                      onToggleObscure: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                      segmentBg: segmentBg,
                      enabled: !_isBusy,
                      textInputAction: TextInputAction.next,
                      onChanged: () {
                        if (_errorText != null) {
                          setState(() => _errorText = null);
                        }
                      },
                    ),
                    SizedBox(height: gap),
                  ],
                  SegmentedPasswordInput(
                    controller: _passwordCtrl,
                    hint: _passwordHint,
                    obscure: _obscurePassword,
                    onToggleObscure: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    segmentBg: segmentBg,
                    enabled: !_isBusy,
                    autofocus: true,
                    textInputAction: _needsConfirmField
                        ? TextInputAction.next
                        : TextInputAction.done,
                    onSubmitted: _needsConfirmField ? null : (_) => _submit(),
                    onChanged: () {
                      if (_errorText != null) {
                        setState(() => _errorText = null);
                      }
                    },
                  ),
                  if (_needsConfirmField) ...[
                    SizedBox(height: gap),
                    SegmentedPasswordInput(
                      controller: _confirmCtrl,
                      hint: 'Confirm password',
                      obscure: _obscureConfirm,
                      onToggleObscure: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      segmentBg: segmentBg,
                      enabled: !_isBusy,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      onChanged: () {
                        if (_errorText != null) {
                          setState(() => _errorText = null);
                        }
                      },
                    ),
                  ],
                  if (_showBiometricsRow) ...[
                    SizedBox(height: 12.h),
                    Container(
                      decoration: BoxDecoration(
                        color: segmentBg,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 6.h,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.fingerprint_rounded,
                            color: appColors.grey10,
                            size: 20,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              AppConstants.biometricUnlock,
                              style: TextStyle(
                                fontFamily: AppConstants.font,
                                color: appColors.grey10,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          Switch(
                            value: _enableBiometrics,
                            activeColor: appColors.primary,
                            onChanged: _isBusy
                                ? null
                                : (v) =>
                                    setState(() => _enableBiometrics = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_errorText != null) ...[
                    SizedBox(height: 10.h),
                    Text(
                      _errorText!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppConstants.font,
                        color: appColors.error,
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: _isBusy
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.sp,
                              vertical: 14.sp,
                            ),
                            decoration: ShapeDecoration(
                              color: buttonBg,
                              shape: SmoothRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  CustomButton.defaultBorderRadius,
                                ),
                                smoothness: 1,
                              ),
                            ),
                            child: Center(
                              child: CupertinoActivityIndicator(
                                radius: 10,
                                color: buttonFg,
                              ),
                            ),
                          )
                        : CustomButton(
                            onPressed: _submit,
                            text: _primaryButtonText,
                            color: buttonBg,
                            textColor: buttonFg,
                            expandWidth: true,
                            textPadding: EdgeInsets.symmetric(
                              horizontal: 24.sp,
                              vertical: 14.sp,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Two-segment pill password input with an adjacent visibility toggle button,
/// circular at both outer ends and separated by a compact inner seam.
class SegmentedPasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final Color segmentBg;
  final bool enabled;
  final bool autofocus;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onChanged;

  const SegmentedPasswordInput({
    super.key,
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggleObscure,
    required this.segmentBg,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final outerRadius = Radius.circular(26.r);
    final innerRadius = Radius.circular(8.r);

    final inputRadius = BorderRadius.horizontal(
      left: outerRadius,
      right: innerRadius,
    );

    final buttonRadius = BorderRadius.horizontal(
      left: innerRadius,
      right: outerRadius,
    );

    return SizedBox(
      height: 52.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: segmentBg,
                borderRadius: inputRadius,
              ),
              child: TextField(
                controller: controller,
                obscureText: obscure,
                autofocus: autofocus,
                enabled: enabled,
                textInputAction: textInputAction,
                onSubmitted: onSubmitted,
                onChanged: (_) => onChanged?.call(),
                style: TextStyle(
                  fontFamily: AppConstants.font,
                  color: appColors.grey10,
                  fontSize: 15.5.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                ),
                cursorColor: appColors.primary,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontFamily: AppConstants.font,
                    color: appColors.grey2,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: false,
                  isDense: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggleObscure,
              borderRadius: buttonRadius,
              child: Ink(
                width: 54.w,
                decoration: BoxDecoration(
                  color: segmentBg,
                  borderRadius: buttonRadius,
                ),
                child: Icon(
                  obscure
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: appColors.grey10,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum BackupExportOption { encrypted, standard }

class BackupOptionsBottomSheet extends StatelessWidget {
  const BackupOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colorsOf(context);
    final hiveService = Get.find<HiveService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPitchBlack = hiveService.pitchBlack;

    final sheetBg = isPitchBlack
        ? (isDark ? Colors.black : Colors.white)
        : appColors.grey6;
    final tileBg = isPitchBlack
        ? (isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03))
        : appColors.grey5;

    final outerRadius = Radius.circular(24.r);
    final innerRadius = Radius.circular(8.r);

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: kToolbarHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: appColors.grey10,
                        ),
                      ),
                    ),
                    Text(
                      AppConstants.backup,
                      style: TextStyle(
                        fontFamily: AppConstants.font,
                        color: appColors.grey10,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              _buildOptionRow(
                appColors: appColors,
                tileBg: tileBg,
                icon: Icons.enhanced_encryption_rounded,
                title: AppConstants.encryptedBackup,
                subtitle: AppConstants.encryptedBackupDesc,
                borderRadius: BorderRadius.only(
                  topLeft: outerRadius,
                  topRight: outerRadius,
                  bottomLeft: innerRadius,
                  bottomRight: innerRadius,
                ),
                onTap: () =>
                    Navigator.of(context).pop(BackupExportOption.encrypted),
              ),
              SizedBox(height: 3.w),
              _buildOptionRow(
                appColors: appColors,
                tileBg: tileBg,
                icon: Icons.folder_zip_rounded,
                title: AppConstants.standardBackup,
                subtitle: AppConstants.standardBackupDesc,
                borderRadius: BorderRadius.only(
                  topLeft: innerRadius,
                  topRight: innerRadius,
                  bottomLeft: outerRadius,
                  bottomRight: outerRadius,
                ),
                onTap: () =>
                    Navigator.of(context).pop(BackupExportOption.standard),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required AppThemeColors appColors,
    required Color tileBg,
    required IconData icon,
    required String title,
    required String subtitle,
    required BorderRadius borderRadius,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: tileBg,
            borderRadius: borderRadius,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
            leading: Icon(icon, color: appColors.grey10),
            title: Text(
              title,
              style: TextStyle(
                fontFamily: AppConstants.font,
                color: appColors.grey10,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontFamily: AppConstants.font,
                color: appColors.grey2,
                fontSize: 12.5.sp,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ),
        ),
      ),
    );
  }
}
