import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'expanding_colors.dart';

class GradientWidget extends StatefulWidget {
  final ImmersiveColors colors;
  final AnimationController animationController;
  final bool isExiting;

  const GradientWidget({
    Key? key,
    required this.colors,
    required this.animationController,
    this.isExiting = false,
  }) : super(key: key);

  @override
  State<GradientWidget> createState() => _GradientWidgetState();
}

class _GradientWidgetState extends State<GradientWidget> {
  late Animation<double> _blurIntensityAnimation;
  late Animation<double> _expandingCircleAnimation;
  late Animation<double> _expandingOpacityAnimation;
  late Animation<double> _backgroundCirclesAnimation;
  late Animation<double> _breathingAnimation;

  static const _initialBreathingTime = Duration(milliseconds: 1000);
  static const _repeatedBreathingTime = Duration(milliseconds: 7500);
  static const _breathingEasing = Cubic(0, 0.55, 0.45, 1);

  @override
  void initState() {
    super.initState();

    _blurIntensityAnimation = Tween<double>(begin: 0.0, end: 25.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _expandingCircleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: widget.isExiting ? Curves.linear : Curves.linear,
      ),
    );

    _expandingOpacityAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _backgroundCirclesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Curves.linear,
      ),
    );

    _breathingAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: _breathingEasing)),
        weight: _initialBreathingTime.inMilliseconds.toDouble(),
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.7)
            .chain(CurveTween(curve: Curves.linear)),
        weight: (_repeatedBreathingTime.inMilliseconds / 2).toDouble(),
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.7, end: 1.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: (_repeatedBreathingTime.inMilliseconds / 2).toDouble(),
      ),
    ]).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: _blurIntensityAnimation.value * 0.5,
                sigmaY: _blurIntensityAnimation.value * 0.5,
              ),
              child: Container(color: Colors.transparent),
            ),
            CustomPaint(
              painter: GradientPainter(
                expandingCircleProgress: _expandingCircleAnimation.value,
                expandingOpacity: widget.isExiting ? _expandingOpacityAnimation.value : 1.0,
                backgroundCirclesProgress: _backgroundCirclesAnimation.value,
                breathingProgress: widget.isExiting ? 0.0 : _breathingAnimation.value,
                colors: widget.colors,
                isDark: isDark,
              ),
              size: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height,
              ),
            ),
          ],
        );
      },
    );
  }
}

class GradientPainter extends CustomPainter {
  final double expandingCircleProgress;
  final double expandingOpacity;
  final double backgroundCirclesProgress;
  final double breathingProgress;
  final ImmersiveColors colors;
  final bool isDark;

  GradientPainter({
    required this.expandingCircleProgress,
    required this.expandingOpacity,
    required this.backgroundCirclesProgress,
    required this.breathingProgress,
    required this.colors,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintExpandingCircle(canvas, size);
    _paintBackgroundCircles(canvas, size);
  }

  void _paintExpandingCircle(Canvas canvas, Size size) {
    final expandingColors = isDark
        ? ColorUtils.generateExpandingColors(colors.expanding.dark)
        : ColorUtils.generateExpandingColors(colors.expanding.light);

    if (expandingColors.isEmpty) return;

    Color currentColor;
    if (expandingCircleProgress <= 0) {
      currentColor = expandingColors.first;
    } else if (expandingCircleProgress >= 1) {
      currentColor = expandingColors.last;
    } else {
      final segmentCount = expandingColors.length - 1;
      final segment = (expandingCircleProgress * segmentCount).floor();
      final segmentProgress = (expandingCircleProgress * segmentCount) - segment;

      final color1 = expandingColors[segment];
      final color2 = expandingColors[segment + 1];

      currentColor = Color.lerp(color1, color2, segmentProgress)!;
    }

    final paint = Paint()
      ..color = currentColor.withOpacity(expandingOpacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);

    final cr = size.width / 3;
    final centerX = size.width / 2;
    final centerY = size.height + cr;

    final scale = ui.lerpDouble(0, 10, expandingCircleProgress)!;

    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.scale(scale, scale);
    canvas.translate(-centerX, -centerY);
    canvas.drawCircle(Offset(centerX, centerY), cr, paint);
    canvas.restore();
  }

  void _paintBackgroundCircles(Canvas canvas, Size size) {
    final primaryPaint = Paint()
      ..color = colors.primary.withOpacity(backgroundCirclesProgress * 1.0)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 300);

    final secondaryPaint = Paint()
      ..color = colors.secondary.withOpacity(backgroundCirclesProgress * 1.0)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 250);

    final cr = size.width;

    canvas.save();
    canvas.translate(size.width / 2, size.height);
    canvas.scale(breathingProgress, breathingProgress);
    canvas.translate(-(size.width / 2), -size.height);
    canvas.drawCircle(Offset(-(cr / 3), 0), cr, primaryPaint);
    canvas.restore();

    canvas.save();
    canvas.translate(size.width / 2, size.height);
    canvas.scale(breathingProgress, breathingProgress);
    canvas.translate(-(size.width / 2), -size.height);
    canvas.drawCircle(Offset(cr + (cr / 3), size.height), cr, secondaryPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(GradientPainter oldDelegate) {
    return oldDelegate.expandingCircleProgress != expandingCircleProgress ||
        oldDelegate.expandingOpacity != expandingOpacity ||
        oldDelegate.backgroundCirclesProgress != backgroundCirclesProgress ||
        oldDelegate.breathingProgress != breathingProgress ||
        oldDelegate.colors != colors ||
        oldDelegate.isDark != isDark;
  }
}