// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistModalAdapter extends TypeAdapter<PlaylistModal> {
  @override
  final int typeId = 1;

  @override
  PlaylistModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistModal(
      playlistName: fields[0] as String,
    )..playlistSongID = (fields[1] as List).cast<int>();
  }

  @override
  void write(BinaryWriter writer, PlaylistModal obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.playlistName)
      ..writeByte(1)
      ..write(obj.playlistSongID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
