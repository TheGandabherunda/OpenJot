import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/// Simple service to handle photo, text, video, and audio sharing
class ShareService {
  /// Callback for received shared content
  void Function({
  String? text,
  List<String>? photos,
  List<String>? videos,
  List<String>? audios,
  })? onShareReceived;

  StreamSubscription<List<SharedMediaFile>>? _streamSub;

  /// Start listening for share intents
  void startListening() {
    // Listen for new shares while app is running
    _streamSub = ReceiveSharingIntent.instance.getMediaStream().listen(
          (files) {
        if (files.isNotEmpty) {
          _handleSharedFiles(files);
        }
      },
      onError: (err) {
        debugPrint("ShareService error: $err");
      },
    );

    // Handle share intent when app was closed
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      if (files.isNotEmpty) {
        _handleSharedFiles(files);
        ReceiveSharingIntent.instance.reset();
      }
    });
  }

  /// Stop listening
  void dispose() {
    _streamSub?.cancel();
  }

  /// Process shared files and categorize them
  void _handleSharedFiles(List<SharedMediaFile> files) {
    String? text;
    final photos = <String>[];
    final videos = <String>[];
    final audios = <String>[];

    for (final file in files) {
      switch (file.type) {
        case SharedMediaType.text:
          text = file.path;
          break;
        case SharedMediaType.image:
          photos.add(file.path);
          break;
        case SharedMediaType.video:
          videos.add(file.path);
          break;
        case SharedMediaType.file:
        case SharedMediaType.url:
        // Check if it's an audio file or a GIF
          if (file.mimeType?.startsWith('audio/') == true) {
            audios.add(file.path);
          } else if (file.mimeType == 'image/gif') {
            photos.add(file.path);
          }
          break;
      }
    }

    // Only call callback if we have something
    if (text != null ||
        photos.isNotEmpty ||
        videos.isNotEmpty ||
        audios.isNotEmpty) {
      onShareReceived?.call(
        text: text,
        photos: photos.isNotEmpty ? photos : null,
        videos: videos.isNotEmpty ? videos : null,
        audios: audios.isNotEmpty ? audios : null,
      );
    }
  }
}
