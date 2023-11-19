import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_bindings.dart';

import '../controllers/setting_basic_controller.dart';

class SettingBasicInfoBinding extends BaseBindings {
  @override
  void injectService() {
      Get.lazyPut<SettingBasicInfoController>(
      () => SettingBasicInfoController(),
    );
  }
}
