import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as locat;
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tracker_run/app/modules/tab_view/controllers/tab_analysis_controller/tab_analysis_controller.dart';
import 'package:tracker_run/app/modules/tab_view/controllers/tab_home_controller/tab_home_controller.dart';
import 'package:tracker_run/app/modules/tab_view/controllers/tab_plan_controller/tab_plan_controller.dart';
import 'package:tracker_run/app/modules/tab_view/views/tab_analysis_view/tab_analysis_view.dart';
import 'package:tracker_run/app/modules/tab_view/views/tab_mine_view/tab_mine_view.dart';
import 'package:tracker_run/app/modules/tab_view/views/tab_plan_view/tab_plan_view.dart';
import 'package:tracker_run/app/routes/app_pages.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../base/base_controller.dart';
import '../views/tab_home_view/tab_home_view.dart';
import 'tab_mine_controller/tab_mine_controller.dart';

class MainTabController extends BaseController {
  // LoginModel modelLogin = Get.find<LoginController>().loginModel.value;
  var selectedIndex = 0.obs;
  RxString page = 'home'.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Get.updateLocale(Locale("vi"));
    Get.find<TabHomeController>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  RxList<Widget> body = RxList(
      [TabHomeView(), TabPlanScreen(), TabAnalysisView(), TabMineView()]);
  onItemTapped(String index) {
    page.value = index;
    switch (page.value) {
      case 'home':
        Get.find<TabHomeController>();
        return selectedIndex.value = 0;
      case 'plan':
        Get.find<TabPlanController>();
        return selectedIndex.value = 1;
      case 'chart':
        Get.find<TabAnalysisController>();
        return selectedIndex.value = 2;
      case 'mine':
        Get.find<TabMineController>();
        // Get.to(TabMineView());
        // return null;
        return selectedIndex.value = 3;
      default:
        return selectedIndex.value = 0;
    }
  }

  onItemTapped1(int index) {
    switch (index) {
      case 0:
        Get.find<TabHomeController>();
        return selectedIndex.value = 0;
      case 1:
        Get.find<TabPlanController>();
        return selectedIndex.value = 1;
      case 2:
        Get.find<TabAnalysisController>();
        return selectedIndex.value = 2;
      case 3:
        Get.find<TabMineController>();
        // Get.to(TabMineView());
        // return null;
        return selectedIndex.value = 3;
      default:
        return selectedIndex.value = 0;
    }
  }

  onSelectedTrackingView(BuildContext context) async {
    // await testRequestLocationPermission();

    locat.Location location = locat.Location();
    if (await Permission.location.isGranted &&
        await location.serviceEnabled()) {
      Get.toNamed(Routes.TRACKING_MAP_V2);
    } else {
      QuickAlert.show(
        context: Get.context!,
        title:LocaleKeys.common_location.tr,
        text: LocaleKeys.common_accept_location_irace.tr,
        type: QuickAlertType.warning,
        confirmBtnText: "OK",
        onConfirmBtnTap: () async {
          Get.back();
          await testRequestLocationPermission();
        },
        cancelBtnText: "Cancel",
        showCancelBtn: true,
        onCancelBtnTap: () {
          Get.back();
        },
      );
    }
  }

  Future<void> testRequestLocationPermission() async {
    PermissionStatus locationStatus = await Permission.location.request();
    print("locationStatus" + locationStatus.toString());
    if (locationStatus != PermissionStatus.granted) {
//Show thông báo

      if (locationStatus == PermissionStatus.denied) {
        await QuickAlert.show(
            title: LocaleKeys.common_location.tr,
            text: LocaleKeys.common_need_accept.tr,
            context: Get.context!,
            type: QuickAlertType.warning,
            confirmBtnText:LocaleKeys.common_need_accept.tr,
            onConfirmBtnTap: () async {
              Get.back();
              await Permission.location.request();
            },
            onCancelBtnTap: () {
              Get.back();
            },
            showCancelBtn: true);
      } else if (locationStatus == PermissionStatus.permanentlyDenied) {
        //Show thông báo Bị từ chối vĩnh viễn
        await QuickAlert.show(
            title: LocaleKeys.common_location_off_parmanent.tr,
            text:
                "${LocaleKeys.common_open_app_setting.tr}""\n""${LocaleKeys.common_permission_app.tr}""\n" "${LocaleKeys.common_location_permiss.tr}""\n""${LocaleKeys.common_location_always.tr}",
            context: Get.context!,
            type: QuickAlertType.warning,
            confirmBtnText: LocaleKeys.common_allow.tr,
            onConfirmBtnTap: () async {
              Get.back();
              await openAppSettings();
            },
            onCancelBtnTap: () {
              Get.back();
            },
            showCancelBtn: true);
      }
    }
  }
}
