import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;

    // List of third-party libraries from pubspec.yaml
    final List<String> thirdPartyLibraries = [
      // --- STATE MANAGEMENT & ROUTING ---
      'get',

      // --- LOCAL STORAGE ---
      'hive',
      'hive_flutter',
      'sqflite',
      'markdown_quill',

      // --- UI & UX ---
      'flutter_quill',
      'flutter_screenutil',
      'flutter_staggered_grid_view',
      'flutter_svg',
      'vector_graphics',
      'modal_bottom_sheet',
      'scroll_edge_blur',
      'shimmer',
      'smooth_corner',

      // --- MEDIA & FILE HANDLING ---
      'archive',
      'audioplayers',
      'camera',
      'file_picker',
      'pdf',
      'permission_handler',
      'photo_manager',
      'photo_manager_image_provider',
      'printing',
      'record',
      'video_player',
      'get_thumbnail_video',
      'image',

      // --- LOCATION & MAPS ---
      'flutter_map',
      'latlong2',

      // --- NOTIFICATIONS ---
      'flutter_local_notifications',
      'flutter_timezone',
      'timezone',

      // --- AUTHENTICATION ---
      'local_auth',

      // --- UTILITIES ---
      'device_info_plus',
      'intl',
      'package_info_plus',
      'palette_generator',
      'path',
      'path_provider',
      'url_launcher',
      'uuid',
    ];

    return Scaffold(
      backgroundColor: appColors.surface,
      appBar: AppBar(
        backgroundColor: appColors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              size: 24, color: appColors.primary),
          onPressed: () {
            HapticFeedback.lightImpact();
            Get.back();
          },
        ),
        title: Text(
          AppConstants.termsNConditions.tr,
          style: TextStyle(
            fontFamily: AppConstants.font,
            letterSpacing: -0.2,
            fontSize: 24,
            height: 1.3,
            color: appColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.termsIntro.tr,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontStyle: FontStyle.italic,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            SectionTitle(title: AppConstants.termsSectionDataPrivacy.tr),
            const SizedBox(height: 12),
            Text(
              AppConstants.termsSectionDataPrivacyBody.tr,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            SectionTitle(title: AppConstants.termsSectionUserContent.tr),
            const SizedBox(height: 12),
            Text(
              AppConstants.termsSectionUserContentBody.tr,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            SectionTitle(title: AppConstants.termsSectionDisclaimer.tr),
            const SizedBox(height: 12),
            Text(
              AppConstants.termsSectionDisclaimerBody.tr,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            SectionTitle(title: AppConstants.termsSectionLiability.tr),
            const SizedBox(height: 12),
            Text(
              AppConstants.termsSectionLiabilityBody.tr,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            SectionTitle(title: AppConstants.termsSectionThirdParty.tr),
            const SizedBox(height: 12),
            Text(
              AppConstants.termsSectionThirdPartyBody.tr,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: thirdPartyLibraries
                  .map(
                    (library) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    '• $library',
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: appColors.onSurfaceVariant,
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 32),
            Text(
              'By using OpenJot, you agree to these terms and conditions. If you do not agree with any part of these terms, you must not use the application.',
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: AppConstants.font,
        letterSpacing: -0.2,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
