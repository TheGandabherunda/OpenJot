import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/modules/insights/insights_bottomsheet.dart';
import 'package:open_jot/app/modules/read_journal/read_journal_bottom_sheet.dart';
import 'package:open_jot/app/modules/search/search_view.dart';
import 'package:open_jot/app/modules/settings/settings_bottomsheet.dart';
import 'package:open_jot/app/modules/write_journal/write_journal_bottom_sheet.dart';
import 'package:progressive_blur/progressive_blur.dart';

import '../../core/constants.dart';// ADDED: Import share service
import '../../core/shared_services.dart';
import '../../core/theme.dart';
import '../../core/widgets/custom_icon_button.dart';
import '../../core/widgets/journal_tile.dart';
import '../reflection/reflection_bottom_sheet.dart';
import 'home_controller.dart'; // Import the new bottom sheet

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
  // START: ADDED FOR SHARING
  final _shareService = ShareService();
  // END: ADDED FOR SHARING

  double _lastOffset = 0.0;
  static const double _tileHeightEstimate = 100;
  int _topEntryIndex = 0;

  // OPTIMIZATION: Use ValueNotifiers to update the chip without rebuilding the entire list.
  late final ValueNotifier<String?> _currentMonthYearNotifier;
  late final ValueNotifier<bool> _showChipNotifier;

  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  // Key for the menu button
  final GlobalKey _menuKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // START: ADDED FOR SHARING
    _shareService.startListening();
    _shareService.onShareReceived = _handleShare;
    // END: ADDED FOR SHARING

    // OPTIMIZATION: Initialize notifiers.
    _currentMonthYearNotifier = ValueNotifier<String?>(null);
    _showChipNotifier = ValueNotifier<bool>(false);

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration:
      const Duration(milliseconds: 700), // Longer exit duration
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
      reverseCurve:
      const Interval(0.0, 0.8, curve: Curves.easeOut), // Longer fade out
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
    // START: ADDED FOR SHARING
    _shareService.dispose();
    // END: ADDED FOR SHARING

    // OPTIMIZATION: Dispose notifiers to prevent memory leaks.
    _currentMonthYearNotifier.dispose();
    _showChipNotifier.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  // START: ADDED FOR SHARING
  void _handleShare({
    String? text,
    List<String>? photos,
    List<String>? videos,
    List<String>? audios,
  }) {
    // Use the main context to show the bottom sheet.
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => SafeArea(
        child: WriteJournalBottomSheet(
          initialText: text,
          sharedImagePaths: photos,
          sharedVideoPaths: videos,
          sharedAudioPaths: audios,
        ),
      ),
    );
  }
  // END: ADDED FOR SHARING

  // Method to show the popup menu
  void _showPopupMenu(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final RenderBox renderBox =
    _menuKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      color: appThemeColors.grey5,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      position: RelativeRect.fromLTRB(
        position.dx - renderBox.size.width * 2,
        position.dy + renderBox.size.height + 16,
        position.dx,
        position.dy + renderBox.size.height * 2,
      ),
      items: [
        // Using a custom PopupMenuEntry that doesn't close the menu on tap.
        TappablePopupMenuEntry(
          onTap: () => _showSortSubmenu(context, position, renderBox),
          child: Obx(
                () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.sort, color: appThemeColors.grey10),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sort by',
                            style: TextStyle(color: appThemeColors.grey10)),
                        SizedBox(
                          width: 68.w,
                          child: Text(
                            widget.controller.currentSortTypeDisplayName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: appThemeColors.grey2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.keyboard_arrow_right_rounded,
                    color: appThemeColors.grey10),
              ],
            ),
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'insights',
          child: Row(
            children: [
              Icon(Icons.insights_outlined, color: appThemeColors.grey10),
              SizedBox(width: 8.w),
              Text('Insights', style: TextStyle(color: appThemeColors.grey10)),
            ],
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'reflections',
          child: Row(
            children: [
              Icon(Icons.self_improvement_rounded,
                  color: appThemeColors.grey10),
              SizedBox(width: 8.w),
              Text('Reflections',
                  style: TextStyle(color: appThemeColors.grey10)),
            ],
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined, color: appThemeColors.grey10),
              SizedBox(width: 8.w),
              Text('Settings', style: TextStyle(color: appThemeColors.grey10)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'insights') {
        _handleInsights();
      } else if (value == 'reflections') {
        _handleReflections();
      } else if (value == 'settings') {
        _handleSettings();
      }
    });
  }

  // Method to show the sort submenu
  void _showSortSubmenu(
      BuildContext context, Offset position, RenderBox renderBox) {
    final appThemeColors = AppTheme.colorsOf(context);
    final subMenuPosition = RelativeRect.fromLTRB(
      position.dx - 294, // shift right of parent menu
      position.dy + renderBox.size.height + 16, // align vertically
      position.dx,
      position.dy,
    );

    showMenu<String>(
      context: context,
      color: appThemeColors.grey5,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      position: subMenuPosition,
      items: [
        PopupMenuItem(
          value: 'time',
          child: Text("Entry time",
              style: TextStyle(color: appThemeColors.grey10)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'bookmark',
          child: Text("Bookmark first",
              style: TextStyle(color: appThemeColors.grey10)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'reflection',
          child: Text("Reflection first",
              style: TextStyle(color: appThemeColors.grey10)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'media',
          child: Text("With media first",
              style: TextStyle(color: appThemeColors.grey10)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'text',
          child: Text("Text only first",
              style: TextStyle(color: appThemeColors.grey10)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'location',
          child: Text("With location first",
              style: TextStyle(color: appThemeColors.grey10)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'mood',
          child: Text("With mood first",
              style: TextStyle(color: appThemeColors.grey10)),
        ),
      ],
    ).then((sortValue) {
      // If a value was selected from the sort submenu, it will close itself.
      // We then need to manually close the main menu.
      if (sortValue != null) {
        Navigator.of(context).pop(); // This closes the main menu.
        _handleSortSelection(sortValue);
      }
      // If the user dismisses the submenu (sortValue is null), we do nothing,
      // leaving the main menu open for other actions.
    });
  }

  // Handle sort selection
  void _handleSortSelection(String sortType) {
    // Calls the sortEntries method in the HomeController
    widget.controller.sortEntries(sortType);
  }

  // Handle menu actions
  void _handleInsights() {
    // Show the new reflection bottom sheet
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return const SafeArea(
          child: InsightsBottomSheet(),
        );
      },
    );
  }

  void _handleReflections() {
    // Show the new reflection bottom sheet
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return const SafeArea(
          child: ReflectionBottomSheet(),
        );
      },
    );
  }

  void _handleSettings() {
    // Show the new reflection bottom sheet
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return const SafeArea(
          child: SettingsBottomSheet(),
        );
      },
    );
  }

  // OPTIMIZATION: Removed setState from the scroll listener.
  // This now updates the notifiers, which only rebuilds the chip widget.
  void _onScroll(double offset, int totalEntries, List entries) {
    if (entries.isEmpty) {
      if (_showChipNotifier.value) {
        _showChipNotifier.value = false;
        _slideAnimationController.reverse();
      }
      return;
    }

    int index = (offset / (_tileHeightEstimate + 32.h))
        .floor()
        .clamp(0, totalEntries - 1);
    if (_topEntryIndex != index) {
      _topEntryIndex = index;
      final dt = entries[index].createdAt;
      _currentMonthYearNotifier.value = DateFormat('MMM, yyyy').format(dt);
    }

    // Wider threshold gap for smoother transitions
    final showThreshold = (_tileHeightEstimate + 32.h) * 0.8;
    final hideThreshold = (_tileHeightEstimate + 32.h) * 0.2;

    bool shouldShow;
    if (_showChipNotifier.value) {
      shouldShow = offset > hideThreshold;
    } else {
      shouldShow = offset > showThreshold;
    }

    if (_showChipNotifier.value != shouldShow) {
      _showChipNotifier.value = shouldShow;

      if (shouldShow) {
        _slideAnimationController.forward();
      } else {
        _slideAnimationController.reverse();
      }
    }
  }

  // Helper widget to build each statistic item
  Widget _buildStatItem(String label, String value, IconData icon) {
    final appThemeColors = AppTheme.colorsOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: appThemeColors.grey2,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              value,
              style: TextStyle(
                fontFamily: AppConstants.font,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: appThemeColors.grey10,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppConstants.font,
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: appThemeColors.grey2,
          ),
        ),
      ],
    );
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
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  expandedHeight: 80.h,
                  floating: false,
                  pinned: true,
                  flexibleSpace: RepaintBoundary(
                    child: ClipRect(
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
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    AppConstants.appTitle,
                                    style: TextStyle(
                                      fontFamily: AppConstants.font,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.sp,
                                      color: appThemeColors.grey10,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(() => const SearchView()),
                                  child: Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                      color: appThemeColors.grey6,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.search,
                                      size: 24.sp,
                                      color: appThemeColors.grey1,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                GestureDetector(
                                  key: _menuKey,
                                  onTap: () => _showPopupMenu(context),
                                  child: Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                      color: appThemeColors.grey6,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.more_horiz_rounded,
                                      size: 24.sp,
                                      color: appThemeColors.grey1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            titlePadding: EdgeInsets.only(
                                left: 16.w, right: 16.w, bottom: 16.h),
                            expandedTitleScale: 28.sp / 24.sp,
                          ),
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
                          SvgPicture.asset('assets/app_icon.svg',
                              height: 48.sp),
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
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                    child: _buildStatItem(
                                        'Entries This Year',
                                        widget.controller.totalEntriesThisYear
                                            .toString(),
                                        Icons.horizontal_split_rounded)),
                                VerticalDivider(
                                  color: appThemeColors.grey5,
                                  thickness: 1.w,
                                ),
                                Expanded(
                                    child: _buildStatItem(
                                        'Words Written',
                                        widget.controller.totalWordsWritten
                                            .toString(),
                                        Icons.format_quote_rounded)),
                                VerticalDivider(
                                  color: appThemeColors.grey5,
                                  thickness: 1.w,
                                ),
                                Expanded(
                                    child: _buildStatItem(
                                        'Days Journaled',
                                        widget.controller.daysJournaled
                                            .toString(),
                                        Icons.calendar_today_rounded)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          top: 16.h,
                          bottom: 140.h,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final itemIndex = index ~/ 2;
                              if (index.isEven) {
                                final entry = entries[itemIndex];
                                return JournalTile(
                                  entry: entry,
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                      context: context,
                                      expand: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (modalContext) {
                                        return SafeArea(
                                          child: ReadJournalBottomSheet(
                                              entry: entry),
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                              return SizedBox(height: 32.h);
                            },
                            childCount:
                            entries.isEmpty ? 0 : entries.length * 2 - 1,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
          ),
        ),
        // OPTIMIZATION: Wrap the chip in builders that listen to the notifiers.
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
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _showChipNotifier,
                        builder: (context, showChip, _) {
                          return ValueListenableBuilder<String?>(
                            valueListenable: _currentMonthYearNotifier,
                            builder: (context, currentMonthYear, _) {
                              return (showChip && currentMonthYear != null)
                                  ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 9.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: appThemeColors.grey5,
                                  borderRadius:
                                  BorderRadius.circular(6.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                      Colors.black.withOpacity(0.12),
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  currentMonthYear,
                                  style: TextStyle(
                                    fontFamily: AppConstants.font,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2.sp,
                                    fontSize: 14.sp,
                                    color: appThemeColors.grey10,
                                  ),
                                ),
                              )
                                  : const SizedBox.shrink();
                            },
                          );
                        },
                      ),
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
                      showCupertinoModalBottomSheet(
                        context: innerContext,
                        expand: true,
                        backgroundColor: null,
                        bounce: true,
                        animationCurve: Curves.easeOutCubic,
                        duration: const Duration(milliseconds: 400),
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

/// A custom [PopupMenuEntry] that allows tapping without closing the menu.
/// This is used to trigger a submenu.
class TappablePopupMenuEntry extends PopupMenuEntry<Never> {
  const TappablePopupMenuEntry({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  final double height = kMinInteractiveDimension; // Standard menu item height.

  final VoidCallback onTap;
  final Widget child;

  @override
  bool represents(void value) => false;

  @override
  State<TappablePopupMenuEntry> createState() => _TappablePopupMenuEntryState();
}

class _TappablePopupMenuEntryState extends State<TappablePopupMenuEntry> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: widget.child,
        ),
      ),
    );
  }
}
