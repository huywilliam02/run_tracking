import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/enum/format_timer.dart';
import 'package:tracker_run/app/modules/tracking_step/controllers/tracking_step_controller.dart';
import 'package:tracker_run/app/modules/tracking_step/views/tracking_step_view.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../../../class_test_data/calculate.dart';
import '../../../../common/commonTopBar/commonTopBar.dart';
import '../../../../routes/app_pages.dart';
import '../../../tracking_map_v2/model/data_model_strava.dart';
import '../../controllers/tab_home_controller/tab_home_controller.dart';

class TabHomeView extends BaseView<TabHomeController> {
  @override
  Widget buildView(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: ColorConstant.common_bg_dark,
        body: Obx(
          () => controller.isLoading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ColorConstant.primary,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: UtilsReponsive.width(context, 15),
                          vertical: UtilsReponsive.height(context, 15)),
                      child: CommonTopBar(
                        "IRACE",
                        // this,
                        isShowSubheader: true,
                        subHeader: "Believe it - Achieve it",
                        isInfo: true,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: UtilsReponsive.width(context, 15)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: UtilsReponsive.height(Get.context!, 15),
                              ),
                              stepsAndWaterButtons(
                                  MediaQuery.of(context).size.height,
                                  MediaQuery.of(context).size.width),
                              SizedBox(
                                height: UtilsReponsive.height(Get.context!, 15),
                              ),
                              Obx(
                                () => controller.list.isEmpty
                                    ? SizedBox.shrink()
                                    : recentActivities(fullHeight, fullWidth),
                              ),
                              SizedBox(
                                height: UtilsReponsive.height(Get.context!, 15),
                              ),
                              bestRecords(fullHeight, fullWidth),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }

  recentActivities(double fullHeight, double fullWidth) {
    return Visibility(
      visible: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.tab_home_view_text_recent_activity.tr,
                  style: TextStyleConstant.white22RobotoBold,
                ),
              ),
              controller.list.length == 0
                  ? SizedBox.shrink()
                  : InkWell(
                      onTap: () {
                        controller.onClickMore();
                      },
                      child: Text(
                        LocaleKeys.tab_home_view_text_more.tr,
                        style: TextStyleConstant.purple22RobotoBold,
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: UtilsReponsive.height(Get.context!, 15),
          ),
          recentActivitiesList(fullHeight),
          SizedBox(
            height: UtilsReponsive.height(Get.context!, 15),
          ),
        ],
      ),
    );
  }

  recentActivitiesList(
    double fullHeight,
  ) {
    return controller.list.isEmpty
        ? Text(
            LocaleKeys.common_not_have_data.tr,
            style: TextStyleConstant.whiteBold16,
          )
        : _activity(0, Get.context!);
  }

  stepsAndWaterButtons(double fullHeight, double fullWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.tab_home_view_text_today_title.tr,
          style: TextStyleConstant.white22RobotoBold,
        ),
        SizedBox(
          height: UtilsReponsive.height(Get.context!, 15),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: () async {
                  // Fluttertoast.showToast(msg: "Comming soon");
                  if (await Permission.activityRecognition.isGranted) {
                    if (Get.isRegistered<TrackingStepController>()) {
                      await Get.find<TrackingStepController>().update7day();
                      Get.to(() => TrackingStepView());
                    } else {
                      Get.toNamed(Routes.TRACKING_STEP);
                    }
                  } else {
                    await controller.checkPermission();
                  }
                },
                child: Image.asset("assets/icons/ic_steps.png",
                    height: 90, width: fullWidth * 0.385)),
            SizedBox(
              width: 20,
            ),
            InkWell(
                onTap: () => Get.toNamed(Routes.TRACKING_DRINK_WATER),
                child: Image.asset("assets/icons/ic_water.png",
                    height: 90, width: fullWidth * 0.385)),
          ],
        ),
      ],
    );
  }

  bestRecords(double fullHeight, double fullWidth) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.tab_home_view_text_best_record.tr,
              style: TextStyleConstant.white22RobotoBold,
            ),
          ],
        ),
        SizedBox(
          height: 21,
        ),
        bestRecordList()
      ],
    );
  }

  bestRecordList() {
    return Column(
      children: [
        bestRecordListTile(
            dataModel: controller.bestRecord.bestDistance,
            img: "ic_distance.webp",
            text: LocaleKeys.tab_home_view_text_best_record_distance.tr
                .toUpperCase(),
            value: controller.bestRecord.bestDistance?.distance != null
                ? (controller.bestRecord.bestDistance!.distance / 1000)
                    .toPrecision(2)
                    .toString()
                : "0.0",
            unit: "Km".toLowerCase(),
            isNotDuration: true),
        bestRecordListTile(
            dataModel: controller.bestRecord.bestPace,
            img: "ic_best_pace.png",
            text:
                LocaleKeys.tab_home_view_text_best_record_pace.tr.toUpperCase(),
            value: controller.bestRecord.bestPace != null
                ? CalculateUtils.changeToMinutesSecond(
                    controller.bestRecord.bestPace!.maxPace)
                : "00:00",
            unit: "min/km".toLowerCase(),
            isNotDuration: true),
        bestRecordListTile(
            dataModel: controller.bestRecord.bestDuration,
            img: "ic_duration.webp",
            text: LocaleKeys.tab_home_view_text_best_record_longest.tr
                .toUpperCase(),
            value: controller.bestRecord.bestDuration != null
                ? Duration(
                        seconds:
                            controller.bestRecord.bestDuration!.elapsedTime)
                    .toHoursMinutesSeconds()
                : "00:00:00",
            isNotDuration: false),
      ],
    );
  }

  bestRecordListTile(
      {DataModelStrava? dataModel,
      String? img,
      required String text,
      required String value,
      String? unit,
      required bool isNotDuration}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () async {
          if (dataModel != null) {
            Get.toNamed(Routes.TRACKING_DETAIL, arguments: dataModel);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: ColorConstant.progress_background_color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/icons/$img",
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 12.0, bottom: 12.0, top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleConstant.white16Roboto,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            value,
                            style: TextStyleConstant.purple22RobotoBold,
                          ),
                          Visibility(
                            visible: isNotDuration,
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 5.0, bottom: 3.0),
                              child: Text(
                                isNotDuration ? unit! : "",
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyleConstant.purple16RobotoBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _activity(int index, BuildContext context) {
    return InkWell(
      onTap: () {
        controller.onTapDetail(controller.list.value[index]);
      },
      child: Container(
        margin: EdgeInsets.all(UtilsReponsive.height(context, 20)),
        height: UtilsReponsive.height(context, 250),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  // clipBehavior: Clip.hardEdge,
                  height: UtilsReponsive.height(context, 200),
                  width: double.infinity,
                  // padding: EdgeInsets.only(
                  //     top:
                  //         UtilsReponsive.height(context, 40)),
                  decoration: BoxDecoration(
                    color: ColorConstant.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              // ignore: sort_child_properties_last
                              child: (controller
                                          .list[index].photos.isNotEmpty &&
                                      controller.list[index].isOnline)
                                  ? CachedNetworkImage(
                                      height:
                                          UtilsReponsive.height(context, 200),
                                      width: UtilsReponsive.width(context, 120),
                                      imageUrl:
                                          controller.list[index].photos[0],
                                      fit: BoxFit.scaleDown,
                                    )
                                  : Image.asset(
                                      controller.list[index].photos
                                                  .isNotEmpty &&
                                              !controller.list[index].isOnline
                                          ? controller.list[index].photos[0]
                                          : "assets/images/label.jpg",
                                      height:
                                          UtilsReponsive.height(context, 120),
                                      width:
                                          UtilsReponsive.height(context, 120),
                                      fit: BoxFit.scaleDown,
                                    ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(
                            width: UtilsReponsive.width(context, 10),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat.yMd().add_jm().format(
                                      controller.list.value[index].startDate),
                                  style: TextStyleConstant.white16Roboto,
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(context, 10),
                                ),
                                Text(
                                  LocaleKeys.tab_home_view_text_pace.tr +
                                      CalculateUtils.calculatePage(
                                          controller
                                              .list.value[index].movingTime,
                                          controller
                                              .list.value[index].distance) +
                                      " /km",
                                  softWrap: false,
                                  maxLines: 2,
                                  style: TextStyleConstant.white16Roboto,
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(context, 10),
                                ),
                                Text(
                                  LocaleKeys.tab_home_view_text_time.tr +
                                      Duration(
                                              seconds: controller.list
                                                  .value[index].elapsedTime)
                                          .toMinutesSeconds(),
                                  style: TextStyleConstant.white16Roboto,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
            Positioned(
              top: 0,
              left: 0,
              // left: UtilsReponsive.width(context, 130),
              child: Text(
                controller.list[index].name,
                softWrap: false,
                maxLines: 2,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white),
              ),
            ),
            Positioned(
              top: UtilsReponsive.height(context, 30),
              right: 0,
              // left: UtilsReponsive.width(context, 130),
              child: Container(
                padding: EdgeInsets.all(UtilsReponsive.height(context, 10)),
                height: UtilsReponsive.height(context, 40),
                width: UtilsReponsive.width(context, 70),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        UtilsReponsive.height(context, 20)),
                    color: Colors.orange),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      (controller.list.value[index].distance / 1000)
                              .toPrecision(2)
                              .toString() +
                          " km",
                      softWrap: false,
                      maxLines: 2,
                      style: TextStyleConstant.white22RobotoBold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget _activity2(int index, BuildContext context) {
  //   return InkWell(
  //     onTap: () {
  //       controller.onTapDetail(controller.list.value[index]);
  //     },
  //     child: Container(
  //       padding:
  //           EdgeInsets.symmetric(horizontal: UtilsReponsive.width(context, 15)),
  //       height: UtilsReponsive.height(context, 330),
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: Colors.black,
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.directions_walk,
  //                 color: Colors.white,
  //               ),
  //               SizedBox(
  //                 width: UtilsReponsive.width(context, 10),
  //               ),
  //               Text(
  //                   DateFormat.yMd().add_jm().format(
  //                         controller.list.value[index].startDate,
  //                       ),
  //                   softWrap: false,
  //                   maxLines: 2,
  //                   style: TextStyleConstant.white16Roboto),
  //             ],
  //           ),
  //           SizedBox(
  //             height: UtilsReponsive.height(context, 10),
  //           ),
  //           Text(controller.list.value[index].name,
  //               softWrap: false,
  //               maxLines: 2,
  //               style: TextStyle(
  //                   fontWeight: FontWeight.w500,
  //                   fontSize: 25,
  //                   color: Colors.white)),
  //           SizedBox(
  //             height: UtilsReponsive.height(context, 50),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: [
  //                       Text(LocaleKeys.tab_home_view_text_distance.tr,
  //                           softWrap: false,
  //                           maxLines: 2,
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.w500,
  //                               fontSize: 13,
  //                               color: Colors.white)),
  //                       Text(
  //                         (controller.list.value[index].distance / 1000)
  //                                 .toPrecision(2)
  //                                 .toString() +
  //                             " km",
  //                         softWrap: false,
  //                         maxLines: 2,
  //                         style: TextStyleConstant.white22RobotoBold,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   height: double.infinity,
  //                   width: 3,
  //                   color: Colors.red,
  //                 ),
  //                 Expanded(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: [
  //                       Text(LocaleKeys.tab_home_view_text_best_record_pace.tr,
  //                           softWrap: false,
  //                           maxLines: 2,
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.w500,
  //                               fontSize: 13,
  //                               color: Colors.white)),
  //                       Text(
  //                         CalculateUtils.calculatePage(
  //                                 controller.list.value[index].movingTime,
  //                                 controller.list.value[index].distance) +
  //                             " /km",
  //                         softWrap: false,
  //                         maxLines: 2,
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.w500,
  //                             fontSize: 25,
  //                             color: Colors.white),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             width: double.infinity,
  //             height: UtilsReponsive.height(context, 200),
  //             child: ClipRRect(
  //               // ignore: sort_child_properties_last
  //               child: (controller.list[index].photos.isNotEmpty &&
  //                       controller.list[index].isOnline)
  //                   ? CachedNetworkImage(
  //                       height: UtilsReponsive.height(context, 200),
  //                       // height:
  //                       //     UtilsReponsive.height(
  //                       //         context, 90),
  //                       width: UtilsReponsive.width(context, 120),
  //                       imageUrl: controller.list[index].photos[0],
  //                       fit: BoxFit.scaleDown,
  //                     )
  //                   : Image.asset(
  //                       controller.list[index].photos.isNotEmpty &&
  //                               !controller.list[index].isOnline
  //                           ? controller.list[index].photos[0]
  //                           : "assets/images/label.jpg",
  //                       height: UtilsReponsive.height(context, 120),
  //                       width: UtilsReponsive.height(context, 120),
  //                       fit: BoxFit.fill,
  //                     ),
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
