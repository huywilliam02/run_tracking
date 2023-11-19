import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/controllers/tracking_drink_water_controller.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/models/app_prefs.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/models/daily_drink_record.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/utils/datetime_utils.dart';

class WidgetJson extends BaseView<TrackingDrinkWaterController> {
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: JsonViewer({
            'capacityChooserIndex': AppPrefs.instance.capacityChooserIndex,
            'target': AppPrefs.instance.target,
            'logsOfYear': List.generate(
                12,
                (index) => {
                      'month': index + 1,
                      "total": controller.totalOfMonth(index + 1),
                    }).toList(),
            'logsOfDay': List.generate(
                7,
                (index) => {
                      'day': index + 1,
                      'totalday': controller.totalCapacity.value,
                      // 'totalday': controller.totalOfday(index + 1),
                    }).toList(),
            'dailyRecords': controller.dailyRecords.value.length,
            'todaywater': controller.getWeekAverage(),
            'logs': AppPrefs.instance.logs
                .map((e) => {
                      'datetime': DateFormat('dd/MM/yyyy').format(e.date),
                      'records': e.records
                          .map((e) => {
                                'capacity': e.capacity,
                                'time': e.time.format(context)
                              })
                          .toList()
                    })
                .toList(),
          }),
        ),
      ),
    );
  }
}
