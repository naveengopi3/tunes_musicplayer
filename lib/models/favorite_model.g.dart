// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteModelAdapter extends TypeAdapter<FavoriteModel> {
  @override
  final int typeId = 2;

  @override
  FavoriteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteModel(
      favoriteSongname: fields[0] as String,
      favoriteSongArtist: fields[1] as String,
      favoriteSongDuration: fields[2] as int,
      favoriteSongurl: fields[3] as String,
      favoriteSongId: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.favoriteSongname)
      ..writeByte(1)
      ..write(obj.favoriteSongArtist)
      ..writeByte(2)
      ..write(obj.favoriteSongDuration)
      ..writeByte(3)
      ..write(obj.favoriteSongurl)
      ..writeByte(4)
      ..write(obj.favoriteSongId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
