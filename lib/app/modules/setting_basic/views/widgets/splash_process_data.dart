import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tracker_run/app/resources/data_constant.dart';

class SplashProcessData extends StatelessWidget {
  const SplashProcessData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.common_bg_dark,
      body: Center(
          child: SizedBox(
        width: 50,
        height: 50,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              // you can replace this with Image.asset
              'assets/images/finish_image.png',
              fit: BoxFit.cover,
              height: 30,
              width: 30,
            ),
            // you can replace
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 0.7,
            ),
          ],
        ),
      )),
    );
  }
}
