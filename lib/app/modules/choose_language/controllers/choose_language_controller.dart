import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/database/database_local.dart';
import 'package:tracker_run/app/modules/login/views/login_choose_page.dart';

class ChooseLanguageController extends BaseController {
  @override
  void onInit() {
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

  updateLanguage(int index) async {
    switch (index) {
      case 1:
        Get.updateLocale(Locale("vi"));
        await DatabaseLocal.instance.updateLocale('vi');
        Get.to(() => LoginChoosePage());
        break;
      case 2:
        Get.updateLocale(Locale("en"));
        await DatabaseLocal.instance.updateLocale('en');
        Get.to(() => const LoginChoosePage());
        break;
      default:
    }
  }
}
