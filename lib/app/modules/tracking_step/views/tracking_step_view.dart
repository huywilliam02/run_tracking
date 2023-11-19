import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tracker_run/app/modules/tracking_step/views/tracking_step_setting.dart';
import 'package:tracker_run/app/resources/data_constant.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../base/base_view.dart';
import '../controllers/tracking_step_controller.dart';

class TrackingStepView extends BaseView<TrackingStepController> {
  // const TrackingStepView({Key? key}) : super(key: key);
  int count = 0;
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstant.common_bg_dark,
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              color: ColorConstant.common_bg_dark,
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
                size: UtilsReponsive.height(context, 30),
              )),
          actions: [
         
                  IconButton(
                color: ColorConstant.common_bg_dark,
                onPressed: () {
                  controller.onClickRestart();
                },
                icon: Icon(
                  Icons.restart_alt,
                  color: Colors.white,
                  size: UtilsReponsive.height(context, 30),
                )),
                   IconButton(
                color: ColorConstant.common_bg_dark,
                onPressed: () {
                  Get.to(() => TrackingStepSetting());
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: UtilsReponsive.height(context, 30),
                )),
          ],
          backgroundColor: ColorConstant.primary,
          title: Text(
            LocaleKeys.step_view_step_title.tr,
            style: TextStyleConstant.white22RobotoBold,
          )),
      body: SafeArea(
        child: Center(
            child: Obx(
          () => controller.isLoading.value
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                   
                      // Text(
                      //   LocaleKeys.step_view_step_title.tr,
                      //   style: TextStyleConstant.white50RobotoBold,
                      // ),
                     
                      Obx(
                        () => Center(
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: CircularPercentIndicator(
                              radius: UtilsReponsive.height(context, 100),
                              animation: false,
                              animationDuration: 0,
                              lineWidth: 15.0,
                              percent: controller.percent.value,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        controller.stepDaily.value.steps
                                            .toString(),
                                        style:
                                            TextStyleConstant.white50RobotoBold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "/" +
                                        controller.stepDaily.value.target
                                            .toString(),
                                    style: TextStyleConstant.grey16RobotoBold,
                                  )
                                ],
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: Colors.yellow,
                              progressColor: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.04,
                      ),
                      Text(LocaleKeys.step_view_step_7_day.tr,
                          style: TextStyleConstant.white22RobotoBold),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      Row(
                        children: [
                          FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Obx(
                              () => Text(
                                controller.count7day.value.toString(),
                                style: TextStyleConstant.white50RobotoBold,
                              ),
                            ),
                          ),
                          Expanded(flex: 2, child: SizedBox.shrink())
                        ],
                      )
                      // Obx(
                      //   () => controller.list7Day.value.isNotEmpty
                      //       ? SizedBox.shrink()
                      //       : SizedBox(
                      //           height: Get.height * 0.5,
                      //           child: Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: List.generate(
                      //               7,
                      //               (index) => Expanded(
                      //                 child: Column(
                      //                   children: [
                      //                     CircularPercentIndicator(
                      //                       radius: UtilsReponsive.height(
                      //                           context, 25),
                      //                       animation: false,
                      //                       animationDuration: 0,
                      //                       lineWidth: 7.0,
                      //                       percent: controller.percent.value,
                      //                       circularStrokeCap:
                      //                           CircularStrokeCap.butt,
                      //                       backgroundColor: Colors.yellow,
                      //                       progressColor: Colors.red,
                      //                     ),
                      //                     SizedBox(
                      //                       height: 5,
                      //                     ),
                      //                     Text(
                      //                         DateFormat('E')
                      //                             .format(DateTime.now()
                      //                                 .add(Duration(days: index)))
                      //                             .toString(),
                      //                         style: TextStyleConstant
                      //                             .white16Roboto),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      // )
                      // Expanded(
                      //   flex: 5,
                      //   child: Align(
                      //     alignment: Alignment.topCenter,
                      //     child: Row(

                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Expanded(
                      //           child: ListView.separated(
                      //             separatorBuilder: (context, index) => SizedBox(width: 10,),
                      //              scrollDirection: Axis.horizontal,
                      //             itemCount: 7,
                      //             shrinkWrap: true,
                      //             itemBuilder: (context, index) =>
                      //                 CircularPercentIndicator(
                      //               radius: UtilsReponsive.height(context, 30),
                      //               animation: false,
                      //               animationDuration: 0,
                      //               lineWidth: 10.0,
                      //               percent: controller.percent.value,
                      //               center: Text(
                      //                   DateFormat('E')
                      //                       .format(
                      //                           DateTime.fromMillisecondsSinceEpoch(
                      //                               controller.stepDaily.value.id))
                      //                       .toString(),
                      //                   style: TextStyleConstant.white16Roboto),
                      //               circularStrokeCap: CircularStrokeCap.butt,
                      //               backgroundColor: Colors.yellow,
                      //               progressColor: Colors.red,
                      //             ),
                      //           ),
                      //         )
                      // ],
                      // ),
                      // ),
                      // ),
                      // ),
                      //  SizedBox(
                      //   height: Get.height*0.31,)
                    ],
                  ),
                ),
        )),
      ),
    );
  }
}
