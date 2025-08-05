import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'expanding_colors.dart';
import 'immersive_overlay_controller.dart';
import 'overlay_widget.dart';

class ImmersiveOverlay extends StatefulWidget {
  final Widget child;

  const ImmersiveOverlay({Key? key, required this.child}) : super(key: key);

  @override
  State<ImmersiveOverlay> createState() => _ImmersiveOverlayState();
}

class _ImmersiveOverlayState extends State<ImmersiveOverlay>
    with TickerProviderStateMixin {
  late AnimationController _warpController;
  late Animation<double> _warpAnimation;
  bool _displayOverlay = false;
  bool _isExiting = false;
  Widget? _contentComponent;
  ImmersiveColors _colors = ImmersiveColors.defaultColors;

  @override
  void initState() {
    super.initState();
    _warpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      reverseDuration: const Duration(milliseconds: 500),
    );

    _warpAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Cubic(0.4, -0.2, 0.2, 1.1))),
        weight: 300,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Cubic(0.4, -0.2, 0.2, 1.1))), // Match OverlayWidget's bounce
        weight: 900,
      ),
    ]).animate(_warpController);
  }

  @override
  void dispose() {
    _warpController.dispose();
    super.dispose();
  }

  void immerse({Widget? component, ImmersiveColors? colors}) {
    if (_isExiting || _displayOverlay) {
      print('Immerse called while exiting or overlay displayed');
      return;
    }
    setState(() {
      _contentComponent = component;
      _colors = colors ?? ImmersiveColors.defaultColors;
      _displayOverlay = true;
      _isExiting = false;
    });
    _warpController.forward(from: 0.0);
  }

  void startDismiss() {
    if (_isExiting) {
      print('Dismiss already in progress');
      return;
    }
    setState(() {
      _isExiting = true;
    });
    // The _warpController.reverse() call will still run, but the AnimatedBuilder
    // will use effectiveWarpValue = 0.0 when _isExiting is true, effectively
    // removing the exit scaling animation for the background.
    _warpController.reverse().then((_) {
      if (mounted) {
        completeDismiss();
      }
    }).catchError((error) {
      print('Error in dismiss animation: $error');
    });
  }

  void completeDismiss() {
    if (mounted) {
      setState(() {
        _displayOverlay = false;
        _contentComponent = null;
        _colors = ImmersiveColors.defaultColors;
        _isExiting = false;
      });
      _warpController.reset();
    }
  }

  Future<bool> _onPopInvoked() async {
    if (_displayOverlay && !_isExiting) {
      startDismiss();
      return false; // Prevent default back navigation
    }
    return true; // Allow default back navigation
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_displayOverlay || _isExiting,
      onPopInvoked: (didPop) async {
        if (!didPop && context.mounted) {
          final shouldPop = await _onPopInvoked();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: ImmersiveOverlayProvider(
        controller: ImmersiveOverlayController(
          immerse: ({component, colors}) =>
              immerse(component: component, colors: colors),
          dismiss: startDismiss,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _warpController,
              builder: (context, child) {
                const intensity = 0.1;
                // Calculate the effective warp value for the transform.
                // If the overlay is exiting, we want the background to immediately
                // revert to its original, un-warped state (effectiveWarpValue = 0.0).
                // Otherwise (during opening or when overlay is fully displayed),
                // use the animation value for the warp effect.
                final double effectiveWarpValue = _isExiting ? 0.0 : _warpAnimation.value;

                return Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..rotateX(-3 * effectiveWarpValue * (math.pi / 180))
                    ..setEntry(1, 0, -1.0 * effectiveWarpValue * (math.pi / 180))
                    ..scale(
                      1.0 - intensity * 0.4 * effectiveWarpValue,
                      1.0 + intensity * effectiveWarpValue,
                    ),
                  child: child,
                );
              },
              child: widget.child,
            ),
            if (_displayOverlay)
              OverlayWidget(
                contentComponent: _contentComponent,
                colors: _colors,
                onDismissed: completeDismiss,
                isExiting: _isExiting,
              ),
          ],
        ),
      ),
    );
  }
}
