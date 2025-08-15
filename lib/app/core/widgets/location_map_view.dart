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
          _permissionMessage = 'Location permission is required to use the map.';
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
        setState(() {
          _selectedLocation = latLng;
          _isLoading = false;
        });
        _mapController.move(latLng, 15.0);
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
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    height: 500.h, // Set a fixed height for the map
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: const LatLng(20.5937, 78.9629),
                        initialZoom: 5.0,
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
                                  Icons.location_on_rounded,
                                  color: Theme.of(context).primaryColor,
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
              child: SizedBox(height: 100),
            ),
          ],
        ),
        Positioned(
          top: 16.h,
          right: 16.w,
          child: FloatingActionButton(
            heroTag: 'current_location_btn',
            backgroundColor: colors.grey6,
            foregroundColor: colors.grey10,
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
                : Icon(Icons.my_location_rounded, size: 24.sp),
          ),
        ),
        if (_selectedLocation != null)
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Center(
              child: CustomButton(
                onPressed: _addLocation,
                borderRadius: 56,
                text: 'Add Location',
                icon: Icons.add,
                iconSize: 24,
                color: Theme.of(context).primaryColor,
                textColor: colors.grey8,
                textPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
            ),
          ),
      ],
    );
  }
}
