import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_bindings.dart';

import '../controllers/sign_up_controller.dart';

class SignUpBinding extends BaseBindings {
  
  @override
  void injectService() {
     Get.lazyPut<SignUpController>(
      () => SignUpController(),
    );
  }
}
