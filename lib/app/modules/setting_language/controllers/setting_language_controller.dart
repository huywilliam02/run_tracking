import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_controller.dart';

import '../../../database/database_local.dart';

class SettingLanguageController extends BaseController {
  Rx<String> language = "en".obs;
  Rx<bool> isLoading = true.obs;
  @override
  void onInit() async {
    super.onInit();
    Locale languageLocale = await DatabaseLocal.instance.getLocale();
    language.value = languageLocale.toLanguageTag();
    isLoading(false);
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
        language.value = "vi";
        break;
      case 2:
        Get.updateLocale(Locale("en"));
        await DatabaseLocal.instance.updateLocale('en');
        language.value = "en";

        break;
      default:
    }
  }
}
