import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/utils/foss_location.dart';

/// Displays a static light-mode map card background pinned at [coordinates]
/// with a subtle radial vignette blur baked once into a cached [ui.Image] so
/// scrolling stays tear-free and zero-lag.
class LocationCardContent extends StatefulWidget {
  final LatLng coordinates;
  final bool compact;

  const LocationCardContent({
    super.key,
    required this.coordinates,
    this.compact = false,
  });

  @override
  State<LocationCardContent> createState() => _LocationCardContentState();
}

class _LocationCardContentState extends State<LocationCardContent> {
  static const int _regularZoom = 17;
  static const int _compactZoom = 18;
  static const int _regularCanvasWidth = 720;
  static const int _regularCanvasHeight = 500;
  static const double _regularTileDrawSize = 320.0;
  static const int _compactCanvasSize = 560;
  static const double _compactTileDrawSize = 380.0;
  static const int _maxCachedMaps = 40;
  static const int _maxCachedTiles = 120;
  static const Color _mapBaseColor = Color(0xFFF2EFE9);

  static final LinkedHashMap<String, ui.Image> _renderedMapCache =
      LinkedHashMap<String, ui.Image>();
  static final Map<String, Future<ui.Image?>> _inFlightMaps = {};
  static final LinkedHashMap<String, ui.Image> _tileCache =
      LinkedHashMap<String, ui.Image>();
  static final Map<String, Future<ui.Image?>> _inFlightTiles = {};
  static final HttpClient _httpClient = HttpClient()
    ..userAgent = 'org.thegandabherunda.openjot';

  ui.Image? _mapImage;
  String? _placeName;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (_mapImage == null) {
      _loadData();
    }
  }

  @override
  void didUpdateWidget(covariant LocationCardContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coordinates != widget.coordinates ||
        oldWidget.compact != widget.compact) {
      _loadData();
    }
  }

  String _coordKey(LatLng coords, bool compact) =>
      '${compact ? 'c' : 'r'}_${coords.latitude.toStringAsFixed(4)},${coords.longitude.toStringAsFixed(4)}';

  void _loadData() {
    final target = widget.coordinates;
    final compact = widget.compact;
    final key = _coordKey(target, compact);

    if (compact) {
      _placeName = null;
    } else {
      _placeName = FossLocation.getCachedPlaceName(target);
      if (_placeName == null) {
        unawaited(FossLocation.getPlaceName(target).then((resolved) {
          if (!mounted ||
              resolved == null ||
              widget.coordinates != target ||
              widget.compact) {
            return;
          }
          setState(() {
            _placeName = resolved;
          });
        }));
      }
    }

    final cachedMap = _renderedMapCache[key];
    if (cachedMap != null) {
      _mapImage = cachedMap;
      return;
    }

    _mapImage = null;
    unawaited(_getOrRenderMapImage(target, compact, key).then((image) {
      if (!mounted ||
          image == null ||
          widget.coordinates != target ||
          widget.compact != compact) {
        return;
      }
      setState(() {
        _mapImage = image;
      });
    }));
  }

  static Future<ui.Image?> _getOrRenderMapImage(
    LatLng coords,
    bool compact,
    String key,
  ) {
    final cached = _renderedMapCache[key];
    if (cached != null) return Future.value(cached);

    final existing = _inFlightMaps[key];
    if (existing != null) return existing;

    final future = _renderMapCardImage(coords, compact, key).whenComplete(() {
      _inFlightMaps.remove(key);
    });
    _inFlightMaps[key] = future;
    return future;
  }

  static Future<ui.Image?> _renderMapCardImage(
    LatLng coords,
    bool compact,
    String key,
  ) async {
    try {
      final zoom = compact ? _compactZoom : _regularZoom;
      final canvasWidth = compact ? _compactCanvasSize : _regularCanvasWidth;
      final canvasHeight = compact ? _compactCanvasSize : _regularCanvasHeight;
      final tileDrawSize =
          compact ? _compactTileDrawSize : _regularTileDrawSize;
      final n = 1 << zoom;
      final tx = (coords.longitude + 180.0) / 360.0 * n;
      final latRad = coords.latitude * math.pi / 180.0;
      final ty = (1.0 -
              math.log(math.tan(latRad) + 1.0 / math.cos(latRad)) / math.pi) /
          2.0 *
          n;

      final cx = tx.floor();
      final cy = ty.floor();
      final fx = tx - cx;
      final fy = ty - cy;

      final halfW = canvasWidth / 2.0;
      final halfH = canvasHeight / 2.0;

      final tileJobs = <({int dx, int dy, Future<ui.Image?> future})>[];
      for (int dy = -1; dy <= 1; dy++) {
        final tileY = cy + dy;
        if (tileY < 0 || tileY >= n) continue;
        for (int dx = -1; dx <= 1; dx++) {
          var tileX = (cx + dx) % n;
          if (tileX < 0) tileX += n;
          tileJobs.add((
            dx: dx,
            dy: dy,
            future: _fetchTile(zoom, tileX, tileY),
          ));
        }
      }

      final resolvedTiles = await Future.wait(
        tileJobs.map((job) async => (
              dx: job.dx,
              dy: job.dy,
              image: await job.future,
            )),
      );

      if (resolvedTiles.every((t) => t.image == null)) {
        return null;
      }

      // 1. Composite OSM tiles onto a single crisp base texture (with 1px overlap).
      final baseRecorder = ui.PictureRecorder();
      final bounds = Rect.fromLTWH(
        0,
        0,
        canvasWidth.toDouble(),
        canvasHeight.toDouble(),
      );
      final baseCanvas = Canvas(baseRecorder, bounds);
      baseCanvas.drawRect(bounds, Paint()..color = _mapBaseColor);

      final tilePaint = Paint()..filterQuality = FilterQuality.medium;
      for (final tile in resolvedTiles) {
        final img = tile.image;
        if (img == null) continue;
        final left = halfW + (tile.dx - fx) * tileDrawSize;
        final top = halfH + (tile.dy - fy) * tileDrawSize;
        final src = Rect.fromLTWH(
          0,
          0,
          img.width.toDouble(),
          img.height.toDouble(),
        );
        final dst = Rect.fromLTWH(
          left,
          top,
          tileDrawSize + 1.0,
          tileDrawSize + 1.0,
        );
        baseCanvas.drawImageRect(img, src, dst, tilePaint);
      }

      final basePicture = baseRecorder.endRecording();
      final baseImage = await basePicture.toImage(canvasWidth, canvasHeight);
      basePicture.dispose();

      // 2. Bake subtle radial edge blur into a single flat texture so scrolling
      //    never pays per-frame blur or BackdropFilter readback costs.
      final finalRecorder = ui.PictureRecorder();
      final finalCanvas = Canvas(finalRecorder, bounds);
      finalCanvas.drawImage(baseImage, Offset.zero, Paint());

      finalCanvas.saveLayer(bounds, Paint());
      finalCanvas.drawImage(
        baseImage,
        Offset.zero,
        Paint()
          ..imageFilter = ui.ImageFilter.blur(
            sigmaX: 6.5,
            sigmaY: 6.5,
            tileMode: ui.TileMode.clamp,
          ),
      );
      finalCanvas.drawRect(
        bounds,
        Paint()
          ..blendMode = BlendMode.dstIn
          ..shader = ui.Gradient.radial(
            Offset(halfW, halfH),
            canvasWidth * 0.48,
            const [
              Color(0x00FFFFFF),
              Color(0x00FFFFFF),
              Color(0xFFFFFFFF),
            ],
            const [0.0, 0.46, 1.0],
          ),
      );
      finalCanvas.restore();
      baseImage.dispose();

      final finalPicture = finalRecorder.endRecording();
      final finalImage =
          await finalPicture.toImage(canvasWidth, canvasHeight);
      finalPicture.dispose();

      if (_renderedMapCache.length >= _maxCachedMaps) {
        final oldestKey = _renderedMapCache.keys.first;
        _renderedMapCache.remove(oldestKey);
      }
      _renderedMapCache[key] = finalImage;
      return finalImage;
    } catch (e, st) {
      debugPrint('LocationCardContent render error: $e\n$st');
      return null;
    }
  }

  static Future<ui.Image?> _fetchTile(int z, int x, int y) {
    final key = '$z/$x/$y';
    final cached = _tileCache[key];
    if (cached != null) return Future.value(cached);

    final existing = _inFlightTiles[key];
    if (existing != null) return existing;

    final future = _downloadAndDecodeTile(z, x, y, key).whenComplete(() {
      _inFlightTiles.remove(key);
    });
    _inFlightTiles[key] = future;
    return future;
  }

  static Future<ui.Image?> _downloadAndDecodeTile(
    int z,
    int x,
    int y,
    String key,
  ) async {
    try {
      final uri = Uri.parse('https://tile.openstreetmap.org/$z/$x/$y.png');
      final request = await _httpClient.getUrl(uri);
      request.headers.set(
        HttpHeaders.userAgentHeader,
        'org.thegandabherunda.openjot',
      );
      final response =
          await request.close().timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) {
        await response.drain<void>();
        debugPrint('LocationCardContent tile $key HTTP ${response.statusCode}');
        return null;
      }

      final bytes = await consolidateHttpClientResponseBytes(response);
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      codec.dispose();

      if (_tileCache.length >= _maxCachedTiles) {
        final oldestKey = _tileCache.keys.first;
        _tileCache.remove(oldestKey);
      }
      _tileCache[key] = frame.image;
      return frame.image;
    } catch (e) {
      debugPrint('LocationCardContent tile $key error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);

    return RepaintBoundary(
      child: ColoredBox(
        color: _mapBaseColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_mapImage != null)
              RawImage(
                image: _mapImage,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
              ),
            Center(
              child: Transform.translate(
                offset: Offset(0, widget.compact ? -11.sp : -14.sp),
                child: Icon(
                  Icons.location_pin,
                  color: colors.aOrange[1],
                  size: widget.compact ? 28.sp : 34.sp,
                ),
              ),
            ),
            if (!widget.compact)
              Positioned(
                left: 12.w,
                right: 12.w,
                bottom: 10.h,
                child: Text(
                  _placeName ?? 'Pinned Location',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppConstants.font,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                    color: const Color(0xFF1C1C1E),
                    letterSpacing: -0.2,
                    shadows: const [
                      Shadow(
                        color: Colors.white,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
