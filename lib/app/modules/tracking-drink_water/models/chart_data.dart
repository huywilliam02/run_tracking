import 'package:hive/hive.dart';

import 'daily_drink_record.dart';

@HiveType(typeId: 18)
class ChartData {
  @HiveField(0)
  String label;
  @HiveField(1)
  DailyDrinkRecord? record;

  ChartData(this.label, this.record);
}
// @HiveType(typeId: 19)
// class ChartDataa {
//   @HiveField(0)
//   String tilte;
//   @HiveField(1)
//   DailyDrinkRecord? record;
//    ChartDataa(
//     this.tilte,
//     this.record,
//   );
// }
