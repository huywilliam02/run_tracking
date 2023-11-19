// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_tracking_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StepTrackingDayAdapter extends TypeAdapter<StepTrackingDay> {
  @override
  final int typeId = 100;

  @override
  StepTrackingDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepTrackingDay(
      id: fields[0] as int,
      steps: fields[1] as int,
      target: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StepTrackingDay obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.steps)
      ..writeByte(2)
      ..write(obj.target);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepTrackingDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
