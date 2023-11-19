import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/modules/login/views/splash.dart';
import 'package:tracker_run/app/modules/setting_basic/views/widgets/splash_process_data.dart';
import 'package:tracker_run/app/modules/setting_basic/views/widgets/tall_setting.dart';
import 'package:tracker_run/app/modules/setting_basic/views/widgets/weight_setting.dart';
import 'package:tracker_run/app/modules/setting_basic/views/widgets/gender_setting.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/app/routes/app_pages.dart';

import '../../../../generated/locales.g.dart';
import '../controllers/setting_basic_controller.dart';

class SettingBasicInfoView extends BaseView<SettingBasicInfoController> {
  @override
  Widget buildView(BuildContext context) {
    return Obx(
      () => controller.isLoading.isTrue
          ? SplashStart()
          : controller.isFinish.isTrue
              ? SplashProcessData()
              : Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: ColorConstant.common_bg_dark,
                  body: SafeArea(
                    bottom: true,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Opacity(
                                        opacity: controller.indexPage.value != 0
                                            ? 1
                                            : 0,
                                        child: IconButton(
                                            onPressed: () {
                                              controller.backPage();
                                            },
                                            icon: Icon(
                                              Icons.arrow_back_ios_new_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            )),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: LinearPercentIndicator(
                                      lineHeight: 20.0,
                                      percent:
                                          (controller.indexPage.value + 1) / 3,
                                      barRadius: const Radius.circular(16),
                                      progressColor: Colors.blueAccent,
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        "${controller.indexPage.value + 1}/3",
                                        style: TextStyleConstant.whiteBold25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              flex: 12,
                              child: PageView(
                                controller: controller.pageController,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GenderSetting(),
                                  WeightSetting(),
                                  TallSetting(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.maxFinite,
                            height: 40,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 40),
                            child: ElevatedButton(
                              onPressed: ()async {
                                if (controller.indexPage.value < 2) {
                                  controller.nextPage();
                                } else {
                                  controller.onFinish();
                                }
                              },
                              child: Text(controller.indexPage.value < 2
                                  ? LocaleKeys
                                      .basic_setting_page_buttons_next.tr
                                  : LocaleKeys
                                      .basic_setting_page_buttons_finish.tr),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        )
                      ],
                    ),
                  )),
    );
  }
}
