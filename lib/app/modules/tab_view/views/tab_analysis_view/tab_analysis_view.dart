import 'package:flutter/material.dart';
import 'package:tracker_run/app/base/base_view.dart';

import '../../controllers/tab_analysis_controller/tab_analysis_controller.dart';

class TabAnalysisView extends BaseView<TabAnalysisController> {
 @override
  Widget buildView(BuildContext context) {
   return Center(child: Text("TabAnalysisView"),);
  }
}
