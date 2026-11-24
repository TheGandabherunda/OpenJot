import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:scroll_edge_blur/scroll_edge_blur.dart';

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
  static final DateFormat _monthFormat = DateFormat('MMMM');
  static final DateFormat _tileDateFormat = DateFormat('dd,MMM');

  final _shareService = ShareService();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _listKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();

  late final ValueNotifier<double> _appBarOffsetNotifier;
  late final ValueNotifier<bool> _isScrubbing;
  late final ValueNotifier<double> _scrollProgress;
  late final ValueNotifier<DateTime?> _scrubDate;
  late final AnimationController _scrubFadeController;
  late final AnimationController _scrollFadeController;

  Timer? _scrollFadeTimer;
  double _startProgress = 0.0;
  double _startPointerY = 0.0;
  bool _dateUpdateScheduled = false;

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

    _appBarOffsetNotifier = ValueNotifier<double>(0.0);
    _isScrubbing = ValueNotifier<bool>(false);
    _scrollProgress = ValueNotifier<double>(0.0);

    final initialEntries = widget.controller.journalEntries;
    _scrubDate = ValueNotifier<DateTime?>(
      initialEntries.isNotEmpty ? initialEntries.first.createdAt : null,
    );

    _scrubFadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scrollFadeController = AnimationController(
      duration: const Duration(milliseconds: 60),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
      value: 0.0,
    );

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final double offset = _scrollController.offset;
    final double maxScroll = _scrollController.position.maxScrollExtent;

    _appBarOffsetNotifier.value = offset;

    if (!_isScrubbing.value) {
      if (maxScroll > 0) {
        _scrollProgress.value = (offset / maxScroll).clamp(0.0, 1.0);
      } else {
        _scrollProgress.value = 0.0;
      }

      _scrollFadeController.value = 1.0;
      _startFadeTimer();

      _scheduleDateUpdate();
    }
  }

  void _scheduleDateUpdate() {
    if (_dateUpdateScheduled) return;
    _dateUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dateUpdateScheduled = false;
      if (mounted) {
        _updateDateFromVisibleTiles();
      }
    });
  }

  void _updateDateFromVisibleTiles() {
    final entries = widget.controller.journalEntries;
    if (entries.isEmpty) return;

    final renderSliver = _listKey.currentContext?.findRenderObject()
        as RenderSliverMultiBoxAdaptor?;
    if (renderSliver == null || renderSliver.firstChild == null) return;

    final screenHeight = MediaQuery.of(context).size.height;
    final statsHeight =
        widget.controller.hideHomeStats.value ? 0.0 : 44.h;
    final trackTop = 102.h + statsHeight + 20.h;
    final bottomBound = 116.h;
    final trackHeight =
        (screenHeight - trackTop - bottomBound).clamp(80.0, 3000.0);
    final pillY =
        trackTop + (_scrollProgress.value * (trackHeight - 8.h)) + 4.h;

    RenderBox? child = renderSliver.firstChild;
    RenderBox? matchingChild;

    while (child != null) {
      final offset = child.localToGlobal(Offset.zero);
      final top = offset.dy;
      final bottom = top + child.size.height;

      if (pillY >= top && pillY < bottom) {
        matchingChild = child;
        break;
      }
      if (pillY < top && matchingChild == null) {
        matchingChild = child;
        break;
      }
      matchingChild = child;
      child = renderSliver.childAfter(child);
    }

    if (matchingChild != null) {
      final int idx = renderSliver.indexOf(matchingChild);
      if (idx >= 0 && idx < entries.length) {
        final dt = entries[idx].createdAt;
        if (_scrubDate.value != dt) {
          _scrubDate.value = dt;
        }
      }
    }
  }

  @override
  void dispose() {
    _shareService.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollFadeTimer?.cancel();
    _appBarOffsetNotifier.dispose();
    _isScrubbing.dispose();
    _scrollProgress.dispose();
    _scrubDate.dispose();
    _scrubFadeController.dispose();
    _scrollFadeController.dispose();
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
                        Text(
                          AppConstants.sortBy,
                          style: TextStyle(
                            color: appThemeColors.grey10,
                            fontFamily: AppConstants.font,
                            letterSpacing: -0.2,
                          ),
                        ),
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
              Text(
                AppConstants.bookmark,
                style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2,
                ),
              ),
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
              Text(
                AppConstants.drafts,
                style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2,
                ),
              ),
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
              Text(
                AppConstants.insights,
                style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2,
                ),
              ),
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
              Text(
                AppConstants.reflections,
                style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2,
                ),
              ),
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
              Text(
                AppConstants.settings,
                style: TextStyle(
                  color: appThemeColors.grey10,
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2,
                ),
              ),
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
          child: Text(
            AppConstants.entryTime,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
            ),
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'bookmark',
          child: Text(
            AppConstants.bookmarkFirst,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
            ),
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'reflection',
          child: Text(
            AppConstants.reflectionFirst,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
            ),
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'media',
          child: Text(
            AppConstants.withMediaFirst,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
            ),
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'text',
          child: Text(
            AppConstants.textOnlyFirst,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
            ),
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'location',
          child: Text(
            AppConstants.withLocationFirst,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
            ),
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'mood',
          child: Text(
            AppConstants.withMoodFirst,
            style: TextStyle(
              color: appThemeColors.grey10,
              fontFamily: AppConstants.font,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    ).then((sortValue) {
      if (sortValue != null) {
        Navigator.of(context).pop();
        widget.controller.sortEntries(sortValue);
      }
    });
  }

  void _handleInsights() {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => const SafeArea(child: InsightsBottomSheet()),
    );
  }

  void _handleReflections() {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => const SafeArea(child: ReflectionBottomSheet()),
    );
  }

  void _handleSettings() {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => const SafeArea(child: SettingsBottomSheet()),
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
      if (!_scrollController.hasClients) return;

      final statsHeight =
          widget.controller.hideHomeStats.value ? 0.0 : (44.h + 20.h);
      double targetOffset = 58.h + statsHeight;

      for (int i = 0; i < targetIndex; i++) {
        final entry = entries[i];
        final prevEntry = i > 0 ? entries[i - 1] : null;

        bool showYearDivider = prevEntry == null ||
            entry.createdAt.year != prevEntry.createdAt.year;
        bool showMonthDivider = prevEntry == null ||
            entry.createdAt.month != prevEntry.createdAt.month ||
            entry.createdAt.year != prevEntry.createdAt.year;

        if (showYearDivider) {
          targetOffset += 20.h + (28.sp * 1.2);
        }
        if (showMonthDivider) {
          targetOffset += (showYearDivider ? 0 : 8.h) + 16.h + (18.sp * 1.2);
        }

        double tileHeight = 46.h;
        final hasMedia =
            entry.galleryImages.isNotEmpty || entry.cameraPhotos.isNotEmpty;
        final hasAudio =
            entry.galleryAudios.isNotEmpty || entry.recordings.isNotEmpty;
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

      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double clampedTarget = targetOffset.clamp(0.0, maxScroll);

      await _scrollController.animateTo(
        clampedTarget,
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

    if (_scrubDate.value != null) {
      initialMonth = _scrubDate.value!.month;
      initialYear = _scrubDate.value!.year;
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
                              child: Text(
                                m,
                                style: TextStyle(
                                  color: appThemeColors.grey10,
                                  fontFamily: AppConstants.font,
                                  fontSize: 18.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ))
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
                              child: Text(
                                y.toString(),
                                style: TextStyle(
                                  color: appThemeColors.grey10,
                                  fontFamily: AppConstants.font,
                                  fontSize: 18.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ))
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

  void _startFadeTimer() {
    _scrollFadeTimer?.cancel();
    _scrollFadeTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted && !_isScrubbing.value) {
        _scrollFadeController.reverse();
      }
    });
  }

  void _onScrubStart(double globalY) {
    _startProgress = _scrollProgress.value;
    _startPointerY = globalY;

    _isScrubbing.value = true;
    _scrubFadeController.forward();
    _scrollFadeTimer?.cancel();
    _scrollFadeController.value = 1.0;
    HapticFeedback.selectionClick();
  }

  void _onScrubUpdate(double globalY, double trackHeight) {
    final double circleSize = 42.w;
    final double effectiveTrackHeight =
        (trackHeight - circleSize).clamp(1.0, 3000.0);

    final double deltaY = globalY - _startPointerY;
    final double progress =
        (_startProgress + (deltaY / effectiveTrackHeight)).clamp(0.0, 1.0);
    _scrollProgress.value = progress;

    _applyScrollProgress(progress);
  }

  void _onScrubEnd() {
    _isScrubbing.value = false;
    _scrubFadeController.reverse();
    _startFadeTimer();
    _scheduleDateUpdate();
  }

  void _applyScrollProgress(double progress) {
    if (!_scrollController.hasClients) return;
    final double maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    final double clampedProgress = progress.clamp(0.0, 1.0);
    _scrollController.jumpTo(clampedProgress * maxScroll);

    final entries = widget.controller.journalEntries;
    if (entries.isNotEmpty) {
      final int targetIndex = (clampedProgress * (entries.length - 1))
          .round()
          .clamp(0, entries.length - 1);
      final dt = entries[targetIndex].createdAt;
      if (_scrubDate.value != dt) {
        _scrubDate.value = dt;
        HapticFeedback.selectionClick();
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

    return RepaintBoundary(
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (!_isScrubbing.value) {
                if (notification is ScrollStartNotification ||
                    notification is UserScrollNotification ||
                    notification is ScrollUpdateNotification) {
                  _scrollFadeController.value = 1.0;
                  _startFadeTimer();
                }
              }
              return false;
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
              SliverAppBar(
                forceMaterialTransparency: true,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                expandedHeight: 102.h,
                toolbarHeight: 44.h,
                floating: false,
                pinned: true,
              ),
              Obx(() {
                if (widget.controller.hideHomeStats.value) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            AppConstants.entriesThisYear,
                            widget.controller.totalEntriesThisYear.toString(),
                            Icons.web_stories,
                          ),
                        ),
                        Container(
                          width: 1.w,
                          height: 44.h,
                          color: appThemeColors.grey5,
                        ),
                        Expanded(
                          child: _buildStatItem(
                            AppConstants.wordsWritten,
                            widget.controller.totalWordsWritten.toString(),
                            Icons.format_quote_rounded,
                          ),
                        ),
                        Container(
                          width: 1.w,
                          height: 44.h,
                          color: appThemeColors.grey5,
                        ),
                        Expanded(
                          child: _buildStatItem(
                            AppConstants.daysJournaled,
                            widget.controller.daysJournaled.toString(),
                            Icons.calendar_today_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Obx(() {
                final entries = widget.controller.journalEntries;
                if (entries.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/app_icon.svg',
                              height: 48.sp,
                            ),
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
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: 20.h,
                    bottom: 140.h,
                  ),
                  sliver: SliverList(
                    key: _listKey,
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = entries[index];
                        final prevEntry =
                            index > 0 ? entries[index - 1] : null;

                        bool showYearDivider = prevEntry == null ||
                            entry.createdAt.year != prevEntry.createdAt.year;
                        bool showMonthDivider = prevEntry == null ||
                            entry.createdAt.month !=
                                prevEntry.createdAt.month ||
                            entry.createdAt.year != prevEntry.createdAt.year;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 32.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showYearDivider) ...[
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 12.h,
                                    top: index == 0 ? 0 : 8.h,
                                  ),
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
                                    top: showYearDivider
                                        ? 0
                                        : (index == 0 ? 0 : 8.h),
                                  ),
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
                        );
                      },
                      childCount: entries.length,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: true,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 102.h,
            child: IgnorePointer(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const EdgeBlur(
                    edge: BlurEdge.top,
                    sigma: 16,
                    curve: Curves.easeIn,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          appThemeColors.grey7,
                          appThemeColors.grey7.withOpacity(0.85),
                          appThemeColors.grey7.withOpacity(0.55),
                          appThemeColors.grey7.withOpacity(0.28),
                          appThemeColors.grey7.withOpacity(0.10),
                          appThemeColors.grey7.withOpacity(0.02),
                          appThemeColors.grey7.withOpacity(0.0),
                          appThemeColors.grey7.withOpacity(0.0),
                        ],
                        stops: const [
                          0.0,
                          0.12,
                          0.26,
                          0.38,
                          0.48,
                          0.56,
                          0.62,
                          1.0
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _appBarOffsetNotifier,
              builder: (context, offset, _) {
                final double maxExtent = 102.h;
                final double minExtent = 44.h;
                final double delta = maxExtent - minExtent;
                final double t = (offset / delta).clamp(0.0, 1.0);
                final double currentHeight = maxExtent - (delta * t);
                final double topPadding = 42.h * (1.0 - t);
                final double bottomPadding = 20.h - (12.h * t);
                final double fontSize = 28.sp - (4.sp * t);
                final double buttonSize = 40.w - (4.w * t);
                final double iconSize = 24.sp - (2.sp * t);

                return Container(
                  height: currentHeight,
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: topPadding,
                    bottom: bottomPadding,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          AppConstants.appTitle,
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                            color: appThemeColors.grey10,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => const SearchView()),
                        child: Container(
                          width: buttonSize,
                          height: buttonSize,
                          decoration: BoxDecoration(
                            color: appThemeColors.grey6,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.search,
                            size: iconSize,
                            color: appThemeColors.grey1,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        key: _menuKey,
                        onTap: () => _showPopupMenu(context),
                        child: Container(
                          width: buttonSize,
                          height: buttonSize,
                          decoration: BoxDecoration(
                            color: appThemeColors.grey6,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.more_horiz_rounded,
                            size: iconSize,
                            color: appThemeColors.grey1,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 180.h,
            child: IgnorePointer(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const EdgeBlur(
                    edge: BlurEdge.bottom,
                    sigma: 16,
                    curve: Curves.easeIn,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          appThemeColors.grey7,
                          appThemeColors.grey7.withOpacity(0.85),
                          appThemeColors.grey7.withOpacity(0.55),
                          appThemeColors.grey7.withOpacity(0.28),
                          appThemeColors.grey7.withOpacity(0.10),
                          appThemeColors.grey7.withOpacity(0.02),
                          appThemeColors.grey7.withOpacity(0.0),
                          appThemeColors.grey7.withOpacity(0.0),
                        ],
                        stops: const [
                          0.0,
                          0.12,
                          0.26,
                          0.38,
                          0.48,
                          0.56,
                          0.62,
                          1.0
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _scrubFadeController,
                builder: (context, _) {
                  final val = _scrubFadeController.value;
                  if (val == 0.0) return const SizedBox.shrink();
                  return Container(
                    color: Colors.black.withOpacity(0.55 * val),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _scrubFadeController,
                builder: (context, _) {
                  final val = _scrubFadeController.value;
                  if (val == 0.0) return const SizedBox.shrink();
                  return Opacity(
                    opacity: val,
                    child: Center(
                      child: ValueListenableBuilder<DateTime?>(
                        valueListenable: _scrubDate,
                        builder: (context, date, _) {
                          if (date == null) return const SizedBox.shrink();
                          final monthStr = DateFormat('MMMM').format(date);
                          final yearStr = DateFormat('yyyy').format(date);

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                monthStr,
                                style: TextStyle(
                                  fontFamily: AppConstants.font,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 44.sp,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                yearStr,
                                style: TextStyle(
                                  fontFamily: AppConstants.font,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                  color: Colors.white.withOpacity(0.85),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Obx(() {
            if (widget.controller.journalEntries.isEmpty) {
              return const SizedBox.shrink();
            }

            final screenHeight = MediaQuery.of(context).size.height;
            final double statsHeight =
                widget.controller.hideHomeStats.value ? 0.0 : 44.h;
            final double trackTop = 102.h + statsHeight + 20.h;
            final double bottomBound = 116.h;
            final double trackHeight =
                (screenHeight - trackTop - bottomBound).clamp(80.0, 3000.0);

            return Positioned(
              right: 0,
              top: trackTop,
              width: 48.w,
              height: trackHeight,
              child: AnimatedBuilder(
                animation: _scrollFadeController,
                builder: (context, _) {
                  final fadeVal = _scrollFadeController.value;
                  return ValueListenableBuilder<bool>(
                    valueListenable: _isScrubbing,
                    builder: (context, isScrubbing, _) {
                      final double opacity = isScrubbing ? 1.0 : fadeVal;
                      if (opacity == 0.0) return const SizedBox.shrink();

                      return ValueListenableBuilder<double>(
                        valueListenable: _scrollProgress,
                        builder: (context, progress, _) {
                          final double normalHeight = 8.h;
                          final double circleSize = 42.w;
                          final double effectiveTrackHeight =
                              (trackHeight - circleSize).clamp(1.0, 3000.0);
                          final double thumbCenterY =
                              (circleSize / 2) + (progress * effectiveTrackHeight);
                          final double currentThumbHeight =
                              isScrubbing ? circleSize : normalHeight;
                          final double thumbTop =
                              thumbCenterY - (currentThumbHeight / 2);
                          const double touchPaddingY = 16.0;
                          final double badgeHeight = 20.h;
                          final double badgeTop = thumbTop - badgeHeight - 4.h;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              if (!isScrubbing)
                                ValueListenableBuilder<DateTime?>(
                                  valueListenable: _scrubDate,
                                  builder: (context, date, _) {
                                    if (date == null) {
                                      return const SizedBox.shrink();
                                    }
                                    final String formattedDate =
                                        DateFormat('dd,MMM').format(date);

                                    return Positioned(
                                      right: 3.w,
                                      width: 36.w,
                                      height: badgeHeight,
                                      top: badgeTop,
                                      child: IgnorePointer(
                                        child: Opacity(
                                          opacity: opacity,
                                          child: Container(
                                            width: 36.w,
                                            height: badgeHeight,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: appThemeColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              formattedDate,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppConstants.font,
                                                fontSize: 8.5.sp,
                                                fontWeight: FontWeight.bold,
                                                color: appThemeColors.onPrimary,
                                                letterSpacing: -0.3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              Positioned(
                                right: 0,
                                top: thumbTop - touchPaddingY.h,
                                width: 48.w,
                                height: currentThumbHeight + (touchPaddingY.h * 2),
                                child: Listener(
                                  behavior: HitTestBehavior.opaque,
                                  onPointerDown: (event) {
                                    _onScrubStart(event.position.dy);
                                  },
                                  onPointerMove: (event) {
                                    if (_isScrubbing.value) {
                                      _onScrubUpdate(
                                        event.position.dy,
                                        trackHeight,
                                      );
                                    }
                                  },
                                  onPointerUp: (event) {
                                    if (_isScrubbing.value) {
                                      _onScrubEnd();
                                    }
                                  },
                                  onPointerCancel: (event) {
                                    if (_isScrubbing.value) {
                                      _onScrubEnd();
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 3.w),
                                      child: Opacity(
                                        opacity: opacity,
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 180),
                                          curve: Curves.easeOutCubic,
                                          width:
                                              isScrubbing ? circleSize : 36.w,
                                          height: currentThumbHeight,
                                          decoration: BoxDecoration(
                                            color: appThemeColors.primary,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(
                                              isScrubbing
                                                  ? (circleSize / 2)
                                                  : 100.r,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          }),
        ],
      ),
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
