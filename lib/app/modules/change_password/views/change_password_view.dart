import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/resources/data_constant.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../components/form_field_widget.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends BaseView<ChangePasswordController> {
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        title: const Text('ChangePasswordView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(
            UtilsReponsive.width(context, 20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: UtilsReponsive.height(context, 70),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage("assets/images/finish_image.png"),
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              SizedBox(
                height: UtilsReponsive.height(context, 50),
              ),
              Text(
                LocaleKeys.change_password_text_old_password.tr,
                style: TextStyleConstant.blackBold16,
              ),
              SizedBox(
                height: UtilsReponsive.height(context, 15),
              ),
              Row(children: [
                Expanded(
                  flex: 5,
                  child: Obx(
                    () => FormFieldWidget(
                        isObscureText: true,
                        controllerEditting: controller.oldPasswordController,
                        textInputType: TextInputType.text,
                        errorText: controller.errOldPassword.value,
                        setValueFunc: controller.setValueOldPassword),
                  ),
                ),
              ]),
              SizedBox(
                height: UtilsReponsive.height(context, 20),
              ),
              Text(LocaleKeys.change_password_text_new_password.tr,
                  style: TextStyleConstant.blackBold16),
              SizedBox(
                height: UtilsReponsive.height(context, 15),
              ),
              Row(children: [
                Expanded(
                  flex: 5,
                  child: Obx(
                    () => FormFieldWidget(
                        isObscureText: true,
                        controllerEditting: controller.newPasswordController,
                        textInputType: TextInputType.text,
                        errorText: controller.errNewPassword.value,
                        setValueFunc: controller.setValueNewPassword),
                  ),
                ),
              ]),
              SizedBox(
                height: UtilsReponsive.height(context, 20),
              ),
              Text(LocaleKeys.change_password_text_confirm_password.tr,
                  style: TextStyleConstant.blackBold16),
              SizedBox(
                height: UtilsReponsive.height(context, 15),
              ),
              Row(children: [
                Expanded(
                  flex: 5,
                  child: Obx(
                    () => FormFieldWidget(
                        isObscureText: true,
                        controllerEditting: controller.reNewPasswordController,
                        textInputType: TextInputType.text,
                        errorText: controller.errReNewPassword.value,
                        setValueFunc: controller.setValueReNewPassword),
                  ),
                ),
              ]),
              SizedBox(
                height: UtilsReponsive.height(context, 20),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: context.width),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurpleAccent),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(14)),
                  ),
                  child: Text(
                    LocaleKeys.change_password_buttons_update.tr,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  onPressed: () async {
                    controller.onClickChangePassword();
                  },
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
