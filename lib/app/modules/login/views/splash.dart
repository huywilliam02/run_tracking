import 'package:flutter/material.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';

class SplashStart extends StatefulWidget {
  // final String content;
  SplashStart({Key? key}) : super(key: key);

  _SplashStartState createState() => _SplashStartState();
}

class _SplashStartState extends State<SplashStart>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.common_bg_dark,
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 150,
            width: 150,
            child: Stack(
              children: [
                RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                            colors: [Colors.red, Colors.blue],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                    )),
                Center(
                  child: Image(
                    image: AssetImage("assets/images/finish_image.png"),
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: UtilsReponsive.height(context, 15),),
        Center(
            child: Text(
          "iRace Run Tracking",
          style: TextStyleConstant.whiteBold22,
        ))
      ],
    ));
  }
}
