import 'dart:async';
import 'package:flutter/services.dart';

class ShareService {
  static const _platform = MethodChannel('app.channel.shared.data');
  void Function({
  String? text,
  List<String>? photos,
  List<String>? videos,
  List<String>? audios,
  })? onShareReceived;

  ShareService() {
    _platform.setMethodCallHandler(_handleMethod);
  }

  void startListening() {
    _platform.invokeMethod('getInitialShareData').then((data) {
      if (data != null) {
        _processSharedData(Map<String, dynamic>.from(data));
      }
    });
  }

  Future<void> _handleMethod(MethodCall call) async {
    if (call.method == 'onShareReceived') {
      _processSharedData(Map<String, dynamic>.from(call.arguments));
    }
  }

  void _processSharedData(Map<String, dynamic> data) {
    final String? text = data['text'];
    final List<dynamic> files = data['files'] ?? [];

    final photos = <String>[];
    final videos = <String>[];
    final audios = <String>[];

    for (final fileData in files) {
      final map = Map<String, dynamic>.from(fileData);
      final String path = map['path'];
      final String? mimeType = map['mimeType'];

      if (mimeType != null) {
        if (mimeType.startsWith('image/')) {
          photos.add(path);
        } else if (mimeType.startsWith('video/')) {
          videos.add(path);
        } else if (mimeType.startsWith('audio/')) {
          audios.add(path);
        }
      }
    }

    if (text != null || photos.isNotEmpty || videos.isNotEmpty || audios.isNotEmpty) {
      onShareReceived?.call(
        text: text,
        photos: photos.isNotEmpty ? photos : null,
        videos: videos.isNotEmpty ? videos : null,
        audios: audios.isNotEmpty ? audios : null,
      );
    }
  }

  void dispose() {
    // No-op for a persistent MethodChannel
  }
}

