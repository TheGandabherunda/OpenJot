import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/widgets/custom_button.dart';

import '../../core/theme.dart';
import '../../core/widgets/tile.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);

    return Scaffold(
      backgroundColor: appThemeColors.grey7,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _OnboardingContent(
            appThemeColors: appThemeColors,
            controller: controller,
          ),
        ),
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  final dynamic appThemeColors;
  final OnboardingController controller;

  const _OnboardingContent({
    required this.appThemeColors,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // App Icon
        _AnimatedElement(
          delay: const Duration(milliseconds: 200),
          child: Column(
            children: [
              SizedBox(height: 80.sp),
              SvgPicture.asset(
                'assets/app_icon.svg',
                height: 150.sp,
              ),
              SizedBox(height: 48.sp),
            ],
          ),
        ),

        // Welcome Text
        _AnimatedElement(
          delay: const Duration(milliseconds: 400),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Text(
              AppConstants.welcomeToOpenJot,
              style: TextStyle(
                fontFamily: AppConstants.font,
                fontWeight: FontWeight.bold,
                fontSize: 32.sp,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Feature Tiles
        _AnimatedElement(
          delay: const Duration(milliseconds: 600),
          child: Tile(
            iconColor: appThemeColors.primary,
            textColor: appThemeColors.grey1,
            iconSize: 32.sp,
            title: AppConstants.feature1,
            icon: Icons.auto_fix_high_outlined,
            fontSize: 16.sp,
          ),
        ),
        _AnimatedElement(
          delay: const Duration(milliseconds: 800),
          child: Tile(
            iconColor: appThemeColors.primary,
            textColor: appThemeColors.grey1,
            iconSize: 32.sp,
            title: AppConstants.feature2,
            icon: Icons.sentiment_satisfied_alt_rounded,
            fontSize: 16.sp,
          ),
        ),
        _AnimatedElement(
          delay: const Duration(milliseconds: 1000),
          child: Tile(
            iconColor: appThemeColors.primary,
            textColor: appThemeColors.grey1,
            iconSize: 32.sp,
            fontSize: 16.sp,
            title: AppConstants.feature3,
            icon: Icons.lock_outlined,
          ),
        ),

        const Spacer(),

        // Continue Button
        _AnimatedElement(
          delay: const Duration(milliseconds: 1200),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.sp),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: AppConstants.continueButton,
                    color: appThemeColors.primary,
                    textColor: appThemeColors.onPrimary,
                    onPressed: () {
                      controller.navigateToHome();
                    },
                    textPadding: EdgeInsets.symmetric(
                      horizontal: 56.sp,
                      vertical: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.sp),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom animated element widget with blur, fade-in, and slide-up effect
class _AnimatedElement extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const _AnimatedElement({
    required this.child,
    required this.delay,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<_AnimatedElement> createState() => _AnimatedElementState();
}

class _AnimatedElementState extends State<_AnimatedElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Fade animation (0 to 1)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ));

    // Slide animation (from 30 pixels up to 0)
    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    // Blur animation (from 10 to 0)
    _blurAnimation = Tween<double>(
      begin: 10.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
