import 'package:flutter/services.dart';

class FossLocation {
  static const MethodChannel _channel = MethodChannel('foss_location');

  /// Ask user for location permission (Android runtime permission).
  static Future<bool> requestPermission() async {
    final granted = await _channel.invokeMethod<bool>('requestPermission');
    return granted ?? false;
  }

  /// Check if device location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    final enabled = await _channel.invokeMethod<bool>('isLocationServiceEnabled');
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
}