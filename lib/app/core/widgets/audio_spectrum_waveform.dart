import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:path/path.dart' as p;

/// Shared minimal equalizer / recorded spectrum waveform widget.
///
/// Renders evenly spaced vertical rounded capsule bars centered around the
/// midline. When [progress] is `null`, it renders a live equalizer. When
/// [progress] is provided (`0.0`..`1.0`), it renders recorded playback
/// progress and supports tap/drag seeking via [onSeek].
class AudioSpectrumWaveform extends StatelessWidget {
  const AudioSpectrumWaveform({
    super.key,
    required this.levels,
    required this.activeColor,
    required this.inactiveColor,
    this.progress,
    this.height = 84,
    this.barWidth = 3.2,
    this.minBarHeight = 4.0,
    this.playheadColor,
    this.onSeek,
  });

  final List<double> levels;
  final Color activeColor;
  final Color inactiveColor;
  final double? progress;
  final double height;
  final double barWidth;
  final double minBarHeight;
  final Color? playheadColor;
  final ValueChanged<double>? onSeek;

  /// Normalizes a `record` dBFS reading (typically `-60..0`) into `0.0..1.0`.
  static double normalizeDb(double dbfs) {
    final linear = ((dbfs + 52.0) / 48.0).clamp(0.0, 1.0);
    return math.pow(linear, 0.85).toDouble();
  }

  /// Peak-preserving downsample of recorded amplitude samples into [targetCount]
  /// normalized bars suitable for playback spectrum display.
  static List<double> downsampleLevels(
    List<double> samples, {
    int targetCount = 44,
  }) {
    if (samples.isEmpty) {
      return List<double>.filled(targetCount, 0.08);
    }
    if (samples.length == targetCount) {
      return samples.map((e) => e.clamp(0.05, 1.0)).toList();
    }
    if (samples.length < targetCount) {
      final result = <double>[];
      for (int i = 0; i < targetCount; i++) {
        final pos = (i / (targetCount - 1)) * (samples.length - 1);
        final lo = pos.floor();
        final hi = math.min(samples.length - 1, pos.ceil());
        final frac = pos - lo;
        final val = lerpDouble(samples[lo], samples[hi], frac) ?? samples[lo];
        result.add(val.clamp(0.05, 1.0));
      }
      return result;
    }

    final result = <double>[];
    final step = samples.length / targetCount;
    for (int i = 0; i < targetCount; i++) {
      final start = (i * step).floor();
      final end = math.max(start + 1, ((i + 1) * step).floor()).clamp(0, samples.length);
      double maxVal = 0.0;
      double sumVal = 0.0;
      for (int j = start; j < end; j++) {
        final v = samples[j];
        if (v > maxVal) maxVal = v;
        sumVal += v;
      }
      final avg = sumVal / math.max(1, end - start);
      final combined = (maxVal * 0.72 + avg * 0.28).clamp(0.05, 1.0);
      result.add(combined);
    }
    return result;
  }

  static String storageKeyForPath(String filePath) {
    return 'audio_waveform_${p.basename(filePath)}';
  }

  static void saveWaveform(HiveService hiveService, String filePath, List<double> bars) {
    hiveService.settingsBox.put(storageKeyForPath(filePath), bars);
  }

  static List<double>? loadWaveform(HiveService hiveService, String filePath) {
    final raw = hiveService.settingsBox.get(storageKeyForPath(filePath));
    if (raw is List) {
      return raw
          .whereType<num>()
          .map((e) => e.toDouble().clamp(0.05, 1.0))
          .toList();
    }
    return null;
  }

  static void deleteWaveform(HiveService hiveService, String filePath) {
    hiveService.settingsBox.delete(storageKeyForPath(filePath));
  }

  /// Deterministic wave contour fallback for legacy recordings created before
  /// amplitude spectrum persistence was added.
  static List<double> fallbackLevelsForKey(
    String seedKey, {
    int targetCount = 36,
  }) {
    final seed = seedKey.hashCode;
    final result = <double>[];
    for (int i = 0; i < targetCount; i++) {
      final phase = (seed & 0xFFFF) * 0.01 + i * 0.48;
      final envelope = math.sin((i / math.max(1, targetCount - 1)) * math.pi);
      final raw = 0.25 +
          0.35 * (0.5 + 0.5 * math.sin(phase)) +
          0.25 * (0.5 + 0.5 * math.cos(phase * 1.7 + 0.9));
      result.add((raw * (0.45 + 0.55 * envelope)).clamp(0.12, 0.95));
    }
    return result;
  }

  void _emitSeek(BuildContext context, Offset localPosition) {
    if (onSeek == null) return;
    final box = context.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 0.0;
    if (width <= 0) return;
    final ratio = (localPosition.dx / width).clamp(0.0, 1.0);
    onSeek!(ratio);
  }

  @override
  Widget build(BuildContext context) {
    final paint = SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _SpectrumPainter(
          levels: levels,
          progress: progress,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          barWidth: barWidth,
          minBarHeight: minBarHeight,
          playheadColor: playheadColor ?? activeColor,
        ),
      ),
    );

    if (onSeek == null) {
      return paint;
    }

    return Builder(
      builder: (gestureContext) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) =>
            _emitSeek(gestureContext, details.localPosition),
        onHorizontalDragStart: (details) =>
            _emitSeek(gestureContext, details.localPosition),
        onHorizontalDragUpdate: (details) =>
            _emitSeek(gestureContext, details.localPosition),
        child: paint,
      ),
    );
  }
}

class _SpectrumPainter extends CustomPainter {
  _SpectrumPainter({
    required this.levels,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.barWidth,
    required this.minBarHeight,
    required this.playheadColor,
  });

  final List<double> levels;
  final double? progress;
  final Color activeColor;
  final Color inactiveColor;
  final double barWidth;
  final double minBarHeight;
  final Color playheadColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (levels.isEmpty) return;

    final int count = levels.length;
    final double centerY = size.height / 2;
    final double maxBarH = size.height * 0.9;
    final double usableWidth = math.max(barWidth, size.width - barWidth);
    final double spacing = count > 1 ? usableWidth / (count - 1) : 0.0;
    final double effectiveBarWidth =
        count > 1 ? math.min(barWidth, spacing * 0.62) : barWidth;
    final double startX = count > 1 ? barWidth / 2 : size.width / 2;

    final paint = Paint()..style = PaintingStyle.fill;
    final double clampedProgress = (progress ?? 0.0).clamp(0.0, 1.0);

    for (int i = 0; i < count; i++) {
      final double norm = levels[i].clamp(0.0, 1.0);
      final double barH = math.max(minBarHeight, norm * maxBarH);
      final double x = startX + i * spacing;
      final double top = centerY - barH / 2;

      if (progress != null) {
        final double barPos = count > 1 ? i / (count - 1) : 0.0;
        paint.color = barPos <= clampedProgress ? activeColor : inactiveColor;
      } else {
        paint.color =
            Color.lerp(inactiveColor, activeColor, (norm * 1.15).clamp(0.25, 1.0)) ??
                activeColor;
      }

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x - effectiveBarWidth / 2,
            top,
            effectiveBarWidth,
            barH,
          ),
          Radius.circular(effectiveBarWidth / 2),
        ),
        paint,
      );
    }

    if (progress != null) {
      final double playheadX = startX + clampedProgress * usableWidth;
      final playheadPaint = Paint()
        ..color = playheadColor
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(playheadX, 2),
        Offset(playheadX, size.height - 2),
        playheadPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpectrumPainter oldDelegate) {
    if (oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.playheadColor != playheadColor ||
        oldDelegate.levels.length != levels.length) {
      return true;
    }
    for (int i = 0; i < levels.length; i++) {
      if (oldDelegate.levels[i] != levels[i]) return true;
    }
    return false;
  }
}
