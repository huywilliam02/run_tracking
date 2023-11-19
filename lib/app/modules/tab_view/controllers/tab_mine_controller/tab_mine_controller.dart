import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/modules/login/controllers/login_controller.dart';
import 'package:tracker_run/app/resources/dev_utils.dart';
import 'package:tracker_run/app/routes/app_pages.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../../base/base_controller.dart';

class TabMineController extends BaseController
    with GetSingleTickerProviderStateMixin {
  // LoginModel model = Get.find<MainTabController>().modelLogin;
  late TabController tabController;
  List<String> listFilter = ["Today", "Weekly", "Month"];
  CarouselController carouselController = CarouselController();
  Rx<int> indexFilterStatis = 1.obs;
  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 3);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  jumpTo() {
    if (indexFilterStatis.value + 1 < listFilter.length) {
      carouselController.jumpToPage(++indexFilterStatis.value);
    }
  }

  jumpBack() {
    if (indexFilterStatis.value - 1 > -1) {
      carouselController.jumpToPage(--indexFilterStatis.value);
    }
  }

  onClickButtonEditProfile() {
    if (Get.find<LoginController>().hasInternet.isTrue) {
      Get.toNamed(Routes.EDIT_PROFILE);
    } else {
      DevUtils.showSnackbarMessage(
          "Notification", "Error! Please check Internet", Colors.redAccent);
    }
  }

  onClickButtonEditHealth() {
    if (Get.find<LoginController>().hasInternet.isTrue) {
      Get.toNamed(Routes.EDIT_HEALTH);
    } else {
      Fluttertoast.showToast(msg: LocaleKeys.common_err_internet.tr,textColor: Colors.redAccent,backgroundColor: Colors.white);
    }
  }

  onClickButtonSettingLanguage() {
    Get.toNamed(Routes.SETTING_LANGUAGE);
  }
}
