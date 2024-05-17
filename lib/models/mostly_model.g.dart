// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mostly_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MostlyPlayedModelAdapter extends TypeAdapter<MostlyPlayedModel> {
  @override
  final int typeId = 4;

  @override
  MostlyPlayedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MostlyPlayedModel(
      mostlysongname: fields[0] as String,
      mostlyartistname: fields[1] as String,
      mostlysongduration: fields[2] as int,
      mostlysongurl: fields[3] as String,
      songcount: fields[4] as int,
      mostlySongId: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MostlyPlayedModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.mostlysongname)
      ..writeByte(1)
      ..write(obj.mostlyartistname)
      ..writeByte(2)
      ..write(obj.mostlysongduration)
      ..writeByte(3)
      ..write(obj.mostlysongurl)
      ..writeByte(4)
      ..write(obj.songcount)
      ..writeByte(5)
      ..write(obj.mostlySongId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MostlyPlayedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
