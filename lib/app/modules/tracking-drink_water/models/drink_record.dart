import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 15)
class DrinkRecord {
  @HiveType(typeId: 0)
  final String id;
  @HiveField(1)
  final int capacity;
  @HiveField(2)
  final TimeOfDay time;

  const DrinkRecord(
      {required this.id, required this.capacity, required this.time});
}

@HiveType(typeId: 16)
class Target {
  @HiveField(0)
  String? id;
  @HiveType(typeId: 1)
  int? capacityChooserIndex;
  @HiveType(typeId: 2)
  int? target;

  Target({this.id, this.capacityChooserIndex, this.target});

  Target.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["capacityChooserIndex"] is int) {
      capacityChooserIndex = json["capacityChooserIndex"];
    }
    if (json["target"] is int) {
      target = json["target"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["capacityChooserIndex"] = capacityChooserIndex;
    _data["target"] = target;
    return _data;
  }
}
