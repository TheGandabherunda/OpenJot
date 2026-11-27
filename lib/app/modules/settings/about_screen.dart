import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme.dart';
import '../../utils/custom_toast.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = AppConstants.loading.tr;

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
      CustomToast.showToast(
        AppConstants.couldNotLaunchUrl.tr,
        backgroundColor: appColors.grey7,
        textColor: appColors.grey10,
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
          AppConstants.aboutApp.tr,
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
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: appColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.versionPrefix.tr.replaceFirst('%s', _appVersion),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2,
                      fontSize: 14,
                      color: appColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppConstants.aboutSubtitle.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppConstants.keyFeatures.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FeatureText(text: AppConstants.aboutFeature1.tr),
                FeatureText(text: AppConstants.aboutFeature2.tr),
                FeatureText(text: AppConstants.aboutFeature3.tr),
                FeatureText(text: AppConstants.aboutFeature4.tr),
                FeatureText(text: AppConstants.aboutFeature5.tr),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              AppConstants.openSource.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppConstants.openSourceDesc.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppConstants.dataPrivacy.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppConstants.dataPrivacyDesc.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: appColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppConstants.linksTitle.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: AppConstants.font,
                letterSpacing: -0.2,
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
                    AppConstants.sourceCodeOnGithub.tr,
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: appColors.primary,
                    ),
                  ),
                  trailing: Icon(Icons.open_in_new,
                      size: 20, color: appColors.primary),
                  onTap: () =>
                      _launchURL('https://github.com/TheGandabherunda/OpenJot'),
                ),
                ListTile(
                  title: Text(
                    AppConstants.sendFeedback.tr,
                    style: TextStyle(
                      fontFamily: AppConstants.font,
                      letterSpacing: -0.2,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: appColors.primary,
                    ),
                  ),
                  trailing: Icon(Icons.open_in_new,
                      size: 20, color: appColors.primary),
                  onTap: () => _launchURL(
                      'https://github.com/TheGandabherunda/OpenJot/discussions/15'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Thank you for using OpenJot!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppConstants.font,
                  letterSpacing: -0.2,
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
          fontFamily: AppConstants.font,
          letterSpacing: -0.2,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
