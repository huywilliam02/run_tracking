import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/modules/tab_view/views/tab_home_view/tab_home_view.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/controllers/tracking_drink_water_controller.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/models/chart_data.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/utils/datetime_utils.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/views/settings/settings_drinkwater.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/views/water_reminder/chart_analytics.dart';
import 'package:tracker_run/app/resources/data_constant.dart';
import 'package:tracker_run/app/routes/app_pages.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../widgets/widgets.dart';
import '../jsonview.dart';

class TrackingDrinkWaterView extends BaseView<TrackingDrinkWaterController> {
  final List<CapacityChooserItem> _capacityChooserItems = [
    CapacityChooserItem(
      icon: AssetIconPaths.empty100,
      seletedIcon: AssetIconPaths.fill100,
      extraIcon: AssetIconPaths.fillPlus100,
      capacity: 100,
    ),
    CapacityChooserItem(
      icon: AssetIconPaths.empty150,
      seletedIcon: AssetIconPaths.fill150,
      extraIcon: AssetIconPaths.fillPlus150,
      capacity: 150,
    ),
    CapacityChooserItem(
      icon: AssetIconPaths.empty250,
      seletedIcon: AssetIconPaths.fill250,
      extraIcon: AssetIconPaths.fillPlus250,
      capacity: 250,
    ),
    CapacityChooserItem(
      icon: AssetIconPaths.empty500,
      seletedIcon: AssetIconPaths.fill500,
      extraIcon: AssetIconPaths.fillPlus500,
      capacity: 500,
    ),
  ];

  final _startAndEndDayOfWeek = DateTimeUtils.getSartAndEndDayOfWeek();
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: _appBar(LocaleKeys.tracking_drinkwater_text_today.tr,
          LocaleKeys.tracking_drinkwater_text_drink_water.tr),
      body: ValueListenableBuilder(
          valueListenable: controller.dailyRecords,
          builder: (context, value, child) {
            // print(
            //     'controller.dailyRecords: ${controller.dailyRecords.value.first.records}')
            return SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    children: [
                      const SizedBox(height: 36),
                      Align(
                        child: GestureDetector(
                            onTap: () {
                              Get.to(WidgetJson());
                            },
                            child: RoundedWaveWidget(
                              // current:
                              //     controller.getTodayRecord().totalCapacity,
                              // max: controller.getTodayRecord().target,

                              size: 200,
                              foregroundColor: Palette.foregroundColor,
                            )),
                      ),
                      // Arrow icon
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Image.asset(AssetIconPaths.upArrow,
                            width: 14, height: 14),
                      ),
                      Obx(() {
                        var item = _capacityChooserItems[
                            controller.selectedIndex.value];
                        return DrinkButton(
                          icon: item.extraIcon ?? item.seletedIcon,
                          label: '${item.capacity}' +
                              LocaleKeys.tracking_drinkwater_text_ml.tr,
                          size: 42,
                          onTap: () {
                            controller.addDrinkRecord(item.capacity);
                            controller.update();
                          },
                        );
                      }),
                      const SizedBox(height: 36),
                      Obx(() {
                        return CapacityChooser(
                          seletedIndex: controller.selectedIndex.value,
                          items: _capacityChooserItems,
                          iconSize: 32,
                          itemSpacer: 32,
                          onSelectedIndexChange: (index) => controller
                              .changeSelectedCapacityChooserIndex(index),
                        );
                      }),
                      const SizedBox(height: 56),
                      ..._weekHeader(),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 250,
                        child: _buildChart(),
                      ),
                      const SizedBox(height: 36),
                      Text(
                        LocaleKeys.tracking_drinkwater_text_average.tr +
                            '${controller.getWeekAverage()} ' +
                            LocaleKeys.tracking_drinkwater_text_ml.tr,
                        style: const TextStyle(
                          color: Palette.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 56),
                      _renimderInfor(),
                      _todayDrinkHistory(),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            );
          }),
      backgroundColor: Palette.scaffold,
    );
  }

  Widget _renimderInfor() {
    return ListTile(
      leading: Icon(
        Icons.alarm,
        size: 28,
        color: Palette.foregroundColor.withOpacity(0.9),
      ),
      title: Text(
        LocaleKeys.tracking_drinkwater_text_disabled.tr,
        style: const TextStyle(
          color: Palette.foregroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      subtitle: Text(
        LocaleKeys.tracking_drinkwater_text_water_today.tr,
        style: TextStyle(color: Palette.foregroundColor.withOpacity(0.5)),
      ),
      trailing: Text(
        '${_capacityChooserItems[controller.selectedIndex.value].capacity} ml',
        style: const TextStyle(
          color: Palette.foregroundColor,
        ),
      ),
    );
  }

  // Extract widgets
  AppBar _appBar(String title, String subtitle) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 14, color: Palette.secondaryForegroundColor),
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () => Get.to(ChartAnalytics()),
            icon: const Icon(Icons.analytics_outlined)),
        IconButton(
          onPressed: () => Get.to(() => SettingDrinkWater()),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
      leading: IconButton(
          onPressed: () {
            Get.offNamed(Routes.HOME);
          },
          icon: Icon(Icons.arrow_back)),
      elevation: 0.0,
      backgroundColor: Palette.scaffold,
      foregroundColor: Palette.foregroundColor,
    );
  }

  List<Widget> _weekHeader() {
    return [
      Text(
        LocaleKeys.tracking_drinkwater_text_this_week.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Palette.foregroundColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        width: 40,
        child: Divider(
          color: Palette.blue,
          thickness: 2,
        ),
      ),
      const SizedBox(height: 24),
      Text(
        '${DateTimeUtils.dateTimeString(_startAndEndDayOfWeek[0], 'dd MMM')} - ${DateTimeUtils.dateTimeString(_startAndEndDayOfWeek[1], 'dd MMM')}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Palette.foregroundColor),
      )
    ];
  }

  Widget _buildChart() {
    return SfCartesianChart(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        axisLine: const AxisLine(width: 0),
        isVisible: true,
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        isVisible: false,
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
          yValueMapper: (ChartData? data, _) => data!.record!.totalCapacity,
        ),
      ],
    );
  }

  ListView _todayDrinkHistory() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      reverse: true,
      itemCount: controller.getTodayRecord().records.length,
      itemBuilder: (context, index) {
        final record = controller.getTodayRecord().records[index];
        return RecordListTile(
          record: record,
          onDeleteActionTap: () => controller.deleteDrinkRecord(record),
        );
      },
    );
  }
}
