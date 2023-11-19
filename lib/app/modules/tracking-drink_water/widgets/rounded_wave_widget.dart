import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/controllers/tracking_drink_water_controller.dart';
import 'package:tracker_run/app/resources/data_constant.dart';

import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../../base/base_view.dart';


class RoundedWaveWidget extends BaseView<TrackingDrinkWaterController> {
  RoundedWaveWidget({
    Key? key,
    // required this.current,
    // required this.max,
    required this.size,
    this.foregroundColor,
  });

  // final int current;
  // final int max;
  final double size;
  final Color? foregroundColor;

  @override
  Widget buildView(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(width: 4, color: Colors.white.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      clipBehavior: Clip.hardEdge,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Stack(
          children: [
            Obx(() => _buildWaveWidget()),
            _buildLabel(),
            _buildBottleOfWater(),
          ],
        ),
      ),
    );
  }

  Align _buildBottleOfWater() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image.asset(
          'assets/icons/ic_bottle.png',
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Text(
              controller.totalCapacity.toString(),
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
            ),
          ),
          Obx(() => Text(
                "/${controller.target.toString()}",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ))
        ],
      ),
    );
  }

  WaveWidget _buildWaveWidget() {
    // print("today ${controller.getTodayRecord().totalCapacity}");
    // print("today ${controller.totalCapacity}");

    // print("today ${controller.target}");
    return WaveWidget(
      config: CustomConfig(
        colors: [
          Palette.blue,
          Palette.lighterBlue,
        ],
        durations: [5000, 4000],
        heightPercentages: [
          0.9 - (controller.totalCapacity / controller.target.value) - 0.005,
          0.9 - (controller.totalCapacity / controller.target.value)
        ],
      ),
      backgroundColor: Palette.scaffold,
      size: const Size(double.infinity, double.infinity),
      waveAmplitude: 0,
    );
  }
}
