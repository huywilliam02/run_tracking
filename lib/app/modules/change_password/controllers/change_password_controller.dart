import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/modules/change_password/api/api_change_password.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../resources/app_constants.dart';

class ChangePasswordController extends BaseController {

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reNewPasswordController = TextEditingController();
  Rx<String> oldPassword = "".obs;
  Rx<String> newPassword = "".obs;
  Rx<String> reNewPassword = "".obs;
  Rx<String> errOldPassword = "".obs;
  Rx<String> errNewPassword = "".obs;

  Rx<String> errReNewPassword = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    reNewPasswordController.dispose();
  }

  setValueOldPassword(String value) {
    oldPassword.value = value;
    errOldPassword.value = validateOldPassword(value);
  }

  setValueNewPassword(String value) {
    newPassword.value = value;
    errNewPassword.value = validateNewPassword(value);
    if (errNewPassword.isEmpty) {
      errReNewPassword.value =
          validateRetypePassword(value, reNewPassword.value);
    }
  }

  setValueReNewPassword(String value) {
    reNewPassword.value = value;
    errReNewPassword.value = validateRetypePassword(value, newPassword.value);
  }

  String validateOldPassword(String value) {
    if (value.length < 6) {
      return LocaleKeys.change_password_text_validate_length_password.tr;
    }
    return "";
  }

  String validateNewPassword(String value) {
    if (value.length < 6) {
      return LocaleKeys.change_password_text_validate_length_password.tr;
    }
    return "";
  }

  String validateRetypePassword(String valueCompare, String value) {
    if (value != valueCompare) {
      return LocaleKeys.change_password_text_confirm_password.tr;
    }
    return "";
  }

  onClickChangePassword() async {
    try {
      if (errNewPassword.isEmpty &&
          errOldPassword.isEmpty &&
          errReNewPassword.isEmpty) {
        String check = await ChangePassWordApi().updatePassword(
            oldPassword.value, newPassword.value, reNewPassword.value);
        if (check == "Success") {
          Get.back();
        }
      }
    } catch (e) {
      Get.snackbar(LocaleKeys.common_notification_title.tr,
          "${e.toString().split("Exception: ")[1]}".tr,
          backgroundColor: ColorConstant.white);
    }
  }
}
