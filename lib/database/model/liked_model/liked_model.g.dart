// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LikedSongsAdapter extends TypeAdapter<LikedSongs> {
  @override
  final int typeId = 0;

  @override
  LikedSongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LikedSongs(
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, LikedSongs obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikedSongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
