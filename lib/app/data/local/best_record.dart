import 'package:hive/hive.dart';

import '../../modules/tracking_map_v2/model/data_model_strava.dart';

part 'best_record.g.dart';

@HiveType(typeId: 5)
class BestRecord extends HiveObject {
  BestRecord({this.bestPace, this.bestDistance, this.bestDuration});
  @HiveField(0)
  DataModelStrava? bestPace;
  @HiveField(1)
  DataModelStrava? bestDuration;
  @HiveField(2)
  DataModelStrava? bestDistance;

  factory BestRecord.fromJson(Map<String, dynamic> json) => BestRecord(
      bestPace: DataModelStrava.fromJson(json["top_pace"]),
      bestDuration: DataModelStrava.fromJson(json["top_moving_time"]),
      bestDistance: DataModelStrava.fromJson(json["top_distance"]));
  // Hive fields go here
}
