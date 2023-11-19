import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/modules/login/api/login_api.dart';
import 'package:tracker_run/generated/locales.g.dart';


class ForgetPasswordController extends BaseController {
  Rx<String> email = "".obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> appearTextTrue = false.obs;
  Rx<bool> appearTextFalse = false.obs;
  Rx<String> textStatus = "".obs;
  Rx<String> errEmail = "".obs;
  Rx<bool> enableButton = false.obs;

 

  void setValueEmail(String value) {
    email.value = value;
    checkEmail(email.value);
  }

  onClickSubmit() async {
    appearTextFalse(false);
    try {
      if (enableButton.value) {
        isLoading(true);
        bool check = await LoginApi.resetPassword(email.value);
        if (check) {
          textStatus.value =
              "Link thay đổi mật khẩu đã được gửi Email vui lòng kiểm tra hộp thư";
          appearTextTrue(true);
        } else {
          textStatus.value = "Vui Lòng kiểm tra lại email";
          appearTextFalse(true);
        }
      }
    } catch (e) {
      textStatus.value = e.toString().split("Exception: ")[1].tr;
      appearTextFalse(true);
    } finally {
      isLoading(false);
    }
  }

  checkEnableButton() {
    if (errEmail.isEmpty) {
      enableButton(true);
    } else {
      enableButton(false);
    }
  }

  checkEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      errEmail.value = LocaleKeys.common_err_format_email.tr;
    } else {
      errEmail.value = "";
    }
    checkEnableButton();
  }
}
