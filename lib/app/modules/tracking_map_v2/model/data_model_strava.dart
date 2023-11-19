// To parse this JSON data, do
//
//     final dataModelStrava = dataModelStravaFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:tracker_run/app/modules/tracking_map_v2/model/streamdata.dart';

part 'data_model_strava.g.dart';

DataModelStrava dataModelStravaFromJson(String str) =>
    DataModelStrava.fromJson(json.decode(str));

String dataModelStravaToJson(DataModelStrava data) =>
    json.encode(data.toJson());

@HiveType(typeId: 1)
class DataModelStrava extends HiveObject {
  DataModelStrava(
      {this.name = "",
      this.distance = 0,
      this.movingTime = 0,
      this.elapsedTime = 0,
      this.totalElevationGain = 0,
      this.type = "",
      this.sportType = "",
      this.id = 0,
      DateTime? startDate,
      DateTime? startDateLocal,
      this.timezone = "",
      this.utcOffset = 0,
      this.locationCountry = "",
      MapClass? map,
      List<double>? startLatlng,
      List<double>? endLatlng,
      this.averageSpeed = 0,
      this.maxSpeed = 0,
      this.maxPace = 1000000,
      this.elevHigh = 0,
      this.elevLow = 0,
      this.calories = 0,
      List<SplitsMetric>? splitsMetric,
      this.deviceName = "",
      List<String>? photos,
      StreamData? dataStream,
      this.isOnline = false,
      List<List<double>>? listPolyline,
      List<List<double>>? listPolylineSum})
      : this.startDate = startDate ?? DateTime.now(),
        this.startDateLocal = startDateLocal ?? DateTime.now(),
        this.startLatlng = startLatlng ?? [],
        this.endLatlng = endLatlng ?? [],
        this.splitsMetric = splitsMetric ?? [],
        this.photos = photos ?? [],
        this.map = map ?? MapClass(),
        this.dataStream = dataStream ?? StreamData(),
        this.listPolyline = listPolyline ?? [],
        this.listPolylineSum = listPolylineSum ?? [];

  @HiveField(0)
  String name;
  @HiveField(1)
  double distance;
  @HiveField(2)
  int movingTime;
  @HiveField(3)
  int elapsedTime;
  @HiveField(4)
  double totalElevationGain;
  @HiveField(5)
  String type;
  @HiveField(6)
  String sportType;
  @HiveField(7)
  int id;
  @HiveField(8)
  DateTime startDate;
  @HiveField(9)
  DateTime startDateLocal;
  @HiveField(10)
  String timezone;
  @HiveField(11)
  int utcOffset;
  @HiveField(12)
  String locationCountry;
  @HiveField(13)
  MapClass map;
  @HiveField(14)
  List<double> startLatlng;
  @HiveField(15)
  List<double> endLatlng;
  @HiveField(16)
  double averageSpeed;
  @HiveField(17)
  double maxSpeed;
  @HiveField(18)
  double maxPace;
  @HiveField(19)
  double elevHigh;
  @HiveField(20)
  double elevLow;
  @HiveField(21)
  double calories;
  @HiveField(22)
  List<SplitsMetric> splitsMetric = [];
  @HiveField(23)
  String deviceName;
  @HiveField(24)
  List<String> photos = [];
  @HiveField(25)
  StreamData dataStream;
  @HiveField(26)
  bool isOnline;
  @HiveField(27)
  List<List<double>>? listPolyline;
  @HiveField(28)
  List<List<double>>? listPolylineSum;

  factory DataModelStrava.fromJson(Map<String, dynamic> json) =>
      DataModelStrava(
          name: json["name"] ?? "",
          distance: json["distance"].toDouble() ?? 0,
          movingTime: json["moving_time"] ?? 0,
          elapsedTime: json["elapsed_time"] ?? 0,
          totalElevationGain: json["total_elevation_gain"].toDouble() ?? 0,
          type: json["type"] ?? "RUN",
          sportType: json["sport_type"] ?? "RUN",
          id: json["id"],
          startDate: DateTime.parse(json["start_date"]),
          startDateLocal: DateTime.parse(json["start_date_local"]),
          timezone: json["timezone"] ?? "",
          utcOffset: json["utc_offset"],
          locationCountry: json["location_country"] ?? "unKnow",
          map: MapClass.fromJson(json["map"]),
          startLatlng:
              List<double>.from(json["start_latlng"].map((x) => x.toDouble())),
          endLatlng:
              List<double>.from(json["end_latlng"].map((x) => x.toDouble())),
          averageSpeed: json["average_speed"].toDouble(),
          maxSpeed: json["max_speed"].toDouble(),
          maxPace: json["max_pace"].toDouble(),
          elevHigh: json["elev_high"].toDouble(),
          elevLow: json["elev_low"].toDouble(),
          calories: json["calories"].toDouble(),
          splitsMetric: List<SplitsMetric>.from(
              json["splits_metric"].map((x) => SplitsMetric.fromJson(x))),
          deviceName: json["device_name"] ?? "Unknow",
          photos:
              List<String>.from(json["photos"] ?? [].map((x) => x.toString())),
          dataStream: json["stream_data"] != null
              ? StreamData.fromJson(json["stream_data"])
              : StreamData(),
          isOnline: true,
          );


  Map<String, dynamic> toJson() => {
        "name": name,
        "distance": distance,
        "moving_time": movingTime,
        "elapsed_time": elapsedTime,
        "total_elevation_gain": totalElevationGain,
        "type": type,
        "sport_type": sportType,
        "id": id,
        "start_date": startDate.toString(),
        "start_date_local": startDateLocal.toString(),
        "timezone": timezone,
        "utc_offset": utcOffset,
        "location_country": locationCountry,
        "map": map.toJson(),
        "start_latlng": List<dynamic>.from(startLatlng.map((x) => x)),
        "end_latlng": List<dynamic>.from(endLatlng.map((x) => x)),
        "average_speed": averageSpeed,
        "max_speed": maxSpeed,
        "max_pace": maxPace,
        "elev_high": elevHigh,
        "elev_low": elevLow,
        "calories": calories,
        "splits_metric":
            List<dynamic>.from(splitsMetric.map((x) => x.toJson())),
        "device_name": deviceName,
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "stream_data": dataStream.toJson(),
        "isOnline": isOnline
      };

}

@HiveType(typeId: 2)
class MapClass {
  MapClass({
    this.id = "",
    this.polyline = "",
    this.summaryPolyline = "",
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  String polyline;
  @HiveField(2)
  String summaryPolyline;

  factory MapClass.fromJson(Map<String, dynamic> json) => MapClass(
        id: json["id"] ?? "Unknow",
        polyline: json["polyline"] ?? "Empty",
        summaryPolyline: json["summary_polyline"] ?? "Empty",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "polyline": polyline,
        "summary_polyline": summaryPolyline,
      };
}

@HiveType(typeId: 3)
class SplitsMetric {
  SplitsMetric({
    this.distance = 0,
    this.elapsedTime = 0,
    this.elevationDifference = 0,
    this.movingTime = 0,
    this.split = 0,
    this.averageSpeed = 0,
    this.paceZone = 0,
  });
  @HiveField(0)
  double distance;
  @HiveField(1)
  int elapsedTime;
  @HiveField(2)
  double elevationDifference;
  @HiveField(3)
  int movingTime;
  @HiveField(4)
  int split;
  @HiveField(5)
  double averageSpeed;
  @HiveField(6)
  int paceZone;

  factory SplitsMetric.fromJson(Map<String, dynamic> json) => SplitsMetric(
        distance: json["distance"].toDouble(),
        elapsedTime: json["elapsed_time"],
        elevationDifference: json["elevation_difference"].toDouble(),
        movingTime: json["moving_time"],
        split: json["split"],
        averageSpeed: json["average_speed"].toDouble(),
        paceZone: json["pace_zone"],
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "elapsed_time": elapsedTime,
        "elevation_difference": elevationDifference,
        "moving_time": movingTime,
        "split": split,
        "average_speed": averageSpeed,
        "pace_zone": paceZone,
      };
}
