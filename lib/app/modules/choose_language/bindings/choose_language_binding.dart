import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_bindings.dart';

import '../controllers/choose_language_controller.dart';

class ChooseLanguageBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<ChooseLanguageController>(
      () => ChooseLanguageController(),
    );
  }
}
