import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart'; // <-- CHANGED from geolocator
import 'package:permission_handler/permission_handler.dart' as perm_handler; // Used for opening app settings

import '../../core/constants.dart';
import '../../core/theme.dart';
import 'custom_button.dart';

class LocationMapView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(LatLng location)? onLocationSelected;

  const LocationMapView({
    super.key,
    required this.scrollController,
    this.onLocationSelected,
  });

  @override
  State<LocationMapView> createState() => _LocationMapViewState();
}

class _LocationMapViewState extends State<LocationMapView> {
  final MapController _mapController = MapController();
  final Location _location = Location(); // <-- ADDED location instance
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  bool _isLoading = false;
  String? _permissionMessage;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  // REWRITTEN to use the 'location' package
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _permissionMessage = 'Location services are disabled.';
          });
        }
        return;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted == PermissionStatus.deniedForever) {
        if (mounted) {
          setState(() {
            _permissionMessage =
            'Location permission is permanently denied. Please enable it from settings.';
          });
        }
        return;
      }
      if (permissionGranted != PermissionStatus.granted) {
        if (mounted) {
          setState(() {
            _permissionMessage = 'Location permission is required to use the map.';
          });
        }
        return;
      }
    }

    // If we have permission, get the location
    _getCurrentLocation();
  }

  // REWRITTEN to use the 'location' package
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _permissionMessage = null;
    });

    try {
      final LocationData locationData = await _location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        final latLng = LatLng(locationData.latitude!, locationData.longitude!);

        const double latitudeOffset = 0.0008;
        const double longitudeOffset = 0.0000;
        final mapCenter = LatLng(latLng.latitude - latitudeOffset,
            latLng.longitude - longitudeOffset);

        if (mounted) {
          setState(() {
            _currentLocation = latLng;
            _selectedLocation = latLng;
            _isLoading = false;
          });
          _mapController.move(mapCenter, 18.0);
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
    return (_selectedLocation!.latitude.toStringAsFixed(5) ==
        _currentLocation!.latitude.toStringAsFixed(5) &&
        _selectedLocation!.longitude.toStringAsFixed(5) ==
            _currentLocation!.longitude.toStringAsFixed(5));
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);

    if (_permissionMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _permissionMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.grey10,
                  fontSize: 16.sp,
                  decoration: TextDecoration.none,
                  fontFamily: AppConstants.font,
                ),
              ),
              SizedBox(height: 16.h),
              if (_permissionMessage!.contains('settings'))
                ElevatedButton(
                  onPressed: perm_handler.openAppSettings,
                  child: const Text('Open Settings'),
                ),
            ],
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
                      initialCenter: const LatLng(20.5937, 78.9629),
                      initialZoom: 10.0,
                      onTap: _handleTap,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.openjot',
                      ),
                      if (_selectedLocation != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 80.w,
                              height: 80.w,
                              point: _selectedLocation!,
                              child: Icon(
                                Icons.location_pin,
                                color: colors.aOrange[1],
                                size: 40.sp,
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
              borderRadius: BorderRadius.circular(50.0),
            ),
            heroTag: 'current_location_btn',
            backgroundColor: colors.grey6,
            foregroundColor: colors.grey10,
            elevation: 0.0,
            onPressed: _isLoading ? null : _getCurrentLocation,
            child: _isLoading
                ? SizedBox(
              width: 24.w,
              height: 24.h,
              child: CircularProgressIndicator(
                color: colors.grey10,
                strokeWidth: 2,
              ),
            )
                : Icon(
                _isSelectedLocationCurrentUserLocation()
                    ? Icons.my_location_rounded
                    : Icons.location_searching_rounded,
                size: 24.sp),
          ),
        ),
        if (_selectedLocation != null)
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: Center(
              child: CustomButton(
                onPressed: _addLocation,
                borderRadius: 56,
                text: 'Add',
                icon: Icons.add_location_alt_outlined,
                iconSize: 24,
                color: colors.grey8,
                textColor: colors.grey10,
                textPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ),
      ],
    );
  }
}
