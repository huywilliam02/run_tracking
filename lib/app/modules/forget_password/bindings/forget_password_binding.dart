import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_bindings.dart';

import '../controllers/forget_password_controller.dart';

class ForgetPasswordBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(),
    );
  }
}
