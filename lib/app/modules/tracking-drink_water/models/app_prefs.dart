import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_cli/common/utils/json_serialize/json_ast/utils/grapheme_splitter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/models/daily_drink_record.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/models/drink_record.dart';

class AppPrefs {
  AppPrefs._();

  static final AppPrefs _instance = AppPrefs._();

  static AppPrefs get instance => _instance;

  late Box _box;
  bool _initialized = false;

  initListener() async {
    if (_initialized) return;
    if (!kIsWeb) {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocDirectory.path);
    }
    _box = await Hive.openBox('AppPref');
    _initialized = true;
  }

  Stream watch(key) => _box.watch(key: key);

  void clear() {
    _box.delete(target);
  }

  Future insertLog(log) async {
    var maps = (jsonDecode(_box.get('logs') ?? '[]') as List);
    maps.add(log);
    print('AppDatabaseManager: insertLog $log');
    await _box.put('logs', jsonEncode(maps));
  }

  Future deleteLog(String id) async {
    print('AppDatabaseManager: deleteLog $id');
    var maps = (jsonDecode(_box.get('logs') ?? '[]') as List);
    maps.removeWhere((e) => e['id'] == id);
    await _box.put('logs', jsonEncode(maps));
  }

  List get logsMaps {
    return (jsonDecode(_box.get('logs') ?? '[]') as List);
  }

  List<DailyDrinkRecord> get logs {
    var maps = (jsonDecode(_box.get('logs') ?? '[]') as List);
    print('AppDatabaseManager: fetchLogs maps $maps');
    List<DailyDrinkRecord> records = [];
    groupBy<dynamic, String>(maps, (item) {
      return DateFormat('dd/MM/yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(item['datetime']));
    }).forEach((day, logs) {
      var _ = logs
          .map(
            (e) => DrinkRecord(
              id: e['id'],
              capacity: e['capacity'],
              time: TimeOfDay.fromDateTime(
                DateTime.fromMillisecondsSinceEpoch(
                  e['datetime'],
                ),
              ),
            ),
          )
          .toList();
      records.add(DailyDrinkRecord(
          id: 1,
          target: 2000,
          date: DateFormat('dd/MM/yyyy').parse(day),
          records: _));
    });
    return records;
  }

  //

  //Configs
  set capacityChooserIndex(int value) =>
      _box.put('capacityChooserIndex', value);

  int get capacityChooserIndex => _box.get('capacityChooserIndex') ?? 0;

  set target(int value) => _box.put('target', value);

  int get target => _box.get('target') ?? 2000;
}
