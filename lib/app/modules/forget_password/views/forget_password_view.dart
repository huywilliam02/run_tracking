import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/components/form_field_widget.dart';
import 'package:tracker_run/app/modules/login/controllers/login_controller.dart';
import 'package:tracker_run/app/modules/login/views/login_choose_page.dart';
import 'package:tracker_run/app/modules/login/views/login_page.dart';
import 'package:tracker_run/app/resources/data_constant.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../routes/app_pages.dart';
import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends BaseView<ForgetPasswordController> {
  @override
  Widget buildView(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<LoginController>().onInit();
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Get.find<LoginController>().onInit();
                },
                icon: Icon(Icons.arrow_back_ios_outlined)),
            title:  Text(LocaleKeys.common_forget_password.tr),
            centerTitle: true,
            backgroundColor: ColorConstant.common_bg_dark,
          ),
          body: Center(
            child: Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: UtilsReponsive.width(context, 30)),
                child: controller.appearTextTrue.value
                    ? Column(
                        children: [
                          SizedBox(
                            height: UtilsReponsive.height(context, 20),
                          ),
                          Text(controller.textStatus.value),
                          SizedBox(
                            height: UtilsReponsive.height(context, 20),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Get.find<LoginController>().onInit();
                              },
                              child: Text(LocaleKeys.forget_password_text_back_login_page.tr))
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: UtilsReponsive.height(context, 20),
                          ),
                          Obx(
                            () => FormFieldWidget(
                                errorText: controller.errEmail.value,
                                padding: 20,
                                labelText: LocaleKeys.common_request_input_email.tr,
                                setValueFunc: controller.setValueEmail),
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(context, 20),
                          ),
                          Obx(() => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: controller.enableButton.value
                                      ? Colors.blue
                                      : Colors.grey),
                              onPressed: controller.onClickSubmit,
                              child: controller.isLoading.value
                                  ? CupertinoActivityIndicator(color: Colors.amber,)
                                  : Text(LocaleKeys.forget_password_text_send_email.tr))),
                          Obx(() => controller.appearTextFalse.isTrue
                              ? Text(controller.textStatus.value)
                              : SizedBox.shrink())
                        ],
                      ),
              ),
            ),
          )),
    );
  }
}
