import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/utils/foss_location.dart';
import 'package:open_jot/app/core/widgets/custom_button.dart';

// Animation Helper: A custom Tween for animating between two LatLng points.
class LatLngTween extends Tween<LatLng> {
  LatLngTween({required super.begin, required super.end});

  @override
  LatLng lerp(double t) {
    return LatLng(
      begin!.latitude + (end!.latitude - begin!.latitude) * t,
      begin!.longitude + (end!.longitude - begin!.longitude) * t,
    );
  }
}

class LocationMapView extends StatefulWidget {
  const LocationMapView({
    super.key,
    required this.scrollController,
    this.onLocationSelected,
    this.initialLocation,
  });

  final ScrollController scrollController;
  final Function(LatLng location)? onLocationSelected;
  final LatLng? initialLocation;

  @override
  State<LocationMapView> createState() => _LocationMapViewState();
}

class _LocationMapViewState extends State<LocationMapView>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  bool _isLoading = false;
  String? _permissionMessage;

  late final AnimationController _animationController;

  // This offset shifts the map's center down, making the pin appear higher.
  static const double _latitudeOffset = 0.0009;
  static const double _longitudeOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // If a location is passed, show it. Otherwise, fetch the current location.
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _checkPermissionAndFetch(moveMap: false);
      // This ensures the map moves to the initial location after the widget is built.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final mapCenter = LatLng(
            widget.initialLocation!.latitude - _latitudeOffset,
            widget.initialLocation!.longitude - _longitudeOffset,
          );
          _animatedMapMove(mapCenter, 18);
        }
      });
    } else {
      _checkPermissionAndFetch(moveMap: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween =
    LatLngTween(begin: _mapController.camera.center, end: destLocation);
    final zoomTween =
    Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

    final animation = CurvedAnimation(
      parent: _animationController,
      // This custom cubic curve provides a fast start and a long, gentle deceleration for a natural feel.
      curve: const Cubic(0.23, 1, 0.32, 1),
    );

    void listener() {
      if (mounted) {
        _mapController.move(
          latTween.evaluate(animation),
          zoomTween.evaluate(animation),
        );
      }
    }

    _animationController.reset();
    animation.addListener(listener);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        animation.removeListener(listener);
      }
    });
    _animationController.forward();
  }

  Future<void> _checkPermissionAndFetch({bool moveMap = true}) async {
    final granted = await FossLocation.requestPermission();
    if (granted) {
      await _getCurrentLocation(moveMap: moveMap);
    } else {
      if (mounted) {
        setState(() {
          _permissionMessage = 'Location permission denied.';
        });
      }
    }
  }

  Future<void> _getCurrentLocation({bool moveMap = true}) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _permissionMessage = null;
    });

    try {
      final result = await FossLocation.getCurrentLocation();
      if (result != null) {
        final latLng = LatLng(result['latitude']!, result['longitude']!);

        // Apply offsets for visual centering.
        final mapCenter = LatLng(
          latLng.latitude - _latitudeOffset,
          latLng.longitude - _longitudeOffset,
        );

        if (mounted) {
          setState(() {
            _currentLocation = latLng;
            if (moveMap) {
              _selectedLocation = latLng;
            }
            _isLoading = false;
          });
          if (moveMap) {
            _animatedMapMove(mapCenter, 18);
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _permissionMessage = 'Failed to get current location.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _permissionMessage = 'Failed to get current location: $e';
        });
      }
    }
  }

  void _handleTap(TapPosition tapPosition, LatLng latLng) {
    if (mounted) {
      setState(() {
        _selectedLocation = latLng;
      });
      // Apply offsets for visual centering.
      final mapCenter = LatLng(
        latLng.latitude - _latitudeOffset,
        latLng.longitude - _longitudeOffset,
      );
      _animatedMapMove(mapCenter, _mapController.camera.zoom);
    }
  }

  void _addLocation() {
    if (_selectedLocation != null) {
      widget.onLocationSelected?.call(_selectedLocation!);
    }
  }

  bool _isSelectedLocationCurrentUserLocation() {
    if (_selectedLocation == null || _currentLocation == null) {
      return false;
    }
    // Removed the unnecessary parentheses here
    return _selectedLocation!.latitude.toStringAsFixed(5) ==
        _currentLocation!.latitude.toStringAsFixed(5) &&
        _selectedLocation!.longitude.toStringAsFixed(5) ==
            _currentLocation!.longitude.toStringAsFixed(5);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);

    if (_permissionMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _permissionMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.grey10,
              fontSize: 16.sp,
              decoration: TextDecoration.none,
              fontFamily: AppConstants.font,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  height: 530.h,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter:
                      _selectedLocation ?? const LatLng(20.5937, 78.9629),
                      initialZoom: _selectedLocation != null ? 18 : 10,
                      onTap: _handleTap,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'org.thegandabherunda.openjot',
                      ),
                      if (_selectedLocation != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 80.w,
                              height: 80.w,
                              point: _selectedLocation!,
                              child: TweenAnimationBuilder<double>(
                                key: ValueKey(_selectedLocation),
                                tween: Tween(begin: 0.3, end: 1),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutBack,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  Icons.location_pin,
                                  color: colors.aOrange[1],
                                  size: 40.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 80), // Space for the button
            ),
          ],
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            heroTag: 'current_location_btn',
            backgroundColor: colors.grey6,
            foregroundColor: colors.grey10,
            elevation: 0,
            onPressed:
            _isLoading ? null : () => _getCurrentLocation(moveMap: true),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _isLoading
                  ? SizedBox(
                key: const ValueKey('loader'),
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  color: colors.grey10,
                  strokeWidth: 2,
                ),
              )
                  : Icon(
                key: ValueKey(_isSelectedLocationCurrentUserLocation()),
                _isSelectedLocationCurrentUserLocation()
                    ? Icons.my_location_rounded
                    : Icons.location_searching_rounded,
                size: 24.sp,
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          bottom: _selectedLocation != null ? 16.h : -100.h,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: _selectedLocation != null ? 1 : 0,
            child: Center(
              child: CustomButton(
                onPressed: _addLocation,
                borderRadius: 60,
                text: 'Add',
                icon: Icons.add_location_alt_outlined,
                iconSize: 24,
                color: colors.grey8,
                textColor: colors.grey10,
                textPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              ),
            ),
          ),
        ),
      ],
    );
  }
}