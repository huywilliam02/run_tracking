import 'package:get/get.dart';

import '../../../../base/base_controller.dart';
import '../../../tracking_map_v2/model/streamdata.dart';

class TabPlanController extends BaseController {
  RxList<StreamData> listData = <StreamData>[].obs;
  Rx<String> text = "".obs;
  
 
  @override
  void onInit() async {
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

}
