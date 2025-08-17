import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/modules/write_journal/write_journal_bottom_sheet.dart';
import 'package:progressive_blur/progressive_blur.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/widgets/custom_icon_button.dart';
import '../../core/widgets/journal_tile.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final Brightness brightness = Theme.of(context).brightness;
    final SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: appThemeColors.grey7,
      systemNavigationBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: CupertinoScaffold(
        body: Scaffold(
          backgroundColor: appThemeColors.grey7,
          body: Stack(
            children: [
              // Main scrollable content with progressive blur
              ProgressiveBlurWidget(
                sigma: 24.0,
                linearGradientBlur: const LinearGradientBlur(
                  values: [1, 0, 0, 1], // Full blur at top and bottom
                  stops: [0.0, 0.13, 0.88, 1.0],
                  start: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                tintColor: appThemeColors.grey7.withOpacity(0.15),
                child: Obx(
                  () {
                    if (controller.journalEntries.isEmpty) {
                      return _buildEmptyState(context, appThemeColors);
                    } else {
                      return _buildJournalListWithTopPadding(context);
                    }
                  },
                ),
              ),

              // Fixed app title (no background, positioned over blur)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16.h,
                      left: 16.w,
                      right: 16.w,
                      bottom: 16.h,
                    ),
                    child: Row(
                      children: [
                        Text(
                          AppConstants.appTitle,
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontWeight: FontWeight.bold,
                            fontSize: 28.sp,
                            color: appThemeColors.grey10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Floating button
              Positioned(
                bottom: 40.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Builder(
                    builder: (BuildContext innerContext) {
                      return CustomIconButton(
                        icon: Icons.add,
                        color: appThemeColors.primary,
                        iconColor: appThemeColors.onPrimary,
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            CupertinoScaffold.showCupertinoModalBottomSheet(
                              context: innerContext,
                              expand: true,
                              backgroundColor: appThemeColors.grey6,
                              builder: (BuildContext modalContext) {
                                return const SafeArea(
                                  child: WriteJournalBottomSheet(),
                                );
                              },
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppThemeColors appThemeColors) {
    return Center(
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
    );
  }

  Widget _buildJournalListWithTopPadding(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: MediaQuery.of(context).padding.top +
            80.h, // Account for fixed title
        bottom: 140.h, // Add bottom padding for floating button and blur
      ),
      itemCount: controller.journalEntries.length,
      itemBuilder: (context, index) {
        final entry = controller.journalEntries[index];
        return JournalTile(entry: entry);
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 32.h);
      },
    );
  }
}
