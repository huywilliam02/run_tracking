// To parse this JSON data, do
//
//     final streamData = streamDataFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'streamdata.g.dart';

StreamData streamDataFromJson(String str) =>
    StreamData.fromJson(json.decode(str));

String streamDataToJson(StreamData data) => json.encode(data.toJson());

@HiveType(typeId: 4)
class StreamData extends HiveObject {
  StreamData(
      {List<List<double>>? latlng,
      List<double>? distance,
      List<double>? altitude,
      List<int>? time,
      List<double>? speed})
      : this.latlng = latlng ?? [],
        this.distance = distance ?? [],
        this.altitude = altitude ?? [],
        this.time = time ?? [],
        this.speed = speed ?? [];

  @HiveField(0)
  List<List<double>> latlng;
  @HiveField(1)
  List<double> distance;
  @HiveField(2)
  List<double> altitude;
  @HiveField(3)
  List<int> time;
  @HiveField(4)
  List<double> speed;

  factory StreamData.fromJson(Map<String, dynamic> json) => StreamData(
        latlng: json["latlng"] == null
            ? []
            : List<List<double>>.from(json["latlng"]
                .map((x) => List<double>.from(x.map((x) => x.toDouble())))),
        distance: json["distance"] == null
            ? []
            : List<double>.from(json["distance"].map((x) => x.toDouble())),
        altitude: json["altitude"] == null
            ? []
            : List<double>.from(json["altitude"].map((x) => x.toDouble())),
        time: json["time"] == null
            ? []
            : List<int>.from(json["time"].map((x) => x)),
     speed: json["speed"]==null?[]:List<double>.from(json["speed"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "latlng": List<dynamic>.from(
            latlng.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "distance": List<dynamic>.from(distance.map((x) => x)),
        "altitude": List<dynamic>.from(altitude.map((x) => x)),
        "time": List<dynamic>.from(time.map((x) => x)),
        "speed":List<dynamic>.from(speed.map((x) => x)),
      };
}
