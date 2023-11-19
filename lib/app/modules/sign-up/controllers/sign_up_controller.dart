import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/modules/login/controllers/login_controller.dart';
import 'package:tracker_run/app/modules/login/model/login_model.dart';
import 'package:tracker_run/app/modules/login/views/login_choose_page.dart';
import 'package:tracker_run/app/modules/sign-up/api/sign_up.dart';
import 'package:tracker_run/app/modules/sign-up/model/sign_up.dart';
import 'package:tracker_run/app/modules/sign-up/views/sign_up_view.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/app/routes/app_pages.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../database/database_local.dart';

class SignUpController extends BaseController {
  Rx<String> nameInput = "".obs;
  Rx<String> passwordInput = "".obs;
  Rx<String> rePasswordInput = "".obs;
  Rx<String> email = "".obs;
  Rx<bool> isLoading = false.obs;
  Rx<String> errNameInput = "".obs;
  Rx<String> errPasswordInput = "".obs;
  Rx<String> errEmail = "".obs;
  Rx<bool> enableButton = false.obs;
  Rx<bool> checkpassword = true.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  setNameInput(String? value) {
    if (value != null) {
      checkName(value);
      nameInput.value = value;
    }
  }

  setPasswordInput(String? value) {
    if (value != null) {
      passwordInput.value = value;
      checkPassword();
    }
  }

  setRePasswordInput(String? value) {
    if (value != null) {
      rePasswordInput.value = value;
      checkPassword();
    }
  }

  setEmailInput(String? value) {
    if (value != null) {
      email.value = value;
      checkEmail(value);
    }
  }

  checkEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      errEmail.value = "Provide valid Email";
    } else {
      errEmail.value = "";
    }
    checkEnableButton();
  }

  checkPassword() {
    if (passwordInput.value.length < 8) {
      errPasswordInput.value = "Password must be more than 8 character";
    } else if (passwordInput != rePasswordInput) {
      errPasswordInput.value = "Repassword not the same";
    } else {
      errPasswordInput.value = "";
    }
    checkEnableButton();
  }

  checkName(String value) {
    if (value == "") {
      errNameInput.value = "Name must not empty";
    } else {
      errNameInput.value = "";
    }
    checkEnableButton();
  }

  bool checkEmpty() {
    if (nameInput.isNotEmpty &&
        passwordInput.isNotEmpty &&
        rePasswordInput.isNotEmpty &&
        email.isNotEmpty) {
      return true;
    }
    return false;
  }

  checkEnableButton() {
    if (errNameInput.isEmpty &&
        errEmail.isEmpty &&
        errPasswordInput.isEmpty &&
        checkEmpty()) {
      enableButton(true);
    } else {
      enableButton(false);
    }
  }

  signUp() async {
    isLoading(true);
    if (errEmail.isEmpty && errPasswordInput.isEmpty && errNameInput.isEmpty) {
      SignUpModel signUpModel = SignUpModel(
          name: nameInput.value,
          email: email.value,
          password: passwordInput.value);
      try {
        LoginModel? loginModel = await SignUpApi.register(signUpModel);
        if (loginModel != null) {
          Get.find<LoginController>().loginModel.value = loginModel;
          Get.find<LoginController>().jwtToken =
              await DatabaseLocal.instance.getJwtToken();
          await DatabaseLocal.instance.reNewLoginModel(loginModel);
          Get.offAllNamed(Routes.SETTING_BASIC_INFO);
          Get.snackbar("Notification", LocaleKeys.common_sign_up_success.tr,
              backgroundColor: Colors.white);
        }
      } catch (e) {
        enableButton(false);
        isLoading(false);
        Get.offNamed(Routes.SIGN_UP);
        Get.snackbar(
           LocaleKeys.common_notification_title.tr, "${e.toString().split("Exception: ")[1]}".tr,
            backgroundColor: ColorConstant.white);
      } finally {
        isLoading(false);
      }
    }
  }
}
