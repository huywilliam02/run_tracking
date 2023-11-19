import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/database/database_local.dart';
import 'package:tracker_run/app/modules/login/controllers/login_controller.dart';
import 'package:tracker_run/app/modules/login/model/login_model.dart';
import 'package:tracker_run/app/modules/setting_basic/api/basic_setting.dart';
import 'package:tracker_run/app/resources/data_constant.dart';
import 'package:tracker_run/app/resources/dev_utils.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/app/routes/app_pages.dart';

import '../../../../generated/locales.g.dart';

class SettingBasicInfoController extends BaseController {
  Rx<bool> isLoading = true.obs;

  PageController pageController = PageController();
  Rx<int> indexPage = 0.obs;
  Rx<bool> gender = false.obs;
  Rx<double> weight = 30.0.obs;
  Rx<double> tall = 1.3.obs;
  Rx<bool> isFinish = false.obs;
  Rx<int> meter = 1.obs;
  Rx<int> cm = 30.obs;
  @override
  void onInit() async {
    super.onInit();
    await getBasicInfo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  wellcomeBottomSheet() async {
    await Future.delayed(Duration(milliseconds: 100), () {
      Get.bottomSheet(Container(
          color: Colors.transparent,
          height: UtilsReponsive.height(Get.context!, 420),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                height: UtilsReponsive.height(Get.context!, 350),
                decoration: BoxDecoration(
                    color: ColorConstant.primary,
                    border: Border.all(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20)),
              ),
              Positioned(
                top: 0,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: UtilsReponsive.height(Get.context!, 120),
                  width: UtilsReponsive.height(Get.context!, 120),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/images/label.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: SizedBox.shrink()),
                    Expanded(
                      child: Text(
                        LocaleKeys
                            .basic_setting_page_text_bottom_sheet_title.tr,
                        style: TextStyleConstant.whiteBold25,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        LocaleKeys
                            .basic_setting_page_text_bottom_sheet_content.tr,
                        style: TextStyleConstant.whiteBold16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        LocaleKeys
                            .basic_setting_page_text_bottom_sheet_description
                            .tr,
                        style: TextStyleConstant.whiteBold16,
                      ),
                    ),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            width: double.maxFinite,
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  LocaleKeys.basic_setting_page_buttons_ok.tr,
                                  style: TextStyleConstant.whiteBold22,
                                ))))
                  ],
                ),
              ))
            ],
          )));
    });
  }

  getBasicInfo() async {
    LoginModel loginModel = Get.find<LoginController>().loginModel.value;
    print(loginModel.weight);
    if (loginModel.weight == 0) {
      print("hhe");
      isLoading(false);
      await wellcomeBottomSheet();
      // print("false  ${basicInfo.tall}");
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed(Routes.HOME);
      });
    }
  }

  nextPage() {
    if (indexPage.value < 3) {
      pageController.animateToPage(++indexPage.value,
          curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 200));
    }
  }

  backPage() {
    if (indexPage.value > 0) {
      pageController.animateToPage(--indexPage.value,
          curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 200));
    }
  }

  changeGender(bool value) {
    gender(value);
  }

  changeTall() {
    tall.value = (meter.value + cm.value * 0.01).toPrecision(2);
    print(tall);
  }

  changeMeter(int value) {
    meter.value = value;
    changeTall();
  }

  changeCm(int value) {
    cm.value = value;
    changeTall();
  }

  changeWeight(double value) {
    weight(value);
  }

  onFinish() async {
    isFinish(true);
    DevUtils.printLog(
        "basic",
        "onfinish",
        tall.value.toPrecision(2).toString() +
            "/" +
            weight.value.toPrecision(1).toString());
    Get.find<LoginController>().loginModel.value.height =
        tall.value.toPrecision(2);
    Get.find<LoginController>().loginModel.value.weight =
        weight.value.toPrecision(1);
    Get.find<LoginController>().loginModel.value.gender =
        gender.isTrue ? "Male" : "Female";
    // await Hive.openBox("loginModel");
    // Get.find<LoginController>().loginModel.value.save();
    await DatabaseLocal.instance
        .updateLoginModel(Get.find<LoginController>().loginModel.value);
    await BasicSettingApi().updateInfoBasic(tall.value.toPrecision(2),
        weight.value.toPrecision(1), gender.isTrue ? "Male" : "Female");
    Future.delayed(Duration(seconds: 3), () {
      Get.offAllNamed(Routes.HOME);
    });
  }
}
