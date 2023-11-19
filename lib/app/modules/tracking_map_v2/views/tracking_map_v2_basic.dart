import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/modules/tracking_map_v2/controllers/tracking_map_v2_controller.dart';

import '../../../../generated/locales.g.dart';
import '../../../components/circle_button.dart';
import '../../../resources/app_constants.dart';
import '../../../resources/reponsive_utils.dart';

class TrackingMapV2Basic extends BaseView<TrackingMapV2Controller> {
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: UtilsReponsive.height(context, 20),
                horizontal: UtilsReponsive.width(context, 10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "TIME",
                        style: TextStyleConstant.black16Roboto,
                      ),
                      SizedBox(
                        height: UtilsReponsive.height(context, 15),
                      ),
                      Expanded(
                        flex: 2,
                        child:Obx(()=> Text(
                          controller.elapTime.value,
                          style: TextStyleConstant.black60RobotoBold,
                        ),)
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Obx(() => controller.typeMode.value == "RUN"
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
                      Obx(() => controller.typeMode.value == "RUN"
                          ? Text(
                              controller.pace.value,
                              style: TextStyleConstant.black60RobotoBold,
                            )
                          : Text(
                              controller.speed.value,
                              style: TextStyleConstant.black60RobotoBold,
                            )),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            LocaleKeys.tracking_map_view_text_kcal.tr,
                            style: TextStyleConstant.black16Roboto,
                          ),
                          Obx(() => Text(
                                controller.calo.value.toString(),
                                style: TextStyleConstant.black60RobotoBold,
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            LocaleKeys.tracking_map_view_text_km.tr,
                            style: TextStyleConstant.black16Roboto,
                          ),
                          Obx(
                            () => Text(
                              controller.distance.toString(),
                              style: TextStyleConstant.black60RobotoBold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: SizedBox()),
                      Expanded(
                        child: Obx(() => controller.isLoadingBeforeStart.value
                            ? buttonLoading(MediaQuery.of(context).size.height)
                            : controller.isButtonStart.value
                                ? buttonStart(MediaQuery.of(context).size.height)
                                : buttonStop(MediaQuery.of(context).size.height)),
                      ),
                      Expanded(
                        child: Obx(() => !controller.isButtonStart.value
                            ? CircleButton(
                                widget: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    size: 40,
                                    color: ColorConstant.primary,
                                  ),
                                ),
                                onTap: () {
                                  Get.back();
                                },
                                backgroundColor: Colors.white,
                              )
                            : SizedBox.shrink()),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
            fit: BoxFit.cover,
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
}
