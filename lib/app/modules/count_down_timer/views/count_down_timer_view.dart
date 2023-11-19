import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_view.dart';

import '../../../components/count_down_timer.dart';
import '../controllers/count_down_timer_controller.dart';

class CountDownTimerView extends BaseView<CountDownTimerController> {
  @override
  Widget buildView(BuildContext context) {
    return CountdownTimerScreen();
  }
}
