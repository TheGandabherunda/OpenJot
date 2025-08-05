import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'expanding_colors.dart';
import 'gradient_overlay.dart';

class OverlayWidget extends StatefulWidget {
  final Widget? contentComponent;
  final ImmersiveColors colors;
  final VoidCallback onDismissed;
  final bool isExiting;

  const OverlayWidget({
    Key? key,
    this.contentComponent,
    required this.colors,
    required this.onDismissed,
    required this.isExiting,
  }) : super(key: key);

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleYAnimation;
  late Animation<double> _scaleXAnimation;
  late Animation<double> _rotateXAnimation;
  late Animation<double> _translateYAnimation;
  bool _isExiting = false;
  bool _animationsInitialized = false;

  static const _animationDuration = Duration(milliseconds: 500);
  static const _easingBezier = Curves.easeInOut;
  static const _springCurve = Cubic(
    0.4,
    -0.2,
    0.2,
    1.1,
  ); // Quick, subtle bounce

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: _animationDuration,
      reverseDuration: _animationDuration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: _easingBezier));

    _scaleYAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: _easingBezier,
        reverseCurve: _easingBezier,
      ),
    );

    _scaleXAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: _easingBezier,
        reverseCurve: _easingBezier,
      ),
    );

    _rotateXAnimation = Tween<double>(begin: -3.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: _easingBezier,
        reverseCurve: _easingBezier,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_animationsInitialized) {
      _translateYAnimation = Tween<double>(
        begin: MediaQuery.of(context).size.height,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: _springCurve, // Quick, subtle bounce
          reverseCurve: _easingBezier,
        ),
      );

      _animationsInitialized = true;
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(OverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExiting && !_isExiting) {
      _startExitAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startExitAnimation() {
    if (_isExiting) {
      print('Exit animation already in progress');
      return;
    }
    if (_controller.isAnimating) {
      print('Stopping current animation');
      _controller.stop();
    }

    setState(() {
      _isExiting = true;
    });

    print('Starting exit animation');
    _controller
        .reverse()
        .then((_) {
          print('Exit animation completed');
          if (mounted) {
            widget.onDismissed();
          }
        })
        .catchError((error) {
          print('Error in exit animation: $error');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: GradientWidget(
            colors: widget.colors,
            animationController: _controller,
            isExiting: _isExiting,
          ),
        ),

        if (widget.contentComponent != null)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              print(
                'Animating with opacity: ${_opacityAnimation.value}, isExiting: $_isExiting',
              );
              return Opacity(
                opacity: _opacityAnimation.value.clamp(0.0, 1.0),
                child: Transform(
                  alignment: Alignment.bottomCenter,
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(_rotateXAnimation.value * (math.pi / 180))
                        ..scale(_scaleXAnimation.value, _scaleYAnimation.value)
                        ..translate(0.0, _translateYAnimation.value),
                  child: child,
                ),
              );
            },
            child: widget.contentComponent,
          ),
      ],
    );
  }
}
