import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../resources/app_constants.dart';
import '../../../../../resources/reponsive_utils.dart';
import '../../../controllers/tab_mine_controller/tab_mine_controller.dart';

class CarouselSliderfilterStatis extends StatelessWidget {
  const CarouselSliderfilterStatis({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TabMineController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: UtilsReponsive.width(context, 120),
        height: UtilsReponsive.height(context, 30),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40)),
        child: Row(
          children: [
            Expanded(
                child: Obx(()=>
                Visibility(
                              visible: controller.indexFilterStatis.value != 0,
                              child: IconButton(
                  onPressed: (() {
                    controller.jumpBack();
                  }),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 14,
                  ),
                              ),
                            ),
                )),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: CarouselSlider(
                  carouselController: controller.carouselController,
                  options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        controller.indexFilterStatis.value = index;
                      },
                      initialPage: 1,
                      viewportFraction: 1,
                      enableInfiniteScroll: true),
                  items: controller.listFilter.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Text(
                          i,
                          style: TextStyleConstant.blackBold16,
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
                child: Obx(()=>
                   Visibility(
                              visible: controller.indexFilterStatis.value < controller.listFilter.length-1,
                              child: IconButton(
                  onPressed: (() {
                    controller.jumpTo();
                  }),
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 14,
                  ),
                              ),
                            ),
                )),
          ],
        ),
      ),
    );
  }
}
