import 'package:get/get.dart';

import '../controllers/tracking_drink_water_controller.dart';

class TrackingDrinkWaterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackingDrinkWaterController>(
      () => TrackingDrinkWaterController(),
    );
  }
}
