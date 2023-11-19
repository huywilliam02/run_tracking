import 'package:get/get.dart';
import 'package:tracker_run/app/modules/login/model/login_model.dart';

import '../../../base/base_bindings.dart';
import '../controllers/tab_analysis_controller/tab_analysis_controller.dart';
import '../controllers/tab_controller.dart';
import '../controllers/tab_home_controller/tab_home_controller.dart';
import '../controllers/tab_mine_controller/tab_mine_controller.dart';
import '../controllers/tab_plan_controller/tab_plan_controller.dart';

class MainTabBinding extends BaseBindings {
  @override
  void injectService() {

    Get.lazyPut<MainTabController>(
      () => MainTabController(),
    );
// Get.put(MainTabController(modelLogin: argument),permanent: true);
    Get.lazyPut<TabAnalysisController>(
      () => TabAnalysisController(),
    );
    Get.lazyPut<TabHomeController>(
      () => TabHomeController(),
    );
    Get.lazyPut<TabMineController>(
      () => TabMineController(),
    );
    Get.lazyPut<TabPlanController>(
      () => TabPlanController(),
    );
  }
}
