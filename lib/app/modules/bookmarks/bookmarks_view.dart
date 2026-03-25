import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/core/widgets/journal_tile.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/read_journal/read_journal_bottom_sheet.dart';

class BookmarksView extends GetView<HomeController> {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final Brightness platformBrightness = Theme.of(context).brightness;
    final Brightness iconBrightness = platformBrightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    return Scaffold(
      backgroundColor: appThemeColors.grey7,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: iconBrightness,
          systemNavigationBarColor: appThemeColors.grey7,
          systemNavigationBarIconBrightness: iconBrightness,
        ),
        backgroundColor: appThemeColors.grey7,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: appThemeColors.grey1),
        title: Text(
          AppConstants.bookmark,
          style: TextStyle(
            fontFamily: AppConstants.font,
            color: appThemeColors.grey10,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final bookmarks = controller.journalEntries
            .where((entry) => entry.isBookmarked)
            .toList();

        if (bookmarks.isEmpty) {
          return Center(
            child: Text(
              "No bookmarks yet.",
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                color: appThemeColors.grey3,
                fontSize: 16.sp,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: bookmarks.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final entry = bookmarks[index];
            return JournalTile(
              entry: entry,
              onTap: () {
                showCupertinoModalBottomSheet(
                  context: context,
                  expand: true,
                  backgroundColor: Colors.transparent,
                  builder: (modalContext) {
                    return SafeArea(
                      child: ReadJournalBottomSheet(entry: entry),
                    );
                  },
                );
              },
            );
          },
        );
      }),
    );
  }
}