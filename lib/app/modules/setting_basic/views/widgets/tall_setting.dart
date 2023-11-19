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

class TallSetting extends BaseView<SettingBasicInfoController> {
  @override
  Widget buildView(BuildContext context) {
    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: ColorConstant.common_bg_dark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.basic_setting_page_text_question_tall.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      LocaleKeys
                          .basic_setting_page_text_question_tall_deciption.tr,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                )),
            Expanded(
              flex: 6,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child:
                          Obx(()=>
                           CupertinoPicker(
                              looping: true,
                              magnification: 2,
                              squeeze: 0.1,
                              backgroundColor: Colors.transparent,
                              itemExtent: 30,
                              scrollController:
                                  FixedExtentScrollController(initialItem: controller.meter.value),
                              children: List.generate(
                                  10,
                                  (index) => Text(index.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold))),
                              // children:  [Container(height: 30,width: 30,color: Colors.amber,)],
                              onSelectedItemChanged: (int value) {controller.changeMeter(value);}),)
                        ),
                      ),
                      Text(".".toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold)),
                      Expanded(
                        child:
                          Obx(()=> CupertinoPicker(
                            looping: true,
                            magnification: 2,
                            squeeze: 0.1,
                            backgroundColor: Colors.transparent,
                            itemExtent: 30,
                            scrollController:
                                FixedExtentScrollController(initialItem: controller.cm.value),
                            children: List.generate(
                                100,
                                (index) => Text(index.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))),
                            // children:  [Container(height: 30,width: 30,color: Colors.amber,)],
                            onSelectedItemChanged: (int value) {controller.changeCm(value);}),)
                      ),
                      Expanded(
                        child: Text('m',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(flex: 3, child: SizedBox.shrink())
          ],
        ));
  }
}
