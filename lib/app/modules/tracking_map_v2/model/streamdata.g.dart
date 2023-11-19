// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streamdata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StreamDataAdapter extends TypeAdapter<StreamData> {
  @override
  final int typeId = 4;

  @override
  StreamData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StreamData(
      latlng: (fields[0] as List?)
          ?.map((dynamic e) => (e as List).cast<double>())
          .toList(),
      distance: (fields[1] as List?)?.cast<double>(),
      altitude: (fields[2] as List?)?.cast<double>(),
      time: (fields[3] as List?)?.cast<int>(),
      speed: (fields[4] as List?)?.cast<double>(),
    );
  }

  @override
  void write(BinaryWriter writer, StreamData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.latlng)
      ..writeByte(1)
      ..write(obj.distance)
      ..writeByte(2)
      ..write(obj.altitude)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.speed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
