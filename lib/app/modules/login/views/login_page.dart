import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/components/form_field_widget.dart';
import 'package:tracker_run/app/resources/data_constant.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../base/base_view.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginPage extends BaseView<LoginController> {
  @override
  Widget buildView(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          controller.onBackLoginPage();
          return true;
        },
        child: controller.isLoading.isTrue
            ? CircularProgressIndicator()
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: ColorConstant.common_bg_dark,
                  title: Text(LocaleKeys.login_page_text_title_app_bar.tr),
                ),
                body: SafeArea(
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
                                image: AssetImage(
                                    "assets/images/finish_image.png"),
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(context, 20),
                            ),
                            Text(
                              LocaleKeys.login_page_text_title_form.tr,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black87),
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(context, 20),
                            ),
                            Obx(
                              () => FormFieldWidget(
                                  icon: const Icon(Icons.mail),
                                  textInputType: TextInputType.emailAddress,
                                  controllerEditting:
                                      controller.emailController,
                                  // focusNode: controller.focusEmail,
                                  errorText: controller.validateErrEmail.value,
                                  labelText: LocaleKeys
                                      .login_page_text_text_hide_email.tr,
                                  setValueFunc: controller.setValueEmail),
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(context, 20),
                            ),
                            Obx(
                              () => FormFieldWidget(
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
                                  icon: const Icon(Icons.lock),
                                  textInputType: TextInputType.text,
                                  controllerEditting:
                                      controller.passwordController,
                                  // focusNode: controller.focusPassword,
                                  errorText:
                                      controller.validateErrPassword.value,
                                  labelText: LocaleKeys
                                      .login_page_text_text_hide_password.tr,
                                  setValueFunc: controller.setValuePassword),
                            ),
                            TextButton(
                                onPressed: () async {
                                Get.toNamed(Routes.FORGET_PASSWORD);
                                },
                                child: Text(LocaleKeys
                                    .login_page_text_forgot_password.tr)),
                            SizedBox(
                              height: UtilsReponsive.height(context, 10),
                            ),
                            Obx(
                              () => ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                    width: context.width),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        controller.email.value != "" &&
                                                controller.password.value != ""&&controller.validateErrEmail.isEmpty&&controller.validateErrPassword.isEmpty
                                            ? Colors.deepPurpleAccent
                                            : Colors.grey),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(14)),
                                  ),
                                  child: Text(
                                    LocaleKeys.login_page_buttons_login.tr,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    await controller.login();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(context, 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }
}
