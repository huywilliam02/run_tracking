import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/database/database_local.dart';
import 'package:tracker_run/app/modules/login/model/login_model.dart';
import 'package:tracker_run/app/modules/login/views/login_choose_page.dart';
import 'package:tracker_run/app/resources/dev_utils.dart';

import '../../../../generated/locales.g.dart';
import '../../../resources/app_constants.dart';
import '../../../routes/app_pages.dart';
import '../api/login_api.dart';

class LoginController extends BaseController {
  Rx<bool> isLoading = false.obs;
  late Rx<LoginModel> loginModel;
  String jwtToken = "";
  Rx<bool> hasInternet = false.obs;
  Rx<String> validateErrEmail = "".obs;
  Rx<String> validateErrPassword = "".obs;
  late TextEditingController emailController, passwordController;
  Rx<String> email = "".obs;
  Rx<String> password = "".obs;
  Rx<bool> checkpassword = true.obs;
  late StreamSubscription streamConnect;

  @override
  void onInit() async {
    await getConnection();
    try {
      streamConnect = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          hasInternet(true);
        } else if (result == ConnectivityResult.none) {
          hasInternet(false);
        }
      });

      emailController = TextEditingController();
      passwordController = TextEditingController();

      jwtToken = await DatabaseLocal.instance.getJwtToken();
      loginModel = Rx<LoginModel>(LoginModel());
      if (jwtToken == "") {
        final prefs = await SharedPreferences.getInstance();
        String? tmp = prefs.getString('language');
        if (tmp == null) {
          Get.offAllNamed(Routes.CHOOSE_LANGUAGE);
        } else {
          Get.to(() => const LoginChoosePage());
        }
      } else {
        if (hasInternet.isTrue) {
          //Lay thong tin ve

          LoginModel? loginModelCheck =
              await LoginApi.getDataCustomer(jwtToken);
          if (loginModelCheck == null) {
            DevUtils.printLog("LoginController", "59", "null");
            Get.to(() => const LoginChoosePage());
          } else {
            loginModel.value = loginModelCheck;
            DevUtils.printLog(
                "LoginController", "60", loginModel.value.weight.toString());
            Get.offAllNamed(Routes.SETTING_BASIC_INFO);
          }
        } else {
          loginModel =
              Rx<LoginModel>(await DatabaseLocal.instance.getLoginModel());
          Get.offAllNamed(Routes.SETTING_BASIC_INFO);
        }
        DevUtils.printLog(
            "LoginController", "54", loginModel.value.weight.toString());
      }
      super.onInit();
    } catch (e) {
      Get.snackbar(LocaleKeys.common_notification_title.tr,
          "${e.toString().split("Exception: ")[1]}".tr,
          backgroundColor: ColorConstant.white);
    }
  }

  @override
  void onReady() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.toMap();

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

//LoginController-Module Login
  Future<bool> getConnection() async {
    bool isConnection = await InternetConnectionChecker().hasConnection;
    if (isConnection) {
      hasInternet(true);
      return Future.value(true);
    } else {
      hasInternet(false);
      return Future.value(false);
    }
  }

  void onBackLoginPage() {
    email("");
    password("");
    validateErrEmail("");
    validateErrPassword("");
    emailController.text = "";
    passwordController.text = "";
  }

  validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      validateErrEmail.value = "Provide valid Email";
    } else {
      validateErrEmail.value = "";
    }
  }

  validatePassword(String value) {
    if (value.length < 1) {
      validateErrPassword.value = "Password must be of 8 characters";
    } else {
      validateErrPassword.value = "";
    }
  }

  setValueEmail(String? value) {
    if (value != null) {
      validateEmail(value);
      email.value = value;
    }
  }

  setValuePassword(String? value) {
    if (value != null) {
      validatePassword(value);
      password.value = value;
    }
  }

  login() async {
    isLoading(true);
    try {
      await DatabaseLocal.instance.removeJwtToken();
      validateEmail(email.value);
      validatePassword(password.value);
      if (validateErrEmail.value == "" && validateErrPassword.value == "") {
        loginModel =
            Rx<LoginModel>(await LoginApi.login(email.value, password.value));
        jwtToken = await DatabaseLocal.instance.getJwtToken();
        if (jwtToken != "") {
          await DatabaseLocal.instance.reNewLoginModel(loginModel.value);
          Get.offAllNamed(Routes.SETTING_BASIC_INFO);
          Get.snackbar(
            LocaleKeys.common_notification_title.tr,
            LocaleKeys.common_sign_in_success.tr,
            icon: Icon(Icons.person, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            borderRadius: 20,
            margin: EdgeInsets.all(15),
            colorText: Colors.white,
            duration: Duration(seconds: 5),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeOutBack,
          );
        }
      }
    } catch (e) {
      Get.snackbar(LocaleKeys.common_notification_title.tr,
          "${e.toString().split("Exception: ")[1]}".tr,
          backgroundColor: ColorConstant.white);
    } finally {
      isLoading(false);
    }
  }

  logout() async {
    loginModel = Rx<LoginModel>(LoginModel());
    await DatabaseLocal.instance.reNewLoginModel(loginModel.value);
    await DatabaseLocal.instance.removeJwtToken();
    Get.offAllNamed(Routes.START_APP);
  }
}
