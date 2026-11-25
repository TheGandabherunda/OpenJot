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

import '../../core/constants.dart';
import '../../core/services/shared_services.dart';
import '../../core/theme.dart';
import '../../core/widgets/custom_icon_button.dart';
import '../../core/widgets/journal_tile.dart';
import '../../core/widgets/progressive_edge_blur.dart';
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
      statusBarColor: Colors.transparent,
      statusBarBrightness:
          brightness == Brightness.dark ? Brightness.dark : Brightness.light,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarContrastEnforced: false,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: CupertinoScaffold(
        body: Scaffold(
          backgroundColor: appThemeColors.grey7,
          resizeToAvoidBottomInset: false,
          body: _HomeScreenStack(controller: controller),
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
  final ValueNotifier<bool> _isMenuOpen = ValueNotifier<bool>(false);
  late final AnimationController _scrubFadeController;
  late final AnimationController _scrollFadeController;

  Timer? _scrollFadeTimer;
  double _startProgress = 0.0;
  double _startPointerY = 0.0;
  double _lastScrollOffset = 0.0;
  double _lastMaxScroll = 0.0;
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
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 280),
      vsync: this,
      value: 0.0,
    );

    _scrollController.addListener(_onScroll);
  }

  void _showScrollIndicator() {
    if (_scrollFadeController.status != AnimationStatus.forward &&
        _scrollFadeController.value < 1.0) {
      _scrollFadeController.forward();
    }
    _startFadeTimer();
  }

  /// Computes continuous, monotonic progress in `[0.0, 1.0]` so lazy sliver
  /// `maxScrollExtent` re-estimations during scroll never cause backward jerks.
  double _computeSmoothProgress(double offset, double maxScroll) {
    if (maxScroll <= 0.0 || offset <= 0.0) return 0.0;
    if (offset >= maxScroll) return 1.0;
    if (_lastMaxScroll <= 0.0) {
      return (offset / maxScroll).clamp(0.0, 1.0);
    }

    final double prev = _scrollProgress.value;
    if (offset > _lastScrollOffset) {
      final double denom = maxScroll - _lastScrollOffset;
      if (denom <= 1.0) return 1.0;
      final double delta = offset - _lastScrollOffset;
      return (prev + (delta / denom) * (1.0 - prev)).clamp(prev, 1.0);
    }
    if (offset < _lastScrollOffset) {
      if (_lastScrollOffset <= 1.0) return 0.0;
      final double delta = _lastScrollOffset - offset;
      return (prev - (delta / _lastScrollOffset) * prev).clamp(0.0, prev);
    }
    return prev;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final double offset = _scrollController.offset;
    final double maxScroll = _scrollController.position.maxScrollExtent;

    _appBarOffsetNotifier.value = offset;

    if (!_isScrubbing.value) {
      _scrollProgress.value = _computeSmoothProgress(offset, maxScroll);
      _lastScrollOffset = offset.clamp(0.0, maxScroll > 0 ? maxScroll : 0.0);
      _lastMaxScroll = maxScroll;

      _showScrollIndicator();
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

  ({double trackTop, double trackHeight}) _scrollTrackMetrics(
    BuildContext context,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final topInset = mediaQuery.padding.top;
    final bottomInset = mediaQuery.padding.bottom;
    final statsHeight = widget.controller.hideHomeStats.value ? 0.0 : 48.h;
    final trackTop = 124.h + topInset + statsHeight + 28.h;
    final bottomBound = 116.h + bottomInset;
    final trackHeight =
        (screenHeight - trackTop - bottomBound).clamp(80.0, 3000.0);
    return (
      trackTop: trackTop,
      trackHeight: trackHeight,
    );
  }

  void _updateDateFromVisibleTiles() {
    final entries = widget.controller.journalEntries;
    if (entries.isEmpty) return;

    final renderSliver = _listKey.currentContext?.findRenderObject()
        as RenderSliverMultiBoxAdaptor?;
    if (renderSliver == null || renderSliver.firstChild == null) return;

    final (:trackTop, :trackHeight) = _scrollTrackMetrics(context);
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
    _isMenuOpen.dispose();
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

  Widget _buildPopupMenuRow({
    required String label,
    required IconData icon,
    required AppThemeColors colors,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.grey10,
            fontFamily: AppConstants.font,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(width: 8.w),
        Icon(icon, color: colors.grey10),
      ],
    );
  }

  void _showPopupMenu(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _isMenuOpen.value = true;

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
                    Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: appThemeColors.grey10,
                    ),
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
                Icon(Icons.sort, color: appThemeColors.grey10),
              ],
            ),
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'bookmarks',
          child: _buildPopupMenuRow(
            label: AppConstants.bookmark,
            icon: Icons.bookmark_outline_rounded,
            colors: appThemeColors,
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'drafts',
          child: _buildPopupMenuRow(
            label: AppConstants.drafts,
            icon: Icons.edit_document,
            colors: appThemeColors,
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'insights',
          child: _buildPopupMenuRow(
            label: AppConstants.insights,
            icon: Icons.insights_outlined,
            colors: appThemeColors,
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'reflections',
          child: _buildPopupMenuRow(
            label: AppConstants.reflections,
            icon: Icons.self_improvement_rounded,
            colors: appThemeColors,
          ),
        ),
        PopupMenuDivider(height: 1, color: appThemeColors.grey6),
        PopupMenuItem(
          value: 'settings',
          child: _buildPopupMenuRow(
            label: AppConstants.settings,
            icon: Icons.settings_outlined,
            colors: appThemeColors,
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
    }).whenComplete(() {
      if (mounted) {
        _isMenuOpen.value = false;
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
          widget.controller.hideHomeStats.value ? 0.0 : (48.h + 20.h);
      double targetOffset = 80.h + statsHeight;

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
    final double targetOffset = clampedProgress * maxScroll;
    _lastScrollOffset = targetOffset;
    _lastMaxScroll = maxScroll;
    _scrollController.jumpTo(targetOffset);

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
    final mediaQuery = MediaQuery.of(context);
    final double topInset = mediaQuery.padding.top;
    final double bottomInset = mediaQuery.padding.bottom;
    final double topBlurHeight = 96.h + topInset;
    final double bottomBlurHeight = 112.h + bottomInset;

    return RepaintBoundary(
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (!_isScrubbing.value) {
                if (notification is ScrollStartNotification ||
                    notification is UserScrollNotification ||
                    notification is ScrollUpdateNotification) {
                  _showScrollIndicator();
                }
              }
              return false;
            },
            child: CustomScrollView(
              controller: _scrollController,
              cacheExtent: 600.0,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
              SliverAppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarBrightness:
                      Theme.of(context).brightness == Brightness.dark
                          ? Brightness.dark
                          : Brightness.light,
                  statusBarIconBrightness:
                      Theme.of(context).brightness == Brightness.dark
                          ? Brightness.light
                          : Brightness.dark,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarIconBrightness:
                      Theme.of(context).brightness == Brightness.dark
                          ? Brightness.light
                          : Brightness.dark,
                  systemNavigationBarDividerColor: Colors.transparent,
                  systemStatusBarContrastEnforced: false,
                  systemNavigationBarContrastEnforced: false,
                ),
                forceMaterialTransparency: true,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                // SliverAppBar (primary: true) already adds topInset internally.
                expandedHeight: 124.h,
                toolbarHeight: 48.h,
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
                        padding: EdgeInsets.fromLTRB(
                          16.w,
                          0,
                          16.w,
                          112.h + bottomInset,
                        ),
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
                    bottom: 140.h + bottomInset,
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
            height: topBlurHeight,
            child: IgnorePointer(
              child: ProgressiveEdgeBlur(
                edge: ProgressiveBlurEdge.top,
                sigma: 12,
                curve: Curves.easeIn,
                tint: appThemeColors.grey7.withValues(alpha: 0.28),
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
                final double maxExtent = 124.h;
                final double minExtent = 48.h;
                final double delta = maxExtent - minExtent;
                final double t = (offset / delta).clamp(0.0, 1.0);
                final double currentHeight = maxExtent - (delta * t);
                final double topPadding = 57.h * (1.0 - t);
                final double bottomPadding = 21.h - (15.h * t);
                final double fontSize = 28.sp - (4.sp * t);
                final double buttonSize = 44.w - (4.w * t);
                final double iconSize = 23.sp - (2.sp * t);
                final outerRadius = Radius.circular(buttonSize / 2);
                final innerRadius = Radius.circular(8.r);

                return Container(
                  height: currentHeight + topInset,
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: topInset + topPadding,
                    bottom: bottomPadding,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          style: TextStyle(
                            fontFamily: AppConstants.font,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                            color: appThemeColors.grey10,
                            letterSpacing: -0.2,
                          ),
                          child: const Text(AppConstants.appTitle),
                        ),
                      ),
                      _buildHeaderActionButton(
                        context: context,
                        icon: Icons.search_rounded,
                        iconSize: iconSize,
                        size: buttonSize,
                        borderRadius: BorderRadius.only(
                          topLeft: outerRadius,
                          bottomLeft: outerRadius,
                          topRight: innerRadius,
                          bottomRight: innerRadius,
                        ),
                        onTap: () => Get.to(() => const SearchView()),
                      ),
                      SizedBox(width: 3.w),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isMenuOpen,
                        builder: (context, isMenuOpen, _) {
                          return _buildHeaderActionButton(
                            context: context,
                            buttonKey: _menuKey,
                            icon: isMenuOpen
                                ? Icons.close_rounded
                                : Icons.more_horiz_rounded,
                            iconSize: iconSize,
                            size: buttonSize,
                            borderRadius: isMenuOpen
                                ? BorderRadius.circular(buttonSize / 2)
                                : BorderRadius.only(
                                    topLeft: innerRadius,
                                    bottomLeft: innerRadius,
                                    topRight: outerRadius,
                                    bottomRight: outerRadius,
                                  ),
                            onTap: () => _showPopupMenu(context),
                          );
                        },
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
            height: bottomBlurHeight,
            child: IgnorePointer(
              child: ProgressiveEdgeBlur(
                edge: ProgressiveBlurEdge.bottom,
                sigma: 12,
                curve: Curves.easeIn,
                tint: appThemeColors.grey7.withValues(alpha: 0.28),
              ),
            ),
          ),
          Positioned(
            bottom: 40.h + bottomInset,
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

            final (:trackTop, :trackHeight) = _scrollTrackMetrics(context);

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
                                        _tileDateFormat.format(date);

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
                                top: thumbCenterY -
                                    (circleSize / 2) -
                                    touchPaddingY.h,
                                width: 48.w,
                                height: circleSize + (touchPaddingY.h * 2),
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

  Widget _buildHeaderActionButton({
    required BuildContext context,
    Key? buttonKey,
    required IconData icon,
    required double iconSize,
    required double size,
    required BorderRadius borderRadius,
    required VoidCallback onTap,
  }) {
    final appThemeColors = AppTheme.colorsOf(context);

    return GestureDetector(
      key: buttonKey,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: appThemeColors.grey6,
          borderRadius: borderRadius,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: Icon(
            icon,
            key: ValueKey<IconData>(icon),
            size: iconSize,
            color: appThemeColors.grey10.withValues(alpha: 0.9),
          ),
        ),
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


