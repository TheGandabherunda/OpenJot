// immersive_overlay_controller.dart
import 'package:flutter/material.dart';
import 'expanding_colors.dart';

class ImmersiveOverlayController {
  final Function({Widget? component, ImmersiveColors? colors}) immerse;
  final VoidCallback dismiss;

  ImmersiveOverlayController({required this.immerse, required this.dismiss});

  static ImmersiveOverlayController of(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<ImmersiveOverlayProvider>();
    if (provider == null) {
      throw FlutterError(
        'ImmersiveOverlayController.of() called with a context that does not contain an ImmersiveOverlayProvider.\n'
            'Make sure the context comes from a descendant of ImmersiveOverlay.',
      );
    }
    return provider.controller;
  }
}

class ImmersiveOverlayProvider extends InheritedWidget {
  final ImmersiveOverlayController controller;

  const ImmersiveOverlayProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ImmersiveOverlayProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}