import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/modules/login/controllers/login_controller.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';

import '../../../../generated/locales.g.dart';
import '../../../components/form_field_widget.dart';
import '../../../resources/app_constants.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends BaseView<EditProfileController> {
  @override
  Widget buildView(BuildContext context) {
    print(Get.find<LoginController>().loginModel.value.avatar);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.common_bg_dark,
        title: Text(LocaleKeys.edit_profile_text_edit_profile.tr),
        actions: [
          TextButton(
              onPressed: controller.onClickChangePassword,
              child: Text(LocaleKeys.edit_profile_text_change_password.tr))
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 60, left: 16, right: 16),
          width: context.width,
          height: context.height,
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Stack(
                      // fit: StackFit.expand,
                      children: [
                        GetBuilder<LoginController>(
                          builder: (controller) => controller
                                      .loginModel.value.avatar ==
                                  ""
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 450,
                                    imageUrl:
                                        "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000",
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                )
                              : Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: 150,
                                  width: 150,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl:
                                        controller.loginModel.value.avatar,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),

                          // ClipOval(
                          //     child: CachedNetworkImage(
                          //       fit: BoxFit.cover,
                          //       width: 150,
                          //       height: 450,
                          //       imageUrl:
                          //           controller.loginModel.value.avatar,
                          //       progressIndicatorBuilder: (context, url,
                          //               downloadProgress) =>
                          //           CircularProgressIndicator(
                          //               value: downloadProgress.progress),
                          //       errorWidget: (context, url, error) =>
                          //           const Icon(Icons.error),
                          //     ),
                          //   ),
                        ),
                        Positioned(
                            bottom: -5,
                            right: -5,
                            child: IconButton(
                                onPressed: () async {
                                  controller.onImagePick();
                                  controller.showLoading();
                                },
                                icon: const Icon(Icons.add_a_photo)))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(context, 20),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(LocaleKeys.edit_profile_text_email.tr),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(context, 10),
                  ),
                  Row(children: [
                    Expanded(
                      flex: 5,
                      child: Obx(
                        () => InkWell(
                          onTap: () => controller.onClickEdit(),
                          child: FormFieldWidget(
                            
                              icon: const Icon(Icons.email_outlined),
                              initValue: controller.email.value,
                              isEnabled: false,
                              textInputType: TextInputType.text,
                              // errorText: controller.errNameInput.value,
                              setValueFunc: controller.setValueEmail),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: UtilsReponsive.height(context, 20),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(LocaleKeys.edit_profile_text_name.tr),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(context, 10),
                  ),
                  Row(children: [
                    Expanded(
                      flex: 5,
                      child: Obx(
                        () => InkWell(
                          onTap: () => controller.onClickEdit(),
                          child: FormFieldWidget(
                            icon: const Icon(Icons.account_circle_outlined),
                            initValue: controller.name.value,
                            isEnabled: controller.isEnable.value,
                            textInputType: TextInputType.text,
                            setValueFunc: controller.setValueName,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: UtilsReponsive.height(context, 16),
                  ),
                  Row(children: [
                    Expanded(
                      flex: 5,
                      child: Obx(() => Row(
                            children: [
                              Text(LocaleKeys.edit_profile_text_birthday.tr),
                              Text(controller.birthday.value,
                                  style: TextStyleConstant.blackBold16),
                              IconButton(
                                  onPressed: () {
                                    controller.onClickEdit();
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(1890, 1, 1),
                                        maxTime: DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day),
                                        onChanged: (value) {
                                      controller.setValueBirthDay(value);
                                    }, currentTime: DateTime.now());
                                  },
                                  icon: Icon(Icons.calendar_month))
                            ],
                          )),
                    ),
                  ]),
                  SizedBox(
                    height: 16,
                  ),
                  Obx(() => controller.isEnable.isFalse
                      ? buttonEdit(context)
                      : rowUpdateCancel(context)),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buttonEdit(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
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
                padding: MaterialStateProperty.all(EdgeInsets.all(14)),
              ),
              child: Text(
                LocaleKeys.edit_profile_text_edit.tr,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              onPressed: () async {
                controller.onClickEdit();
              },
            ),
          ),
        ),
      ],
    );
  }

  Row rowUpdateCancel(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
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
                padding: MaterialStateProperty.all(EdgeInsets.all(14)),
              ),
              child: Text(
                LocaleKeys.edit_profile_text_update.tr,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              onPressed: () async {
                controller.onClickUpdate(context);
              },
            ),
          ),
        ),
        SizedBox(
          width: UtilsReponsive.width(context, 10),
        ),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: context.width),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(EdgeInsets.all(14)),
              ),
              child: Text(
                LocaleKeys.edit_profile_text_cancel.tr,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              onPressed: () async {
                controller.onClickCancel();
              },
            ),
          ),
        ),
      ],
    );
  }
}
