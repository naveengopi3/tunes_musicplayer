// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentModelAdapter extends TypeAdapter<RecentModel> {
  @override
  final int typeId = 1;

  @override
  RecentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentModel(
      recentSongName: fields[0] as String,
      recentSongArtist: fields[1] as String,
      recentSongDuration: fields[2] as int,
      recentSongurl: fields[3] as String,
      recentId: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecentModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.recentSongName)
      ..writeByte(1)
      ..write(obj.recentSongArtist)
      ..writeByte(2)
      ..write(obj.recentSongDuration)
      ..writeByte(3)
      ..write(obj.recentSongurl)
      ..writeByte(4)
      ..write(obj.recentId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
