import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_controller.dart';

class CountDownTimerController extends BaseController {

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
