import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:tracker_run/app/modules/tracking_map_v2/views/tracking_map_v2_basic.dart';

import '../../../../generated/locales.g.dart';
import '../../../components/circle_button.dart';
import '../../../components/list_title_sport_custom.dart';
import '../../../resources/app_constants.dart';
import '../../../resources/reponsive_utils.dart';
import '../controllers/tracking_map_v2_controller.dart';

class TrackingMapV2View extends GetView<TrackingMapV2Controller> {
  const TrackingMapV2View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double sizeWith = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    return Obx(() => controller.isLoading.value
        ? const Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : WillPopScope(
          onWillPop: ()async=>false,
          child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniCenterFloat,
              floatingActionButton:
                  Obx(() => controller.isLoadingBeforeStart.value
                      ? buttonLoading(sizeHeight)
                      : controller.isButtonStart.value
                          ? buttonStart(sizeHeight)
                          : buttonStop(sizeHeight)),
              body: SafeArea(
                child: Column(children: [
                  headerContainer(sizeHeight, sizeWith),
                  Expanded(
                    child: Container(
                      height: sizeHeight * 0.7,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Obx(
                            () => GoogleMap(
                              minMaxZoomPreference:
                                  const MinMaxZoomPreference(0, 18),
                              mapType: MapType.normal,
                              markers: controller.markers.value,
                              polylines: {
                                Polyline(
                                    color: Colors.blue,
                                    width: 5,
                                    polylineId: PolylineId(LocaleKeys
                                        .tracking_map_view_text_route.tr),
                                    points: controller.polyline.value)
                              },
                              onMapCreated: ((value) =>
                                  controller.onMapCreated(value)),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              zoomControlsEnabled: false,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      controller.currentPosition.latitude!,
                                      controller.currentPosition.longitude!),
                                  zoom: 18),
                            ),
                          ),
                          Obx(() => buttonTypeMode(sizeHeight, context)),
                          Positioned(
                              top: 0,
                              left: UtilsReponsive.width(context, 5),
                              child: SizedBox(
                                  height: UtilsReponsive.height(context, 50),
                                  width: UtilsReponsive.width(context, 120),
                                  child: Image.asset(
                                    "assets/images/waterwall.png",
                                    fit: BoxFit.fill,
                                  )))
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
        ));
  }

  Widget buttonTypeMode(double sizeHeight, BuildContext context) {
    return !controller.isButtonStart.value
        ? Positioned(
            bottom: sizeHeight * 0.05,
            right: 0,
            child: CircleButton(
              widget: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 40,
                  color: ColorConstant.primary,
                ),
              ),
              onTap: () {
                Get.to(() => TrackingMapV2Basic(),
                    transition: Transition.leftToRight);
              },
              backgroundColor: Colors.white,
            ))
        : controller.typeMode.value == "RUN"
            ? Positioned(
                bottom: sizeHeight * 0.05,
                right: 0,
                child: CircleButton(
                  widget: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.directions_walk,
                      size: 40,
                      color: ColorConstant.primary,
                    ),
                  ),
                  onTap: () {
                    showSheet(context);
                  },
                  backgroundColor: Colors.white,
                ))
            : Positioned(
                bottom: sizeHeight * 0.05,
                right: 0,
                child: CircleButton(
                  widget: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.directions_bike,
                      size: 40,
                      color: ColorConstant.primary,
                    ),
                  ),
                  onTap: () {
                    showSheet(context);
                  },
                  backgroundColor: Colors.white,
                ));
  }

  SizedBox buttonStop(
    double sizeHeight,
  ) {
    return SizedBox(
      height: sizeHeight * 0.15,
      width: sizeHeight * 0.15,
      child: CircleButton(
        onTap: () async => controller.onClickStop(),
        backgroundColor: ColorConstant.green,
        widget: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              LocaleKeys.tracking_map_view_buttons_pause.tr.toUpperCase(),
              style: TextStyleConstant.white22RobotoBold,
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buttonLoading(
    double sizeHeight,
  ) {
    return SizedBox(
      height: sizeHeight * 0.15,
      width: sizeHeight * 0.15,
      child: CircleButton(
        widget: const Padding(
          padding: const EdgeInsets.all(5.0),
          child: FittedBox(
              fit: BoxFit.scaleDown, child: CircularProgressIndicator()),
        ),
        backgroundColor:
            // controller.isGpsDisable.isFalse?
            ColorConstant.redpink,
        // : ColorConstant.grey70747E,
        onTap: () {},
      ),
    );
  }

  SizedBox buttonStart(
    double sizeHeight,
  ) {
    return SizedBox(
      height: sizeHeight * 0.15,
      width: sizeHeight * 0.15,
      child: CircleButton(
        widget: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              LocaleKeys.tracking_map_view_buttons_start.tr,
              style: TextStyleConstant.white22RobotoBold,
            ),
          ),
        ),
        backgroundColor: controller.isGpsDisable.isFalse
            ? ColorConstant.redpink
            : ColorConstant.grey70747E,
        onTap: () async => {
          controller.onClickStart()
          // Get.to(()=>CountdownTimerScreen())
        },
      ),
    );
  }

  SizedBox headerContainer(double sizeHeight, double sizeWith) {
    TextStyle styleTime = TextStyle(fontWeight: FontWeight.w500, fontSize: 40);
    TextStyle styleDescription = TextStyle(fontSize: 20);
    TextStyle styleSub = TextStyle(fontWeight: FontWeight.w500, fontSize: 30);

    return SizedBox(
      height: sizeHeight * 0.26,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizeWith * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Obx(
                      () => Visibility(
                        visible: controller.isButtonStart.value,
                        child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.close)),
                      ),
                    ),
                    Obx(
                      () => pinGps(sizeHeight),
                    )
                  ],
                ),
                SizedBox()
                // ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Obx(
                            () => Text(
                              controller.distance.toString(),
                              style: TextStyleConstant.black22RobotoBold,
                            ),
                          )),
                    ),
                    SizedBox(
                      height: sizeHeight * 0.01,
                    ),
                    Center(
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            LocaleKeys.tracking_map_view_text_km.tr,
                            style: TextStyleConstant.black16Roboto,
                          )),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              controller.elapTime.value,
                              style: TextStyleConstant.black40RobotoBold,
                            )),
                        SizedBox(
                          height: sizeHeight * 0.01,
                        ),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              LocaleKeys.tracking_map_view_text_min.tr,
                              style: TextStyleConstant.black16Roboto,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: sizeHeight * 0.01,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child:
                                  Obx(() => controller.typeMode.value == "RUN"
                                      ? Text(
                                          controller.pace.value,
                                          style: TextStyleConstant
                                              .black22RobotoBold,
                                        )
                                      : Text(
                                          controller.speed.value,
                                          style: TextStyleConstant
                                              .black22RobotoBold,
                                        ))),
                        ),
                        SizedBox(
                          height: sizeHeight * 0.01,
                        ),
                        Center(
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Obx(() => controller.typeMode.value ==
                                      "RUN"
                                  ? Text(
                                      LocaleKeys
                                          .tracking_map_view_text_pace_mk.tr,
                                      style: TextStyleConstant.black16Roboto)
                                  : Text(
                                      LocaleKeys
                                          .tracking_map_view_text_speed_kmh.tr,
                                      style: TextStyleConstant.black16Roboto,
                                    ))),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Obx(() => Text(
                                    controller.calo.value.toString(),
                                    style: TextStyleConstant.black22RobotoBold,
                                  ))),
                        ),
                        SizedBox(
                          height: sizeHeight * 0.01,
                        ),
                        Center(
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                LocaleKeys.tracking_map_view_text_kcal.tr,
                                style: TextStyleConstant.black16Roboto,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container pinGps(double sizeHeight) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      width: 30,
      height: sizeHeight * 0.02,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount:
            controller.isGpsDisable.isTrue ? 1 : controller.numSignal.value + 1,
        itemBuilder: (context2, index) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: controller.isGpsDisable.isTrue
                    ? Colors.red
                    : controller.numSignal.value == 2
                        ? Colors.green[600]
                        : controller.numSignal.value == 1
                            ? Colors.orange
                            : Colors.red),
            height: 3,
            width: 10,
          );
        },
      ),
    );
  }

  Future showSheet(context) => showSlidingBottomSheet(context,
      builder: (context) => SlidingSheetDialog(
            snapSpec: const SnapSpec(snappings: [0.4, 0.7]),
            builder: buildSheet,
          ));
  Widget buildSheet(context, state) => Material(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey),
                ),
              ),
              Center(
                  child: Text(
                      LocaleKeys.tracking_map_view_text_choosse_a_Sport.tr,
                      style: TextStyleConstant.blackBold16)),
              Align(
                alignment: Alignment.topLeft,
                child: Text(LocaleKeys.tracking_map_view_text_foot_sport.tr,
                    style: TextStyleConstant.blackBold16),
              ),
              InkWell(
                  onTap: () {
                    controller.typeMode.value = "RUN";
                    Get.back();
                  },
                  child: Obx(
                    () => ListTitleSport(
                      title: LocaleKeys.tracking_map_view_text_run.tr,
                      icon: Icons.directions_walk,
                      isCheck:
                          controller.typeMode.value == "RUN" ? true : false,
                    ),
                  )),
              InkWell(
                  onTap: () {
                    controller.typeMode.value = "RIDE";
                    Get.back();
                  },
                  child: Obx(
                    () => ListTitleSport(
                      title: LocaleKeys.tracking_map_view_text_ride.tr,
                      icon: Icons.directions_bike,
                      isCheck:
                          controller.typeMode.value == "RIDE" ? true : false,
                    ),
                  )),
            ],
          ),
        ),
      );
}
