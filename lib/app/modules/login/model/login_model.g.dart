// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginModelAdapter extends TypeAdapter<LoginModel> {
  @override
  final int typeId = 7;

  @override
  LoginModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginModel(
      id: fields[0] as int,
      name: fields[1] as String,
      email: fields[2] as String,
      createdAt: fields[3] as DateTime?,
      iraceId: fields[4] as int,
      gender: fields[5] as String,
      birthday: fields[6] as DateTime?,
      height: fields[7] as double,
      weight: fields[8] as double,
      avatar: fields[9] as String,
      totalActivities: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, LoginModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.iraceId)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.birthday)
      ..writeByte(7)
      ..write(obj.height)
      ..writeByte(8)
      ..write(obj.weight)
      ..writeByte(9)
      ..write(obj.avatar)
      ..writeByte(10)
      ..write(obj.totalActivities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
