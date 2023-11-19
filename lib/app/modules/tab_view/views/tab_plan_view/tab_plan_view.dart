import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_view.dart';

import '../../controllers/tab_plan_controller/tab_plan_controller.dart';

class TabPlanScreen extends BaseView<TabPlanController> {
  @override
  Widget buildView(BuildContext context) {
    return Center(
      child: Obx(()=>Text(controller.text.value)),
    );
  }
}
