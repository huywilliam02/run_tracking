import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/data/local/tracking_detail_model.dart';
import 'package:tracker_run/app/enum/format_timer.dart';
import 'package:tracker_run/generated/locales.g.dart';
import 'package:polyline_do/polyline_do.dart' as polyDo;
import '../../../routes/app_pages.dart';
import '../../tracking_map_v2/model/data_model_strava.dart';

class TrackingDetailController extends BaseController
    with GetSingleTickerProviderStateMixin {
  TrackingDetailController({required this.model});
  final DataModelStrava model;
  late TabController tabController;
  var listTrackingDetail = <TrackingDetailModel>[].obs;

  Rx<double> maxPaceYValue = 0.0.obs;
  Rx<double> maxElevYValue = 0.0.obs;
  Rx<String> averagePage = "".obs;
  Rx<double> minElevYValue = 0.0.obs;

  @override
  void onInit() async {
    tabController = TabController(vsync: this, length: 3);

    try {
      // print("moving time" +model.movingTime.toString());
      double abc = ((model.movingTime / 60) / (model.distance / 1000));

      int minute = abc.truncate();

      int secondd = ((abc - minute) * 60).round();
      if (secondd < 10) {
        averagePage.value = "${minute}:0${secondd}";
      } else {
        averagePage.value = "${minute}:${secondd}";
      }

      getListTrackingDetail();
      getValueChartXY();
    } catch (e) {}
    // ti);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    print(model.dataStream.latlng.length);
    var a =
        polyDo.Polyline.Decode(encodedString: model.map.polyline, precision: 5);
    List<LatLng> abc = List<LatLng>.from(
        a.decodedCoords.map((e) => LatLng(e[0], e[1])).toList());
  }

  @override
  void onClose() {
    super.onClose();
  }

  getListTrackingDetail() {
    listTrackingDetail.value = [
      TrackingDetailModel(
          icon: Icons.av_timer,
          title: LocaleKeys.tracking_detail_view_text_move_time.tr,
          detail: Duration(seconds: model.movingTime).toHoursMinutesSeconds(),
          unit: LocaleKeys.tracking_detail_view_text_hour.tr),
      TrackingDetailModel(
          icon: Icons.local_fire_department_sharp,
          title: LocaleKeys.tracking_detail_view_text_kcal.tr,
          detail: model.calories.round().toString(),
          unit: LocaleKeys.tracking_detail_view_text_kcal.tr),
      TrackingDetailModel(
          icon: Icons.timer_outlined,
          title: LocaleKeys.tracking_detail_view_text_avg_speed.tr,
          detail: model.averageSpeed.toPrecision(1).toString(),
          unit: 'm/s'),
      TrackingDetailModel(
          icon: Icons.filter_hdr,
          title: LocaleKeys.tracking_detail_view_text_elevation.tr,
          detail: model.totalElevationGain.toPrecision(1).toString(),
          unit: 'm'),
    ];
  }

  onTapLeading() {
    // Get.offAllNamed(Routes.HOME);
    Get.offAllNamed(Routes.HOME);
  }

  getValueChartXY() {
    double maxPaceY = 0;
    double tmpPace = 0;
    double tmpElev = 0;
    double maxElevY = 0;
    double minElevY = 0;
    // double totalPace = 0;

    model.splitsMetric.forEach((data) {
      tmpPace = ((((data.elapsedTime * 1000) / data.distance)) / 60);
      tmpElev = data.elevationDifference;
      if (tmpPace > maxPaceY) {
        maxPaceY = tmpPace;
      }

      if (tmpElev > maxElevY) {
        maxElevY = tmpElev;
      }
      if (tmpElev < minElevY) {
        minElevY = tmpElev;
      }
      // totalPace += tmpPace;
    });
    // averagePage.value = (totalPace / model.splitsMetric.length).round();
    maxPaceYValue.value = maxPaceY;
    maxElevYValue.value = maxElevY;
    if (minElevY < 0) {
      minElevYValue.value = minElevY - 2;
    } else {
      minElevYValue.value = minElevY + 2;
    }
  }
}
