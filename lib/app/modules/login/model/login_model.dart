// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'login_model.g.dart';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

@HiveType(typeId: 7)
class LoginModel extends HiveObject {
  LoginModel({
    this.id = 0,
    this.name = "",
    this.email = "",
    DateTime? createdAt,
    this.iraceId = 0,
    this.gender = "",
    DateTime? birthday,
    this.height = 0,
    this.weight = 0,
    this.avatar = "",
    int? totalActivities
  })  : this.createdAt =
            createdAt ?? DateFormat("yyyy-MM-dd").parse("1990-1-1"),
        this.birthday = birthday ?? DateFormat("yyyy-MM-dd").parse("1990-1-1"),
        this.totalActivities=totalActivities??0;
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String email;
  @HiveField(3)
  DateTime? createdAt;
  @HiveField(4)
  int iraceId;
  @HiveField(5)
  String gender;
  @HiveField(6)
  DateTime birthday;
  @HiveField(7)
  double height;
  @HiveField(8)
  double weight;
  @HiveField(9)
  String avatar;
  @HiveField(10)
  int? totalActivities;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        iraceId: json["irace_id"] ?? 0,
        gender: json["gender"] ?? "",
        birthday:
            DateFormat("yyyy-MM-dd").parse(json["birthday"] ?? "1990-01-01"),
        height: json["height"] ?? 0,
        weight: json["weight"] != null ? json["weight"].toDouble() : 0,
        avatar: json["avatar"] ?? "",
        totalActivities: json["total_activities"]??0
      );
}
