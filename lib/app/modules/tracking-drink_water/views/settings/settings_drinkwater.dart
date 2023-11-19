import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/controllers/tracking_drink_water_controller.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/drinkWaterReminder/drinkwater_view.dart';
import 'package:tracker_run/app/resources/data_constant.dart';
import 'package:tracker_run/generated/locales.g.dart';

class SettingDrinkWater extends BaseView<TrackingDrinkWaterController> {
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
        backgroundColor: Palette.scaffold,
        foregroundColor: Palette.foregroundColor,
        elevation: 0.0,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: GetX<TrackingDrinkWaterController>(builder: (controller) {
            return ListView(
              children: [
                ListTile(
                  title: Text(
                    LocaleKeys.tracking_drinkwater_text_target.tr,
                    style: const TextStyle(color: Palette.foregroundColor),
                  ),
                  subtitle: Text(
                    LocaleKeys.tracking_drinkwater_text_title.tr,
                    style: TextStyle(
                        color: Palette.foregroundColor.withOpacity(0.5)),
                  ),
                  trailing: DropdownButton<int>(
                    value: controller.target.value,
                    style: const TextStyle(color: Palette.foregroundColor),
                    dropdownColor: Palette.scaffold,
                    onChanged: (target) =>
                        controller.changeTarget(target ?? 500),
                    items: [
                      for (int i = 500; i < 5001; i += 500)
                        DropdownMenuItem(
                          value: i,
                          child: Text('$i Ml'),
                        ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    LocaleKeys.tracking_drinkwater_text_notify.tr,
                    style: const TextStyle(color: Palette.foregroundColor),
                  ),
                  subtitle: Text(
                    LocaleKeys.tracking_drinkwater_text_setting_notify.tr,
                    style: TextStyle(
                        color: Palette.foregroundColor.withOpacity(0.5)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.read_more_sharp,
                    ),
                    onPressed: () {
                      Get.to( DrinkWaterReminderScreen());
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      backgroundColor: Palette.scaffold,
    );
  }
}
