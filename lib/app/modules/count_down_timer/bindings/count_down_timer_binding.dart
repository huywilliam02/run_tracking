import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_bindings.dart';

import '../controllers/count_down_timer_controller.dart';

class CountDownTimerBinding extends BaseBindings {

  @override
  void injectService() {
    Get.lazyPut<CountDownTimerController>(
          () => CountDownTimerController(),
    );  }
}
