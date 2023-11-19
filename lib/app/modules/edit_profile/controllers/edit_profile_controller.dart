import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/modules/edit_profile/api/edit_profile.dart';
import 'package:tracker_run/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:tracker_run/app/modules/login/controllers/login_controller.dart';
import 'package:tracker_run/app/routes/app_pages.dart';

import '../../../../generated/locales.g.dart';
import '../../../resources/app_constants.dart';

class EditProfileController extends BaseController {

  Rx<bool> isEnable = false.obs;
  Rx<bool> isLoading = true.obs;
  Rx<String> name = "".obs;
  Rx<String> email = "".obs;
  Rx<String> birthday = "1990/01/01".obs;
  TextEditingController controllerName = TextEditingController();
  @override
  void onInit() {
    name.value = Get.find<LoginController>().loginModel.value.name;
    email.value = Get.find<LoginController>().loginModel.value.email;
    birthday.value = DateFormat("yyyy-MM-dd")
        .format(Get.find<LoginController>().loginModel.value.birthday);
    super.onInit();
  }

  @override
  void onReady() {
    isLoading(false);

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  setValueEmail(String value) {
    email.value = value;
  }

  setValueName(String value) {
    print("hehe");
    name.value = value;
  }

  setValueBirthDay(DateTime value) {
    birthday.value = DateFormat("yyyy-MM-dd").format(value).toString();
  }

  onClickEdit() {
    isEnable(true);
  }



  onClickUpdate(BuildContext context) async {
    isEnable(true);
    try {
      isEnable(false);
      String messCheck =
          await EditProfileApi().updateInfomation(name.value, birthday.value);
      if (messCheck == "Success") {
        
        Get.find<LoginController>().loginModel.value.name = name.value;
        Get.find<LoginController>().loginModel.value.birthday =
            DateFormat("yyyy-MM-dd").parse(birthday.value);
        Get.find<LoginController>().update();
        QuickAlert.show(
          context: context,
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

  onClickCancel() {
    isEnable(false);
    Get.back();
  }

  // onImagePick() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? pickedFile =
  //       await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
  //   if (pickedFile != null) {
  //     final LostDataResponse response2 = await _picker.retrieveLostData();
  //     File file = File(pickedFile.path);
  //     String avatar = await EditProfileApi().updateAvatar(file);
  //     if (avatar != "") {
  //       print(avatar);
  //       showLoading(title: 'Loading');
  //       Future.delayed(Duration(milliseconds: 5000), () {
  //         onClickCancel();
  //         Get.off(EditProfileView());
  //       });
  //       Get.find<LoginController>().loginModel.value.avatar = avatar;
  //       // await DatabaseLocal.updateLoginModel(
  //       //     Get.find<LoginController>().loginModel.value);
  //       Get.find<LoginController>().update();
  //     }
  //   }
  //   update();
  // }

  onImagePick() async {
    isLoading(true);
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 100);
      if (pickedFile != null) {
        final LostDataResponse response2 = await _picker.retrieveLostData();
        File file = File(pickedFile.path);
        String avatar = await EditProfileApi().updateAvatar(file);
        if (avatar != "") {
          isLoading(true);
          print(avatar);
          showLoading(title: 'Loading');
          Future.delayed(const Duration(milliseconds: 5000), () {
            onClickCancel();
            // Get.off(EditProfileView());
            Get.back();
            Get.snackbar("Thành công", "done");
          });
          Get.find<LoginController>().loginModel.value.avatar = avatar;
          

          Get.find<LoginController>().update();
        }
      }
    } catch (e) {
      isLoading(false);
      showLoading(title: 'Loading');
      Future.delayed(const Duration(milliseconds: 5000), () {
        onClickCancel();
        Get.off(EditProfileView());
        Get.snackbar("Không thành công", "Lỗi");
      });
    } finally {
      update();
    }
  }

  onClickChangePassword() {
    Get.toNamed(Routes.CHANGE_PASSWORD);
  }

  showLoading({String title = "Loading..."}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  title,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
