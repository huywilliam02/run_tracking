import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tracker_run/app/base/base_view.dart';
import 'package:tracker_run/app/modules/setting_basic/controllers/setting_basic_controller.dart';

import '../../../../../generated/locales.g.dart';
import '../../../../resources/app_constants.dart';

class WeightSetting extends BaseView<SettingBasicInfoController> {
  @override
  Widget buildView(BuildContext context) {
    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: EdgeInsets.all(20),
        color: ColorConstant.common_bg_dark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        LocaleKeys.basic_setting_page_text_question_weight.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        LocaleKeys
                            .basic_setting_page_text_question_weight_description
                            .tr,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CupertinoPicker(
                            looping: true,
                            magnification: 2,
                            squeeze: 0.1,
                            backgroundColor: Colors.transparent,
                            itemExtent: 30,
                            scrollController:
                                FixedExtentScrollController(initialItem: 60),
                            children: List.generate(
                                400,
                                (index) => Text(index.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))),
                            // children:  [Container(height: 30,width: 30,color: Colors.amber,)],
                            onSelectedItemChanged: (int value) {
                              controller.changeWeight(value.toDouble());
                            }),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text('KG',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )),
            // Expanded(
            //   child: Obx(
            //     () =>
            //     // SizedBox.shrink(),
            //     Align(
            //       alignment: Alignment.topCenter,
            //       child: SfSlider(
            //         inactiveColor: Colors.white,
            //         min: 30,
            //         max: 200,
            //         value: controller.weight.value,
            //         interval: 30,
            //         showLabels: false,
            //         onChanged: (value) {
            //           controller.changeWeight(value);
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(flex: 3, child: SizedBox.shrink())
          ],
        ));
  }
}
