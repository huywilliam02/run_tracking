// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model_strava.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataModelStravaAdapter extends TypeAdapter<DataModelStrava> {
  @override
  final int typeId = 1;

  @override
  DataModelStrava read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataModelStrava(
      name: fields[0] as String,
      distance: fields[1] as double,
      movingTime: fields[2] as int,
      elapsedTime: fields[3] as int,
      totalElevationGain: fields[4] as double,
      type: fields[5] as String,
      sportType: fields[6] as String,
      id: fields[7] as int,
      startDate: fields[8] as DateTime?,
      startDateLocal: fields[9] as DateTime?,
      timezone: fields[10] as String,
      utcOffset: fields[11] as int,
      locationCountry: fields[12] as String,
      map: fields[13] as MapClass?,
      startLatlng: (fields[14] as List?)?.cast<double>(),
      endLatlng: (fields[15] as List?)?.cast<double>(),
      averageSpeed: fields[16] as double,
      maxSpeed: fields[17] as double,
      maxPace: fields[18] as double,
      elevHigh: fields[19] as double,
      elevLow: fields[20] as double,
      calories: fields[21] as double,
      splitsMetric: (fields[22] as List?)?.cast<SplitsMetric>(),
      deviceName: fields[23] as String,
      photos: (fields[24] as List?)?.cast<String>(),
      dataStream: fields[25] as StreamData?,
      isOnline: fields[26] as bool,
      listPolyline: (fields[27] as List?)
          ?.map((dynamic e) => (e as List).cast<double>())
          .toList(),
      listPolylineSum: (fields[28] as List?)
          ?.map((dynamic e) => (e as List).cast<double>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, DataModelStrava obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.distance)
      ..writeByte(2)
      ..write(obj.movingTime)
      ..writeByte(3)
      ..write(obj.elapsedTime)
      ..writeByte(4)
      ..write(obj.totalElevationGain)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.sportType)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.startDate)
      ..writeByte(9)
      ..write(obj.startDateLocal)
      ..writeByte(10)
      ..write(obj.timezone)
      ..writeByte(11)
      ..write(obj.utcOffset)
      ..writeByte(12)
      ..write(obj.locationCountry)
      ..writeByte(13)
      ..write(obj.map)
      ..writeByte(14)
      ..write(obj.startLatlng)
      ..writeByte(15)
      ..write(obj.endLatlng)
      ..writeByte(16)
      ..write(obj.averageSpeed)
      ..writeByte(17)
      ..write(obj.maxSpeed)
      ..writeByte(18)
      ..write(obj.maxPace)
      ..writeByte(19)
      ..write(obj.elevHigh)
      ..writeByte(20)
      ..write(obj.elevLow)
      ..writeByte(21)
      ..write(obj.calories)
      ..writeByte(22)
      ..write(obj.splitsMetric)
      ..writeByte(23)
      ..write(obj.deviceName)
      ..writeByte(24)
      ..write(obj.photos)
      ..writeByte(25)
      ..write(obj.dataStream)
      ..writeByte(26)
      ..write(obj.isOnline)
      ..writeByte(27)
      ..write(obj.listPolyline)
      ..writeByte(28)
      ..write(obj.listPolylineSum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataModelStravaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MapClassAdapter extends TypeAdapter<MapClass> {
  @override
  final int typeId = 2;

  @override
  MapClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MapClass(
      id: fields[0] as String,
      polyline: fields[1] as String,
      summaryPolyline: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MapClass obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.polyline)
      ..writeByte(2)
      ..write(obj.summaryPolyline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SplitsMetricAdapter extends TypeAdapter<SplitsMetric> {
  @override
  final int typeId = 3;

  @override
  SplitsMetric read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SplitsMetric(
      distance: fields[0] as double,
      elapsedTime: fields[1] as int,
      elevationDifference: fields[2] as double,
      movingTime: fields[3] as int,
      split: fields[4] as int,
      averageSpeed: fields[5] as double,
      paceZone: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SplitsMetric obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.distance)
      ..writeByte(1)
      ..write(obj.elapsedTime)
      ..writeByte(2)
      ..write(obj.elevationDifference)
      ..writeByte(3)
      ..write(obj.movingTime)
      ..writeByte(4)
      ..write(obj.split)
      ..writeByte(5)
      ..write(obj.averageSpeed)
      ..writeByte(6)
      ..write(obj.paceZone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SplitsMetricAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
