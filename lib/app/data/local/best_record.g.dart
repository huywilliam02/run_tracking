// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'best_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BestRecordAdapter extends TypeAdapter<BestRecord> {
  @override
  final int typeId = 5;

  @override
  BestRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BestRecord(
      bestPace: fields[0] as DataModelStrava?,
      bestDistance: fields[2] as DataModelStrava?,
      bestDuration: fields[1] as DataModelStrava?,
    );
  }

  @override
  void write(BinaryWriter writer, BestRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.bestPace)
      ..writeByte(1)
      ..write(obj.bestDuration)
      ..writeByte(2)
      ..write(obj.bestDistance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BestRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
