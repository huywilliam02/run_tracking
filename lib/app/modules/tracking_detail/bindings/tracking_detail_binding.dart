import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_bindings.dart';

import '../../tracking_map_v2/model/data_model_strava.dart';
import '../controllers/tracking_detail_controller.dart';

class TrackingDetailBinding extends BaseBindings {
  @override
  void injectService() {
    var argument = Get.arguments as DataModelStrava;
    Get.lazyPut<TrackingDetailController>(
      () => TrackingDetailController(model: argument),
    );
  }
}
