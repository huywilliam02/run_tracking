import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../login/controllers/login_controller.dart';
import '../../controllers/tab_mine_controller/tab_mine_controller.dart';

class TabMineView extends BaseView<TabMineController> {
  @override
  Widget buildView(BuildContext context) {
    // List<Widget> listWidget = [
    //   Container(
    //       margin: EdgeInsets.symmetric(horizontal: 5.0),
    //       width: UtilsReponsive.width(context, 150),
    //       decoration: BoxDecoration(
    //           border: Border.all(color: Colors.black),
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(20)),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           // Lotties.asset(), icon_water_profile.json
    //           Expanded(
    //             flex: 3,
    //             child: SizedBox(
    //               height: UtilsReponsive.height(context, 70),
    //               width: UtilsReponsive.width(context, 70),
    //               child: Lottie.asset('assets/icons/icon_water_profile.json'),
    //             ),
    //           ),
    //           Expanded(
    //             child: Text("Water",
    //                 style: TextStyle(
    //                     fontSize: 20,
    //                     fontWeight: FontWeight.w500,
    //                     color: Colors.black)),
    //           ),
    //           Expanded(
    //             child: LinearPercentIndicator(
    //               // width: MediaQuery.of(context).size.width - 50,
    //               animation: true,
    //               lineHeight: 20.0,
    //               animationDuration: 2500,
    //               percent: 0.8,
    //               center: Text("80.0%"),
    //               barRadius: const Radius.circular(16),
    //               progressColor: Colors.blueAccent,
    //             ),
    //           ),
    //         ],
    //       )),
    //   Container(
    //       margin: EdgeInsets.symmetric(horizontal: 5.0),
    //       width: UtilsReponsive.width(context, 150),
    //       decoration: BoxDecoration(
    //           border: Border.all(color: Colors.black),
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(20)),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Expanded(
    //             flex: 3,
    //             child: SizedBox(
    //                 height: UtilsReponsive.height(context, 70),
    //                 width: UtilsReponsive.width(context, 70),
    //                 child: Lottie.asset('assets/icons/icon_walk.json')),
    //           ),
    //           Expanded(
    //             child: Text("Steps",
    //                 style: TextStyle(
    //                     fontSize: 20,
    //                     fontWeight: FontWeight.w500,
    //                     color: Colors.black)),
    //           ),
    //           Expanded(
    //             child: Text("500 Steps",
    //                 style: TextStyle(
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.w500,
    //                     color: Colors.grey.shade500)),
    //           )
    //         ],
    //       )),
    //   Container(
    //       margin: EdgeInsets.symmetric(horizontal: 5.0),
    //       width: UtilsReponsive.width(context, 150),
    //       decoration: BoxDecoration(
    //           border: Border.all(color: Colors.black),
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(20)),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Expanded(
    //             flex: 3,
    //             child: SizedBox(
    //                 height: UtilsReponsive.height(context, 70),
    //                 width: UtilsReponsive.width(context, 70),
    //                 child: Lottie.asset('assets/icons/icon_calo_profile.json')),
    //           ),
    //           Expanded(
    //             child: Text("Calories",
    //                 style: TextStyle(
    //                     fontSize: 20,
    //                     fontWeight: FontWeight.w500,
    //                     color: Colors.black)),
    //           ),
    //           Expanded(
    //             child: Text("500 Kcal",
    //                 style: TextStyle(
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.w500,
    //                     color: Colors.grey.shade500)),
    //           )
    //         ],
    //       ))
    // ];

    return Scaffold(
      backgroundColor: ColorConstant.common_bg_dark,
      body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: UtilsReponsive.height(context, 20),
                  ),
                  Row(
                    children: [
                      GetBuilder<LoginController>(builder: (controller) {
                        return Container(
                          clipBehavior: Clip.hardEdge,
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: controller.loginModel.value.avatar,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        );
                      }),
                      // SizedBox(
                      //   height: UtilsReponsive.height(context, 100),
                      //   width: UtilsReponsive.width(context, 100),
                      //   child: ClipOval(
                      //     child: GetBuilder<LoginController>(
                      //         builder: (controller) {
                      //           DevUtils.printLog("ABC","AB2C","${controller.loginModel.value.avatar.toString()}");
                      //       return CachedNetworkImage(

                      //         fit: BoxFit.cover,
                      //         imageUrl: controller.loginModel.value.avatar != ""
                      //             ? controller.loginModel.value.avatar
                      //             : "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000",
                      //         progressIndicatorBuilder:
                      //             (context, url, downloadProgress) =>
                      //                 CircularProgressIndicator(
                      //                     value: downloadProgress.progress),
                      //         errorWidget: (context, url, error) =>
                      //             Icon(Icons.error),
                      //       );
                      //     }),
                      //   ),
                      // ),
                      // // CircleAvatar(
                      //   radius: 40,
                      //   backgroundImage: NetworkImage(
                      //   ,
                      //   ),
                      // ),
                      SizedBox(
                        width: UtilsReponsive.width(context, 20),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GetBuilder<LoginController>(
                            builder: (controller) => Text(
                              controller.loginModel.value.name,
                              style: TextStyleConstant.white22RobotoBold,
                            ),
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(context, 10),
                          ),
                          Row(
                            children: [
                              Text(
                                LocaleKeys.tab_mine_view_text_ID.tr +
                                    Get.find<LoginController>()
                                        .loginModel
                                        .value
                                        .iraceId
                                        .toString(),
                                style: TextStyleConstant.white16Roboto,
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(context, 15),
                              ),
                              // ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //         backgroundColor: Colors.redAccent),
                              //     onPressed: () {
                              //       Get.find<LoginController>().logout();
                              //     },
                              //     child: Text(LocaleKeys
                              //         .tab_mine_view_buttons_buttons.tr))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(context, 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                              Get.find<LoginController>()
                                  .loginModel
                                  .value.totalActivities
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          SizedBox(
                            height: UtilsReponsive.height(context, 10),
                          ),
                          Text(
                            LocaleKeys.tab_mine_view_text_activities.tr,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500),
                          )
                        ],
                      ),
                      // Container(
                      //   color: Colors.white,
                      //   width: UtilsReponsive.width(context, 3),
                      //   height: UtilsReponsive.height(context, 50),
                      // ),
                      // Column(
                      //   children: [
                      //     Text(
                      //         Get.find<TabHomeController>()
                      //             .list
                      //             .length
                      //             .toString(),
                      //         style: const TextStyle(
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.w500,
                      //             color: Colors.white)),
                      //     SizedBox(
                      //       height: UtilsReponsive.height(context, 10),
                      //     ),
                      //     Text(
                      //       LocaleKeys.tab_mine_view_text_activities.tr,
                      //       style: TextStyle(
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //           color: Colors.grey.shade500),
                      //     )
                      //   ],
                      // ),
                      Container(
                        color: Colors.white,
                        width: UtilsReponsive.width(context, 3),
                        height: UtilsReponsive.height(context, 50),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent),
                              onPressed: () {
                                Get.find<LoginController>().logout();
                              },
                              child: Text(
                                  LocaleKeys.tab_mine_view_buttons_buttons.tr))

                          // ElevatedButton(
                          //   onPressed: () {
                          //     controller.onClickButtonEditProfile();
                          //   },
                          //   child: Text(
                          //     LocaleKeys.tab_mine_view_text_profile.tr,
                          //     style: TextStyleConstant.whiteRegular16,
                          //   ),
                          // )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(context, 20),
                  ),
                  ListTile(
                    title: Text(
                     LocaleKeys.tab_mine_view_text_setting_account.tr,
                      style: TextStyleConstant.white18Roboto,
                    ),
                    onTap: () {
                      controller.onClickButtonEditProfile();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: UtilsReponsive.width(context, 50)),
                    child: Divider(
                      height: UtilsReponsive.height(context, 2),
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    title: Text(
                       LocaleKeys.tab_mine_view_text_setting_health.tr,
                      style: TextStyleConstant.white18Roboto,
                    ),
                    onTap: () {
                      controller.onClickButtonEditHealth();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: UtilsReponsive.width(context, 50)),
                    child: Divider(
                      height: UtilsReponsive.height(context, 2),
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    title: Text(
                     LocaleKeys.common_language.tr,
                      style: TextStyleConstant.white18Roboto,
                    ),
                    onTap: () {
                      controller.onClickButtonSettingLanguage();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: UtilsReponsive.width(context, 50)),
                    child: Divider(
                      height: UtilsReponsive.height(context, 2),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
