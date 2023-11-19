import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_bindings.dart';

import '../controllers/start_app_controller.dart';

class StartAppBinding extends BaseBindings {
  @override
  void injectService() {
    Get.put<StartAppController>(
       StartAppController(),
    );
  }
}
