import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSliderWithTooltip extends StatefulWidget {
  final double min;
  final double max;
  final double initialValue;
  final ValueChanged<double>? onChanged;
  final Color activeColor;
  final Color unfocusedActiveColor;
  final Color inactiveColor;
  final double unfocusedTrackHeight;
  final double focusedTrackHeight;
  final Duration animationDuration;
  final double animationCurvePeriod;
  final TextStyle? tooltipTextStyle;
  final Color? tooltipBackgroundColor;
  final bool showValueTooltip;
  final String? minLabel;
  final String? maxLabel;
  final TextStyle? labelTextStyle;
  final EdgeInsets unfocusedTrackPadding;
  final EdgeInsets focusedTrackPadding;
  final double gapWidth;
  final Color? dividerColor;
  final int? divisions;
  final bool hapticOnCheckpoints;

  const CustomSliderWithTooltip({
    super.key,
    this.min = 0.0,
    this.max = 100.0,
    this.initialValue = 0.0,
    this.onChanged,
    this.activeColor = Colors.blueAccent,
    this.unfocusedActiveColor = Colors.white,
    this.inactiveColor = Colors.grey,
    this.unfocusedTrackHeight = 10.0,
    this.focusedTrackHeight = 20.0,
    this.animationDuration = const Duration(milliseconds: 750),
    this.animationCurvePeriod = 0.8,
    this.tooltipTextStyle,
    this.tooltipBackgroundColor,
    this.showValueTooltip = true,
    this.minLabel,
    this.maxLabel,
    this.labelTextStyle,
    this.unfocusedTrackPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.focusedTrackPadding = EdgeInsets.zero,
    this.gapWidth = 12.0,
    this.dividerColor,
    this.divisions,
    this.hapticOnCheckpoints = true,
  }) : assert(initialValue >= min && initialValue <= max);

  @override
  State<CustomSliderWithTooltip> createState() =>
      _CustomSliderWithTooltipState();
}

class _CustomSliderWithTooltipState extends State<CustomSliderWithTooltip>
    with SingleTickerProviderStateMixin {
  // ValueNotifiers for animation properties
  late final ValueNotifier<double> _trackHeightNotifier;
  late final ValueNotifier<Color> _activeTrackColorNotifier;
  late final ValueNotifier<EdgeInsets> _trackPaddingNotifier;
  late final ValueNotifier<double> _currentProgressNotifier;

  // Animation curve and overshoot factor
  late ElasticOutCurve _animationCurve;
  late double _overshootFactor;

  // Internal state variables
  double _currentSliderValue = 0.0;
  bool _isInteracting = false;
  int? _lastHapticCheckpoint;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.initialValue;
    _lastHapticCheckpoint = _checkpointForValue(widget.initialValue);

    _currentProgressNotifier = ValueNotifier(
        ((widget.initialValue - widget.min) / (widget.max - widget.min))
            .clamp(0.0, 1.0));
    _currentProgressNotifier.addListener(_onProgressChanged);

    _updateAnimationCurveInfo();

    _trackHeightNotifier = ValueNotifier(widget.unfocusedTrackHeight);
    _activeTrackColorNotifier = ValueNotifier(widget.unfocusedActiveColor);
    _trackPaddingNotifier = ValueNotifier(widget.unfocusedTrackPadding);
  }

  @override
  void didUpdateWidget(covariant CustomSliderWithTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationCurvePeriod != oldWidget.animationCurvePeriod ||
        widget.unfocusedTrackHeight != oldWidget.unfocusedTrackHeight ||
        widget.focusedTrackHeight != oldWidget.focusedTrackHeight ||
        widget.animationDuration != oldWidget.animationDuration ||
        widget.unfocusedTrackPadding != oldWidget.unfocusedTrackPadding ||
        widget.focusedTrackPadding != oldWidget.focusedTrackPadding ||
        widget.activeColor != oldWidget.activeColor ||
        widget.unfocusedActiveColor != oldWidget.unfocusedActiveColor) {
      _updateAnimationCurveInfo();

      if (!_isInteracting) {
        _trackHeightNotifier.value = widget.unfocusedTrackHeight;
        _activeTrackColorNotifier.value = widget.unfocusedActiveColor;
        _trackPaddingNotifier.value = widget.unfocusedTrackPadding;
      } else {
        _trackHeightNotifier.value = widget.focusedTrackHeight;
        _activeTrackColorNotifier.value = widget.activeColor;
        _trackPaddingNotifier.value = widget.focusedTrackPadding;
      }
    }
    if (widget.initialValue != oldWidget.initialValue) {
      _currentProgressNotifier.value =
          ((widget.initialValue - widget.min) / (widget.max - widget.min))
              .clamp(0.0, 1.0);
    }
  }

  @override
  void dispose() {
    _trackHeightNotifier.dispose();
    _activeTrackColorNotifier.dispose();
    _trackPaddingNotifier.dispose();
    _currentProgressNotifier.removeListener(_onProgressChanged);
    _currentProgressNotifier.dispose();
    super.dispose();
  }

  // Interaction handlers
  void _startInteraction() {
    if (!mounted) return;
    setState(() {
      _isInteracting = true;
    });
    _trackHeightNotifier.value = widget.focusedTrackHeight;
    _activeTrackColorNotifier.value = widget.activeColor;
    _trackPaddingNotifier.value = widget.focusedTrackPadding;
  }

  int _checkpointForValue(double value) {
    final divs = widget.divisions;
    if (divs != null && divs > 0) {
      final norm =
          ((value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
      return (norm * divs).round();
    }
    return value.round();
  }

  void _updateProgressFromGlobalPosition(Offset globalPosition, BoxConstraints constraints) {
    final double effectiveTrackWidth =
        constraints.maxWidth - widget.unfocusedTrackPadding.horizontal;
    if (effectiveTrackWidth <= 0) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(globalPosition);
    final double adjustedDx = localPosition.dx - widget.unfocusedTrackPadding.left;

    double newProgress = (adjustedDx / effectiveTrackWidth).clamp(0.0, 1.0);
    final divs = widget.divisions;
    if (divs != null && divs > 0) {
      final int snapped = (newProgress * divs).round().clamp(0, divs);
      newProgress = snapped / divs;
    }

    _currentProgressNotifier.value = newProgress;
  }

  void _endInteraction() {
    if (!mounted) return;
    setState(() {
      _isInteracting = false;
    });
    _trackHeightNotifier.value = widget.unfocusedTrackHeight;
    _activeTrackColorNotifier.value = widget.unfocusedActiveColor;
    _trackPaddingNotifier.value = widget.unfocusedTrackPadding;
  }

  void _onProgressChanged() {
    final newValue =
        lerpDouble(widget.min, widget.max, _currentProgressNotifier.value) ??
            widget.initialValue;
    if (newValue != _currentSliderValue) {
      final newCheckpoint = _checkpointForValue(newValue);
      final prevCheckpoint =
          _lastHapticCheckpoint ?? _checkpointForValue(_currentSliderValue);
      if (widget.hapticOnCheckpoints &&
          _isInteracting &&
          newCheckpoint != prevCheckpoint) {
        _lastHapticCheckpoint = newCheckpoint;
        HapticFeedback.selectionClick();
      } else {
        _lastHapticCheckpoint = newCheckpoint;
      }
      setState(() {
        _currentSliderValue = newValue;
      });
      widget.onChanged?.call(_currentSliderValue);
    }
  }

  void _updateAnimationCurveInfo() {
    _animationCurve = ElasticOutCurve(widget.animationCurvePeriod);
    _overshootFactor =
        _animationCurve.transform(widget.animationCurvePeriod / 2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTooltipTextStyle = widget.tooltipTextStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ) ??
        const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );

    final defaultLabelTextStyle = widget.labelTextStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: Colors.grey.shade700,
        ) ??
        const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        );

    final defaultTooltipBackgroundColor =
        widget.tooltipBackgroundColor ?? theme.colorScheme.primary;

    // Estimated heights for layout to prevent shifts
    final double tooltipEstimatedHeight = widget.showValueTooltip ? 20.0 : 0.0;
    final double tooltipToSliderGap = widget.showValueTooltip ? 3.0 : 0.0;
    final double labelEstimatedHeight =
    (widget.minLabel != null || widget.maxLabel != null) ? 14.0 : 0.0;
    final double sliderToLabelGap =
    (widget.minLabel != null || widget.maxLabel != null) ? 15.0 : 0.0;

    // Calculate total height to prevent layout shifts
    final double fixedOverallHeight = tooltipEstimatedHeight +
        tooltipToSliderGap +
        (widget.focusedTrackHeight * _overshootFactor) +
        sliderToLabelGap +
        labelEstimatedHeight;

    final double maxSliderTrackHeight =
        widget.focusedTrackHeight * _overshootFactor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double effectiveTrackWidth =
            constraints.maxWidth - widget.unfocusedTrackPadding.horizontal;
        final double thumbPosition = widget.unfocusedTrackPadding.left +
            (_currentProgressNotifier.value * effectiveTrackWidth);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragDown: (details) {
            _startInteraction();
            _updateProgressFromGlobalPosition(details.globalPosition, constraints);
          },
          onHorizontalDragStart: (details) {
            _startInteraction();
            _updateProgressFromGlobalPosition(details.globalPosition, constraints);
          },
          onHorizontalDragUpdate: (details) {
            _updateProgressFromGlobalPosition(details.globalPosition, constraints);
          },
          onHorizontalDragEnd: (_) => _endInteraction(),
          onHorizontalDragCancel: _endInteraction,
          onTapDown: (details) {
            _startInteraction();
            _updateProgressFromGlobalPosition(details.globalPosition, constraints);
          },
          onTapUp: (_) => _endInteraction(),
          onTapCancel: _endInteraction,
          child: Container(
            height: fixedOverallHeight,
            alignment: Alignment.center,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Min and Max Labels
                if (widget.minLabel != null)
                  Positioned(
                    left: widget.unfocusedTrackPadding.left,
                    bottom: 0,
                    child: Text(
                      widget.minLabel!,
                      style: defaultLabelTextStyle,
                    ),
                  ),
                if (widget.maxLabel != null)
                  Positioned(
                    right: widget.unfocusedTrackPadding.right,
                    bottom: 0,
                    child: Text(
                      widget.maxLabel!,
                      style: defaultLabelTextStyle,
                    ),
                  ),
                // Slider Track Container
                Positioned(
                  left: 0,
                  right: 0,
                  height: maxSliderTrackHeight,
                  bottom: labelEstimatedHeight + sliderToLabelGap,
                  child: ValueListenableBuilder<EdgeInsets>(
                    valueListenable: _trackPaddingNotifier,
                    builder: (context, currentPadding, child) {
                      return AnimatedPadding(
                        duration: widget.animationDuration,
                        curve: _animationCurve,
                        padding: currentPadding,
                        child: child,
                      );
                    },
                    child: ValueListenableBuilder<double>(
                      valueListenable: _trackHeightNotifier,
                      builder: (context, currentHeight, child) {
                        return Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: maxSliderTrackHeight, // Changed from currentHeight to allow overflow
                            width: double.infinity,
                            child: child,
                          ),
                        );
                      },
                      child: ValueListenableBuilder<Color>(
                        valueListenable: _activeTrackColorNotifier,
                        builder: (context, currentActiveColor, child) {
                          return ValueListenableBuilder<double>(
                            valueListenable: _currentProgressNotifier,
                            builder: (context, progress, _) {
                              return ValueListenableBuilder<double>(
                                valueListenable: _trackHeightNotifier,
                                builder: (context, currentHeight, _) {
                                  return Row(
                                    children: [
                                      // Active part
                                      if (progress > 0)
                                        Expanded(
                                          flex: (progress * 1000)
                                              .round()
                                              .clamp(1, 1000),
                                          child: AnimatedContainer(
                                            duration: widget.animationDuration,
                                            curve: _animationCurve,
                                            height: currentHeight,
                                            decoration: BoxDecoration(
                                              color: currentActiveColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      currentHeight / 2),
                                            ),
                                          ),
                                        ),
                                      // Always show divider line (including extremes)
                                      SizedBox(
                                        width: widget.gapWidth,
                                        child: Center(
                                          child: AnimatedContainer(
                                            duration: widget.animationDuration,
                                            curve: _animationCurve,
                                            width: 8.0,
                                            height: currentHeight * 2.0,
                                            decoration: BoxDecoration(
                                              color: widget.dividerColor ??
                                                  (theme.brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black87),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Inactive part
                                      if (progress < 1)
                                        Expanded(
                                          flex: ((1 - progress) * 1000)
                                              .round()
                                              .clamp(1, 1000),
                                          child: AnimatedContainer(
                                            duration: widget.animationDuration,
                                            curve: _animationCurve,
                                            height: currentHeight,
                                            decoration: BoxDecoration(
                                              color: widget.inactiveColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      currentHeight / 2),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Tooltip
                if (widget.showValueTooltip)
                  Positioned(
                    left: thumbPosition,
                    bottom: labelEstimatedHeight +
                        sliderToLabelGap +
                        maxSliderTrackHeight +
                        tooltipToSliderGap,
                    child: AnimatedOpacity(
                      duration: widget.animationDuration,
                      curve: _animationCurve,
                      opacity: _isInteracting ? 1.0 : 0.0,
                      child: Transform.translate(
                        offset: Offset(
                          -((_currentSliderValue.round().toString().length *
                              7.0) +
                              16) /
                              2,
                          0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: defaultTooltipBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _currentSliderValue.round().toString(),
                            style: defaultTooltipTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}