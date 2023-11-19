import 'package:flutter/material.dart';

import '../../../components/circle_button.dart';
import '../../../resources/app_constants.dart';

class OverlayResume extends StatelessWidget {
  const OverlayResume({
    Key? key,
    required this.onStop,
    required this.onResume,
    required this.onRestart,
  }) : super(key: key);
  final VoidCallback onStop;
  final VoidCallback onResume;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(flex: 4, child: SizedBox()),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleButton(
                      onTap: onStop,
                      widget: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Icon(Icons.stop,size: 45,),
                      ),
                      backgroundColor: ColorConstant.redStop,
                    ),
                    CircleButton(
                      onTap: onResume,
                      widget: const Padding(
                        padding:  EdgeInsets.all(30.0),
                        child:  Icon(Icons.play_arrow,size: 45,),
                      ),
                      backgroundColor: ColorConstant.primary,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onRestart,
                  child: Row(
                    children: const [
                      Expanded(flex: 1, child: SizedBox()),
                      Icon(Icons.restart_alt,color: ColorConstant.white,),
                      Text(
                        'Restart',
                        style: TextStyleConstant.whiteBold16,
                      ),
                      Expanded(flex: 1, child: SizedBox()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
