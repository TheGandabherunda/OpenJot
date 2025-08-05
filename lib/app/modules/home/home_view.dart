import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemUiOverlayStyle
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'; // Still needed for CupertinoScaffold.showCupertinoModalBottomSheet
import 'package:open_jot/app/core/widgets/write_journal_bottom_sheet.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/widgets/custom_icon_button.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final Brightness brightness = Theme
        .of(context)
        .brightness;
    final SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarColor: appThemeColors.grey7,
      systemNavigationBarIconBrightness: brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: CupertinoScaffold(
        // Re-introducing CupertinoScaffold
        body: Scaffold(
          backgroundColor: appThemeColors.grey7,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .padding
                      .top + 16.h,
                  left: 16.w,
                  right: 16.w,
                ),
                child: Row(
                  children: [
                    Text(
                      AppConstants.appTitle,
                      style: TextStyle(
                        fontFamily: AppConstants.font,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                        color: appThemeColors.grey10,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/app_icon.svg', height: 48.sp),
                        SizedBox(height: 24.h),
                        Text(
                          'Jot Your Thoughts',
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            height: 1.2.sp,
                            color: appThemeColors.grey1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Tap + to create your personal journal.',
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            height: 1.2.sp,
                            color: appThemeColors.grey2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.0.h),
                child: Builder(
                  builder: (BuildContext innerContext) {
                    return CustomIconButton(
                      icon: Icons.add,
                      color: appThemeColors.primary,
                      iconColor: appThemeColors.onPrimary,
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          CupertinoScaffold.showCupertinoModalBottomSheet(
                            context: innerContext, // Use innerContext here
                            expand: true,
                            backgroundColor: appThemeColors.grey6,
                            builder: (BuildContext modalContext) {
                              return const SafeArea(
                                child: WriteJournalBottomSheet(), // Removed parentContext argument
                              );
                            },
                          );
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
