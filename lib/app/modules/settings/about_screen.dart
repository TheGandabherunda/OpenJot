import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _appVersion = 'N/A';
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final appColors = AppTheme.colorsOf(context);
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Could not launch URL",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: appColors.grey7,
          textColor: appColors.grey10,
          fontSize: 16.0
      );
    }
  }

  Future<void> _sendEmail(String email, String subject) async {
    final appColors = AppTheme.colorsOf(context);
    final String encodedSubject = Uri.encodeComponent(subject);
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$encodedSubject',
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch email client.';
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Could not open email app. Is one installed?",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: appColors.grey7,
          textColor: appColors.grey10,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;

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
          'About OpenJot',
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
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  SvgPicture.asset(
                    'assets/app_icon.svg',
                    width: 80,
                    height: 80,
                    placeholderBuilder: (context) => Icon(
                      Icons.apps,
                      size: 80,
                      color: appColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'OpenJot',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: appColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version: $_appVersion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: appColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'A minimal, open-source journal to log your thoughts, moods, and memories. All your data stays on your device.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Key Features',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FeatureText(text: '• Clean, distraction-free writing experience.'),
                FeatureText(text: '• Add photos, voice notes, and music to your entries.'),
                FeatureText(text: '• Record your mood alongside your journals.'),
                FeatureText(text: '• Personalize with different text styles.'),
                FeatureText(text: '• Works fully offline, your data stays on your device.'),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Open Source',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'OpenJot is an open-source application. The source code is publicly available for anyone to inspect, modify, and contribute. We believe in transparency and community collaboration.',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Data Privacy',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We value your privacy. OpenJot does not collect, store, or transmit any of your personal data. All your journal entries, including text, images, and audio files, are stored exclusively on your device.',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Links',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                ListTile(
                  title: Text(
                    'Source Code on GitHub',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: appColors.primary,
                    ),
                  ),
                  trailing: Icon(Icons.open_in_new,
                      size: 20, color: appColors.primary),
                  onTap: () => _launchURL(
                      'https://github.com/TheGandabherunda/OpenJot'),
                ),
                ListTile(
                  title: Text(
                    'Send Feedback',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: appColors.primary,
                    ),
                  ),
                  trailing: Icon(Icons.mail_outline,
                      size: 20, color: appColors.primary),
                  onTap: () => _sendEmail(
                      'arunuserx@gmail.com', 'Feedback about OpenJot'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Thank you for using OpenJot!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: appColors.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class FeatureText extends StatelessWidget {
  final String text;

  const FeatureText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
