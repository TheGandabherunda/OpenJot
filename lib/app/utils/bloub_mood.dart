// Minimal black-circle mood character inspired by jeremy-prt/bloub (MIT License)
// and the Xiaozhi / JoyTaung expressive emoji set.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Unified curve/circle geometry for a single facial feature (eye or mouth).
///
/// - When `halfSpan ~ 0`, renders a crisp filled circle (or squashed oval during blinks)
///   of diameter `thickness * radius`.
/// - Otherwise renders a rounded-cap stroke `(-halfSpan, drop) -> peak(0, -arch) -> (+halfSpan, drop)`:
///   - `arch > 0` arches upward (`⌒` when `chevron = 0`, `^` when `chevron = 1`).
///   - `arch < 0` dips downward into a soft crescent / smile (`◡`).
class BloubStrokeSpec {
  final double halfSpan;
  final double thickness;
  final double arch;
  final double drop;
  final double tiltDeg;
  final double open;
  final double chevron;

  const BloubStrokeSpec({
    required this.halfSpan,
    required this.thickness,
    this.arch = 0.0,
    this.drop = 0.0,
    this.tiltDeg = 0.0,
    this.open = 1.0,
    this.chevron = 0.0,
  });

  static BloubStrokeSpec lerp(BloubStrokeSpec a, BloubStrokeSpec b, double t) {
    return BloubStrokeSpec(
      halfSpan: ui.lerpDouble(a.halfSpan, b.halfSpan, t)!,
      thickness: ui.lerpDouble(a.thickness, b.thickness, t)!,
      arch: ui.lerpDouble(a.arch, b.arch, t)!,
      drop: ui.lerpDouble(a.drop, b.drop, t)!,
      tiltDeg: ui.lerpDouble(a.tiltDeg, b.tiltDeg, t)!,
      open: ui.lerpDouble(a.open, b.open, t)!,
      chevron: ui.lerpDouble(a.chevron, b.chevron, t)!,
    );
  }
}

/// Complete interpolated facial pose & decorative mood accents for `0..6`.
class BloubPose {
  final double faceOffsetX;
  final double faceOffsetY;
  final double rollDeg;
  final double eyeSplit;
  final double eyeOffsetY;
  final double cheekOffsetY;
  final double cheekIntensity;
  final double mouthDrop;
  final double blinkAmount;
  final BloubStrokeSpec leftEye;
  final BloubStrokeSpec rightEye;
  final BloubStrokeSpec mouth;
  final double tearOpacity;
  final double sighOpacity;
  final double sleepZOpacity;
  final double glassesOpacity;
  final double sparkleOpacity;
  final double tongueOpacity;

  const BloubPose({
    this.faceOffsetX = 0.0,
    this.faceOffsetY = 0.0,
    this.rollDeg = 0.0,
    this.eyeSplit = 0.34,
    this.eyeOffsetY = -0.06,
    this.cheekOffsetY = 0.12,
    this.cheekIntensity = 0.35,
    this.mouthDrop = 0.12,
    this.blinkAmount = 0.0,
    required this.leftEye,
    required this.rightEye,
    required this.mouth,
    this.tearOpacity = 0.0,
    this.sighOpacity = 0.0,
    this.sleepZOpacity = 0.0,
    this.glassesOpacity = 0.0,
    this.sparkleOpacity = 0.0,
    this.tongueOpacity = 0.0,
  });

  static BloubPose lerp(BloubPose a, BloubPose b, double t) {
    return BloubPose(
      faceOffsetX: ui.lerpDouble(a.faceOffsetX, b.faceOffsetX, t)!,
      faceOffsetY: ui.lerpDouble(a.faceOffsetY, b.faceOffsetY, t)!,
      rollDeg: ui.lerpDouble(a.rollDeg, b.rollDeg, t)!,
      eyeSplit: ui.lerpDouble(a.eyeSplit, b.eyeSplit, t)!,
      eyeOffsetY: ui.lerpDouble(a.eyeOffsetY, b.eyeOffsetY, t)!,
      cheekOffsetY: ui.lerpDouble(a.cheekOffsetY, b.cheekOffsetY, t)!,
      cheekIntensity: ui.lerpDouble(a.cheekIntensity, b.cheekIntensity, t)!,
      mouthDrop: ui.lerpDouble(a.mouthDrop, b.mouthDrop, t)!,
      blinkAmount: ui.lerpDouble(a.blinkAmount, b.blinkAmount, t)!,
      leftEye: BloubStrokeSpec.lerp(a.leftEye, b.leftEye, t),
      rightEye: BloubStrokeSpec.lerp(a.rightEye, b.rightEye, t),
      mouth: BloubStrokeSpec.lerp(a.mouth, b.mouth, t),
      tearOpacity: ui.lerpDouble(a.tearOpacity, b.tearOpacity, t)!,
      sighOpacity: ui.lerpDouble(a.sighOpacity, b.sighOpacity, t)!,
      sleepZOpacity: ui.lerpDouble(a.sleepZOpacity, b.sleepZOpacity, t)!,
      glassesOpacity: ui.lerpDouble(a.glassesOpacity, b.glassesOpacity, t)!,
      sparkleOpacity: ui.lerpDouble(a.sparkleOpacity, b.sparkleOpacity, t)!,
      tongueOpacity: ui.lerpDouble(a.tongueOpacity, b.tongueOpacity, t)!,
    );
  }
}

class _BloubLayout {
  final Offset center;
  final double radius;
  final double rollDeg;
  final Offset faceCenter;
  final Offset leftEye;
  final Offset rightEye;
  final Offset mouth;
  final Offset leftCheek;
  final Offset rightCheek;

  const _BloubLayout({
    required this.center,
    required this.radius,
    required this.rollDeg,
    required this.faceCenter,
    required this.leftEye,
    required this.rightEye,
    required this.mouth,
    required this.leftCheek,
    required this.rightCheek,
  });
}

/// Smooth curvy black-circle Bloub renderer for both SVG export and live 60fps canvas.
class BloubGeometry {
  static const double tau = math.pi * 2.0;
  static const double svgViewBoxSize = 512.0;
  static const double svgRadius = 232.0;

  static const String bodyHex = '#070709';
  static const String cheekHex = '#3D1F24';
  static const String warmCheekHex = '#6E3238';
  static const String featureHex = '#FFFFFF';
  static const String blueAccentHex = '#5FA4FA';
  static const String blueHighlightHex = '#9CCBFF';
  static const String sparkleHex = '#FACC15';
  static const String tongueHex = '#F26470';
  static const String sighHex = '#D4D8DF';

  static const Color bodyColor = Color(0xFF070709);
  static const Color subtleCheekColor = Color(0xFF1D0F12);
  static const Color cheekColor = Color(0xFF3D1F24);
  static const Color warmCheekColor = Color(0xFF6E3238);
  static const Color featureColor = Color(0xFFFFFFFF);
  static const Color blueAccentColor = Color(0xFF5FA4FA);
  static const Color blueHighlightColor = Color(0xFF9CCBFF);
  static const Color sparkleColor = Color(0xFFFACC15);
  static const Color tongueColor = Color(0xFFF26470);
  static const Color sighColor = Color(0xFFD4D8DF);

  /// Seven expressive poses matching OpenJot's `moodIndex` (`0..6`),
  /// faithfully styled after the Xiaozhi / JoyTaung expressive set.
  static const List<BloubPose> moodPoses = [
    // 0: Very Unpleasant -> Crying (哭泣: curved dome eyes + blue waterfalls)
    BloubPose(
      eyeSplit: 0.34,
      eyeOffsetY: -0.14,
      cheekOffsetY: 0.05,
      cheekIntensity: 0.15,
      mouthDrop: -0.01,
      leftEye: BloubStrokeSpec(
        halfSpan: 0.092,
        thickness: 0.088,
        arch: 0.055,
        drop: 0.018,
      ),
      rightEye: BloubStrokeSpec(
        halfSpan: 0.092,
        thickness: 0.088,
        arch: 0.055,
        drop: 0.018,
      ),
      mouth: BloubStrokeSpec(halfSpan: 0.048, thickness: 0.062),
      tearOpacity: 1.0,
    ),
    // 1: Unpleasant -> Sad (伤心: droopy closed arcs + sigh puff cloud)
    BloubPose(
      eyeSplit: 0.35,
      eyeOffsetY: -0.11,
      cheekOffsetY: 0.08,
      cheekIntensity: 0.18,
      mouthDrop: 0.08,
      leftEye: BloubStrokeSpec(
        halfSpan: 0.136,
        thickness: 0.064,
        arch: -0.036,
        drop: -0.016,
        tiltDeg: 6.0,
      ),
      rightEye: BloubStrokeSpec(
        halfSpan: 0.136,
        thickness: 0.064,
        arch: -0.036,
        drop: -0.016,
        tiltDeg: -6.0,
      ),
      mouth: BloubStrokeSpec(halfSpan: 0.058, thickness: 0.064),
      sighOpacity: 1.0,
    ),
    // 2: Slightly Unpleasant -> Sleepy (困倦: calm eye slits + round mouth + blue Z)
    BloubPose(
      faceOffsetX: -0.02,
      faceOffsetY: 0.02,
      eyeSplit: 0.34,
      eyeOffsetY: -0.03,
      cheekOffsetY: 0.16,
      cheekIntensity: 0.22,
      mouthDrop: 0.15,
      leftEye: BloubStrokeSpec(
        halfSpan: 0.125,
        thickness: 0.066,
        arch: -0.012,
        drop: -0.004,
      ),
      rightEye: BloubStrokeSpec(
        halfSpan: 0.125,
        thickness: 0.066,
        arch: -0.012,
        drop: -0.004,
      ),
      mouth: BloubStrokeSpec(halfSpan: 0.020, thickness: 0.105),
      sleepZOpacity: 1.0,
    ),
    // 3: Neutral -> Default (默认: clean symmetric round eyes + mini pill mouth)
    BloubPose(
      eyeSplit: 0.33,
      eyeOffsetY: -0.06,
      cheekOffsetY: 0.12,
      cheekIntensity: 0.20,
      mouthDrop: 0.12,
      blinkAmount: 1.0,
      leftEye: BloubStrokeSpec(halfSpan: 0.0, thickness: 0.242),
      rightEye: BloubStrokeSpec(halfSpan: 0.0, thickness: 0.242),
      mouth: BloubStrokeSpec(halfSpan: 0.052, thickness: 0.066),
    ),
    // 4: Slightly Pleasant -> Happy (开心: crisp `^ ^` chevrons + mini pill mouth)
    BloubPose(
      eyeSplit: 0.34,
      eyeOffsetY: -0.05,
      cheekOffsetY: 0.12,
      cheekIntensity: 0.25,
      mouthDrop: 0.10,
      leftEye: BloubStrokeSpec(
        halfSpan: 0.112,
        thickness: 0.066,
        arch: 0.082,
        drop: 0.036,
        chevron: 1.0,
      ),
      rightEye: BloubStrokeSpec(
        halfSpan: 0.112,
        thickness: 0.066,
        arch: 0.082,
        drop: 0.036,
        chevron: 1.0,
      ),
      mouth: BloubStrokeSpec(halfSpan: 0.052, thickness: 0.064),
    ),
    // 5: Pleasant -> Cool (酷炫: round white sunglasses + yellow ✦ sparkle + smirk)
    BloubPose(
      faceOffsetX: -0.03,
      faceOffsetY: -0.01,
      eyeSplit: 0.200,
      eyeOffsetY: -0.06,
      cheekOffsetY: 0.12,
      cheekIntensity: 0.18,
      mouthDrop: 0.140,
      leftEye: BloubStrokeSpec(halfSpan: 0.0, thickness: 0.304),
      rightEye: BloubStrokeSpec(halfSpan: 0.0, thickness: 0.304),
      mouth: BloubStrokeSpec(
        halfSpan: 0.058,
        thickness: 0.066,
        arch: -0.004,
      ),
      glassesOpacity: 1.0,
      sparkleOpacity: 1.0,
    ),
    // 6: Very Pleasant -> Delicious (美味: `^ ^` eyes + wide smile + pink tongue + blush)
    BloubPose(
      faceOffsetY: -0.02,
      eyeSplit: 0.36,
      eyeOffsetY: -0.12,
      cheekOffsetY: 0.16,
      cheekIntensity: 1.0,
      mouthDrop: 0.09,
      leftEye: BloubStrokeSpec(
        halfSpan: 0.115,
        thickness: 0.066,
        arch: 0.086,
        drop: 0.036,
        chevron: 1.0,
      ),
      rightEye: BloubStrokeSpec(
        halfSpan: 0.115,
        thickness: 0.066,
        arch: 0.086,
        drop: 0.036,
        chevron: 1.0,
      ),
      mouth: BloubStrokeSpec(
        halfSpan: 0.335,
        thickness: 0.062,
        arch: -0.118,
        drop: -0.062,
      ),
      tongueOpacity: 1.0,
    ),
  ];

  /// Continuously blends between poses across `progress` (`0.0..6.0`).
  static BloubPose sampleMoodProgress(double progress) {
    final clamped = progress.clamp(0.0, (moodPoses.length - 1).toDouble());
    final lo = clamped.floor();
    final hi = clamped.ceil();
    final t = clamped - lo;
    if (t <= 0.0001 || lo == hi) return moodPoses[lo];
    return BloubPose.lerp(moodPoses[lo], moodPoses[hi], t);
  }

  static double _deg(double d) => (d * math.pi) / 180.0;
  static String _f(double v) => v.toStringAsFixed(2);

  static String _colorToHex(Color c) {
    final r = (c.r * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
    final g = (c.g * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
    final b = (c.b * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  static double _colorDistanceSq(Color a, Color b) {
    final dr = a.r - b.r;
    final dg = a.g - b.g;
    final db = a.b - b.b;
    return dr * dr + dg * dg + db * db;
  }

  static bool _needsContrastShift(Color a, Color b) =>
      _colorDistanceSq(a, b) < 0.14;

  static Offset _rotatePoint(Offset p, double deg) {
    if (deg.abs() < 0.01) return p;
    final rad = _deg(deg);
    final c = math.cos(rad);
    final s = math.sin(rad);
    return Offset(p.dx * c - p.dy * s, p.dx * s + p.dy * c);
  }

  static _BloubLayout _computeLayout(
    Offset center,
    double r,
    BloubPose pose, {
    double dOffsetX = 0.0,
    double dOffsetY = 0.0,
    double dRollDeg = 0.0,
  }) {
    final roll = pose.rollDeg + dRollDeg;
    final faceCenter = center +
        Offset((pose.faceOffsetX + dOffsetX) * r, (pose.faceOffsetY + dOffsetY) * r);
    final leftEye = faceCenter +
        _rotatePoint(Offset(-pose.eyeSplit * r, pose.eyeOffsetY * r), roll);
    final rightEye = faceCenter +
        _rotatePoint(Offset(pose.eyeSplit * r, pose.eyeOffsetY * r), roll);
    final mouth =
        faceCenter + _rotatePoint(Offset(0.0, pose.mouthDrop * r), roll);
    final cheekSide = pose.tongueOpacity > 0.5 ? 0.52 : 0.55;
    final leftCheek = faceCenter +
        _rotatePoint(Offset(-cheekSide * r, pose.cheekOffsetY * r), roll);
    final rightCheek = faceCenter +
        _rotatePoint(Offset(cheekSide * r, pose.cheekOffsetY * r), roll);

    return _BloubLayout(
      center: center,
      radius: r,
      rollDeg: roll,
      faceCenter: faceCenter,
      leftEye: leftEye,
      rightEye: rightEye,
      mouth: mouth,
      leftCheek: leftCheek,
      rightCheek: rightCheek,
    );
  }

  /// Resolves the 5 control points `(p0, q0, apex, q1, p2)` of a curve/chevron feature.
  ///
  /// Uses de Casteljau midpoint split so `chevron = 0` matches an exact smooth
  /// quadratic parabola and `chevron = 1` produces a crisp V-chevron `^`.
  static ({Offset p0, Offset q0, Offset apex, Offset q1, Offset p2, bool isPolyline})
      _featureGeometry(
    Offset origin,
    BloubStrokeSpec spec,
    double radius, {
    double blinkFactor = 1.0,
    double headRollDeg = 0.0,
  }) {
    final span = spec.halfSpan * radius;
    final drop = spec.drop * radius;
    final arch = spec.arch * radius;
    final effBlink = math.min(blinkFactor, spec.open).clamp(0.0, 1.0);
    final vScale = 0.35 + 0.65 * effBlink;
    final chevron = spec.chevron.clamp(0.0, 1.0);
    final qY = ui.lerpDouble(-arch, (drop - arch) * 0.5, chevron)!;

    Offset mapPt(Offset local) {
      final squashed = Offset(local.dx, local.dy * vScale);
      return origin + _rotatePoint(squashed, spec.tiltDeg + headRollDeg);
    }

    return (
      p0: mapPt(Offset(-span, drop)),
      q0: mapPt(Offset(-span * 0.5, qY)),
      apex: mapPt(Offset(0.0, -arch)),
      q1: mapPt(Offset(span * 0.5, qY)),
      p2: mapPt(Offset(span, drop)),
      isPolyline: chevron >= 0.99,
    );
  }

  static ui.Path _buildCurvePath(
    Offset origin,
    BloubStrokeSpec spec,
    double radius, {
    double blinkFactor = 1.0,
    double headRollDeg = 0.0,
  }) {
    final g = _featureGeometry(
      origin,
      spec,
      radius,
      blinkFactor: blinkFactor,
      headRollDeg: headRollDeg,
    );
    final path = ui.Path()..moveTo(g.p0.dx, g.p0.dy);
    if (g.isPolyline) {
      path
        ..lineTo(g.apex.dx, g.apex.dy)
        ..lineTo(g.p2.dx, g.p2.dy);
    } else if (spec.chevron < 0.01) {
      final ctrl = origin +
          _rotatePoint(
            Offset(
              0.0,
              (-2.0 * spec.arch - spec.drop) *
                  radius *
                  (0.35 + 0.65 * math.min(blinkFactor, spec.open).clamp(0.0, 1.0)),
            ),
            spec.tiltDeg + headRollDeg,
          );
      path.quadraticBezierTo(ctrl.dx, ctrl.dy, g.p2.dx, g.p2.dy);
    } else {
      path
        ..quadraticBezierTo(g.q0.dx, g.q0.dy, g.apex.dx, g.apex.dy)
        ..quadraticBezierTo(g.q1.dx, g.q1.dy, g.p2.dx, g.p2.dy);
    }
    return path;
  }

  static String _buildCurveSvgD(
    Offset origin,
    BloubStrokeSpec spec,
    double radius, {
    double headRollDeg = 0.0,
  }) {
    final g = _featureGeometry(
      origin,
      spec,
      radius,
      headRollDeg: headRollDeg,
    );
    if (g.isPolyline) {
      return 'M${_f(g.p0.dx)} ${_f(g.p0.dy)}'
          'L${_f(g.apex.dx)} ${_f(g.apex.dy)}'
          'L${_f(g.p2.dx)} ${_f(g.p2.dy)}';
    }
    if (spec.chevron < 0.01) {
      final ctrl = origin +
          _rotatePoint(
            Offset(0.0, (-2.0 * spec.arch - spec.drop) * radius),
            spec.tiltDeg + headRollDeg,
          );
      return 'M${_f(g.p0.dx)} ${_f(g.p0.dy)}'
          'Q${_f(ctrl.dx)} ${_f(ctrl.dy)} ${_f(g.p2.dx)} ${_f(g.p2.dy)}';
    }
    return 'M${_f(g.p0.dx)} ${_f(g.p0.dy)}'
        'Q${_f(g.q0.dx)} ${_f(g.q0.dy)} ${_f(g.apex.dx)} ${_f(g.apex.dy)}'
        'Q${_f(g.q1.dx)} ${_f(g.q1.dy)} ${_f(g.p2.dx)} ${_f(g.p2.dy)}';
  }

  /// Bottom intersection `y` on the outer black circle at horizontal offset `x`.
  static double _circleBottomY(Offset center, double r, double x) {
    final dx = x - center.dx;
    final rem = r * r - dx * dx;
    return center.dy + (rem > 0 ? math.sqrt(rem) : 0.0);
  }

  static String _clippedBarSvgD(
    Offset center,
    double r,
    double leftX,
    double rightX,
    double topY,
  ) {
    final by0 = _circleBottomY(center, r, leftX);
    final by1 = _circleBottomY(center, r, rightX);
    return 'M${_f(leftX)} ${_f(topY)}'
        'L${_f(rightX)} ${_f(topY)}'
        'L${_f(rightX)} ${_f(by1)}'
        'A${_f(r)} ${_f(r)} 0 0 1 ${_f(leftX)} ${_f(by0)}Z';
  }

  static ui.Path _sparklePath(Offset c, double r, {double angleDeg = 0.0}) {
    final inner = r * 0.24;
    Offset pt(double dx, double dy) => c + _rotatePoint(Offset(dx, dy), angleDeg);
    final pTop = pt(0, -r);
    final pRight = pt(r, 0);
    final pBottom = pt(0, r);
    final pLeft = pt(-r, 0);
    final cTR = pt(inner * 0.35, -inner * 0.35);
    final cBR = pt(inner * 0.35, inner * 0.35);
    final cBL = pt(-inner * 0.35, inner * 0.35);
    final cTL = pt(-inner * 0.35, -inner * 0.35);
    return ui.Path()
      ..moveTo(pTop.dx, pTop.dy)
      ..quadraticBezierTo(cTR.dx, cTR.dy, pRight.dx, pRight.dy)
      ..quadraticBezierTo(cBR.dx, cBR.dy, pBottom.dx, pBottom.dy)
      ..quadraticBezierTo(cBL.dx, cBL.dy, pLeft.dx, pLeft.dy)
      ..quadraticBezierTo(cTL.dx, cTL.dy, pTop.dx, pTop.dy)
      ..close();
  }

  static String _sparkleSvgD(Offset c, double r) {
    final inner = r * 0.24;
    return 'M${_f(c.dx)} ${_f(c.dy - r)}'
        'Q${_f(c.dx + inner * 0.35)} ${_f(c.dy - inner * 0.35)} ${_f(c.dx + r)} ${_f(c.dy)}'
        'Q${_f(c.dx + inner * 0.35)} ${_f(c.dy + inner * 0.35)} ${_f(c.dx)} ${_f(c.dy + r)}'
        'Q${_f(c.dx - inner * 0.35)} ${_f(c.dy + inner * 0.35)} ${_f(c.dx - r)} ${_f(c.dy)}'
        'Q${_f(c.dx - inner * 0.35)} ${_f(c.dy - inner * 0.35)} ${_f(c.dx)} ${_f(c.dy - r)}Z';
  }

  /// Generates the pink tongue capsule sticking upward along the right side of the smile.
  ///
  /// When [u] varies (`0.45..0.66`), the tongue sweeps cleanly along the quadratic
  /// smile curve without detaching from the mouth stroke.
  static ({
    Offset anchor,
    double angleDeg,
    double halfW,
    double topH,
    double bottomH,
  }) _tongueMetrics(
    Offset mouthPos,
    BloubStrokeSpec mouthSpec,
    double r,
    double rollDeg, {
    double u = 0.633,
    double stretchScale = 1.0,
    double angleWiggleDeg = 0.0,
  }) {
    final t = ((1.0 + u) * 0.5).clamp(0.0, 1.0);
    final inv = 1.0 - t;
    final drop = mouthSpec.drop * r;
    final ctrlY = (-2.0 * mouthSpec.arch - mouthSpec.drop) * r;
    final localX = u * mouthSpec.halfSpan * r;
    final localY = inv * inv * drop + 2.0 * inv * t * ctrlY + t * t * drop;
    final anchor = mouthPos + _rotatePoint(Offset(localX, localY), rollDeg);
    return (
      anchor: anchor,
      angleDeg: rollDeg - 15.0 + angleWiggleDeg,
      halfW: 0.086 * r,
      topH: 0.145 * r * stretchScale,
      bottomH: 0.025 * r,
    );
  }

  static ui.Path _tonguePath(
    ({Offset anchor, double angleDeg, double halfW, double topH, double bottomH}) t,
  ) {
    final rect = RRect.fromLTRBAndCorners(
      -t.halfW,
      -t.topH,
      t.halfW,
      t.bottomH,
      topLeft: Radius.circular(t.halfW),
      topRight: Radius.circular(t.halfW),
      bottomLeft: Radius.circular(t.halfW * 0.45),
      bottomRight: Radius.circular(t.halfW * 0.45),
    );
    return ui.Path()..addRRect(rect);
  }

  static ({
    Offset bridgeStart,
    Offset bridgeEnd,
    Offset templeStart,
    Offset templeEnd,
    Offset sparkleCenter,
  }) _glassesMetrics(_BloubLayout layout) {
    final r = layout.radius;
    final leftLens = layout.leftEye;
    final rightLens = layout.rightEye;
    final templeDir = _rotatePoint(Offset(-0.185 * r, 0.0), layout.rollDeg);
    final templeInner = _rotatePoint(Offset(-0.120 * r, 0.0), layout.rollDeg);
    final sparkleOffset =
        _rotatePoint(Offset(0.170 * r, -0.132 * r), layout.rollDeg);
    return (
      bridgeStart: leftLens,
      bridgeEnd: rightLens,
      templeStart: leftLens + templeDir,
      templeEnd: leftLens + templeInner,
      sparkleCenter: rightLens + sparkleOffset,
    );
  }

  static ({
    Offset smallDot,
    double smallR,
    List<(Offset center, double radius)> cloudLobes,
    double alpha,
  }) _sighMetrics(
    Offset mouthPos,
    double r,
    double rollDeg, {
    bool animate = false,
    double phase = 0.0,
  }) {
    if (!animate) {
      Offset p(double dx, double dy) =>
          mouthPos + _rotatePoint(Offset(dx * r, dy * r), rollDeg);
      final c = p(0.095, 0.255);
      Offset lobe(double dx, double dy) =>
          c + _rotatePoint(Offset(dx * r, dy * r), rollDeg);
      return (
        smallDot: p(-0.095, 0.165),
        smallR: 0.050 * r,
        cloudLobes: [
          (lobe(0.0, -0.042), 0.068 * r),
          (lobe(-0.050, 0.030), 0.056 * r),
          (lobe(0.054, 0.030), 0.056 * r),
        ],
        alpha: 1.0,
      );
    }

    // 5 blow cycles per 12s (2.4s each): brief inhale pause then exhale puff gliding out.
    final cycle = (phase * 5.0) % 1.0;
    if (cycle < 0.18) {
      return (
        smallDot: mouthPos,
        smallR: 0.0,
        cloudLobes: const [],
        alpha: 0.0,
      );
    }
    final p = ((cycle - 0.18) / 0.82).clamp(0.0, 1.0);
    final easeOut = 1.0 - math.pow(1.0 - p, 2.2).toDouble();
    final fadeIn = (p / 0.08).clamp(0.0, 1.0);
    final fadeOut = p > 0.58 ? (1.0 - (p - 0.58) / 0.42).clamp(0.0, 1.0) : 1.0;
    final alpha = fadeIn * fadeOut;

    final dotX = ui.lerpDouble(-0.045, -0.130, easeOut)!;
    final dotY = ui.lerpDouble(0.085, 0.220, easeOut)!;
    final dotScale = 0.55 + 0.55 * easeOut;

    final pCloud = ((p - 0.04) / 0.96).clamp(0.0, 1.0);
    final cloudEase = 1.0 - math.pow(1.0 - pCloud, 2.0).toDouble();
    final cloudX = ui.lerpDouble(0.030, 0.145, cloudEase)!;
    final cloudY = ui.lerpDouble(0.115, 0.315, cloudEase)!;
    final cloudScale = 0.52 + 0.68 * cloudEase;

    final cloudCenter =
        mouthPos + _rotatePoint(Offset(cloudX * r, cloudY * r), rollDeg);
    Offset lobe(double dx, double dy) =>
        cloudCenter + _rotatePoint(Offset(dx * r * cloudScale, dy * r * cloudScale), rollDeg);

    return (
      smallDot: mouthPos + _rotatePoint(Offset(dotX * r, dotY * r), rollDeg),
      smallR: 0.048 * r * dotScale,
      cloudLobes: [
        (lobe(0.0, -0.042), 0.068 * r * cloudScale),
        (lobe(-0.050, 0.030), 0.056 * r * cloudScale),
        (lobe(0.054, 0.030), 0.056 * r * cloudScale),
      ],
      alpha: alpha,
    );
  }

  static List<Offset> _sleepZPoints(
    _BloubLayout layout, {
    double offsetX = 0.0,
    double offsetY = 0.0,
    double scale = 1.0,
    double tiltOffsetDeg = 0.0,
  }) {
    final r = layout.radius;
    final zCenter = layout.faceCenter +
        _rotatePoint(Offset(0.49 * r + offsetX, -0.37 * r + offsetY), layout.rollDeg);
    final zs = 0.068 * r * scale;
    final rot = layout.rollDeg - 8.0 + tiltOffsetDeg;
    return [
      zCenter + _rotatePoint(Offset(-zs, -zs), rot),
      zCenter + _rotatePoint(Offset(zs, -zs), rot),
      zCenter + _rotatePoint(Offset(-zs, zs), rot),
      zCenter + _rotatePoint(Offset(zs, zs), rot),
    ];
  }

  /// Generates a standalone `512x512` flat black circular Bloub SVG string
  /// with crisp white expressions and themed accent effects.
  static String buildSvgString(int moodIndex) {
    final clamped = moodIndex.clamp(0, moodPoses.length - 1);
    final pose = moodPoses[clamped];
    const center = Offset(svgViewBoxSize * 0.5, svgViewBoxSize * 0.5);
    const r = svgRadius;
    final layout = _computeLayout(center, r, pose);

    final cheekColor = Color.lerp(subtleCheekColor, warmCheekColor, pose.cheekIntensity)!;
    final cheekColorHex = _colorToHex(cheekColor);

    final buf = StringBuffer();
    buf.write(
      '<svg width="512" height="512" viewBox="0 0 512 512" fill="none" xmlns="http://www.w3.org/2000/svg">',
    );
    buf.write(
      '<defs><clipPath id="bloub_clip_$clamped">'
      '<circle cx="${_f(center.dx)}" cy="${_f(center.dy)}" r="${_f(r)}"/>'
      '</clipPath></defs>',
    );

    // Matte black circle base
    buf.write(
      '<circle cx="${_f(center.dx)}" cy="${_f(center.dy)}" r="${_f(r)}" fill="$bodyHex"/>',
    );
    buf.write('<g clip-path="url(#bloub_clip_$clamped)">');

    // Warm cheeks
    buf.write(
      '<ellipse cx="${_f(layout.leftCheek.dx)}" cy="${_f(layout.leftCheek.dy)}" '
      'rx="${_f(0.112 * r)}" ry="${_f(0.088 * r)}" fill="$cheekColorHex"/>',
    );
    buf.write(
      '<ellipse cx="${_f(layout.rightCheek.dx)}" cy="${_f(layout.rightCheek.dy)}" '
      'rx="${_f(0.112 * r)}" ry="${_f(0.088 * r)}" fill="$cheekColorHex"/>',
    );

    // 0: Vertical blue tears trimmed cleanly to circle arc (works even if clipPath is ignored)
    if (pose.tearOpacity > 0.01) {
      const tearW = 0.205 * r;
      const hiW = 0.058 * r;
      for (final eyePos in [layout.leftEye, layout.rightEye]) {
        final tearTop = eyePos.dy - 0.015 * r;
        final leftX = eyePos.dx - tearW * 0.5;
        final rightX = eyePos.dx + tearW * 0.5;
        buf.write(
          '<path d="${_clippedBarSvgD(center, r, leftX, rightX, tearTop)}" fill="$blueAccentHex"/>',
        );
        final hiLeft = eyePos.dx - 0.062 * r;
        final hiRight = hiLeft + hiW;
        buf.write(
          '<path d="${_clippedBarSvgD(center, r, hiLeft, hiRight, eyePos.dy + 0.005 * r)}" '
          'fill="$blueHighlightHex"/>',
        );
      }
    }

    // 5: Cool sunglasses bridge + left temple arm (behind round lenses)
    if (pose.glassesOpacity > 0.01) {
      final gm = _glassesMetrics(layout);
      buf.write(
        '<line x1="${_f(gm.templeStart.dx)}" y1="${_f(gm.templeStart.dy)}" '
        'x2="${_f(gm.templeEnd.dx)}" y2="${_f(gm.templeEnd.dy)}" '
        'stroke="$featureHex" stroke-width="${_f(0.038 * r)}" stroke-linecap="round"/>',
      );
      buf.write(
        '<line x1="${_f(gm.bridgeStart.dx)}" y1="${_f(gm.bridgeStart.dy)}" '
        'x2="${_f(gm.bridgeEnd.dx)}" y2="${_f(gm.bridgeEnd.dy)}" '
        'stroke="$featureHex" stroke-width="${_f(0.038 * r)}" stroke-linecap="round"/>',
      );
    }

    // 6: Coral-pink tongue peeking up from right side of smile (under mouth stroke)
    if (pose.tongueOpacity > 0.01) {
      final t = _tongueMetrics(layout.mouth, pose.mouth, r, pose.rollDeg);
      buf.write(
        '<g transform="translate(${_f(t.anchor.dx)},${_f(t.anchor.dy)}) rotate(${_f(t.angleDeg)})">',
      );
      buf.write(
        '<rect x="${_f(-t.halfW)}" y="${_f(-t.topH)}" '
        'width="${_f(t.halfW * 2)}" height="${_f(t.topH + t.bottomH)}" '
        'rx="${_f(t.halfW)}" fill="$tongueHex"/>',
      );
      buf.write(
        '<line x1="0" y1="${_f(-t.topH * 0.56)}" x2="0" y2="${_f(-0.012 * r)}" '
        'stroke="$bodyHex" stroke-width="${_f(0.022 * r)}" stroke-linecap="round"/>',
      );
      buf.write('</g>');
    }

    // Crisp white eyes & mouth (circles emit <circle>, curves/chevrons emit <path>)
    for (final (origin, spec) in [
      (layout.leftEye, pose.leftEye),
      (layout.rightEye, pose.rightEye),
      (layout.mouth, pose.mouth),
    ]) {
      final span = spec.halfSpan * r;
      if (span < 0.5) {
        buf.write(
          '<circle cx="${_f(origin.dx)}" cy="${_f(origin.dy)}" '
          'r="${_f(spec.thickness * r * 0.5)}" fill="$featureHex"/>',
        );
      } else {
        final d = _buildCurveSvgD(origin, spec, r, headRollDeg: pose.rollDeg);
        buf.write(
          '<path d="$d" stroke="$featureHex" stroke-width="${_f(spec.thickness * r)}" '
          'stroke-linecap="round" stroke-linejoin="round" fill="none"/>',
        );
      }
    }

    // 1: Sigh puff dot + cloud cluster
    if (pose.sighOpacity > 0.01) {
      final sigh = _sighMetrics(layout.mouth, r, pose.rollDeg);
      buf.write(
        '<circle cx="${_f(sigh.smallDot.dx)}" cy="${_f(sigh.smallDot.dy)}" '
        'r="${_f(sigh.smallR)}" fill="$sighHex"/>',
      );
      for (final (c, rad) in sigh.cloudLobes) {
        buf.write(
          '<circle cx="${_f(c.dx)}" cy="${_f(c.dy)}" '
          'r="${_f(rad)}" fill="$sighHex"/>',
        );
      }
    }

    // 2: Floating blue Z
    if (pose.sleepZOpacity > 0.01) {
      final zPts = _sleepZPoints(layout);
      buf.write(
        '<path d="M${_f(zPts[0].dx)} ${_f(zPts[0].dy)}'
        'L${_f(zPts[1].dx)} ${_f(zPts[1].dy)}'
        'L${_f(zPts[2].dx)} ${_f(zPts[2].dy)}'
        'L${_f(zPts[3].dx)} ${_f(zPts[3].dy)}" '
        'stroke="$blueAccentHex" stroke-width="${_f(0.044 * r)}" '
        'stroke-linecap="round" stroke-linejoin="round" fill="none"/>',
      );
    }

    // 5: Golden 4-point sparkle star on sunglasses rim
    if (pose.sparkleOpacity > 0.01) {
      final gm = _glassesMetrics(layout);
      buf.write(
        '<path d="${_sparkleSvgD(gm.sparkleCenter, 0.135 * r)}" fill="$sparkleHex"/>',
      );
    }

    buf.write('</g></svg>');
    return buf.toString();
  }

  /// Paints the live animated Bloub onto [canvas] at [size].
  static void paint(
    Canvas canvas,
    Size size, {
    required BloubPose pose,
    Color fillColor = bodyColor,
    double blinkFactor = 1.0,
    double dOffsetX = 0.0,
    double dOffsetY = 0.0,
    double dRollDeg = 0.0,
    double breathScale = 1.0,
    double effectPhase = 0.0,
  }) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final r =
        math.min(size.width, size.height) * (svgRadius / svgViewBoxSize) * breathScale;

    final circlePath = ui.Path()
      ..addOval(Rect.fromCircle(center: center, radius: r));

    canvas.drawPath(
      circlePath,
      Paint()
        ..style = PaintingStyle.fill
        ..color = fillColor,
    );

    canvas.save();
    canvas.clipPath(circlePath);

    final layout = _computeLayout(
      center,
      r,
      pose,
      dOffsetX: dOffsetX,
      dOffsetY: dOffsetY,
      dRollDeg: dRollDeg,
    );

    final isColoredBody = fillColor != bodyColor;
    final isVeryLightBody = fillColor.computeLuminance() > 0.62;
    final effFeatureColor =
        isVeryLightBody ? const Color(0xFF111827) : featureColor;
    final effCreaseColor = isColoredBody ? const Color(0xFF9F1239) : bodyColor;

    // Warm cheeks (on colored bodies, preserve clean hue for subtle blush & vivid coral on joyful moods)
    final Color cheekColor;
    if (isColoredBody) {
      final hsl = HSLColor.fromColor(fillColor);
      final sameHueBlush = hsl
          .withLightness((hsl.lightness - 0.11).clamp(0.14, 0.85))
          .withSaturation((hsl.saturation + 0.08).clamp(0.0, 1.0))
          .toColor();
      cheekColor = pose.cheekIntensity > 0.5
          ? Color.lerp(sameHueBlush, const Color(0xFFFF5E7E), 0.75)!
          : sameHueBlush;
    } else {
      cheekColor =
          Color.lerp(subtleCheekColor, warmCheekColor, pose.cheekIntensity)!;
    }
    final cheekPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = cheekColor;
    for (final cPos in [layout.leftCheek, layout.rightCheek]) {
      canvas.drawOval(
        Rect.fromCenter(center: cPos, width: 0.224 * r, height: 0.176 * r),
        cheekPaint,
      );
    }

    // 0: Flowing blue tear streams with cascading highlights & tear droplets
    if (pose.tearOpacity > 0.01) {
      final tearsCloseToBody =
          isColoredBody && _needsContrastShift(fillColor, blueAccentColor);
      final tearBase =
          tearsCloseToBody ? const Color(0xFFE0F2FE) : blueAccentColor;
      final tearStripe =
          tearsCloseToBody ? const Color(0xFFFFFFFF) : blueHighlightColor;
      final tearCycle = (effectPhase * 8.0) % 1.0;
      final ripple = 1.0 + 0.035 * math.sin(effectPhase * tau * 12.0);
      final tearW = 0.205 * r * ripple;
      final tearPaint = Paint()
        ..color = tearBase.withValues(alpha: pose.tearOpacity);
      for (final eyePos in [layout.leftEye, layout.rightEye]) {
        final tearTop = eyePos.dy - 0.015 * r;
        canvas.drawRect(
          Rect.fromLTWH(eyePos.dx - tearW * 0.5, tearTop, tearW, r * 1.35),
          tearPaint,
        );

        // Subtle continuous base highlight stripe
        final hiLeft = eyePos.dx - 0.062 * r;
        canvas.drawRect(
          Rect.fromLTWH(hiLeft, eyePos.dy + 0.005 * r, 0.056 * r, r * 1.25),
          Paint()
            ..color = tearStripe.withValues(alpha: 0.45 * pose.tearOpacity),
        );

        // Two staggered smoothly-looping falling shimmer ribbons (no snap at loop wrap)
        for (var i = 0; i < 2; i++) {
          final flowT = (tearCycle + i * 0.5) % 1.0;
          final fade = math.sin(flowT * math.pi);
          final dropY = eyePos.dy + (flowT * 1.08 - 0.14) * r;
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(hiLeft, dropY, 0.058 * r, 0.40 * r),
              Radius.circular(0.029 * r),
            ),
            Paint()
              ..color = const Color(0xFFD6E9FF)
                  .withValues(alpha: 0.88 * fade * pose.tearOpacity),
          );

          // Tiny falling droplet glint on the outer half of the waterfall
          final beadY = eyePos.dy + ((flowT + 0.25) % 1.0) * 1.02 * r;
          final beadFade = math.sin(((flowT + 0.25) % 1.0) * math.pi);
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(eyePos.dx + 0.042 * r, beadY),
              width: 0.036 * r,
              height: 0.075 * r,
            ),
            Paint()
              ..color = const Color(0xFFEFF6FF)
                  .withValues(alpha: 0.72 * beadFade * pose.tearOpacity),
          );
        }
      }
    }

    // 5: Sunglasses bridge + temple arm
    if (pose.glassesOpacity > 0.01) {
      final gm = _glassesMetrics(layout);
      final framePaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = effFeatureColor.withValues(alpha: pose.glassesOpacity)
        ..strokeWidth = 0.038 * r
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(gm.templeStart, gm.templeEnd, framePaint);
      canvas.drawLine(gm.bridgeStart, gm.bridgeEnd, framePaint);
    }

    // 6: Coral-pink tongue sweeping playfully along the smile curve
    if (pose.tongueOpacity > 0.01) {
      final lickCycle = (effectPhase * 6.0) % 1.0;
      final sweep = 0.5 - 0.5 * math.cos(lickCycle * tau);
      final u = ui.lerpDouble(0.45, 0.66, sweep)!;
      final stretch = 0.88 + 0.20 * math.sin(lickCycle * math.pi);
      final wiggle = 8.0 - 14.0 * sweep;
      final t = _tongueMetrics(
        layout.mouth,
        pose.mouth,
        r,
        layout.rollDeg,
        u: u,
        stretchScale: stretch,
        angleWiggleDeg: wiggle,
      );
      canvas.save();
      canvas.translate(t.anchor.dx, t.anchor.dy);
      canvas.rotate(_deg(t.angleDeg));
      canvas.drawPath(
        _tonguePath(t),
        Paint()..color = tongueColor.withValues(alpha: pose.tongueOpacity),
      );
      canvas.drawLine(
        Offset(0.0, -t.topH * 0.56),
        Offset(0.0, -0.012 * r),
        Paint()
          ..color = effCreaseColor.withValues(alpha: pose.tongueOpacity)
          ..strokeWidth = 0.022 * r
          ..strokeCap = StrokeCap.round,
      );
      canvas.restore();
    }

    // Only blink when pose eyes are naturally open (blinkAmount > 0), keeping
    // closed/squinted/crying/sunglasses expressions clean and steady.
    final eyeBlink = ui.lerpDouble(1.0, blinkFactor, pose.blinkAmount)!;

    // Gentle sleepy exhale dilation for `o` mouth; subtle blow pucker for sigh mouth.
    final sleepCycle = (effectPhase * 5.0) % 1.0;
    final sleepMouthPulse = 1.0 + 0.13 * math.sin(sleepCycle * tau) * pose.sleepZOpacity;

    final sighCycle = (effectPhase * 5.0) % 1.0;
    final blowPeak = sighCycle >= 0.16 && sighCycle <= 0.56
        ? math.sin(((sighCycle - 0.16) / 0.40) * math.pi)
        : 0.0;
    final sighMouthThicknessScale = 1.0 + 0.22 * blowPeak * pose.sighOpacity;
    final sighMouthSpanScale = 1.0 - 0.24 * blowPeak * pose.sighOpacity;

    // Crisp eyes & mouth
    for (final (origin, rawSpec, blink, isMouth) in [
      (layout.leftEye, pose.leftEye, eyeBlink, false),
      (layout.rightEye, pose.rightEye, eyeBlink, false),
      (layout.mouth, pose.mouth, 1.0, true),
    ]) {
      final spec = isMouth
          ? BloubStrokeSpec(
              halfSpan: rawSpec.halfSpan * sighMouthSpanScale,
              thickness: rawSpec.thickness * sleepMouthPulse * sighMouthThicknessScale,
              arch: rawSpec.arch,
              drop: rawSpec.drop,
              tiltDeg: rawSpec.tiltDeg,
              open: rawSpec.open,
              chevron: rawSpec.chevron,
            )
          : rawSpec;
      final span = spec.halfSpan * r;
      if (span < 0.5) {
        final d = spec.thickness * r;
        final effBlink = math.min(blink, spec.open).clamp(0.0, 1.0);
        final vScale = 0.12 + 0.88 * effBlink;
        final wScale = 1.0 + 0.14 * (1.0 - effBlink);
        final dropShift = 0.022 * r * (1.0 - effBlink);
        canvas.save();
        canvas.translate(origin.dx, origin.dy + dropShift);
        canvas.rotate(_deg(spec.tiltDeg + layout.rollDeg));
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: d * wScale,
            height: d * vScale,
          ),
          Paint()
            ..style = PaintingStyle.fill
            ..color = effFeatureColor,
        );
        canvas.restore();
      } else {
        final path = _buildCurvePath(
          origin,
          spec,
          r,
          blinkFactor: blink,
          headRollDeg: layout.rollDeg,
        );
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..color = effFeatureColor
            ..strokeWidth = spec.thickness * r
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      }
    }

    // 5: Sleek diagonal lens sheen glinting across the white sunglasses
    if (pose.glassesOpacity > 0.01) {
      final shineCycle = (effectPhase * 6.0) % 1.0;
      if (shineCycle >= 0.04 && shineCycle <= 0.44) {
        final sweep = (shineCycle - 0.04) / 0.40;
        final lensClip = ui.Path()
          ..addOval(Rect.fromCircle(
            center: layout.leftEye,
            radius: pose.leftEye.thickness * r * 0.5,
          ))
          ..addOval(Rect.fromCircle(
            center: layout.rightEye,
            radius: pose.rightEye.thickness * r * 0.5,
          ));
        final sweepX = ui.lerpDouble(-0.55 * r, 0.55 * r, sweep)!;
        canvas.save();
        canvas.clipPath(lensClip);
        canvas.translate(layout.faceCenter.dx + sweepX, layout.faceCenter.dy - 0.06 * r);
        canvas.rotate(_deg(24.0 + layout.rollDeg));
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: 0.10 * r, height: 0.50 * r),
          Paint()
            ..color = const Color(0xFF93C5FD)
                .withValues(alpha: 0.55 * pose.glassesOpacity),
        );
        canvas.restore();
      }
    }

    // 1: Expressive blow/sigh puff dot + expanding drifting cloud
    if (pose.sighOpacity > 0.01) {
      final sigh = _sighMetrics(
        layout.mouth,
        r,
        layout.rollDeg,
        animate: true,
        phase: effectPhase,
      );
      if (sigh.alpha > 0.01) {
        final baseSigh = isVeryLightBody
            ? const Color(0xFF475569)
            : (isColoredBody ? const Color(0xFFF1F5F9) : sighColor);
        final sighPaint = Paint()
          ..color = baseSigh.withValues(alpha: 0.92 * sigh.alpha * pose.sighOpacity);
        canvas.drawCircle(sigh.smallDot, sigh.smallR, sighPaint);
        for (final (c, rad) in sigh.cloudLobes) {
          canvas.drawCircle(c, rad, sighPaint);
        }
      }
    }

    // 2: Staggered floating rising blue/contrast Zzz
    if (pose.sleepZOpacity > 0.01) {
      final zCloseToBody =
          isColoredBody && _needsContrastShift(fillColor, blueAccentColor);
      final effZColor = zCloseToBody ? const Color(0xFFFFFFFF) : blueAccentColor;
      for (var i = 0; i < 2; i++) {
        final u = (sleepCycle + i * 0.5) % 1.0;
        final fadeIn = (u / 0.18).clamp(0.0, 1.0);
        final fadeOut = u > 0.62 ? (1.0 - (u - 0.62) / 0.38).clamp(0.0, 1.0) : 1.0;
        final zAlpha = fadeIn * fadeOut * pose.sleepZOpacity * (i == 0 ? 1.0 : 0.72);
        if (zAlpha <= 0.01) continue;

        final baseScale = i == 0 ? 1.0 : 0.72;
        final zScale = baseScale * (0.64 + 0.48 * (1.0 - (1.0 - u) * (1.0 - u)));
        final dx = (-0.08 + 0.18 * u + 0.028 * math.sin(u * tau)) * r;
        final dy = (0.10 - 0.28 * u) * r;
        final zTilt = -8.0 + 12.0 * math.sin(u * math.pi);

        final zPts = _sleepZPoints(
          layout,
          offsetX: dx,
          offsetY: dy,
          scale: zScale,
          tiltOffsetDeg: zTilt,
        );
        final zPath = ui.Path()
          ..moveTo(zPts[0].dx, zPts[0].dy)
          ..lineTo(zPts[1].dx, zPts[1].dy)
          ..lineTo(zPts[2].dx, zPts[2].dy)
          ..lineTo(zPts[3].dx, zPts[3].dy);
        canvas.drawPath(
          zPath,
          Paint()
            ..style = PaintingStyle.stroke
            ..color = effZColor.withValues(alpha: zAlpha)
            ..strokeWidth = 0.044 * r * zScale
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      }
    }

    // 5: Dynamic shine twinkle on the golden 4-point sparkle star
    if (pose.sparkleOpacity > 0.01) {
      final starCloseToBody =
          isColoredBody && _needsContrastShift(fillColor, sparkleColor);
      final effSparkle =
          starCloseToBody ? const Color(0xFFFFFFFF) : sparkleColor;
      final shineCycle = (effectPhase * 6.0) % 1.0;
      final glintWave = shineCycle >= 0.28 && shineCycle <= 0.80
          ? math.sin(((shineCycle - 0.28) / 0.52) * math.pi)
          : 0.0;
      final pulse = 0.74 + 0.16 * math.sin(effectPhase * tau * 3.0) + 0.42 * glintWave;
      final spinDeg = 18.0 * glintWave - 8.0 * math.cos(effectPhase * tau * 3.0);
      final gm = _glassesMetrics(layout);
      canvas.drawPath(
        _sparklePath(gm.sparkleCenter, 0.132 * r * pulse, angleDeg: spinDeg),
        Paint()
          ..color = effSparkle
              .withValues(alpha: (0.78 + 0.22 * glintWave) * pose.sparkleOpacity),
      );
      if (glintWave > 0.05) {
        canvas.drawPath(
          _sparklePath(
            gm.sparkleCenter + _rotatePoint(Offset(0.11 * r, 0.11 * r), layout.rollDeg),
            0.055 * r * glintWave,
            angleDeg: -spinDeg,
          ),
          Paint()
            ..color = const Color(0xFFFEF08A)
                .withValues(alpha: 0.85 * glintWave * pose.sparkleOpacity),
        );
      }
    }

    canvas.restore();
  }
}

/// Animated flat black circular Bloub character that morphs smoothly across
/// `moodProgress` (`0.0..6.0`) with subtle breathing, head drift, blinking,
/// and live expression effects (tears, sigh cloud, floating Z, sunglasses + sparkle).
///
/// Automatically pauses its animation ticker whenever offscreen, scrolled out of
/// view, covered by another route (`TickerMode`), or backgrounded.
class AnimatedBloubMood extends StatefulWidget {
  final double moodProgress;
  final double size;
  final Color fillColor;
  final bool animate;

  const AnimatedBloubMood({
    super.key,
    required this.moodProgress,
    required this.size,
    this.fillColor = BloubGeometry.bodyColor,
    this.animate = true,
  });

  @override
  State<AnimatedBloubMood> createState() => _AnimatedBloubMoodState();
}

class _AnimatedBloubMoodState extends State<AnimatedBloubMood>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _lifeController;
  final List<ScrollPosition> _scrollPositions = [];
  Animation<double>? _routeAnimation;
  bool _appResumed = true;
  bool _tickerModeEnabled = true;
  bool _inViewport = true;
  bool _visibilityCheckScheduled = false;

  @override
  void initState() {
    super.initState();
    _lifeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    WidgetsBinding.instance.addObserver(this);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _appResumed = lifecycle == null || lifecycle == AppLifecycleState.resumed;
    if (widget.animate && _appResumed) {
      _lifeController.repeat();
    }
    _scheduleVisibilityCheck();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tickerModeEnabled = TickerMode.valuesOf(context).enabled;
    final routeAnim = ModalRoute.of(context)?.animation;
    if (routeAnim != _routeAnimation) {
      _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
      _routeAnimation = routeAnim;
      _routeAnimation?.addStatusListener(_onRouteAnimationStatus);
    }
    _attachScrollListeners();
    _syncTickerState();
    _scheduleVisibilityCheck();
  }

  void _onRouteAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      _scheduleVisibilityCheck();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedBloubMood oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate) {
      _syncTickerState();
      if (widget.animate) _scheduleVisibilityCheck();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final resumed = state == AppLifecycleState.resumed;
    if (_appResumed != resumed) {
      _appResumed = resumed;
      _syncTickerState();
      if (resumed) _scheduleVisibilityCheck();
    }
  }

  @override
  void didChangeMetrics() {
    _scheduleVisibilityCheck();
  }

  void _detachScrollListeners() {
    for (final pos in _scrollPositions) {
      pos.removeListener(_scheduleVisibilityCheck);
    }
    _scrollPositions.clear();
  }

  void _attachScrollListeners() {
    _detachScrollListeners();
    context.visitAncestorElements((element) {
      if (element is StatefulElement && element.state is ScrollableState) {
        final pos = (element.state as ScrollableState).position;
        _scrollPositions.add(pos);
        pos.addListener(_scheduleVisibilityCheck);
      }
      return true;
    });
  }

  void _scheduleVisibilityCheck() {
    if (!mounted || _visibilityCheckScheduled) return;
    _visibilityCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _visibilityCheckScheduled = false;
      if (!mounted) return;
      final nowVisible = _evaluateViewportVisibility();
      if (nowVisible != _inViewport) {
        _inViewport = nowVisible;
      }
      _syncTickerState();
    });
  }

  bool _evaluateViewportVisibility() {
    if (!mounted) return false;
    final ro = context.findRenderObject();
    if (ro is! RenderBox || !ro.attached || !ro.hasSize || ro.size.isEmpty) {
      return false;
    }

    // Check against every enclosing Scrollable viewport in local viewport coords
    // (immune to modal SlideTransition transforms moving the whole sheet offscreen at frame 0).
    bool withinScrollables = true;
    context.visitAncestorElements((element) {
      if (element is StatefulElement && element.state is ScrollableState) {
        final scrollRo = element.findRenderObject();
        if (scrollRo is RenderBox && scrollRo.attached && scrollRo.hasSize && !scrollRo.paintBounds.isEmpty) {
          final transform = ro.getTransformTo(scrollRo);
          final rectInScroll =
              MatrixUtils.transformRect(transform, ro.paintBounds);
          if (!rectInScroll.overlaps(scrollRo.paintBounds)) {
            withinScrollables = false;
            return false;
          }
        }
      }
      return true;
    });
    return withinScrollables;
  }

  void _syncTickerState() {
    if (!mounted) return;
    final shouldAnimate =
        widget.animate && _appResumed && _tickerModeEnabled && _inViewport;
    if (shouldAnimate) {
      if (!_lifeController.isAnimating) {
        _lifeController.repeat();
      }
    } else if (_lifeController.isAnimating) {
      _lifeController.stop(canceled: false);
    }
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    _detachScrollListeners();
    WidgetsBinding.instance.removeObserver(this);
    _lifeController.dispose();
    super.dispose();
  }

  /// Smooth raised-cosine open-eye blink (quick organic close, brief touch hold, soft open).
  double _computeBlinkFactor(double sec) {
    const blinkStarts = [1.8, 5.6, 6.08, 9.5];
    const blinkDur = 0.24;
    for (final start in blinkStarts) {
      if (sec >= start && sec <= start + blinkDur) {
        final u = (sec - start) / blinkDur;
        double closeProgress;
        if (u < 0.42) {
          final p = u / 0.42;
          closeProgress = 0.5 - 0.5 * math.cos(math.pi * p);
        } else if (u < 0.52) {
          closeProgress = 1.0;
        } else {
          final p = (u - 0.52) / 0.48;
          closeProgress = 0.5 + 0.5 * math.cos(math.pi * p);
        }
        return 1.0 - closeProgress;
      }
    }
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final targetPose = BloubGeometry.sampleMoodProgress(widget.moodProgress);

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _lifeController,
        builder: (context, _) {
          final phase = _lifeController.value;
          final sec = phase * 12.0;
          final angle = phase * BloubGeometry.tau;

          // Expression-tailored life motion (sobbing quiver for crying, sigh breath, sleepy rise-and-fall, cozy bounce for happy/yummy)
          final breathAmp = 0.015 + 0.010 * targetPose.sleepZOpacity + 0.008 * targetPose.sighOpacity;
          final breathScale = 1.0 + breathAmp * math.sin(angle * 5.0);
          final sobEnvelope = 0.45 + 0.55 * math.sin(angle * 5.0).abs();
          final sobTremble =
              0.014 * math.sin(angle * 24.0) * sobEnvelope * targetPose.tearOpacity;
          final joyFactor = (targetPose.leftEye.chevron * (1.0 - targetPose.tearOpacity))
              .clamp(0.0, 1.0);
          final joyBounce = 0.018 * math.sin(angle * 6.0) * joyFactor;

          final dX = 0.016 * math.sin(angle * 2.0 + 0.4);
          final dY = 0.013 * math.cos(angle * 3.0 + 1.1) + sobTremble - joyBounce;
          final dRoll = 1.4 * math.sin(angle + 0.7) + 1.2 * math.sin(angle * 6.0) * targetPose.tongueOpacity;
          final blink = _computeBlinkFactor(sec);

          return CustomPaint(
            size: Size.square(widget.size),
            painter: _BloubPainter(
              pose: targetPose,
              fillColor: widget.fillColor,
              blinkFactor: blink,
              dOffsetX: dX,
              dOffsetY: dY,
              dRollDeg: dRoll,
              breathScale: breathScale,
              effectPhase: phase,
            ),
          );
        },
      ),
    );
  }
}

class _BloubPainter extends CustomPainter {
  final BloubPose pose;
  final Color fillColor;
  final double blinkFactor;
  final double dOffsetX;
  final double dOffsetY;
  final double dRollDeg;
  final double breathScale;
  final double effectPhase;

  _BloubPainter({
    required this.pose,
    required this.fillColor,
    required this.blinkFactor,
    required this.dOffsetX,
    required this.dOffsetY,
    required this.dRollDeg,
    required this.breathScale,
    required this.effectPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    BloubGeometry.paint(
      canvas,
      size,
      pose: pose,
      fillColor: fillColor,
      blinkFactor: blinkFactor,
      dOffsetX: dOffsetX,
      dOffsetY: dOffsetY,
      dRollDeg: dRollDeg,
      breathScale: breathScale,
      effectPhase: effectPhase,
    );
  }

  @override
  bool shouldRepaint(covariant _BloubPainter oldDelegate) {
    return oldDelegate.effectPhase != effectPhase ||
        oldDelegate.blinkFactor != blinkFactor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.pose.blinkAmount != pose.blinkAmount ||
        oldDelegate.pose.eyeOffsetY != pose.eyeOffsetY ||
        oldDelegate.pose.leftEye.arch != pose.leftEye.arch ||
        oldDelegate.pose.leftEye.chevron != pose.leftEye.chevron ||
        oldDelegate.pose.leftEye.thickness != pose.leftEye.thickness ||
        oldDelegate.pose.mouth.halfSpan != pose.mouth.halfSpan ||
        oldDelegate.pose.tearOpacity != pose.tearOpacity ||
        oldDelegate.pose.sighOpacity != pose.sighOpacity ||
        oldDelegate.pose.sleepZOpacity != pose.sleepZOpacity ||
        oldDelegate.pose.glassesOpacity != pose.glassesOpacity ||
        oldDelegate.pose.sparkleOpacity != pose.sparkleOpacity ||
        oldDelegate.pose.tongueOpacity != pose.tongueOpacity;
  }
}
