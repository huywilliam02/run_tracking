import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../base/base_view.dart';
import '../../../resources/app_constants.dart';
import '../controllers/tab_controller.dart';

class MainTabView extends BaseView<MainTabController> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget buildView(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorConstant.common_bg_dark,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Center(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(
                  math.pi / 4,
                ),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration:const BoxDecoration(
                    // borderRadius: BorderRadius.only(bottomRight: Radius.circular(2)),
                    color: ColorConstant.common_bg_dark,
                    border: Border(
                      right: BorderSide(
                          width: 3, color: ColorConstant.common_bg_dark),
                      bottom: BorderSide(
                          width: 3, color: ColorConstant.common_bg_dark),
                    ),
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: ColorConstant.blueGradient,
                      ),
                      border: Border.all(
                        width: 3,
                        color: ColorConstant.primary,
                      ),
                    ),
                    child: InkWell(
                      splashColor: Colors.blueAccent,
                      onTap: () {
                        controller.onSelectedTrackingView(context);
                      },
                      child: Center(
                        child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationZ(
                              -math.pi / 4,
                            ),
                            child:const Icon(Icons.directions_run,
                                color: ColorConstant.secondary1)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Obx(
            () => controller.body.elementAt(
              controller.selectedIndex.value,
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomAppBar(
              color: ColorConstant.primary,
              shape: CircularNotchedRectangle(),
              notchMargin: 0,
              child: Container(
                height: UtilsReponsive.height(context, 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween  ,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                controller.onItemTapped1(0);
                              },
                              minWidth: UtilsReponsive.width(context, 40),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.home_outlined,
                                      color: controller.selectedIndex.value == 0
                                          ? ColorConstant.secondary1
                                          : ColorConstant.secondary,
                                    ),
                                    Text(LocaleKeys.tab_view_text_home_title_bar.tr,
                                        style: TextStyle(
                                            color: controller.selectedIndex.value == 0
                                                ? ColorConstant.secondary1
                                                : ColorConstant.secondary))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // MaterialButton(
                          //   onPressed: () {
                          //     controller.onItemTapped1(1);
                          //   },
                          //   minWidth: UtilsReponsive.width(context, 40),
                          //   child:FittedBox(
                          //     fit: BoxFit.scaleDown,
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Icon(Icons.sports,
                          //             color: controller.selectedIndex.value == 1
                          //                 ? ColorConstant.secondary1
                          //                 : ColorConstant.secondary),
                          //         Text(LocaleKeys.tab_view_text_plan_title_bar.tr,
                          //             style: TextStyle(
                          //                 color: controller.selectedIndex.value == 1
                          //                     ? ColorConstant.secondary1
                          //                     : ColorConstant.secondary))
                          //       ],
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // MaterialButton(
                          //   onPressed: () {
                          //     controller.onItemTapped1(2);
                          //   },
                          //   minWidth: UtilsReponsive.width(context, 40),
                          //   child: FittedBox(
                          //     fit: BoxFit.scaleDown,
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Icon(Icons.bar_chart,
                          //             color: controller.selectedIndex.value == 2
                          //                 ? ColorConstant.secondary1
                          //                 : ColorConstant.secondary),
                          //         Text(LocaleKeys.tab_view_text_analysis_title_bar.tr,
                          //             style: TextStyle(
                          //                 color: controller.selectedIndex.value == 2
                          //                     ? ColorConstant.secondary1
                          //                     : ColorConstant.secondary))
                          //       ],
                          //     ),
                          //   ),
                          // ),
                    
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                controller.onItemTapped1(3);
                              },
                              minWidth: UtilsReponsive.width(context, 40),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person,
                                        color: controller.selectedIndex.value == 3
                                            ? ColorConstant.secondary1
                                            : ColorConstant.secondary),
                                    Text(
                                      LocaleKeys.tab_view_text_profile_title_bar.tr,
                                      style: TextStyle(
                                          color: controller.selectedIndex.value == 3
                                              ? ColorConstant.secondary1
                                              : ColorConstant.secondary),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )

          // SafeArea(
          //   child: Builder(
          //     builder: (context) =>
          //     PandaBar(
          //       backgroundColor: ColorConstant.primary,
          //       fabIcon: const Icon(
          //         Icons.directions_run,
          //         color: ColorConstant.secondary1,
          //       ),
          //       fabColors: ColorConstant.blueGradient,
          //       buttonColor: ColorConstant.secondary,
          //       buttonSelectedColor: ColorConstant.secondary1,
          //       buttonData: controller.list,
          //       onChange: (id) {
          //         // if (id == "mine") {
          //         //   Scaffold.of(context).openEndDrawer();
          //         //   // controller.scaffoldKey.value=scaffoldKey;
          //         //   // controller.openDrawer();
          //         // } else {
          //           controller.onItemTapped(id);
          //         // }
          //       },
          //       onFabButtonPressed: () {
          //         controller.onSelectedTrackingView(context);
          //       },
          //     ),
          //   ),
          // ),
          ),
    );
  }
}
