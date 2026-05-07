import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<Permission> getMediaPermission(int segment) async {
    if (!Platform.isAndroid) {
      return Permission.photos;
    }

    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = deviceInfo.version.sdkInt;

    if (sdkInt >= 33) {
      switch (segment) {
        case 0:
          return Permission.photos;
        case 1:
          return Permission.videos;
        case 2:
          return Permission.audio;
        default:
          return Permission.photos;
      }
    } else {
      // For Android < 13, all media access is covered by storage permission
      return Permission.storage;
    }
  }

  static Future<PermissionStatus> requestMediaPermission(int segment) async {
    final permission = await getMediaPermission(segment);
    return await permission.request();
  }
}
