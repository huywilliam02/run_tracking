import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/controllers/tracking_drink_water_controller.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/models/chart_data.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../../resources/app_constants.dart';

class ChartAnalytics extends BaseView<TrackingDrinkWaterController> {
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.scaffold,
      appBar: AppBar(
        backgroundColor: ColorConstant.common_bg_dark,
        title:  Text( LocaleKeys.common_analysis.tr),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
           Text(
         LocaleKeys.common_all_water_weekly.tr,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 250,
            child: SfCartesianChart(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                axisLine: const AxisLine(width: 0),
                isVisible: true,
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              series: [
                ColumnSeries(
                  animationDuration: 0,
                  isTrackVisible: true,
                  trackColor: Palette.lighterBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    showZeroValue: false,
                    textStyle: TextStyle(
                      color: Palette.foregroundColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    labelAlignment: ChartDataLabelAlignment.outer,
                  ),
                  dataSource: controller.generateChartDatas(),
                  xValueMapper: (ChartData? data, _) => data?.label,
                  yValueMapper: (ChartData? data, _) =>
                      data!.record!.totalCapacity,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
           Text(
            LocaleKeys.common_all_water_month.tr,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 250,
            width: 400,
            child: SfCartesianChart(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                axisLine: const AxisLine(width: 0),
                isVisible: true,
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              series: [
                ColumnSeries(
                  animationDuration: 0,
                  isTrackVisible: true,
                  trackColor: Palette.lighterBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    showZeroValue: false,
                    textStyle: TextStyle(
                      color: Palette.foregroundColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    labelAlignment: ChartDataLabelAlignment.outer,
                  ),
                  dataSource: controller.generateChartDatasmouth(),
                  xValueMapper: (ChartData? data, _) => data?.label,
                  yValueMapper: (ChartData? data, _) =>
                      data!.record!.totalCapacity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
