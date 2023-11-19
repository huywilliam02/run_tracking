import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tracker_run/app/database/database_local.dart';
import 'package:tracker_run/app/modules/tracking_step/model/step_tracking_day.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../base/base_controller.dart';
import '../../login/controllers/login_controller.dart';

class TrackingStepController extends BaseController {
  late StreamSubscription<StepCount> _stepCountStream;
  Rx<bool> isPaused = true.obs;
  Rx<double> percent = 0.0.obs;
  Rx<bool> isLoading = true.obs;
  Rx<StepTrackingDay> stepDaily = StepTrackingDay().obs;
  RxList<StepTrackingDay> list7Day = <StepTrackingDay>[].obs;
  Rx<int> count7day = 0.obs;
  TextEditingController numStepTargetController = TextEditingController();
  @override
  void onInit() async {
    super.onInit();

    try {
      stepDaily.value = await DatabaseLocal.instance.getCurrentTrackingStep(
          "${Get.find<LoginController>().loginModel.value.id}");
      count7day.value = await DatabaseLocal.instance
          .getTotal7day("${Get.find<LoginController>().loginModel.value.id}");
      numStepTargetController.text = stepDaily.value.target.toString();
      if (stepDaily.value.steps >= stepDaily.value.target) {
        percent.value = 1;
      } else {
        percent.value = stepDaily.value.steps / stepDaily.value.target;
      }

      _stepCountStream = Pedometer.stepCountStream.listen((value) async {
        stepDaily.value.steps++;
        if (stepDaily.value.steps >= stepDaily.value.target) {
          percent.value = 1;
        } else {
          percent.value = stepDaily.value.steps / stepDaily.value.target;
        }
        stepDaily.value.save();
      }, onError: (error) {
        Get.snackbar("Step", "Error");
      }, cancelOnError: false);
      _stepCountStream.resume();
    } catch (e) {
      Get.snackbar("Step", e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }

  onClickSaveSetting() {
    try {
      int stepTarget = int.parse(numStepTargetController.text);
      if (stepTarget < 100) {
        throw Exception();
      } else {
        stepDaily.value.target = stepTarget;
        stepDaily.value.save();
      }
    } catch (e) {
      Get.snackbar(LocaleKeys.common_notification_title.tr,
          LocaleKeys.common_step_setting_target.tr,
          backgroundColor: Colors.white);
    }
  }

  onClickRestart() {
    QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.confirm,
        title: LocaleKeys.step_view_text_reset.tr,
        text: LocaleKeys.step_view_text_confirm_reset.tr,
        cancelBtnText: LocaleKeys.step_view_text_cancel.tr,
        confirmBtnText: LocaleKeys.step_view_text_sure.tr,
        onConfirmBtnTap: () async {
          stepDaily.value.steps = 0;
          stepDaily.value.save();
          percent.value = 0;
          await update7day();

          Get.back();
        });
  }

  onClickRestartAll() {
    QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.confirm,
        title: LocaleKeys.step_view_text_reset_all.tr,
        text: LocaleKeys.step_view_text_confirm_reset_all.tr,
        cancelBtnText: LocaleKeys.step_view_text_cancel.tr,
        confirmBtnText: LocaleKeys.step_view_text_sure.tr,
        onConfirmBtnTap: () async {
          stepDaily.value = await DatabaseLocal.instance.clearAllStepRecord(
              Get.find<LoginController>().loginModel.value.id.toString());
          stepDaily.value.save();
          percent.value = 0;
          await update7day();
          Get.back();
          Get.back();

          // stepDaily.value.steps = 0;
          // stepDaily.value.save();
          // percent.value = 0;
        });
  }

  onClickPause() {
    isPaused.value = !isPaused.value;
  }

  update7day() async {
    count7day.value = await DatabaseLocal.instance
        .getTotal7day("${Get.find<LoginController>().loginModel.value.id}");
  }
}
