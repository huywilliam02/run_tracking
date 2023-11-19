import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_bindings.dart';

import '../controllers/tracking_map_v2_controller.dart';


class TrackingMapV2Binding extends BaseBindings {
  @override
  void injectService() {
     Get.lazyPut<TrackingMapV2Controller>(
      () => TrackingMapV2Controller(),
    );
  }
}
