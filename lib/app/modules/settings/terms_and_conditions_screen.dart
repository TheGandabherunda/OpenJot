import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme
        .of(context)
        .colorScheme;

// List of third-party libraries from pubspec.yaml
    final List<String> thirdPartyLibraries = [
      // State Management & Routing
      'get',

      // Local Storage
      'hive',
      'hive_flutter',

      // UI & UX
      'cupertino_icons',
      'smooth_corner',
      'flutter_screenutil',
      'flutter_svg',
      'modal_bottom_sheet',
      'flutter_quill',
      'shimmer',
      'flutter_staggered_grid_view',
      'progressive_blur',
      'pinput',
      'fluttertoast',

      // Media & File Handling
      'permission_handler',
      'photo_manager',
      'photo_manager_image_provider',
      'camera',
      'video_player',
      'video_thumbnail',
      'record',
      'audioplayers',
      'file_picker',
      'archive',
      'pdf',
      'printing',

      // Location & Maps
      'flutter_map',
      'latlong2',
      'geolocator',

      // Sharing & Intents
      'share_plus',
      'receive_sharing_intent',

      // Notifications
      'flutter_local_notifications',
      'flutter_timezone',
      'timezone',

      // Authentication
      'local_auth',

      // Utilities
      'intl',
      'path_provider',
      'path',
      'uuid',
      'palette_generator',
      'url_launcher',
      'package_info_plus',
      'device_info_plus',
      'change_app_package_name',
    ];


    return Scaffold(
      backgroundColor: appColors.surface,
      appBar: AppBar(
        backgroundColor: appColors.surface,
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back_rounded, size: 24, color: appColors.primary),
          onPressed: () {
            HapticFeedback.lightImpact();
            Get.back();
          },
        ),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(
            fontSize: 24,
            height: 1.3,
            letterSpacing: -0.4,
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
              'Welcome to OpenJot! This document outlines the terms and conditions for using our application. By using OpenJot, you agree to these terms.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            const SectionTitle(title: 'Data Storage and Privacy'),
            const SizedBox(height: 12),
            Text(
              'OpenJot is designed to be a private space for your thoughts. All journal entries, including text, images, audio files, and other media, are stored exclusively on your local device. The application does not collect, store, or transmit any of your personal data to any external servers. We have no access to your content.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            const SectionTitle(title: 'User-Generated Content'),
            const SizedBox(height: 12),
            Text(
              'You are solely responsible for the content you create and store within OpenJot. This includes any text, images, audio recordings, and other files you add to your journal entries. You are responsible for ensuring you have the necessary rights to use any content you import into the app.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            const SectionTitle(title: 'Disclaimer of Warranty'),
            const SizedBox(height: 12),
            Text(
              'OpenJot is provided "as is" without any warranties, express or implied. We do not guarantee that the app will be error-free or uninterrupted. You use the application at your own risk.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            const SectionTitle(title: 'Limitation of Liability'),
            const SizedBox(height: 12),
            Text(
              'In no event shall the developers of OpenJot be liable for any direct, indirect, incidental, special, or consequential damages, including but not limited to, loss of data, arising out of the use or inability to use this application.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            const SectionTitle(title: 'Third-Party Libraries'),
            const SizedBox(height: 12),
            Text(
              'This application utilizes the following third-party libraries, each governed by its own license:',
              style: TextStyle(
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
                    (library) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        '• $library',
                        style: TextStyle(
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
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme
            .of(context)
            .colorScheme
            .onSurface,
      ),
    );
  }
}
