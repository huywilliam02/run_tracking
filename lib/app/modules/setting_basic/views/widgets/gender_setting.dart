import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/modules/setting_basic/controllers/setting_basic_controller.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../../resources/app_constants.dart';

class GenderSetting extends BaseView<SettingBasicInfoController> {
  @override
  Widget buildView(BuildContext context) {
    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: ColorConstant.common_bg_dark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.basic_setting_page_text_question_gender.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                     LocaleKeys.basic_setting_page_text_question_gender_desciption.tr,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                )),
            Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.changeGender(false);
                      },
                      child: Container(
                        height: UtilsReponsive.height(context, 80),
                        margin:
                            EdgeInsets.only(left: 30, right: 30, bottom: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: ColorConstant.primary),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Lottie.asset(
                                    "assets/icons/icon_female.json")),
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: Text(
                                LocaleKeys.basic_setting_page_text_gender_female.tr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child:Obx(()=> Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: controller.gender.value == false
                                        ? Colors.white
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                ),)
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.changeGender(true);
                      },
                      child: Container(
                        height: UtilsReponsive.height(context, 80),
                        margin: EdgeInsets.only(left: 30, right: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: ColorConstant.primary),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Lottie.asset(
                                    "assets/icons/icon_male.json")),
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: Text(
                                    LocaleKeys.basic_setting_page_text_gender_male.tr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child:Obx(()=> Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: controller.gender.value == true
                                        ? Colors.white
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                ),)
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(flex: 1, child: SizedBox.shrink())
          ],
        ));
  }
}
