import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;

/// Adapter for the [LatLng] class from the `latlong2` package.
class LatLngAdapter extends TypeAdapter<LatLng> {
  @override
  final int typeId = 4;

  @override
  LatLng read(BinaryReader reader) {
    final lat = reader.readDouble();
    final lng = reader.readDouble();
    return LatLng(lat, lng);
  }

  @override
  void write(BinaryWriter writer, LatLng obj) {
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
  }
}

/// Adapter for the [XFile] class from the `camera` package.
/// Stores the file path and recreates the [XFile] object on read.
class XFileAdapter extends TypeAdapter<XFile> {
  @override
  final int typeId = 5;

  @override
  XFile read(BinaryReader reader) {
    return XFile(reader.readString());
  }

  @override
  void write(BinaryWriter writer, XFile obj) {
    writer.writeString(obj.path);
  }
}

/// Adapter for the [Document] class from the `flutter_quill` package.
/// Converts the document's Delta to a JSON string for storage.
class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 6;

  @override
  Document read(BinaryReader reader) {
    final jsonString = reader.readString();
    if (jsonString.isEmpty) {
      return Document();
    }
    return Document.fromJson(jsonDecode(jsonString));
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    if (obj.isEmpty()) {
      writer.writeString('');
    } else {
      writer.writeString(jsonEncode(obj.toDelta().toJson()));
    }
  }
}

/// Adapter for the [AssetEntity] class from the `photo_manager` package.
/// Stores the asset's ID and retrieves the asset using the ID on read.
class AssetEntityAdapter extends TypeAdapter<AssetEntity> {
  @override
  final int typeId = 7;

  @override
  AssetEntity read(BinaryReader reader) {
    final id = reader.readString();
    // This is a placeholder. The actual retrieval will be asynchronous.
    // We handle the async loading within the HiveService.
    return AssetEntity(id: id, typeInt: 0, width: 0, height: 0);
  }

  @override
  void write(BinaryWriter writer, AssetEntity obj) {
    writer.writeString(obj.id);
  }
}

// NEW: Adapter for the Duration class.
// This tells Hive how to store the Duration by converting it to an integer
// (total seconds) and how to read it back.
class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 8; // Make sure this typeId is unique

  @override
  Duration read(BinaryReader reader) {
    final seconds = reader.readInt();
    return Duration(seconds: seconds);
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.writeInt(obj.inSeconds);
  }
}
