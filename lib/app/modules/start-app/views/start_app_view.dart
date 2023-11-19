import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';

import '../../../common/commonTopBar/commonTopBar.dart';
import '../../../routes/app_pages.dart';
import '../../login/views/splash.dart';
import '../controllers/start_app_controller.dart';

class StartAppView extends BaseView<StartAppController> {
  @override
  Widget buildView(BuildContext context) {
print(
  Get.deviceLocale.toString()
);
    return  SplashStart();
  }
}
