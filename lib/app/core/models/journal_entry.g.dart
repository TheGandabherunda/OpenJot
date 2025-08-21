// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordedAudioAdapter extends TypeAdapter<RecordedAudio> {
  @override
  final int typeId = 1;

  @override
  RecordedAudio read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecordedAudio(
      path: fields[0] as String,
      name: fields[1] as String,
      duration: fields[2] as Duration,
      isShared: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RecordedAudio obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.isShared);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordedAudioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CapturedPhotoAdapter extends TypeAdapter<CapturedPhoto> {
  @override
  final int typeId = 2;

  @override
  CapturedPhoto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CapturedPhoto(
      file: fields[0] as XFile,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CapturedPhoto obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.file)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CapturedPhotoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SelectedLocationAdapter extends TypeAdapter<SelectedLocation> {
  @override
  final int typeId = 3;

  @override
  SelectedLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SelectedLocation(
      coordinates: fields[0] as LatLng,
      link: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SelectedLocation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.coordinates)
      ..writeByte(1)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 0;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      id: fields[0] as String,
      content: fields[1] as Document,
      createdAt: fields[2] as DateTime,
      isBookmarked: fields[3] as bool,
      isReflection: fields[4] as bool,
      moodIndex: fields[5] as int?,
      location: fields[6] as SelectedLocation?,
      galleryImages: (fields[7] as List).cast<AssetEntity>(),
      cameraPhotos: (fields[8] as List).cast<CapturedPhoto>(),
      galleryAudios: (fields[9] as List).cast<AssetEntity>(),
      recordings: (fields[10] as List).cast<RecordedAudio>(),
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.isBookmarked)
      ..writeByte(4)
      ..write(obj.isReflection)
      ..writeByte(5)
      ..write(obj.moodIndex)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.galleryImages)
      ..writeByte(8)
      ..write(obj.cameraPhotos)
      ..writeByte(9)
      ..write(obj.galleryAudios)
      ..writeByte(10)
      ..write(obj.recordings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
