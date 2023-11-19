import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/database/database_local.dart';
import 'package:tracker_run/app/modules/login/controllers/login_controller.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../resources/app_constants.dart';
import '../../edit_profile/api/edit_profile.dart';
import '../../login/model/login_model.dart';

class EditHealthController extends BaseController {
  late LoginModel loginModel;
  Rx<String> birthday = "1990/01/01".obs;
  Rx<String> gender = "Male".obs;
  Rx<double> weight = 0.0.obs;
  Rx<double> height = 0.0.obs;
  Rx<String> errWeight = "".obs;
  Rx<String> errHeight = "".obs;
  Rx<bool> enableSave = false.obs;

  @override
  void onInit() {
    super.onInit();
    loginModel = Get.find<LoginController>().loginModel.value;
    birthday.value = DateFormat("yyyy-MM-dd").format(loginModel.birthday);
    gender(loginModel.gender);
    weight(loginModel.weight);
    height(loginModel.height * 100);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  checkEnable() {
    if (errHeight.isEmpty && errWeight.isEmpty) {
      enableSave(true);
    } else {
      enableSave(false);
    }
  }

  setValueHeight(String value) {
    try {
      double tmp = checkHeightFormat(value);
      checkHeightValue(tmp);
      height.value = tmp;
      errHeight.value = "";
    } catch (e) {
      errHeight.value = e.toString().split("Exception:")[1];
    } finally {
      checkEnable();
    }
  }

  double checkHeightFormat(String value) {
    double tmp;
    try {
      tmp = double.parse(value);
      return tmp;
    } catch (e) {
      throw Exception(LocaleKeys.common_err_format.tr);
    }
  }

  double? checkHeightValue(double value) {
    double? tmp;
    if (value < 50 || value > 250) {
      throw Exception(LocaleKeys.common_err_limited_height.tr);
    } else {
      return tmp;
    }
  }

  double checkWeightFormat(String value) {
    double tmp;
    try {
      tmp = double.parse(value);
      return tmp;
    } catch (e) {
           throw Exception(LocaleKeys.common_err_format.tr);

    }
  }

  double? checkWeightValue(double value) {
    double? tmp;
    if (value < 20 || value > 500) {
      throw Exception(LocaleKeys.common_err_limited_weight.tr);
    } else {
      return tmp;
    }
  }

  setValueWeight(String value) {
    try {
      double tmp = checkWeightFormat(value);
      checkHeightValue(tmp);
      weight.value = tmp;
      errWeight.value = "";
    } catch (e) {
      errWeight.value = e.toString().split("Exception:")[1];
    } finally {
      checkEnable();
    }
  }

  setValueBirthDay(DateTime value) {
    birthday.value = DateFormat("yyyy-MM-dd").format(value).toString();
  }

  setValueGender(String value) {
    gender.value = value;
  }

  onClickUpdate() async {
    enableSave(false);
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.loading,
      text: 'Loading',
    );
    try {
      String messCheck = await EditProfileApi().updateHealthy(
          gender: gender.value,
          weight: weight.value,
          height: height.value / 100,
          birthday: birthday.value);
      if (messCheck == "Success") {
        Get.back();
        Get.find<LoginController>().loginModel.value.gender = gender.value;
        Get.find<LoginController>().loginModel.value.height =
            height.value / 100;
        Get.find<LoginController>().loginModel.value.weight = weight.value;

        Get.find<LoginController>().loginModel.value.birthday =
            DateFormat("yyyy-MM-dd").parse(birthday.value);
        Get.find<LoginController>().update();
        DatabaseLocal.instance
            .updateLoginModel(Get.find<LoginController>().loginModel.value);
        Get.back();
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.success,
          text: LocaleKeys.common_update_success.tr,
        );
      }
    } catch (e) {
       Get.snackbar(
           LocaleKeys.common_notification_title.tr, "${e.toString().split("Exception: ")[1]}".tr,
            backgroundColor: ColorConstant.white);
    } finally {}
  }
}
