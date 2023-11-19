import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:get/get.dart';
import 'package:tracker_run/app/resources/data_constant.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';

import '../../../../generated/locales.g.dart';
import '../../../base/base_view.dart';
import '../../../components/form_field_widget.dart';
import '../controllers/edit_health_controller.dart';

class EditHealthView extends BaseView<EditHealthController> {
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        title: Text(LocaleKeys.tab_edit_health_text_health_app_bar.tr),
        centerTitle: true,
        backgroundColor: ColorConstant.primary,
        actions: [
          Obx(() => TextButton(
              onPressed: () async {
                if (controller.enableSave.isTrue) {
                  await controller.onClickUpdate();
                }
              },
              child: Text(
                LocaleKeys.tab_edit_health_text_save.tr,
                style: controller.enableSave.isTrue
                    ? TextStyleConstant.purple16RobotoBold
                    : TextStyleConstant.grey16RobotoBold,
              )))
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UtilsReponsive.width(context, 20),
              vertical: UtilsReponsive.height(context, 25)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.tab_edit_health_text_gender.tr,
                          style: TextStyleConstant.black16Roboto,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Obx(
                          () => DropdownButton<String>(
                            dropdownColor: ColorConstant.white,
                            style: TextStyleConstant.black16Roboto,
                            value: controller.gender.value.capitalizeFirst,
                            items: const [
                              DropdownMenuItem(
                                  value: "Male",
                                  child: Text("Male",
                                      style: TextStyleConstant.black16Roboto)),
                              DropdownMenuItem(
                                  value: "Female",
                                  child: Text("Female",
                                      style: TextStyleConstant.black16Roboto))
                            ],
                            onChanged: (String? value) {
                              controller.setValueGender(value!);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(LocaleKeys.edit_profile_text_birthday.tr),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(
                        () => Row(
                          children: [
                            Text(controller.birthday.value,
                                style: TextStyleConstant.blackBold16),
                            IconButton(
                                onPressed: () {
                                  controller.checkEnable();
                                  // controller.onClickEdit();
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
                        ),
                      )
                    ],
                  )),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.tab_edit_health_text_height.tr,
                          style: TextStyleConstant.black16Roboto,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Obx(
                                  () => FormFieldWidget(
                                        padding: UtilsReponsive.width(context, 20),
                                    textInputType: TextInputType.number,
                                    radiusBorder:
                                        UtilsReponsive.height(context, 10),
                                    errorText: controller.errHeight.value,
                                    // suffixIcon: Align(
                                    //   alignment: Alignment.centerRight,
                                    //   child: Text("KM")),
                                    styleInput: TextStyleConstant.black16Roboto,
                                    setValueFunc: controller.setValueHeight,
                                    initValue: controller.height.toString(),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.tab_edit_health_text_weight.tr,
                          style: TextStyleConstant.black16Roboto,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Obx(
                                  () => FormFieldWidget(
                                    padding: UtilsReponsive.width(context, 20),
                                    textInputType: TextInputType.number,
                                    radiusBorder:
                                        UtilsReponsive.height(context, 10),
                                    errorText: controller.errWeight.value,
                                    // suffixIcon: Align(
                                    //   alignment: Alignment.centerRight,
                                    //   child: Text("KM")),
                                    styleInput: TextStyleConstant.black16Roboto,
                                    setValueFunc: controller.setValueWeight,
                                    initValue: controller.weight.toString(),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
