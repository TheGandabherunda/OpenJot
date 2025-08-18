import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

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
  LatLng? _selectedLocation;
  LatLng? _currentLocation; // Added to store the user's actual current location
  bool _isLoading = false;
  String? _permissionMessage;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (mounted) {
      if (status.isGranted) {
        _getCurrentLocation();
      } else if (status.isPermanentlyDenied) {
        setState(() {
          _permissionMessage =
              'Location permission is permanently denied. Please enable it from settings.';
        });
      } else {
        setState(() {
          _permissionMessage =
              'Location permission is required to use the map.';
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    if (await Permission.locationWhenInUse.isGranted) {
      setState(() {
        _isLoading = true;
        _permissionMessage = null;
      });
      try {
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final latLng = LatLng(position.latitude, position.longitude);

        // Calculate an offset to move the map center down, making the location marker appear higher up in the bottom sheet.
        // This value has been reduced to ensure the marker remains visible.
        const double latitudeOffset = 0.0008;
        const double longitudeOffset = 0.0000;
        final mapCenter = LatLng(latLng.latitude - latitudeOffset,
            latLng.longitude - longitudeOffset);

        setState(() {
          _currentLocation = latLng; // Store the current location
          _selectedLocation = latLng; // Set selected location to current
          _isLoading = false;
        });
        _mapController.move(mapCenter, 18.0); // Increased zoom level
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _permissionMessage = 'Failed to get current location: $e';
          });
        }
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

  // Helper function to check if the selected location is the current location
  bool _isSelectedLocationCurrentUserLocation() {
    if (_selectedLocation == null || _currentLocation == null) {
      return false;
    }
    // Compare latitude and longitude with a small tolerance for precision
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _permissionMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.grey10,
                decoration: TextDecoration.none,
                fontFamily: AppConstants.font,
              ),
            ),
            SizedBox(height: 8.h),
            if (_permissionMessage!.contains('settings'))
              ElevatedButton(
                onPressed: openAppSettings,
                child: const Text('Open Settings'),
              ),
          ],
        ),
      );
    }

    // Use Stack to overlay the buttons on top of the scrollable map.
    return Stack(
      children: [
        // Using a CustomScrollView to ensure the entire sheet is scrollable and draggable.
        CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    height: 530.h, // Set a fixed height for the map
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
            ),
            // Padding to ensure the add button is visible above the bottom sheet's min height
            const SliverToBoxAdapter(
              child: SizedBox(height: 0),
            ),
          ],
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  50.0), // Adjust the radius value as needed
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
                    // Conditional icon logic
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
