import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/modules/tracking_step/controllers/tracking_step_controller.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../resources/reponsive_utils.dart';

class TrackingStepSetting extends BaseView<TrackingStepController> {
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              color: ColorConstant.common_bg_dark,
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
                size: UtilsReponsive.height(context, 30),
              )),
          actions: [
            TextButton(
                onPressed: () {
                  controller.onClickSaveSetting();
                },
                child: Text(LocaleKeys.tab_edit_health_text_save.tr,
                    style: TextStyleConstant.white16Roboto)),
          ],
          backgroundColor: ColorConstant.primary,
          title: Text(
            LocaleKeys.common_step_setting_title.tr,
            style: TextStyleConstant.white22RobotoBold,
          )),
      backgroundColor: ColorConstant.common_bg_dark,
      body: SafeArea(
          child: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
            title: Text(
              LocaleKeys.common_target_step.tr,
              style: TextStyleConstant.white22RobotoBold,
            ),
            trailing: SizedBox(
                width: UtilsReponsive.width(context, 100),
                child: TextFormField(
                  controller: controller.numStepTargetController,
                  toolbarOptions: ToolbarOptions(),
                  keyboardType: TextInputType.number,
                  style: TextStyleConstant.white16Roboto,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hoverColor: Colors.white,
                    focusColor: Colors.white,
                    fillColor: Colors.white,
                  ),
                )),
          ),
          SizedBox(
            height: UtilsReponsive.height(context, 20),
          ),
          InkWell(
            onTap:(){
               controller.onClickRestartAll();
            },
            child: ListTile(
              title: Text(
                LocaleKeys.step_view_text_reset_data_text.tr,
                style: TextStyleConstant.red22RobotoBold,
              ),
            ),
          )
        ]),
      )),
    );
  }
}
