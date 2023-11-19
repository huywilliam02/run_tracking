import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/enum/format_timer.dart';
import 'package:tracker_run/app/modules/tab_view/controllers/tab_home_controller/tab_home_controller.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../../../../class_test_data/calculate.dart';

class MoreRecord extends BaseView<TabHomeController> {
  @override
  Widget buildView(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    print(controller.list..value.length);
    return Obx(
      () => controller.isLoading.isTrue
          ? Scaffold(
              backgroundColor: ColorConstant.common_bg_dark,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: ColorConstant.common_bg_dark,
                title: Text(
LocaleKeys.tab_home_view_text_more_app_bar.tr,
                  style: TextStyleConstant.white22RobotoBold,
                ),
                centerTitle: true,
              ),
              backgroundColor: ColorConstant.common_bg_dark,
              body: controller.list.length == 0
                  ? Center(
                      child: Text(
                    LocaleKeys.common_not_have_data.tr,
                      style: TextStyleConstant.black16Roboto,
                    ))
                  :Obx(()=> ListView.builder(
                      controller: controller.scrollController,
                      // reverse: true,
                      itemCount: controller.list.length + 1,
                      // physics: NeverScrollableScrollPhysics(),
                      // shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == controller.list.length ) {
                          return Obx(() =>  Visibility(
                            visible:!controller.notHaveData.value ,
                            child: CupertinoActivityIndicator(
                              color: Colors.red,
                            ),
                          ));
                        }
                        return _activity(index, context);
                      }),)
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
                                          UtilsReponsive.height(context, 180),
                                      // height:
                                      //     UtilsReponsive.height(
                                      //         context, 90),
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
                                  "Time: " +
                                      Duration(
                                              seconds: controller.list
                                                  .value[index].elapsedTime)
                                          .toMinutesSeconds(),
                                  style:TextStyleConstant.white16Roboto,
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
                style: TextStyleConstant.white22RobotoBold,
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
}
