
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/modules/bookmarks/bookmarks_view.dart';
import 'package:open_jot/app/modules/drafts/drafts_view.dart';
import 'package:open_jot/app/modules/insights/insights_bottomsheet.dart';
import 'package:open_jot/app/modules/read_journal/read_journal_bottom_sheet.dart';
import 'package:open_jot/app/modules/search/search_view.dart';
import 'package:open_jot/app/modules/settings/settings_bottomsheet.dart';
import 'package:open_jot/app/modules/write_journal/write_journal_bottom_sheet.dart';
import 'package:progressive_blur/progressive_blur.dart';

import '../../core/constants.dart';
import '../../core/services/shared_services.dart';
import '../../core/theme.dart';
import '../../core/widgets/custom_icon_button.dart';
import '../../core/widgets/journal_tile.dart';
import '../reflection/reflection_bottom_sheet.dart';
import '../../utils/custom_toast.dart';
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
  static final DateFormat _monthYearFormat = DateFormat('MMM, yyyy');
  static final DateFormat _monthFormat = DateFormat('MMMM');

  final _shareService = ShareService();
  double _lastOffset = 0.0;
  int _topEntryIndex = 0;
  final ScrollController _scrollController = ScrollController();

  late final ValueNotifier<String?> _currentMonthYearNotifier;
  late final ValueNotifier<bool> _showChipNotifier;
  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _bodyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _shareService.startListening();
    _shareService.onShareReceived = ({
      String? text,
      List<String>? photos,
      List<String>? videos,
      List<String>? audios,
    }) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _handleShare(
            text: text,
            photos: photos,
            videos: videos,
            audios: audios,
          );
        }
      });
    };

    _currentMonthYearNotifier = ValueNotifier<String?>(null);
    _showChipNotifier = ValueNotifier<bool>(false);
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutCubic,
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));
    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeOutQuart,
    ));
  }

  @override
  void dispose() {
    _shareService.dispose();
    _currentMonthYearNotifier.dispose();
    _showChipNotifier.dispose();
    _slideAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleShare({
    String? text,
    List<String>? photos,
    List<String>? videos,
    List<String>? audios,
  }) {
    if (!mounted) return;
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
                        Text(AppConstants.sortBy,
                            style: TextStyle(
                                color: appThemeColors.grey10,
                                fontFamily: AppConstants.font,
                                letterSpacing: -0.2)),
                        SizedBox(
                          width: 68.w,
                          child: Text(
                            widget.controller.currentSortTypeDisplayName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: appThemeColors.grey2,
                              fontFamily: AppConstants.font,
                              letterSpacing: -0.2,
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
          value: 'bookmarks',
          child: Row(
            children: [
              Icon(Icons.bookmark_outline_rounded, color: appThemeColors.grey10),
              SizedBox(width: 8.w),
              Text(AppConstants.bookmark,
                  style: TextStyle(
                      color: appThemeColors.grey10,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2)),
            ],
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'drafts',
          child: Row(
            children: [
              Icon(Icons.edit_document, color: appThemeColors.grey10),
              SizedBox(width: 8.w),
              Text(AppConstants.drafts,
                  style: TextStyle(
                      color: appThemeColors.grey10,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2)),
            ],
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'insights',
          child: Row(
            children: [
              Icon(Icons.insights_outlined, color: appThemeColors.grey10),
              SizedBox(width: 8.w),
              Text(AppConstants.insights,
                  style: TextStyle(
                      color: appThemeColors.grey10,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2)),
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
              Text(AppConstants.reflections,
                  style: TextStyle(
                      color: appThemeColors.grey10,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2)),
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
              Text(AppConstants.settings,
                  style: TextStyle(
                      color: appThemeColors.grey10,
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'bookmarks') {
        Get.to(() => const BookmarksView());
      } else if (value == 'drafts') {
        Get.to(() => const DraftsView());
      } else if (value == 'insights') {
        _handleInsights();
      } else if (value == 'reflections') {
        _handleReflections();
      } else if (value == 'settings') {
        _handleSettings();
      }
    });
  }

  void _showSortSubmenu(
      BuildContext context, Offset position, RenderBox renderBox) {
    final appThemeColors = AppTheme.colorsOf(context);
    final subMenuPosition = RelativeRect.fromLTRB(
      position.dx - 294,
      position.dy + renderBox.size.height + 16,
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
          child: Text(AppConstants.entryTime,
              style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'bookmark',
          child: Text(AppConstants.bookmarkFirst,
              style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'reflection',
          child: Text(AppConstants.reflectionFirst,
              style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'media',
          child: Text(AppConstants.withMediaFirst,
              style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'text',
          child: Text(AppConstants.textOnlyFirst,
              style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'location',
          child: Text(AppConstants.withLocationFirst,
              style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2)),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'mood',
          child: Text(AppConstants.withMoodFirst,
              style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2)),
        ),
      ],
    ).then((sortValue) {
      if (sortValue != null) {
        Navigator.of(context).pop();
        _handleSortSelection(sortValue);
      }
    });
  }

  void _handleSortSelection(String sortType) {
    widget.controller.sortEntries(sortType);
  }

  void _handleInsights() {
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

  Future<void> _scrollToMonthYear(int month, int year) async {
    final entries = widget.controller.journalEntries;

    int targetIndex = -1;
    for (int i = 0; i < entries.length; i++) {
      if (entries[i].createdAt.month == month &&
          entries[i].createdAt.year == year) {
        targetIndex = i;
        break;
      }
    }

    if (targetIndex != -1) {
      ScrollController? innerCtrl;
      if (_bodyKey.currentContext != null) {
        innerCtrl = PrimaryScrollController.of(_bodyKey.currentContext!);
      }

      if (innerCtrl == null || !innerCtrl.hasClients) return;

      final statsHeight = widget.controller.hideHomeStats.value ? 0.0 : (36.h + (36.sp * 1.2));
      double targetOffset = statsHeight + 16.h;

      for (int i = 0; i < targetIndex; i++) {
        final entry = entries[i];
        final prevEntry = i > 0 ? entries[i - 1] : null;

        bool showYearDivider = prevEntry == null || entry.createdAt.year != prevEntry.createdAt.year;
        bool showMonthDivider = prevEntry == null || entry.createdAt.month != prevEntry.createdAt.month || entry.createdAt.year != prevEntry.createdAt.year;

        if (showYearDivider) {
          targetOffset += 20.h + (28.sp * 1.2);
        }
        if (showMonthDivider) {
          targetOffset += (showYearDivider ? 0 : 8.h) + 16.h + (18.sp * 1.2);
        }

        double tileHeight = 46.h;

        final hasMedia = entry.galleryImages.isNotEmpty || entry.cameraPhotos.isNotEmpty;
        final hasAudio = entry.galleryAudios.isNotEmpty || entry.recordings.isNotEmpty;
        final plainText = entry.content.toPlainText().trim();
        final hasText = plainText.isNotEmpty;

        if (hasMedia) {
          tileHeight += 250.h;
          if (hasText || hasAudio) tileHeight += 8.h;
        }

        if (hasAudio) {
          tileHeight += entry.galleryAudios.length * 44.h;
          tileHeight += entry.recordings.length * 54.h;
          if (hasText) tileHeight += 8.h;
        }

        if (hasText) {
          int lines = (plainText.length / 38).ceil().clamp(1, 4);
          double textPadding = (hasMedia || hasAudio) ? 10.h : 20.h;
          tileHeight += textPadding + (lines * 16.sp * 1.2);
        }

        targetOffset += tileHeight;
        targetOffset += 32.h;
      }

      if (targetOffset > innerCtrl.position.maxScrollExtent) {
        double jumpTarget = targetOffset > 400 ? targetOffset - 400 : targetOffset;
        innerCtrl.jumpTo(jumpTarget);
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted || !innerCtrl.hasClients) return;
      }

      innerCtrl.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      CustomToast.showToast(AppConstants.noEntriesForMonth);
    }
  }

  void _showMonthYearPicker() {
    final entries = widget.controller.journalEntries;
    if (entries.isEmpty) return;

    int initialMonth = DateTime.now().month;
    int initialYear = DateTime.now().year;

    if (_currentMonthYearNotifier.value != null) {
      try {
        final dt =
        _monthYearFormat.parse(_currentMonthYearNotifier.value!);
        initialMonth = dt.month;
        initialYear = dt.year;
      } catch (_) {}
    }

    final years = entries.map((e) => e.createdAt.year).toSet().toList();
    years.sort((a, b) => b.compareTo(a));

    if (!years.contains(initialYear)) {
      initialYear = years.first;
    }

    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final appThemeColors = AppTheme.colorsOf(context);
        int tempMonth = initialMonth;
        int tempYear = initialYear;

        return CupertinoAlertDialog(
          title: Text(
            AppConstants.selectMonthAndYear,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontFamily: AppConstants.font,
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
              letterSpacing: -0.4,
            ),
          ),
          content: SizedBox(
            height: 200.h,
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 44.h,
                    magnification: 1.1,
                    useMagnifier: true,
                    scrollController: FixedExtentScrollController(
                        initialItem: initialMonth - 1),
                    onSelectedItemChanged: (index) {
                      tempMonth = index + 1;
                    },
                    children: AppConstants.months
                        .map((m) => Center(
                                child: Text(m,
                                    style: TextStyle(
                                        color: appThemeColors.grey10,
                                        fontFamily: AppConstants.font,
                                        fontSize: 18.sp,
                                        letterSpacing: -0.2))))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 44.h,
                    magnification: 1.1,
                    useMagnifier: true,
                    scrollController: FixedExtentScrollController(
                        initialItem: years.indexOf(initialYear)),
                    onSelectedItemChanged: (index) {
                      tempYear = years[index];
                    },
                    children: years
                        .map((y) => Center(
                                child: Text(y.toString(),
                                    style: TextStyle(
                                        color: appThemeColors.grey10,
                                        fontFamily: AppConstants.font,
                                        fontSize: 18.sp,
                                        letterSpacing: -0.2))))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppConstants.cancel,
                style: TextStyle(
                  color: appThemeColors.grey2,
                  fontFamily: AppConstants.font,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _scrollToMonthYear(tempMonth, tempYear);
              },
              child: Text(
                AppConstants.done,
                style: TextStyle(
                  color: appThemeColors.primary,
                  fontFamily: AppConstants.font,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onScroll(double offset, int totalEntries, List entries) {
    if (entries.isEmpty) {
      if (_showChipNotifier.value) {
        _showChipNotifier.value = false;
        _slideAnimationController.reverse();
      }
      return;
    }

    // [OPTIMIZED] Use a simpler estimate for index to avoid heavy math during every scroll tick.
    final index = (offset / 150.h).floor().clamp(0, totalEntries - 1);
    if (_topEntryIndex != index) {
      _topEntryIndex = index;
      final dt = entries[index].createdAt;
      _currentMonthYearNotifier.value = _monthYearFormat.format(dt);
    }

    final threshold = widget.controller.hideHomeStats.value ? 40.h : 100.h;
    bool shouldShow = offset > threshold;

    if (_showChipNotifier.value != shouldShow) {
      _showChipNotifier.value = shouldShow;
      if (shouldShow) {
        _slideAnimationController.forward();
      } else {
        _slideAnimationController.reverse();
      }
    }
  }

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
                letterSpacing: -0.2,
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
            letterSpacing: -0.2,
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
            if (notification.depth != 1) return false;

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
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  expandedHeight: 80.h,
                  floating: false,
                  pinned: true,
                  flexibleSpace: Stack(
                    fit: StackFit.expand,
                    children: [
                      // [RESTORED & OPTIMIZED] Restored the background with a more efficient implementation.
                      // Using a simple Container with color instead of BackdropFilter to ensure visibility
                      // while maximizing scrolling performance.
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: appThemeColors.grey7.withOpacity(0.9),
                          ),
                        ),
                      ),
                      FlexibleSpaceBar(
                        titlePadding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                        expandedTitleScale: 28.sp / 24.sp,
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
                                  letterSpacing: -0.2,
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
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: ProgressiveBlurWidget(
              sigma: 25.0,
              linearGradientBlur: const LinearGradientBlur(
                values: [0, 0, 1],
                stops: [0.0, 0.9, 1.0],
                start: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              tintColor: appThemeColors.grey7.withOpacity(0.15),
              child: Builder(
                  key: _bodyKey,
                  builder: (innerContext) {
                    return Obx(() {
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
                                  AppConstants.jotYourThoughts,
                                  style: TextStyle(
                                    fontFamily: AppConstants.font,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.sp,
                                    height: 1.2.sp,
                                    color: appThemeColors.grey1,
                                    letterSpacing: -0.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  AppConstants.tapToCreateJournal,
                                  style: TextStyle(
                                    fontFamily: AppConstants.font,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    height: 1.2.sp,
                                    color: appThemeColors.grey2,
                                    letterSpacing: -0.2,
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
                            Obx(() {
                              if (widget.controller.hideHomeStats.value) {
                                return const SliverToBoxAdapter(
                                    child: SizedBox.shrink());
                              }
                              return SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w, 16.h, 16.w, 16.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: _buildStatItem(
                                              AppConstants.entriesThisYear,
                                              widget.controller
                                                  .totalEntriesThisYear
                                                  .toString(),
                                              Icons.web_stories)),
                                      Container(
                                        width: 1.w,
                                        height: 44.h,
                                        color: appThemeColors.grey5,
                                      ),
                                      Expanded(
                                          child: _buildStatItem(
                                              AppConstants.wordsWritten,
                                              widget.controller
                                                  .totalWordsWritten
                                                  .toString(),
                                              Icons.format_quote_rounded)),
                                      Container(
                                        width: 1.w,
                                        height: 44.h,
                                        color: appThemeColors.grey5,
                                      ),
                                      Expanded(
                                          child: _buildStatItem(
                                              AppConstants.daysJournaled,
                                              widget.controller.daysJournaled
                                                  .toString(),
                                              Icons.calendar_today_rounded)),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            SliverPadding(
                              padding: EdgeInsets.only(
                                left: 16.w,
                                right: 16.w,
                                top: 16.h,
                                bottom: 140.h,
                              ),
                              sliver: SliverMainAxisGroup(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                        final entry = entries[index];
                                        final prevEntry = index > 0 ? entries[index - 1] : null;

                                        bool showYearDivider = prevEntry == null ||
                                            entry.createdAt.year != prevEntry.createdAt.year;
                                        bool showMonthDivider = prevEntry == null ||
                                            entry.createdAt.month != prevEntry.createdAt.month ||
                                            entry.createdAt.year != prevEntry.createdAt.year;

                                        return RepaintBoundary(
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: 32.h),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if (showYearDivider) ...[
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(bottom: 12.h, top: 8.h),
                                                    child: Text(
                                                      entry.createdAt.year.toString(),
                                                      style: TextStyle(
                                                        fontFamily: AppConstants.font,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 28.sp,
                                                        color: appThemeColors.grey10,
                                                        letterSpacing: -0.5,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                if (showMonthDivider) ...[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16.h,
                                                        top: showYearDivider ? 0 : 8.h),
                                                    child: Text(
                                                      _monthFormat.format(entry.createdAt),
                                                      style: TextStyle(
                                                        fontFamily: AppConstants.font,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 18.sp,
                                                        color: appThemeColors.grey2,
                                                        letterSpacing: -0.2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                JournalTile(
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      childCount: entries.isEmpty ? 0 : entries.length,
                                      addAutomaticKeepAlives: false,
                                      addRepaintBoundaries: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    });
                  }
              ),
            ),
          ),
        ),
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
                                  ? GestureDetector(
                                onTap: _showMonthYearPicker,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 9.w, vertical: 5.h),
                                  decoration: BoxDecoration(
                                    color: appThemeColors.grey5,
                                    borderRadius:
                                    BorderRadius.circular(6.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.12),
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
                                      letterSpacing: -0.2,
                                    ),
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

class TappablePopupMenuEntry extends PopupMenuEntry<Never> {
  const TappablePopupMenuEntry({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  final double height = kMinInteractiveDimension;

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