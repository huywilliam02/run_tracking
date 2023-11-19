import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../base/base_view.dart';
import '../../../components/custom_appbar.dart';
import '../../../resources/app_constants.dart';
import '../../../routes/app_pages.dart';
import '../controllers/tracking_result_controller.dart';

class TrackingResultView extends BaseView<TrackingResultController> {
  @override
  Widget buildView(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: ColorConstant.white,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 15, right: 15),
              child: ElevatedButton(
                onPressed: controller.submitActivitie,
                child: Text(LocaleKeys.tracking_result_view_buttons_save.tr),
              ),
            ),
            appBar: CustomAppBar(
              isLight: false,
              isClose: true,
              onTapLeading: () {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    showCancelBtn: true,
                    text: "Bạn có muốn bỏ bản record này?",
                    onCancelBtnTap: () {
                      Get.back();
                    },
                    onConfirmBtnTap: () {
                      Get.offAllNamed(Routes.HOME);
                    });
              },
              action: [
                TextButton(
                    onPressed: () {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          showCancelBtn: true,
                          text: "Bạn có muốn bỏ bản record này?",
                          onCancelBtnTap: () {
                            Get.back();
                          },
                          onConfirmBtnTap: () {
                            Get.offAllNamed(Routes.HOME);
                          });
                    },
                    child: Text(
                      LocaleKeys.tracking_result_view_buttons_discard.tr,
                      style: const TextStyle(color: Colors.red),
                    ))
              ],
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: UtilsReponsive.width(context, 30)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // labelText: labelText,
                      hintText: LocaleKeys
                          .tracking_result_view_text_title_expanded_one.tr,
                      hintTextDirection: TextDirection.ltr,
                      hintMaxLines: 3,
                    ),
                    onChanged: (value) {
                      controller.setValueName(value);
                    },
                  ),
                  // FormFieldWidget(
                  //   padding: 10,
                  //   setValueFunc: controller.setValueName,
                  //   labelText: LocaleKeys
                  //       .tracking_result_view_text_title_expanded_one.tr,
                  // ),
                  SizedBox(
                    height: UtilsReponsive.height(context, 20),
                  ),
                  Container(
                    height: UtilsReponsive.height(context, 160),
                    width: double.infinity,
                    child: Obx(
                      () => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.listImage.isNotEmpty
                            ? controller.listImage.length
                            : 1,
                        // separatorBuilder: (context, index) {
                        //   return Container(
                        //     color: Colors.white,
                        //     height: UtilsReponsive.height(context, 160),
                        //     width: 5,
                        //   );
                        // },
                        itemBuilder: (context, index) {
                          if (controller.listImage.isNotEmpty) {
                            return SizedBox(
                              height: UtilsReponsive.height(context, 150),
                              width: UtilsReponsive.width(context, 150),
                              child: Stack(
                                children: [
                                  Image.file(File(controller.listImage[index])),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                          onPressed: () {
                                            controller.onTabDeleteIamge(index);
                                          },
                                          icon: const Icon(Icons.close)),
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              height: UtilsReponsive.height(context, 150),
                              width: UtilsReponsive.width(context, 150),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 3)),
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      controller.onImagePick();
                                    },
                                    icon: const Icon(Icons.add)),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ))));
  }
}
