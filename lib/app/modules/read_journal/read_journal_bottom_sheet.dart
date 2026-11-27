import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_jot/app/modules/home/home_controller.dart';
import 'package:open_jot/app/modules/write_journal/write_journal_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/constants.dart';
import '../../core/models/journal_entry.dart';
import '../../core/theme.dart';
import '../../core/translations/app_translations.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/journal_card_grid.dart';
import '../../core/widgets/journal_quill_styles.dart';
import '../media_preview/media_preview_bottom_sheet.dart';
import '../../core/services/hive_service.dart';

class ReadJournalBottomSheet extends StatefulWidget {
  final JournalEntry entry;

  const ReadJournalBottomSheet({super.key, required this.entry});

  @override
  ReadJournalBottomSheetState createState() => ReadJournalBottomSheetState();
}

class ReadJournalBottomSheetState extends State<ReadJournalBottomSheet> {
  late JournalEntry _currentEntry;
  late quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _currentEntry = widget.entry;
    _initializeController();
  }

  void _initializeController() {
    final document =
    quill.Document.fromJson(_currentEntry.content.toDelta().toJson());
    _quillController = quill.QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  void _onEditPressed() async {
    final homeController = Get.find<HomeController>();
    // Find the most current version of the entry before editing.
    final entryToEdit = homeController.journalEntries
        .firstWhereOrNull((e) => e.id == _currentEntry.id);

    // If the entry is somehow gone before we even edit, just close.
    if (entryToEdit == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final wasDeleted = await showCupertinoModalBottomSheet<bool>(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        bottom: false,
        child: WriteJournalBottomSheet(entry: entryToEdit),
      ),
    );

    // If the edit sheet returns true, it means the entry was cleared and is now deleted.
    if (wasDeleted == true && mounted) {
      Navigator.of(context).pop();
      return;
    }

    // After the edit sheet closes, refresh the data from the controller.
    if (mounted) {
      // Find the latest version of the entry from the controller's list.
      final latestEntry = homeController.journalEntries
          .firstWhereOrNull((e) => e.id == widget.entry.id);

      if (latestEntry != null) {
        // If the entry still exists, update the state to reflect the changes.
        setState(() {
          _currentEntry = latestEntry;
          _quillController.dispose();
          _initializeController();
        });
      } else {
        // If it's null, it was deleted, so close the read sheet.
        Navigator.of(context).pop();
      }
    }
  }

  bool _isVideoFile(String path) {
    final lowercasedPath = path.toLowerCase();
    return lowercasedPath.endsWith('.mp4') ||
        lowercasedPath.endsWith('.mov') ||
        lowercasedPath.endsWith('.avi') ||
        lowercasedPath.endsWith('.wmv') ||
        lowercasedPath.endsWith('.mkv');
  }

  List<MediaItem> _getAllMediaItems() {
    final items = <MediaItem>[];
    for (final asset in _currentEntry.galleryImages) {
      items.add(MediaItem(asset: asset, type: asset.type, id: asset.id));
    }
    for (final photo in _currentEntry.cameraPhotos) {
      items.add(MediaItem(
        asset: photo,
        type: _isVideoFile(photo.file.path) ? AssetType.video : AssetType.image,
        id: photo.file.path,
      ));
    }
    if (_currentEntry.location != null) {
      items.add(MediaItem.location(_currentEntry.location!));
    }
    if (_currentEntry.moodIndex != null) {
      items.add(MediaItem.mood(_currentEntry.moodIndex!));
    }
    for (final audio in _currentEntry.galleryAudios) {
      items.add(MediaItem(
        asset: audio,
        type: AssetType.audio,
        id: audio.id,
        kind: MediaPreviewKind.audio,
      ));
    }
    for (final rec in _currentEntry.recordings) {
      items.add(MediaItem.recorded(rec));
    }
    return items;
  }

  void _openMediaPreview(int initialIndex) {
    final mediaItems = _getAllMediaItems();
    if (mediaItems.isEmpty || initialIndex < 0 || initialIndex >= mediaItems.length) {
      return;
    }

    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MediaPreviewBottomSheet(
        mediaItems: mediaItems,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hiveService = Get.find<HiveService>();
    final isPitchBlack = hiveService.pitchBlack;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appThemeColors = AppTheme.colorsOf(context);

    final backgroundColor = isPitchBlack
        ? (isDark ? Colors.black : Colors.white)
        : appThemeColors.grey6;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: _buildHeader(appThemeColors),
        titleSpacing: 16.w,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: _buildImagePreview(),
            ),
            if (_currentEntry.tags.isNotEmpty) ...[
              SizedBox(height: 12.h),
              _buildMoodField(appThemeColors),
            ],
            SizedBox(height: 16.h),
            _buildTextField(appThemeColors),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppThemeColors appThemeColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          _currentEntry.isBookmarked
              ? Icons.bookmark_rounded
              : Icons.bookmark_outline_rounded,
          color: _currentEntry.isBookmarked
              ? appThemeColors.primary
              : appThemeColors.grey2,
          size: 28.w,
        ),
        Text(
          AppTranslations.formatDate(_currentEntry.createdAt, 'EEEE, MMM d'),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppConstants.font,
            decoration: TextDecoration.none,
            color: appThemeColors.grey10.withAlpha((255 * 0.6).round()),
          ),
        ),
        CustomButton(
          onPressed: _onEditPressed,
          text: AppConstants.edit.tr,
          color: Colors.transparent,
          textColor: appThemeColors.grey10,
          textSize: 16.sp,
          textPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    final allMedia = [
      ..._currentEntry.galleryImages,
      ..._currentEntry.cameraPhotos,
    ];
    if (allMedia.isEmpty &&
        _currentEntry.location == null &&
        _currentEntry.moodIndex == null &&
        _currentEntry.galleryAudios.isEmpty &&
        _currentEntry.recordings.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
      child: JournalCardGrid(
        mediaItems: allMedia,
        location: _currentEntry.location,
        moodIndex: _currentEntry.moodIndex,
        galleryAudios: _currentEntry.galleryAudios,
        recordings: _currentEntry.recordings,
        onCardTap: _openMediaPreview,
      ),
    );
  }

  Widget _buildMoodField(AppThemeColors appThemeColors) {
    if (_currentEntry.tags.isEmpty) {
      return const SizedBox.shrink();
    }
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _currentEntry.tags
                .map(
                  (tag) => Padding(
                    padding: EdgeInsetsDirectional.only(end: 8.w),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppTheme.getTagBaseColor(
                            tag, Theme.of(context).brightness),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: AppTheme.getTagLightColor(
                              tag, Theme.of(context).brightness),
                          fontSize: 12.sp,
                          fontFamily: AppConstants.font,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(AppThemeColors appThemeColors) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: IgnorePointer(
          child: quill.QuillEditor.basic(
            controller: _quillController,
            focusNode: FocusNode(),
            config: quill.QuillEditorConfig(
              autoFocus: false,
              expands: false,
              padding: EdgeInsets.zero,
              customStyles: buildJournalQuillStyles(context, appThemeColors),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper extension to find an item in a list safely without throwing an error.
extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}