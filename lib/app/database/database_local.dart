import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_run/app/data/local/best_record.dart';
import 'package:tracker_run/app/modules/tracking_step/model/step_tracking_day.dart';
import '../modules/login/model/login_model.dart';
import 'dart:developer' as dev;

import '../modules/tracking_map_v2/model/data_model_strava.dart';

class DatabaseLocal {
  DatabaseLocal._privateConstructor();

  static final DatabaseLocal _instance = DatabaseLocal._privateConstructor();

  static DatabaseLocal get instance => _instance;

  Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? tmp = prefs.getString('language');
    if (tmp != null) {
      switch (tmp) {
        case "en":
          return Locale("en");
        case "vi":
          return Locale("vi");
        default:
      }
    }
    return Locale("en", "UK");
  }

  Future<void> updateLocale(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', key);
  }

  Future<String> getJwtToken() async {
    String jwtToken = "";
    final prefs = await SharedPreferences.getInstance();
    String? tmp = prefs.getString('jwtToken');
    if (tmp != null) {
      jwtToken = tmp;
    }
    return Future<String>.value(jwtToken);
  }

  Future<void> setJwtToken(String jwtToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', jwtToken);
  }

  Future<void> removeJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
  }

  Future<LoginModel> getLoginModel() async {
    LoginModel rs = LoginModel();
    try {
      Box boxLogin = await Hive.openBox("loginModel");
      if (boxLogin.values.isNotEmpty) {
        rs = await boxLogin.getAt(0) as LoginModel;
      } else {}
    } catch (e) {
      dev.log("HiveDb -getLoginModel-${e.toString()}");
      return Future<LoginModel>.value(rs);
    }
    return Future<LoginModel>.value(rs);
  }

  Future<bool> reNewLoginModel(LoginModel modelLogin) async {
    try {
      Box boxLogin = await Hive.openBox("loginModel");
      await boxLogin.clear();
      await boxLogin.add(modelLogin);
      await boxLogin.close();
    } catch (e) {
      dev.log("HiveDb -reNewLoginModel-${e.toString()}");
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }

  Future<bool> updateLoginModel(LoginModel modelLogin) async {
    try {
      Box boxLogin = await Hive.openBox("loginModel");
      await boxLogin.clear();
      await boxLogin.add(modelLogin);
      // modelLogin.save();
      // await boxLogin.close();
    } catch (e) {
      dev.log("HiveDb -updateLoginModel-${e.toString()}");
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }

  Future<bool> updateListTrackingLocal(
      List<DataModelStrava> listDataModelStrava, String idUser) async {
    try {
      Box dataTrackingBox = await Hive.openBox("DATATRACK-$idUser");
      await dataTrackingBox.clear();
      listDataModelStrava.forEach((element) async {
        await dataTrackingBox.put(element.id, element);
        dev.log("HiveDb -updateListTrackingLocal-${"ok".toString()}");
      });
      // await boxLogin.close();
    } catch (e) {
      dev.log("HiveDb -updateListTrackingLocal-${e.toString()}");
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }

  Future<List<DataModelStrava>> getListTrackingLocal(String idUser) async {
    List<DataModelStrava> list = [];
    try {
      Box dataTrackingBox = await Hive.openBox("DATATRACK-$idUser");
      if (dataTrackingBox.values.isNotEmpty) {
        for (var i = 0; i < dataTrackingBox.values.length; i++) {
          list.add((dataTrackingBox.getAt(i) as DataModelStrava));
        }
      }
    } catch (e) {
      dev.log("HiveDb -getListTrackingLocal-${e.toString()}");
      return Future<List<DataModelStrava>>.value(list);
    }
    return Future<List<DataModelStrava>>.value(list);
  }

  Future<List<DataModelStrava>> getListTrackingLocalNotOnline(
      String idUser) async {
    List<DataModelStrava> list = [];
    try {
      Box dataTrackingBox = await Hive.openBox("NOTONLINE-$idUser");
      if (dataTrackingBox.values.isNotEmpty) {
        for (var i = 0; i < dataTrackingBox.values.length; i++) {
          list.add(dataTrackingBox.getAt(i));
        }
      }
    } catch (e) {
      dev.log("HiveDb -getListTrackingLocal-${e.toString()}");
      return Future<List<DataModelStrava>>.value(list);
    }
    return Future<List<DataModelStrava>>.value(list);
  }

  Future<BestRecord> getBestRecord(String idUser) async {
    BestRecord bestRecord = BestRecord();
    try {
      Box bestRecordBox = await Hive.openBox("BESTRECORD-$idUser");
      if (bestRecordBox.values.isNotEmpty) {
        bestRecord = bestRecordBox.getAt(0) as BestRecord;
      }
    } catch (e) {
      dev.log("HiveDb -getBestRecord-${e.toString()}");
      return Future<BestRecord>.value(bestRecord);
    }
    return Future<BestRecord>.value(bestRecord);
  }

  Future<void> updateBestRecord(BestRecord bestRecord, String idUser) async {
    try {
      Box bestRecordBox = await Hive.openBox("BESTRECORD-$idUser");
      await bestRecordBox.clear();
      bestRecordBox.add(bestRecord);
    } catch (e) {
      dev.log("HiveDb -getBestRecord-${e.toString()}");
    }
  }

  Future<bool> storageLocal(DataModelStrava modelStrava, String idUser) async {
    Box dataTrackingBox = await Hive.openBox("NOTONLINE-$idUser");
    dataTrackingBox.put(modelStrava.id.toString(), modelStrava);

    return Future<bool>.value(false);
  }

  Future<bool> deleteRecordNotOnline(String idModel, String idUser) async {
    Box dataTrackingBox = await Hive.openBox("NOTONLINE-$idUser");
    dataTrackingBox.delete(idModel);

    return Future<bool>.value(false);
  }

  Future<StepTrackingDay> getCurrentTrackingStep(String idUser) async {
    StepTrackingDay stepTrackingDay;

    Box dataTrackingBox = await Hive.openBox("STEPTRACKING-$idUser");
    if (dataTrackingBox.values.isNotEmpty) {
      StepTrackingDay tmp = (dataTrackingBox.values.last as StepTrackingDay);
      if (DateTime.fromMillisecondsSinceEpoch(tmp.id).day ==
          DateTime.now().day) {
        stepTrackingDay = tmp;
        return Future<StepTrackingDay>.value(stepTrackingDay);
      } else {
        stepTrackingDay = StepTrackingDay(
            id: DateTime.now().millisecondsSinceEpoch,
            steps: 0,
            target: tmp.target);
        dataTrackingBox.add(stepTrackingDay);
      }
    } else {
      stepTrackingDay = StepTrackingDay(
          id: DateTime.now().millisecondsSinceEpoch, steps: 0, target: 6000);
      dataTrackingBox.add(stepTrackingDay);
    }

    return Future<StepTrackingDay>.value(stepTrackingDay);
  }

  Future<List<StepTrackingDay>> getWeeklyTrackingStep(String idUser) async {
    List<StepTrackingDay> listRs = [];

    Box dataTrackingBox = await Hive.openBox("STEPTRACKING-$idUser");
    if (dataTrackingBox.values.isNotEmpty) {
      for (int i = dataTrackingBox.values.length; i > -1; i--) {
        listRs.add(dataTrackingBox.get(i) as StepTrackingDay);
        if (listRs.length == 7) {
          return Future<List<StepTrackingDay>>.value(listRs);
        }
      }
      return Future<List<StepTrackingDay>>.value(listRs);
    } else {
      return Future<List<StepTrackingDay>>.value(listRs);
    }
  }

  Future<int> getTotal7day(String idUser) async {
    int rs = 0;
    int count = 1;
    Box dataTrackingBox = await Hive.openBox("STEPTRACKING-$idUser");
    if (dataTrackingBox.values.isNotEmpty) {
      for (int i = dataTrackingBox.values.length - 1; i > -1; i--) {
        rs += (dataTrackingBox.get(i) as StepTrackingDay).steps;
        if (count == 7) {
          return Future<int>.value(rs);
        }
        count++;
      }
      return Future<int>.value(rs);
    } else {
      return Future<int>.value(rs);
    }
  }

  Future<StepTrackingDay> clearAllStepRecord(String idUser) async {
    Box dataTrackingBox = await Hive.openBox("STEPTRACKING-$idUser");
    StepTrackingDay tmp=dataTrackingBox.values.last as StepTrackingDay;
     StepTrackingDay rs=StepTrackingDay(target: tmp.target);
    await dataTrackingBox.clear();
    dataTrackingBox.add(rs);
    return  Future<StepTrackingDay>.value(rs);
  }
}
