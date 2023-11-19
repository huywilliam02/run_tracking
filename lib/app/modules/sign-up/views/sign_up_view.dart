import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/components/form_field_widget.dart';
import 'package:tracker_run/app/modules/sign-up/controllers/sign_up_controller.dart';
import 'package:tracker_run/app/resources/data_constant.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../base/base_view.dart';

class SignUpView extends BaseView<SignUpController> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.common_bg_dark,
        title: Text(
          LocaleKeys.sign_up_view_text_sign_up_appbar.tr,
        ),
      ),
      body: Obx(
        () => controller.isLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.green,
              ))
            : SafeArea(
                child: Container(
                  margin: const EdgeInsets.only(top: 60, left: 16, right: 16),
                  width: context.width,
                  height: context.height,
                  child: SingleChildScrollView(
                    child: Form(
                      child: Column(
                        children: [
                          const Center(
                            child: Image(
                              image:
                                  AssetImage("assets/images/finish_image.png"),
                              height: 100,
                              width: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            LocaleKeys.sign_up_view_text_sign_up_appbar.tr,
                            style: TextStyleConstant.black22RobotoBold,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Obx(
                            () => FormFieldWidget(
                                // initValue: controller.nameInput.value,
                                controllerEditting: nameController,
                                textInputType: TextInputType.text,
                                icon: const Icon(Icons.person),
                                labelText: LocaleKeys.sign_up_view_text_name.tr,
                                errorText: controller.errNameInput.value,
                                setValueFunc: controller.setNameInput),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(
                            () => FormFieldWidget(
                                // initValue: controller.email.value,
                                controllerEditting: emailController,
                                textInputType: TextInputType.emailAddress,
                                icon: const Icon(Icons.mail),
                                labelText:
                                    LocaleKeys.sign_up_view_text_email.tr,
                                errorText: controller.errEmail.value,
                                setValueFunc: controller.setEmailInput),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(
                            () => FormFieldWidget(
                                enableInteractiveSelection: false,
                                isObscureText: controller.checkpassword.value,
                                suffixIcon: IconButton(
                                  icon: Icon(controller.checkpassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    controller.checkpassword.value =
                                        !controller.checkpassword.value;
                                  },
                                ),
                                textInputType: TextInputType.text,
                                icon: const Icon(Icons.lock),
                                labelText:
                                    LocaleKeys.sign_up_view_text_password.tr,
                                errorText: controller.errPasswordInput.value,
                                setValueFunc: controller.setPasswordInput),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(
                            () => FormFieldWidget(
                                enableInteractiveSelection: false,
                                isObscureText: controller.checkpassword.value,
                                suffixIcon: IconButton(
                                  icon: Icon(controller.checkpassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    controller.checkpassword.value =
                                        !controller.checkpassword.value;
                                  },
                                ),
                                textInputType: TextInputType.text,
                                icon: const Icon(Icons.lock),
                                labelText:
                                    LocaleKeys.sign_up_view_text_re_password.tr,
                                setValueFunc: controller.setRePasswordInput),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(
                            () => ConstrainedBox(
                              constraints:
                                  BoxConstraints.tightFor(width: context.width),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      controller.enableButton.isTrue
                                          ? Colors.deepPurpleAccent
                                          : Colors.grey),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(14)),
                                ),
                                child: Text(
                                  LocaleKeys
                                      .sign_up_view_text_sign_up_appbar.tr,
                                  style: TextStyleConstant.white16Roboto,
                                ),
                                onPressed: () async {
                                  if (controller.enableButton.isTrue) {
                                    await controller.signUp();
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
