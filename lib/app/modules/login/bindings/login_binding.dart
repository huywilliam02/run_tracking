import 'package:get/get.dart';
import 'package:tracker_run/app/modules/login/model/login_model.dart';

import '../../../base/base_bindings.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends BaseBindings {
  @override
  void injectService() {
    Get.put(LoginController(),permanent: true);
  }
}
