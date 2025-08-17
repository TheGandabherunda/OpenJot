import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
      statusBarColor: appThemeColors.grey7,
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
          body: SafeArea(
            top: true,
            child: _HomeScreenStack(controller: controller),
          ),
        ),
      ),
    );
  }
}

class _HomeScreenStack extends StatefulWidget {
  final HomeController controller;
  const _HomeScreenStack({required this.controller});

  @override
  State<_HomeScreenStack> createState() => _HomeScreenStackState();
}

class _HomeScreenStackState extends State<_HomeScreenStack>
    with TickerProviderStateMixin {
  double _lastOffset = 0.0;
  static const double _tileHeightEstimate = 100;
  String? _currentMonthYear;
  bool _showChip = false;
  int _topEntryIndex = 0;

  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 700), // Longer exit duration
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.2),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutCubic, // Smooth exit curve
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 0.8, curve: Curves.easeOut), // Longer fade out
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeOutQuart, // Smooth scale down
    ));
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    super.dispose();
  }

  void _onScroll(double offset, int totalEntries, List entries) {
    if (entries.isEmpty) {
      if (_showChip) {
        setState(() => _showChip = false);
        _slideAnimationController.reverse();
      }
      return;
    }

    int index =
    (offset / (_tileHeightEstimate + 32.h)).floor().clamp(0, totalEntries - 1);
    if (_topEntryIndex != index) {
      setState(() {
        _topEntryIndex = index;
        final dt = entries[index].createdAt;
        _currentMonthYear = DateFormat('MMM, yyyy').format(dt);
      });
    }

    // Wider threshold gap for smoother transitions
    final showThreshold = (_tileHeightEstimate + 32.h) * 0.8;
    final hideThreshold = (_tileHeightEstimate + 32.h) * 0.2;

    bool shouldShow;
    if (_showChip) {
      shouldShow = offset > hideThreshold;
    } else {
      shouldShow = offset > showThreshold;
    }

    if (_showChip != shouldShow) {
      setState(() => _showChip = shouldShow);

      if (shouldShow) {
        _slideAnimationController.forward();
      } else {
        _slideAnimationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final entries = widget.controller.journalEntries;

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification ||
                notification is ScrollMetricsNotification) {
              final offset = notification.metrics.pixels;
              if ((offset - _lastOffset).abs() > 20.0 || offset == 0.0) {
                _lastOffset = offset;
                _onScroll(offset, entries.length, entries);
              }
            }
            return false;
          },
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  expandedHeight: 72.h,
                  floating: false,
                  pinned: true,
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              appThemeColors.grey7,
                              appThemeColors.grey7.withOpacity(0.6),
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                        child: FlexibleSpaceBar(
                          title: Text(
                            AppConstants.appTitle,
                            style: TextStyle(
                              fontFamily: AppConstants.font,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.sp,
                              color: appThemeColors.grey10,
                            ),
                          ),
                          titlePadding: EdgeInsets.only(left: 16.w, bottom: 16.h),
                          expandedTitleScale: 28.sp / 24.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: ProgressiveBlurWidget(
              sigma: 25.0,
              linearGradientBlur: const LinearGradientBlur(
                values: [0, 0, 0.23, 1],
                stops: [0.0, 0.12, 0.88, 1.0],
                start: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              tintColor: appThemeColors.grey7.withOpacity(0.15),
              child: Obx(() {
                if (entries.isEmpty) {
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
                } else {
                  return ListView.separated(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 16.h,
                      bottom: 140.h,
                    ),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return JournalTile(entry: entry);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 32.h);
                    },
                  );
                }
              }),
            ),
          ),
        ),
        // Fixed position chip with improved animations
        Positioned(
          left: 0,
          right: 0,
          top: 64.h,
          child: AnimatedBuilder(
            animation: _slideAnimationController,
            builder: (context, child) {
              return SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Center(
                      child: (_showChip && _currentMonthYear != null)
                          ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h), // Slightly more padding
                        decoration: BoxDecoration(
                          color: appThemeColors.grey5,
                          borderRadius: BorderRadius.circular(6.r), // More rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12), // Slightly more shadow
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _currentMonthYear!,
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontWeight: FontWeight.w600,
                            height: 1.2.sp,
                            fontSize: 14.sp,
                            color: appThemeColors.grey10,
                          ),
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Add button
        Positioned(
          bottom: 40.h,
          left: 0,
          right: 0,
          child: Center(
            child: Builder(
              builder: (BuildContext innerContext) {
                return CustomIconButton(
                  iconSize: 40,
                  iconPadding: EdgeInsets.all(14.w),
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
    );
  }
}