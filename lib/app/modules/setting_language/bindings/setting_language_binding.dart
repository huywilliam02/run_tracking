import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_bindings.dart';

import '../controllers/setting_language_controller.dart';

class SettingLanguageBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<SettingLanguageController>(
      () => SettingLanguageController(),
    );
  }
}
