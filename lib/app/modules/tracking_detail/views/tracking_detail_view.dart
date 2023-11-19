import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/enum/format_timer.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../../class_test_data/calculate.dart';
import 'components/redraw.dart';
import '../../../resources/app_constants.dart';
import '../controllers/tracking_detail_controller.dart';
import 'components/chart_elevation.dart';
import 'components/chart_pace.dart';

class TrackingDetailView extends BaseView<TrackingDetailController> {
  @override
  Widget buildView(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.onTapLeading();
        return false;
      },
      child: Scaffold(
        appBar: _appBar(),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              ReDrawMap(
                dataModel: controller.model,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _buildInfoCard(
                          LocaleKeys.tracking_detail_view_text_distance.tr,
                          (controller.model.distance / 1000)
                              .toStringAsPrecision(2),
                          LocaleKeys.tracking_detail_view_text_km.tr)),
                  Expanded(
                    child: _buildInfoCard(
                        LocaleKeys.tracking_detail_view_text_time.tr,
                        Duration(seconds: controller.model.movingTime)
                            .toHoursMinutesSeconds(),
                        LocaleKeys.tracking_detail_view_text_hour.tr),
                  ),
                  Expanded(
                      child: _buildInfoCard(
                          LocaleKeys.tracking_detail_view_text_pace.tr,
                          controller.averagePage.value,
                          LocaleKeys.tracking_detail_view_text_min_km.tr)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.model.type == "RUN"
                      ? Expanded(
                          child: _buildInfoCard(
                              LocaleKeys.tracking_detail_view_text_max_speed.tr,
                              (controller.model.maxSpeed * 3.6)
                                  .toPrecision(2)
                                  .toString(),
                              "km/h"))
                      : Expanded(
                          child: _buildInfoCard(
                              LocaleKeys
                                  .tracking_detail_view_text_maximum_pace.tr,
                              CalculateUtils.changeToMinutesSecond(
                                  controller.model.maxPace),
                              LocaleKeys.tracking_detail_view_text_min_km.tr)),
                  Expanded(
                      child: _buildInfoCard(
                          LocaleKeys
                              .tracking_detail_view_text_highest_elevation.tr,
                          controller.model.elevHigh.toPrecision(2).toString(),
                          LocaleKeys.tracking_detail_view_text_elevation_m.tr)),
                ],
              ),
              ...List.generate(
                controller.listTrackingDetail.length,
                (index) {
                  var content = controller.listTrackingDetail.elementAt(index);
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Icon(
                            content.icon,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text(
                            content.title,
                            style: TextStyleConstant.textRegular16,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            content.detail,
                            style: TextStyleConstant.textRegular16,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            content.unit,
                            style: TextStyleConstant.textRegular16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  controller.model.type == "RUN"
                      ? LocaleKeys.tracking_detail_view_text_pace.tr
                      : "Speed",
                  style: TextStyleConstant.blackBold16,
                ),
              ),
              ChartPace(
                  model: controller.model.dataStream,
                  type: controller.model.type),
              const Divider(
                thickness: 12,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  LocaleKeys.tracking_detail_view_text_elevation.tr,
                  style: TextStyleConstant.blackBold16,
                ),
              ),
              ChartElevation(model: controller.model.dataStream),

              controller.model.photos.isNotEmpty
                  ? SizedBox(
                      height: UtilsReponsive.height(context, 160),
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.model.photos.length,
                        separatorBuilder: (context, index) {
                          return Container(
                            color: Colors.white,
                            height: 160,
                            width: 5,
                          );
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            height: UtilsReponsive.height(context, 150),
                            width: UtilsReponsive.width(context, 150),
                            child: controller.model.photos[index]
                                    .contains("irace")
                                ? CachedNetworkImage(
                                    imageUrl: controller.model.photos[index])
                                : Image.file(
                                    File(controller.model.photos[index])),
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink(),   SizedBox(
                height: UtilsReponsive.height(context, 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(LocaleKeys.tracking_detail_view_text_km.tr)),
                  Expanded(
                      flex: 2,
                      child: Text(
                          LocaleKeys.tracking_detail_view_text_avg_speed.tr)),
                  Expanded(
                      flex: 2,
                      child: Text(LocaleKeys
                          .tracking_detail_view_text_elevation_difference.tr)),
                  Expanded(
                      flex: 2,
                      child: Text(
                          LocaleKeys.tracking_detail_view_text_move_time.tr))
                ],
              ),
              SizedBox(
                height: UtilsReponsive.height(context, 10),
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: controller.model.splitsMetric.length,
                primary: false,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(controller.model.splitsMetric[index].split
                              .toString())),
                      Expanded(
                          child: Text((controller
                                      .model.splitsMetric[index].averageSpeed *
                                  3.6)
                              .toPrecision(2)
                              .toString())),
                      Expanded(
                          child: Text(controller
                              .model.splitsMetric[index].elevationDifference
                              .toPrecision(2)
                              .toString())),
                      Expanded(
                          child: Text(Duration(
                                  seconds: controller
                                      .model.splitsMetric[index].movingTime)
                              .toMinutesSeconds()
                              .toString())),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    thickness: 12,
                  );
                },
              ),
              // _tabBar(),
              // _tabChildView(context),
              SizedBox(
                height: UtilsReponsive.height(context, 16),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Container _tabChildView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      // margin: const EdgeInsets.only(
      //     left: 20, right: 20, bottom: 20, top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: UtilsReponsive.height(context, 500),
      width: double.maxFinite,
      child: TabBarView(
        controller: controller.tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: _buildInfoCard(
                            LocaleKeys.tracking_detail_view_text_distance.tr,
                            (controller.model.distance / 1000)
                                .toStringAsPrecision(2),
                            LocaleKeys.tracking_detail_view_text_km.tr)),
                    Expanded(
                      child: _buildInfoCard(
                          LocaleKeys.tracking_detail_view_text_time.tr,
                          Duration(seconds: controller.model.movingTime)
                              .toHoursMinutesSeconds(),
                          LocaleKeys.tracking_detail_view_text_hour.tr),
                    ),
                    Expanded(
                        child: _buildInfoCard(
                            LocaleKeys.tracking_detail_view_text_pace.tr,
                            controller.averagePage.value,
                            LocaleKeys.tracking_detail_view_text_min_km.tr)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.model.type == "RUN"
                        ? Expanded(
                            child: _buildInfoCard(
                                LocaleKeys
                                    .tracking_detail_view_text_max_speed.tr,
                                (controller.model.maxSpeed * 3.6)
                                    .toPrecision(2)
                                    .toString(),
                                "km/h"))
                        : Expanded(
                            child: _buildInfoCard(
                                LocaleKeys
                                    .tracking_detail_view_text_maximum_pace.tr,
                                CalculateUtils.changeToMinutesSecond(
                                    controller.model.maxPace),
                                LocaleKeys
                                    .tracking_detail_view_text_min_km.tr)),
                    Expanded(
                        child: _buildInfoCard(
                            LocaleKeys
                                .tracking_detail_view_text_highest_elevation.tr,
                            controller.model.elevHigh.toPrecision(2).toString(),
                            LocaleKeys.tracking_detail_view_text_min_km.tr)),
                  ],
                ),
                ...List.generate(
                  controller.listTrackingDetail.length,
                  (index) {
                    var content =
                        controller.listTrackingDetail.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              content.icon,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              content.title,
                              style: TextStyleConstant.textRegular16,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              content.detail,
                              style: TextStyleConstant.textRegular16,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              content.unit,
                              style: TextStyleConstant.textRegular16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                controller.model.photos.isNotEmpty
                    ? SizedBox(
                        height: UtilsReponsive.height(context, 160),
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.model.photos.length,
                          separatorBuilder: (context, index) {
                            return Container(
                              color: Colors.white,
                              height: 160,
                              width: 5,
                            );
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              height: UtilsReponsive.height(context, 150),
                              width: UtilsReponsive.width(context, 150),
                              child: controller.model.photos[index]
                                      .contains("irace")
                                  ? CachedNetworkImage(
                                      imageUrl: controller.model.photos[index])
                                  : Image.file(
                                      File(controller.model.photos[index])),
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    controller.model.type == "RUN"
                        ? LocaleKeys.tracking_detail_view_text_pace.tr
                        : "Speed",
                    style: TextStyleConstant.blackBold16,
                  ),
                ),
                ChartPace(
                    model: controller.model.dataStream,
                    type: controller.model.type),
                const Divider(
                  thickness: 12,
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    LocaleKeys.tracking_detail_view_text_elevation.tr,
                    style: TextStyleConstant.blackBold16,
                  ),
                ),
                ChartElevation(model: controller.model.dataStream),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child:
                            Text(LocaleKeys.tracking_detail_view_text_km.tr)),
                    Expanded(
                        flex: 2,
                        child: Text(
                            LocaleKeys.tracking_detail_view_text_avg_speed.tr)),
                    Expanded(
                        flex: 2,
                        child: Text(LocaleKeys
                            .tracking_detail_view_text_elevation_difference
                            .tr)),
                    Expanded(
                        flex: 2,
                        child: Text(
                            LocaleKeys.tracking_detail_view_text_move_time.tr))
                  ],
                ),
                SizedBox(
                  height: UtilsReponsive.height(context, 10),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.model.splitsMetric.length,
                  primary: false,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(controller
                                .model.splitsMetric[index].split
                                .toString())),
                        Expanded(
                            child: Text((controller.model.splitsMetric[index]
                                        .averageSpeed *
                                    3.6)
                                .toPrecision(2)
                                .toString())),
                        Expanded(
                            child: Text(controller
                                .model.splitsMetric[index].elevationDifference
                                .toPrecision(2)
                                .toString())),
                        Expanded(
                            child: Text(Duration(
                                    seconds: controller
                                        .model.splitsMetric[index].movingTime)
                                .toMinutesSeconds()
                                .toString())),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 12,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _tabBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(width: 2),
      ),
      child: TabBar(
        onTap: (value) => {print(value)},
        labelColor: Colors.white,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
            16.0,
          ),
          color: Colors.blue.shade100.withOpacity(0.2),
        ),
        controller: controller.tabController,
        unselectedLabelColor: Colors.grey,
        splashBorderRadius: BorderRadius.circular(20),
        tabs: [
          Tab(
              icon: Row(
            children: [
              Expanded(
                child: Icon(
                  Icons.summarize,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    LocaleKeys.tracking_detail_view_text_sumary.tr,
                    style: TextStyleConstant.blackBold16,
                  ),
                ),
              )
            ],
          )),
          Tab(
              icon: Row(
            children: [
              Expanded(child: Icon(Icons.analytics, color: Colors.black)),
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(LocaleKeys.tracking_detail_view_text_analysis.tr,
                      style: TextStyleConstant.blackBold16),
                ),
              )
            ],
          )),
          Tab(
              icon: Row(
            children: [
              Expanded(
                  child: Icon(Icons.vertical_split_sharp, color: Colors.black)),
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(LocaleKeys.tracking_detail_view_text_split.tr,
                      style: TextStyleConstant.blackBold16),
                ),
              )
            ],
          )),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: ColorConstant.common_bg_dark,
      title: Text(controller.model.name),
      leading: IconButton(
        onPressed: controller.onTapLeading,
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.share,
            color: ColorConstant.gray9e9e9e,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Column _buildInfoCard(String title, String result, String unit,
      {bool isLowerCase = false}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyleConstant.blackRegular16.copyWith(fontSize: 14),
        ),
        Text(
          result,
          style: TextStyleConstant.blackBold16.copyWith(fontSize: 30),
        ),
        Text(
          unit,
          style: TextStyleConstant.textRegular16.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}

class ChartInfo extends StatelessWidget {
  const ChartInfo({
    Key? key,
    required this.title1,
    required this.title2,
    required this.subTitle1,
    required this.subTitle2,
    required this.unit,
  }) : super(key: key);
  final String title1;
  final String title2;
  final String unit;
  final String subTitle1;
  final String subTitle2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: UtilsReponsive.height(context, 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            // flex: 5,
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: title1.toUpperCase(),
                        style: TextStyleConstant.blackBold16
                            .copyWith(fontSize: 50),
                      ),
                      TextSpan(
                        text: unit,
                        style: TextStyleConstant.blackBold16
                            .copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                ),
                Text(
                  subTitle1.toUpperCase(),
                  style: TextStyleConstant.textRegular16.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          VerticalDivider(
            width: UtilsReponsive.width(context, 20),
            thickness: 2,
            indent: 20,
            endIndent: 20,
            color: Colors.grey,
          ),
          Expanded(
            // flex: 5,
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: title2.toUpperCase(),
                        style: TextStyleConstant.blackBold16
                            .copyWith(fontSize: 50),
                      ),
                      TextSpan(
                        text: unit,
                        style: TextStyleConstant.blackBold16
                            .copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                ),
                Text(
                  subTitle2.toUpperCase(),
                  style: TextStyleConstant.textRegular16.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
