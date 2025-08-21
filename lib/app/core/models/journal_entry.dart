
import 'package:camera/camera.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;

part 'journal_entry.g.dart';

@HiveType(typeId: 1)
class RecordedAudio {
  @HiveField(0)
  final String path;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final Duration duration;
  @HiveField(3)
  final bool isShared;

  RecordedAudio({
    required this.path,
    required this.name,
    required this.duration,
    this.isShared = false,
  });
}

@HiveType(typeId: 2)
class CapturedPhoto {
  @HiveField(0)
  final XFile file;
  @HiveField(1)
  final String name;

  CapturedPhoto({required this.file, required this.name});
}

@HiveType(typeId: 3)
class SelectedLocation {
  @HiveField(0)
  final LatLng coordinates;
  @HiveField(1)
  final String link;

  SelectedLocation({required this.coordinates, required this.link});
}

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final Document content;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  bool isBookmarked;
  @HiveField(4)
  final bool isReflection;
  @HiveField(5)
  int? moodIndex;
  @HiveField(6)
  SelectedLocation? location;
  @HiveField(7)
  final List<AssetEntity> galleryImages;
  @HiveField(8)
  final List<CapturedPhoto> cameraPhotos;
  @HiveField(9)
  final List<AssetEntity> galleryAudios;
  @HiveField(10)
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
