import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_bindings.dart';

import '../controllers/edit_health_controller.dart';

class EditHealthBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<EditHealthController>(
      () => EditHealthController(),
    );
  }
}
