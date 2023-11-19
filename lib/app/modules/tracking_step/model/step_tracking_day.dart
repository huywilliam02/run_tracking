import 'package:hive_flutter/hive_flutter.dart';
part 'step_tracking_day.g.dart';
@HiveType(typeId: 100)
class StepTrackingDay extends HiveObject {
  StepTrackingDay({this.id = 0, this.steps = 0, this.target = 0});
  @HiveField(0)
  int id;
  @HiveField(1)
  int steps;
  @HiveField(2)
  int target;
}
