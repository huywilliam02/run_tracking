
import 'package:hive/hive.dart';

import 'drink_record.dart';

@HiveType(typeId: 17)
class DailyDrinkRecord {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int target;
  @HiveField(2)
  List<DrinkRecord> records;
  @HiveField(3)
  DateTime date;

  DailyDrinkRecord(
      {this.id,
      required this.target,
      required this.records,
      required this.date});

  int get totalCapacity => records.fold(
      0, (previousCapacity, record) => previousCapacity + record.capacity);
}
