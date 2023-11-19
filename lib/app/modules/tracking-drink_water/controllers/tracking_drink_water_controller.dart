import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/models/app_prefs.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/models/chart_data.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/models/daily_drink_record.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/models/drink_record.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/utils/datetime_utils.dart';
import 'package:uuid/uuid.dart';

class TrackingDrinkWaterController extends BaseController {
  final count = 0.obs;
  Rx<int> current = 0.obs;
  Rx<int> totalCapacity = 0.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  RxInt selectedIndex = 0.obs;
  RxInt target = 0.obs;

  ValueNotifier<List<DailyDrinkRecord>> dailyRecords = ValueNotifier([]);

  @override
  void onInit() async {
    selectedIndex.value = AppPrefs.instance.capacityChooserIndex;
    int savedTarget = AppPrefs.instance.target;
    changeTarget(savedTarget);
    await _fetchRecords();

    getTodayRecord();
    super.onInit();
  }

  _fetchRecords() async {
    List<DailyDrinkRecord> records = AppPrefs.instance.logs;
    dailyRecords.value = records;
    dailyRecords.notifyListeners();
    print('dailyRecords.value:${dailyRecords.value.length} ');
  }

// lựa chọn bình
  void changeSelectedCapacityChooserIndex(int index) {
    selectedIndex.value = index;
    AppPrefs.instance.capacityChooserIndex = index;
  }

  void changeTarget(int target) {
    this.target.value = target;
    AppPrefs.instance.target = target;
  }

  getTodayRecord() {
    return dailyRecords.value.firstWhere(
      (dailyRecord) {
        totalCapacity.value = dailyRecord.totalCapacity;
        return DateTimeUtils.isToday(dailyRecord.date);
      },
      orElse: () {
        DailyDrinkRecord today = DailyDrinkRecord(
          id: Random().nextInt(899999) + 100000,
          target: target.value,
          records: [],
          date: DateTime.now(),
        );

        dailyRecords.value.add(today);
        totalCapacity.value = today.totalCapacity;
        print("today cap ${totalCapacity}");
        return today;
      },
    );
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
  }

  void addDrinkRecord(int capacity) async {
    await AppPrefs.instance.insertLog({
      'id': const Uuid().v1(),
      "capacity": capacity,
      'datetime': DateTime.now().millisecondsSinceEpoch,
    });
    // totalCapacity.value += capacity;
    _fetchRecords();
  }

// List chart tuần
  List<ChartData?> generateChartDatas() {
    List<ChartData?> chartdata = List.filled(7, null);
    DateTime firstDayOfWeek =
        DateTimeUtils.dateOnly(DateTimeUtils.getSartAndEndDayOfWeek()[0]);

    for (int i = 0; i < 7; i++) {
      DailyDrinkRecord record = dailyRecords.value.firstWhere(
        (record) => DateTimeUtils.compareYMD(
            firstDayOfWeek, DateTimeUtils.dateOnly(record.date)),
        orElse: () =>
            DailyDrinkRecord(target: 2000, records: [], date: firstDayOfWeek),
      );
      chartdata[i] = ChartData(
        DateTimeUtils.isToday(record.date)
            ? 'Today'
            : DateTimeUtils.nameOfDay(record.date),
        record,
      );
      firstDayOfWeek = firstDayOfWeek.add(const Duration(days: 1));
    }
    return chartdata;
  }

// list chart tháng
  List<ChartData?> generateChartDatasmouth() {
    List<ChartData?> chartdataa = List.filled(
      12,
      null,
    );
    DateTime mouth =
        DateTimeUtils.dateOnly(DateTimeUtils.getSartAndEndmouth()[0]);
    for (int i = 0; i < 12; i++) {
      DailyDrinkRecord record = dailyRecords.value.firstWhere(
        (record) => DateTimeUtils.compareYMDMouth(
          mouth, 
          DateTimeUtils.dateOnly(record.date),
        ),
        orElse: () => DailyDrinkRecord(target: 2000, records: [], date: mouth),
      );
      chartdataa[i] = ChartData(
        DateTimeUtils.mouth(record.date),
        record,
      );
      mouth = mouth.add(const Duration(
        days: 31,
        hours: 24,
      ));
    }
    return chartdataa;
  }

  

//json tháng
  int totalOfMonth(int month) {
    int total = 0;
    AppPrefs.instance.logs
        .where((e) =>
            DateFormat('/MM/yyyy').format(e.date) ==
            DateFormat('/MM/yyyy').format(DateTime(DateTime.now().year, month)))
        .forEach((e) {
      for (var e3 in e.records) {
        total += e3.capacity;
      }
    });
    return total;
  }
 
  int totalOfday(int day) {
    int totalday = 0;
    AppPrefs.instance.logs
        .where((e) =>
            DateFormat('EEE, M/d/y').format(e.date) ==
            DateFormat('EEE, M/d/y').format(DateTime(DateTime.now().day, day)))
        .forEach((e) {
      for (var e3 in e.records) {}
    });
    return totalday;
  }

  // trung bình nước hằng ngày
  int getWeekAverage() {
    return generateChartDatas().fold(
        0,
        (previousValue, chartData) =>
            previousValue + (chartData?.record?.totalCapacity as int));
  }

  void deleteDrinkRecord(DrinkRecord record) async {
    // getTodayRecord().records.removeWhere((r) => r.id == record.id);
    await AppPrefs.instance.deleteLog(record.id);
    _fetchRecords();
  }
}
