import 'package:flutter_quill/flutter_quill.dart';
import 'package:latlong2/latlong.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;
import 'package:camera/camera.dart';

// Helper classes moved here for better organization
class RecordedAudio {
  final String path;
  final String name;
  final Duration duration;
  final bool isShared; // ADDED: Flag to identify shared audio files

  RecordedAudio({
    required this.path,
    required this.name,
    required this.duration,
    this.isShared = false, // ADDED: Default value
  });
}

class CapturedPhoto {
  final XFile file;
  final String name;

  CapturedPhoto({required this.file, required this.name});
}

class SelectedLocation {
  final LatLng coordinates;
  final String link;

  SelectedLocation({required this.coordinates, required this.link});
}

class JournalEntry {
  final String id;
  final Document content;
  final DateTime createdAt;
  final bool isBookmarked;
  final bool isReflection;
  final int? moodIndex;
  final SelectedLocation? location;
  final List<AssetEntity> galleryImages;
  final List<CapturedPhoto> cameraPhotos;
  final List<AssetEntity> galleryAudios;
  final List<RecordedAudio> recordings;

  JournalEntry({
    required this.id,
    required this.content,
    required this.createdAt,
    this.isBookmarked = false,
    this.isReflection = false,
    this.moodIndex,
    this.location,
    this.galleryImages = const [],
    this.cameraPhotos = const [],
    this.galleryAudios = const [],
    this.recordings = const [],
  });

  /// Creates a copy of this JournalEntry but with the given fields replaced with the new values.
  JournalEntry copyWith({
    String? id,
    Document? content,
    DateTime? createdAt,
    bool? isBookmarked,
    bool? isReflection,
    int? moodIndex,
    SelectedLocation? location,
    List<AssetEntity>? galleryImages,
    List<CapturedPhoto>? cameraPhotos,
    List<AssetEntity>? galleryAudios,
    List<RecordedAudio>? recordings,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isReflection: isReflection ?? this.isReflection,
      moodIndex: moodIndex ?? this.moodIndex,
      location: location ?? this.location,
      galleryImages: galleryImages ?? this.galleryImages,
      cameraPhotos: cameraPhotos ?? this.cameraPhotos,
      galleryAudios: galleryAudios ?? this.galleryAudios,
      recordings: recordings ?? this.recordings,
    );
  }
}
