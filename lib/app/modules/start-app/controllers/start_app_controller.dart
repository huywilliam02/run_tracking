import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/modules/login/controllers/login_controller.dart';
import 'package:tracker_run/app/routes/app_pages.dart';

class StartAppController extends BaseController {
  @override
  void onInit() async {
    super.onInit();
    await getModelLoginLocal();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getModelLoginLocal() async {
    try {
      await Future.delayed(Duration(seconds: 2), () async {
        if (Get.isRegistered<LoginController>()) {
          Get.find<LoginController>().onInit();
        } else {
          Get.offNamed(Routes.LOGIN);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
