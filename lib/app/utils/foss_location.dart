import 'package:flutter/services.dart';

class FossLocation {
  static const MethodChannel _channel = MethodChannel('foss_location');

  /// Ask user for location permission (Android runtime permission).
  static Future<bool> requestPermission() async {
    final granted = await _channel.invokeMethod<bool>('requestPermission');
    return granted ?? false;
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
