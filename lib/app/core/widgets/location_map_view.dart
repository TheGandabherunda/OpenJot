import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

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
    this.onMaximizeToggled,
  });

  final ScrollController scrollController;
  final Function(LatLng location)? onLocationSelected;
  final LatLng? initialLocation;
  final ValueChanged<bool>? onMaximizeToggled;

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

  // Search variables
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  // Sizing variables
  bool _isMaximized = false;
  final double _defaultMinimizedHeight = 380.0;
  final double _defaultMaximizedHeightRatio = 0.65;

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _checkPermissionAndFetch(moveMap: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _moveToLocation(widget.initialLocation!, 18);
        }
      });
    } else {
      _checkPermissionAndFetch(moveMap: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _moveToLocation(LatLng location, double zoom) {
    _animatedMapMove(location, zoom);
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween =
    LatLngTween(begin: _mapController.camera.center, end: destLocation);
    final zoomTween =
    Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

    final animation = CurvedAnimation(
      parent: _animationController,
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

        if (mounted) {
          setState(() {
            _currentLocation = latLng;
            if (moveMap) {
              _selectedLocation = latLng;
            }
            _isLoading = false;
          });
          if (moveMap) {
            _moveToLocation(latLng, 18);
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

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces(query);
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    try {
      final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&addressdetails=1&limit=5');
      final request = await HttpClient().getUrl(uri);
      request.headers.add('User-Agent', 'OpenJotApp');
      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final List jsonResponse = json.decode(stringData);
        if (mounted) {
          setState(() {
            _searchResults = jsonResponse;
            _isSearching = false;
          });
        }
      } else {
        if (mounted) setState(() => _isSearching = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _selectSearchResult(dynamic result) {
    final lat = double.tryParse(result['lat'].toString());
    final lon = double.tryParse(result['lon'].toString());

    if (lat != null && lon != null) {
      final location = LatLng(lat, lon);
      setState(() {
        _selectedLocation = location;
        _searchResults = [];
        _searchController.text = result['name'] ?? result['display_name']?.split(',').first ?? '';
      });
      _moveToLocation(location, 16);
      FocusScope.of(context).unfocus();
    }
  }

  void _refreshMap() {
    FocusScope.of(context).unfocus();
    _searchController.clear();
    setState(() => _searchResults = []);
    _getCurrentLocation(moveMap: true);
  }

  void _handleTap(TapPosition tapPosition, LatLng latLng) {
    FocusScope.of(context).unfocus();
    setState(() => _searchResults = []);
    if (mounted) {
      setState(() {
        _selectedLocation = latLng;
      });
      _moveToLocation(latLng, _mapController.camera.zoom);
    }
  }

  void _addLocation() {
    if (_selectedLocation != null) {
      widget.onLocationSelected?.call(_selectedLocation!);
    }
  }

  void _toggleMaximize() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isMaximized = !_isMaximized;
    });
    widget.onMaximizeToggled?.call(_isMaximized);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_selectedLocation != null && mounted) {
        _moveToLocation(_selectedLocation!, _mapController.camera.zoom);
      }
    });
  }

  bool _isSelectedLocationCurrentUserLocation() {
    if (_selectedLocation == null || _currentLocation == null) {
      return false;
    }
    return _selectedLocation!.latitude.toStringAsFixed(5) ==
        _currentLocation!.latitude.toStringAsFixed(5) &&
        _selectedLocation!.longitude.toStringAsFixed(5) ==
            _currentLocation!.longitude.toStringAsFixed(5);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final screenHeight = MediaQuery.of(context).size.height;

    final mapHeight = _isMaximized ? (screenHeight * _defaultMaximizedHeightRatio) : _defaultMinimizedHeight.h;

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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                height: mapHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Stack(
                    children: [
                      FlutterMap(
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

                      Positioned(
                        top: 12.h,
                        left: 12.w,
                        right: 12.w,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: colors.grey6.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(999), // Fully rounded pill shape
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                decoration: InputDecoration(
                                  hintText: 'Search places, shops...',
                                  hintStyle: TextStyle(
                                    color: colors.grey2,
                                    fontSize: 14.sp,
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(left: 12.w, right: 4.w),
                                    child: Icon(Icons.search_rounded, color: colors.grey1),
                                  ),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: 8.w),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_isSearching)
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                                            child: SizedBox(
                                              width: 18.w,
                                              height: 18.w,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: colors.grey1,
                                              ),
                                            ),
                                          )
                                        else if (_searchController.text.isNotEmpty)
                                          IconButton(
                                            icon: Icon(Icons.close_rounded, color: colors.grey1, size: 20.sp),
                                            onPressed: () {
                                              _searchController.clear();
                                              setState(() => _searchResults = []);
                                              FocusScope.of(context).unfocus();
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(999),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(999),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(999),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                                ),
                                style: TextStyle(
                                  color: colors.grey10,
                                  fontFamily: AppConstants.font,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),

                            if (_searchResults.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(top: 8.h),
                                decoration: BoxDecoration(
                                  color: colors.grey6.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                constraints: BoxConstraints(maxHeight: 220.h),
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: _searchResults.length,
                                  separatorBuilder: (context, index) => Divider(
                                    color: colors.grey4,
                                    height: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    final result = _searchResults[index];
                                    return ListTile(
                                      leading: Icon(
                                        Icons.location_on_outlined,
                                        color: colors.grey2,
                                        size: 20.sp,
                                      ),
                                      title: Text(
                                        result['display_name'] ?? '',
                                        style: TextStyle(
                                          color: colors.grey10,
                                          fontSize: 13.sp,
                                          fontFamily: AppConstants.font,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () => _selectSearchResult(result),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),

                      Positioned(
                        top: 76.h,
                        right: 12.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FloatingActionButton.small(
                              heroTag: 'maximize_map_btn',
                              backgroundColor: colors.grey6.withOpacity(0.9),
                              foregroundColor: colors.grey10,
                              elevation: 2,
                              onPressed: _toggleMaximize,
                              child: Icon(
                                _isMaximized ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                                size: 22.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            FloatingActionButton.small(
                              heroTag: 'current_location_btn',
                              backgroundColor: colors.grey6.withOpacity(0.9),
                              foregroundColor: colors.grey10,
                              elevation: 2,
                              onPressed: _isLoading ? null : () => _getCurrentLocation(moveMap: true),
                              child: _isLoading
                                  ? SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: CircularProgressIndicator(
                                  color: colors.grey10,
                                  strokeWidth: 2,
                                ),
                              )
                                  : Icon(
                                _isSelectedLocationCurrentUserLocation()
                                    ? Icons.my_location_rounded
                                    : Icons.location_searching_rounded,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            FloatingActionButton.small(
                              heroTag: 'refresh_map_btn',
                              backgroundColor: colors.grey6.withOpacity(0.9),
                              foregroundColor: colors.grey10,
                              elevation: 2,
                              onPressed: _refreshMap,
                              child: Icon(
                                Icons.refresh_rounded,
                                size: 22.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
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