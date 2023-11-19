import 'package:get/get.dart';

import '../../../base/base_bindings.dart';
import '../controllers/tracking_step_controller.dart';

class TrackingStepBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<TrackingStepController>(
      () => TrackingStepController(),
    );
  }
}
