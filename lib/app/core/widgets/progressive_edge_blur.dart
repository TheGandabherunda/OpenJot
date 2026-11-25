import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Which edge of [ProgressiveEdgeBlur] has the strongest blur.
enum ProgressiveBlurEdge {
  top,
  bottom,
  left,
  right,
}

const String _shaderAsset = 'assets/shaders/progressive_edge_blur.frag';
const int _curveSamples = 8;

const int _uBand = 2;
const int _uSigma = 6;
const int _uVertical = 7;
const int _uEdge = 8;
const int _uCurve = 9;
const int _uTint = 17;

ui.FragmentProgram? _program;
Future<ui.FragmentProgram>? _loading;

Future<ui.FragmentProgram> _loadProgram() {
  return _loading ??= ui.FragmentProgram.fromAsset(_shaderAsset).then(
    (program) => _program = program,
  );
}

/// Performance-friendly single-pass-per-axis progressive backdrop blur.
///
/// Renders via one [BackdropFilterLayer] with a bilinear-paired separable
/// Gaussian runtime shader so scrolling stays smooth with zero grid artifacts.
class ProgressiveEdgeBlur extends StatefulWidget {
  /// Creates a progressive backdrop blur anchored to [edge].
  const ProgressiveEdgeBlur({
    super.key,
    this.edge = ProgressiveBlurEdge.top,
    this.sigma = 12,
    this.curve = Curves.easeIn,
    this.tint,
    this.fallbackColor,
  }) : assert(sigma >= 0);

  /// The edge where blur strength reaches [sigma].
  final ProgressiveBlurEdge edge;

  /// Maximum blur sigma at [edge] in logical pixels.
  final double sigma;

  /// Falloff curve from inner edge (`t = 0`) to outer [edge] (`t = 1`).
  final Curve curve;

  /// Optional subtle tint mixed strictly near [edge].
  final Color? tint;

  /// Fallback gradient color when shader backdrop filters are unsupported.
  final Color? fallbackColor;

  /// Whether custom shader image filters are supported on this backend.
  static bool get isSupported => ui.ImageFilter.isShaderFilterSupported;

  /// Preloads the shader program before first frame to avoid initial pop-in.
  static Future<void> precache() async {
    if (isSupported) {
      await _loadProgram();
    }
  }

  @override
  State<ProgressiveEdgeBlur> createState() => _ProgressiveEdgeBlurState();
}

class _ProgressiveEdgeBlurState extends State<ProgressiveEdgeBlur> {
  @override
  void initState() {
    super.initState();
    if (ProgressiveEdgeBlur.isSupported && _program == null) {
      _loadProgram().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final program = _program;
    return IgnorePointer(
      child: !ProgressiveEdgeBlur.isSupported || program == null
          ? _FallbackEdgeGradient(
              edge: widget.edge,
              curve: widget.curve,
              color: widget.fallbackColor,
            )
          : _ProgressiveBlurRenderWidget(
              program: program,
              edge: widget.edge,
              sigma: widget.sigma,
              curve: widget.curve,
              tint: widget.tint,
              devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
            ),
    );
  }
}

class _FallbackEdgeGradient extends StatelessWidget {
  const _FallbackEdgeGradient({
    required this.edge,
    required this.curve,
    required this.color,
  });

  final ProgressiveBlurEdge edge;
  final Curve curve;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color;
    if (color == null) {
      return const SizedBox.expand();
    }

    final (begin, end) = switch (edge) {
      ProgressiveBlurEdge.top => (Alignment.topCenter, Alignment.bottomCenter),
      ProgressiveBlurEdge.bottom => (
          Alignment.bottomCenter,
          Alignment.topCenter
        ),
      ProgressiveBlurEdge.left => (Alignment.centerLeft, Alignment.centerRight),
      ProgressiveBlurEdge.right => (
          Alignment.centerRight,
          Alignment.centerLeft
        ),
    };

    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            colors: [
              for (var i = 0; i < _curveSamples; i++)
                color.withValues(
                  alpha:
                      color.a * curve.transform(1 - i / (_curveSamples - 1)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressiveBlurRenderWidget extends LeafRenderObjectWidget {
  const _ProgressiveBlurRenderWidget({
    required this.program,
    required this.edge,
    required this.sigma,
    required this.curve,
    required this.tint,
    required this.devicePixelRatio,
  });

  final ui.FragmentProgram program;
  final ProgressiveBlurEdge edge;
  final double sigma;
  final Curve curve;
  final Color? tint;
  final double devicePixelRatio;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderProgressiveBlur(
      program: program,
      edge: edge,
      sigma: sigma,
      curve: curve,
      tint: tint,
      devicePixelRatio: devicePixelRatio,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderProgressiveBlur renderObject,
  ) {
    renderObject
      ..edge = edge
      ..sigma = sigma
      ..curve = curve
      ..tint = tint
      ..devicePixelRatio = devicePixelRatio;
  }
}

class _RenderProgressiveBlur extends RenderBox {
  _RenderProgressiveBlur({
    required ui.FragmentProgram program,
    required ProgressiveBlurEdge edge,
    required double sigma,
    required Curve curve,
    required Color? tint,
    required double devicePixelRatio,
  })  : _horizontal = program.fragmentShader(),
        _vertical = program.fragmentShader(),
        _edge = edge,
        _sigma = sigma,
        _curve = curve,
        _tint = tint,
        _devicePixelRatio = devicePixelRatio;

  final ui.FragmentShader _horizontal;
  final ui.FragmentShader _vertical;
  final LayerHandle<ClipRectLayer> _clipLayer = LayerHandle<ClipRectLayer>();
  final LayerHandle<BackdropFilterLayer> _horizLayer =
      LayerHandle<BackdropFilterLayer>();
  final LayerHandle<BackdropFilterLayer> _vertLayer =
      LayerHandle<BackdropFilterLayer>();

  Rect? _paintedRect;
  bool _watching = false;

  ProgressiveBlurEdge get edge => _edge;
  ProgressiveBlurEdge _edge;
  set edge(ProgressiveBlurEdge value) {
    if (value == _edge) return;
    _edge = value;
    markNeedsPaint();
  }

  double get sigma => _sigma;
  double _sigma;
  set sigma(double value) {
    if (value == _sigma) return;
    _sigma = value;
    markNeedsPaint();
  }

  Curve get curve => _curve;
  Curve _curve;
  set curve(Curve value) {
    if (value == _curve) return;
    _curve = value;
    markNeedsPaint();
  }

  Color? get tint => _tint;
  Color? _tint;
  set tint(Color? value) {
    if (value == _tint) return;
    _tint = value;
    markNeedsPaint();
  }

  double get devicePixelRatio => _devicePixelRatio;
  double _devicePixelRatio;
  set devicePixelRatio(double value) {
    if (value == _devicePixelRatio) return;
    _devicePixelRatio = value;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(
      constraints.hasBoundedWidth && constraints.hasBoundedHeight,
      'ProgressiveEdgeBlur requires bounded constraints.',
    );
    return constraints.biggest;
  }

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _watching = true;
    _watchPosition();
  }

  @override
  void detach() {
    _watching = false;
    super.detach();
  }

  void _watchPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_watching) return;
      if (hasSize && _paintedRect != null && _screenRect() != _paintedRect) {
        markNeedsPaint();
      }
      _watchPosition();
    });
  }

  Rect _screenRect() =>
      MatrixUtils.transformRect(getTransformTo(null), Offset.zero & size);

  void _setUniforms(ui.FragmentShader shader, Rect band, bool vertical) {
    final tint = _tint ?? const Color(0x00000000);
    shader
      ..setFloat(_uBand, band.left)
      ..setFloat(_uBand + 1, band.top)
      ..setFloat(_uBand + 2, band.width)
      ..setFloat(_uBand + 3, band.height)
      ..setFloat(_uSigma, _sigma * _devicePixelRatio)
      ..setFloat(_uVertical, vertical ? 1 : 0)
      ..setFloat(_uEdge, _edge.index.toDouble())
      ..setFloat(_uTint, tint.r * tint.a)
      ..setFloat(_uTint + 1, tint.g * tint.a)
      ..setFloat(_uTint + 2, tint.b * tint.a)
      ..setFloat(_uTint + 3, tint.a);
    for (var i = 0; i < _curveSamples; i++) {
      shader.setFloat(_uCurve + i, _curve.transform(i / (_curveSamples - 1)));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final screenRect = _screenRect();
    _paintedRect = screenRect;
    final band = Rect.fromLTRB(
      screenRect.left * _devicePixelRatio,
      screenRect.top * _devicePixelRatio,
      screenRect.right * _devicePixelRatio,
      screenRect.bottom * _devicePixelRatio,
    );
    _setUniforms(_horizontal, band, false);
    _setUniforms(_vertical, band, true);

    final horizBackdrop = _horizLayer.layer ??= BackdropFilterLayer();
    horizBackdrop.filter = ui.ImageFilter.shader(
      _horizontal,
      filterQuality: ui.FilterQuality.low,
    );
    final vertBackdrop = _vertLayer.layer ??= BackdropFilterLayer();
    vertBackdrop.filter = ui.ImageFilter.shader(
      _vertical,
      filterQuality: ui.FilterQuality.low,
    );

    _clipLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      (context, offset) {
        context.pushLayer(horizBackdrop, _paintNothing, offset);
        context.pushLayer(vertBackdrop, _paintNothing, offset);
      },
      oldLayer: _clipLayer.layer,
    );
  }

  static void _paintNothing(PaintingContext context, Offset offset) {}

  @override
  void dispose() {
    _clipLayer.layer = null;
    _horizLayer.layer = null;
    _vertLayer.layer = null;
    _horizontal.dispose();
    _vertical.dispose();
    super.dispose();
  }
}
