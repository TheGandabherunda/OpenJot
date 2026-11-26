import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_jot/app/core/services/hive_service.dart';

class FossLocation {
  static const MethodChannel _channel = MethodChannel('foss_location');
  static const String _placeCacheKey = 'locationNameCache';

  static final Map<String, String> _memoryPlaceCache = {};
  static final Map<String, Future<String?>> _inFlightPlaceLookups = {};

  /// Ask user for location permission (Android runtime permission).
  static Future<bool> requestPermission() async {
    final granted = await _channel.invokeMethod<bool>('requestPermission');
    return granted ?? false;
  }

  /// Check if device location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    final enabled =
        await _channel.invokeMethod<bool>('isLocationServiceEnabled');
    return enabled ?? false;
  }

  /// Open Android location settings
  static Future<void> openLocationSettings() async {
    await _channel.invokeMethod<void>('openLocationSettings');
  }

  /// Get current location (lat/lng). Returns null if failed.
  static Future<Map<String, double>?> getCurrentLocation() async {
    final result = await _channel.invokeMethod<Map>('getCurrentLocation');
    if (result == null) return null;
    return {
      'latitude': result['latitude'] as double,
      'longitude': result['longitude'] as double,
    };
  }

  static String _coordKey(LatLng coords) =>
      '${coords.latitude.toStringAsFixed(4)},${coords.longitude.toStringAsFixed(4)}';

  /// Returns a cached human-readable place name synchronously if known.
  static String? getCachedPlaceName(LatLng coords) {
    final key = _coordKey(coords);
    final memHit = _memoryPlaceCache[key];
    if (memHit != null) return memHit;

    if (Get.isRegistered<HiveService>()) {
      final raw = Get.find<HiveService>().settingsBox.get(_placeCacheKey);
      if (raw is Map && raw[key] is String) {
        final name = raw[key] as String;
        _memoryPlaceCache[key] = name;
        return name;
      }
    }
    return null;
  }

  /// Caches a known place name for [coords] in memory and persistent storage.
  static void cachePlaceName(LatLng coords, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final key = _coordKey(coords);
    _memoryPlaceCache[key] = trimmed;

    if (Get.isRegistered<HiveService>()) {
      final box = Get.find<HiveService>().settingsBox;
      final existing = box.get(_placeCacheKey);
      final updated = existing is Map
          ? Map<String, dynamic>.from(existing)
          : <String, dynamic>{};
      updated[key] = trimmed;
      unawaited(box.put(_placeCacheKey, updated));
    }
  }

  /// Resolves a human-readable place name via OpenStreetMap Nominatim reverse
  /// geocoding, backed by memory and Hive caches.
  static Future<String?> getPlaceName(LatLng coords) async {
    final cached = getCachedPlaceName(coords);
    if (cached != null) return cached;

    final key = _coordKey(coords);
    final existingFuture = _inFlightPlaceLookups[key];
    if (existingFuture != null) return existingFuture;

    final future = _fetchPlaceName(coords).whenComplete(() {
      _inFlightPlaceLookups.remove(key);
    });
    _inFlightPlaceLookups[key] = future;
    return future;
  }

  static Future<String?> _fetchPlaceName(LatLng coords) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${coords.latitude}&lon=${coords.longitude}'
        '&format=json&addressdetails=1&zoom=16',
      );
      final request = await client.getUrl(uri);
      request.headers.add('User-Agent', 'OpenJotApp');
      final response = await request.close().timeout(
            const Duration(seconds: 8),
          );

      if (response.statusCode != 200) return null;

      final body = await response.transform(utf8.decoder).join();
      final decoded = json.decode(body);
      if (decoded is! Map<String, dynamic>) return null;

      final resolved = _extractPlaceName(decoded);
      if (resolved != null && resolved.isNotEmpty) {
        cachePlaceName(coords, resolved);
      }
      return resolved;
    } catch (_) {
      return null;
    } finally {
      client.close(force: true);
    }
  }

  static String? _extractPlaceName(Map<String, dynamic> data) {
    final address = data['address'];
    final Map<String, dynamic>? addrMap =
        address is Map<String, dynamic> ? address : null;

    String? pickFirst(List<String> keys) {
      if (addrMap == null) return null;
      for (final k in keys) {
        final v = addrMap[k]?.toString().trim();
        if (v != null && v.isNotEmpty) return v;
      }
      return null;
    }

    final rawName = data['name']?.toString().trim();
    final primary = (rawName != null && rawName.isNotEmpty)
        ? rawName
        : pickFirst([
            'amenity',
            'leisure',
            'tourism',
            'shop',
            'building',
            'neighbourhood',
            'suburb',
            'quarter',
            'road',
            'village',
            'town',
            'city',
          ]);

    final locality = pickFirst([
      'city',
      'town',
      'village',
      'state_district',
      'county',
      'state',
    ]);

    if (primary != null && locality != null && primary != locality) {
      return '$primary, $locality';
    }
    if (primary != null) return primary;
    if (locality != null) return locality;

    final displayName = data['display_name']?.toString().trim();
    if (displayName != null && displayName.isNotEmpty) {
      final parts = displayName
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .take(2)
          .toList();
      if (parts.isNotEmpty) return parts.join(', ');
    }
    return null;
  }
}
