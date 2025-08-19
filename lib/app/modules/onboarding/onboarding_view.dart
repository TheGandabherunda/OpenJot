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
          padding: const EdgeInsets.all(0.0),
          child: _AnimatedOnboardingContent(
            appThemeColors: appThemeColors,
            controller: controller,
          ),
        ),
      ),
    );
  }
}

class _AnimatedOnboardingContent extends StatefulWidget {
  final dynamic appThemeColors;
  final OnboardingController controller;

  const _AnimatedOnboardingContent({
    required this.appThemeColors,
    required this.controller,
  });

  @override
  State<_AnimatedOnboardingContent> createState() =>
      _AnimatedOnboardingContentState();
}

class _AnimatedOnboardingContentState extends State<_AnimatedOnboardingContent>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  // Animation timing constants (Apple-like)
  static const Duration _baseDuration = Duration(milliseconds: 600);
  static const Duration _staggerDelay = Duration(milliseconds: 150);
  static const Curve _animationCurve = Curves.easeOutCubic;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    // Create 6 animation controllers for each element
    _animationControllers = List.generate(
      6,
          (index) => AnimationController(duration: _baseDuration, vsync: this),
    );

    // Create fade animations
    _fadeAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: _animationCurve));
    }).toList();

    // Create slide animations (slide up from bottom)
    _slideAnimations = _animationControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0.0, 0.3), // Start slightly below
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: _animationCurve));
    }).toList();
  }

  void _startAnimations() {
    // Start animations with staggered delays
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: i * _staggerDelay.inMilliseconds),
            () {
          if (mounted) {
            _animationControllers[i].forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildAnimatedWidget(int index, Widget child) {
    return AnimatedBuilder(
      animation: _animationControllers[index],
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimations[index],
          child: SlideTransition(
            position: _slideAnimations[index],
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // App Icon (Element 0)
        _buildAnimatedWidget(
          0,
          Column(
            children: [
              SizedBox(height: 80.sp),
              SvgPicture.asset(
                'assets/app_icon.svg',
                height: 150.sp,
                // Apply a color filter to change the SVG color
                // colorFilter: ColorFilter.mode(
                //   appThemeColors.grey1,
                //   BlendMode.srcIn,
                // ),
              ),
              SizedBox(height: 48.sp),
            ],
          ),
        ),

        // Welcome Text (Element 1)
        _buildAnimatedWidget(
          1,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Text(
              AppConstants.welcomeToOpenJot,
              style: TextStyle(
                fontFamily: AppConstants.font,
                fontWeight: FontWeight.bold,
                fontSize: 32.sp,
                letterSpacing: -0.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Feature Tiles (Elements 2, 3, 4)
        Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            children: [
              _buildAnimatedWidget(
                2,
                Tile(
                  iconColor: widget.appThemeColors.primary,
                  textColor: widget.appThemeColors.grey1,
                  iconSize: 32.sp,
                  title: AppConstants.feature1,
                  icon: Icons.auto_fix_high_outlined,
                  fontSize: 16.sp,
                ),
              ),
              _buildAnimatedWidget(
                3,
                Tile(
                  iconColor: widget.appThemeColors.primary,
                  textColor: widget.appThemeColors.grey1,
                  iconSize: 32.sp,
                  title: AppConstants.feature2,
                  icon: Icons.sentiment_satisfied_alt_rounded,
                  fontSize: 16.sp,
                ),
              ),
              _buildAnimatedWidget(
                4,
                Tile(
                  iconColor: widget.appThemeColors.primary,
                  textColor: widget.appThemeColors.grey1,
                  iconSize: 32.sp,
                  fontSize: 16.sp,
                  title: AppConstants.feature3,
                  icon: Icons.lock_outlined,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Continue Button (Element 5)
        _buildAnimatedWidget(
          5,
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.sp),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: AppConstants.continueButton,
                    color: widget.appThemeColors.primary,
                    textColor: widget.appThemeColors.onPrimary,
                    onPressed: () {
                      widget.controller.navigateToHome();
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
