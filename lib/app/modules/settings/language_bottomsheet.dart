import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/translations/app_translations.dart';
import 'settings_controller.dart';

/// Searchable full-height modal sheet allowing users to switch OpenJot's
/// display language across all supported languages or follow System Default.
class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  final SettingsScreenController _controller = Get.find();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LanguageOption> get _filteredLanguages {
    if (_query.isEmpty) return AppTranslations.languages;
    final q = _query.toLowerCase();
    return AppTranslations.languages.where((lang) {
      return lang.nativeName.toLowerCase().contains(q) ||
          lang.englishName.toLowerCase().contains(q) ||
          lang.code.toLowerCase().contains(q);
    }).toList();
  }

  void _selectLanguage(String code) {
    HapticFeedback.selectionClick();
    _controller.changeLanguage(code);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isPitchBlack = _controller.pitchBlack.value;
      final selectedCode = _controller.localeCode.value;

      final backgroundColor = isPitchBlack
          ? (isDark ? Colors.black : Colors.white)
          : appThemeColors.grey6;

      final tileBackgroundColor = isPitchBlack
          ? (isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03))
          : appThemeColors.grey5;

      final textColor = appThemeColors.grey10;
      final filtered = _filteredLanguages;

      return Material(
        color: backgroundColor,
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.close_rounded, color: textColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              AppConstants.language.tr,
              style: TextStyle(
                color: textColor,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _query = val.trim()),
                  style: TextStyle(
                    color: textColor,
                    fontFamily: AppConstants.font,
                    fontSize: 15.sp,
                    letterSpacing: -0.2,
                  ),
                  decoration: InputDecoration(
                    hintText: AppConstants.searchLanguagesHint.tr,
                    hintStyle: TextStyle(
                      color: appThemeColors.grey3,
                      fontFamily: AppConstants.font,
                      fontSize: 15.sp,
                      letterSpacing: -0.2,
                    ),
                    filled: true,
                    fillColor: tileBackgroundColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 12.h,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: appThemeColors.grey3,
                    ),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: appThemeColors.grey3,
                              size: 18.sp,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 28.h),
                  children: [
                    if (_query.isEmpty ||
                        AppConstants.systemDefault.tr
                            .toLowerCase()
                            .contains(_query.toLowerCase()) ||
                        'system'.contains(_query.toLowerCase())) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Material(
                          color: tileBackgroundColor,
                          child: ListTile(
                            title: Text(
                              AppConstants.systemDefault.tr,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppConstants.font,
                                letterSpacing: -0.2,
                              ),
                            ),
                            trailing: selectedCode == AppTranslations.systemCode
                                ? Icon(
                                    Icons.check_rounded,
                                    color: appThemeColors.primary,
                                  )
                                : null,
                            onTap: () =>
                                _selectLanguage(AppTranslations.systemCode),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                    if (filtered.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Center(
                          child: Text(
                            AppConstants.noResultsFound.tr,
                            style: TextStyle(
                              color: appThemeColors.grey3,
                              fontFamily: AppConstants.font,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Column(
                          children: List.generate(filtered.length, (index) {
                            final lang = filtered[index];
                            final isSelected = selectedCode == lang.code;
                            final isLast = index == filtered.length - 1;

                            return Container(
                              decoration: BoxDecoration(
                                color: tileBackgroundColor,
                                border: !isLast
                                    ? Border(
                                        bottom: BorderSide(
                                          color: appThemeColors.grey4
                                              .withValues(alpha: 0.4),
                                          width: 1.w,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  title: Text(
                                    lang.nativeName,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.5.sp,
                                      fontFamily: AppConstants.font,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  subtitle: Text(
                                    lang.englishName,
                                    style: TextStyle(
                                      color: appThemeColors.grey2,
                                      fontSize: 12.5.sp,
                                      fontFamily: AppConstants.font,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Icon(
                                          Icons.check_rounded,
                                          color: appThemeColors.primary,
                                        )
                                      : null,
                                  onTap: () => _selectLanguage(lang.code),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
