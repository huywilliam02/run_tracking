import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/generated/locales.g.dart';

import '../../../base/base_view.dart';
import '../controllers/setting_language_controller.dart';

class SettingLanguageView extends BaseView<SettingLanguageController> {
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        title: Text(LocaleKeys.common_language.tr),
        centerTitle: true,
      ),
      backgroundColor: ColorConstant.common_bg_dark,
      body: Obx(
        () => controller.isLoading.isTrue
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () {
                        controller.updateLanguage(1);
                      },
                      title: Text(LocaleKeys.common_language_vi.tr,
                          style: TextStyleConstant.white18Roboto),
                      trailing: controller.language.value == "vi"
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : SizedBox.shrink(),
                    ),
                    ListTile(
                      onTap: () {
                        controller.updateLanguage(2);
                      },
                      title: Text(LocaleKeys.common_language_en.tr,
                          style: TextStyleConstant.white18Roboto),
                      trailing: controller.language.value == "en"
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : SizedBox.shrink(),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
