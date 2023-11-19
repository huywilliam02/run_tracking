import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/components/circle_button.dart';
import '../../../components/text_button.dart';
import '../../../components/cache_image.dart';
import '../../../resources/app_constants.dart';
import '../../../resources/reponsive_utils.dart';

class OverlayFinish extends StatelessWidget {
  const OverlayFinish({
    Key? key,
    required this.onResume,
    required this.onFinish,
    required this.onDiscard,
  }) : super(key: key);
  final VoidCallback onResume;
  final VoidCallback onFinish;
  final ValueChanged<BuildContext> onDiscard;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (()async => false),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyCacheImage(
            'finish_image.png',
            folder: AssetsFolder.images,
            width: UtilsReponsive.width(context, 200),
            height: UtilsReponsive.height(context, 200),
          ),
          ButtonText(
            onTap: onResume,
            text: 'Resume',
            textStyle: TextStyleConstant.text1Regular116,
            backgroundColor: ColorConstant.cyanResume,
          ),
          ButtonText(
            onTap: onFinish,
            text: 'Finish',
            backgroundColor: ColorConstant.primary,
          ),
          SizedBox(
            height: UtilsReponsive.height(context, 8),
          ),
          InkWell(
              onTap:(){
                onDiscard(context);
              } ,
              child: Text(
                'Discard',
                style: TextStyleConstant.textRegular16.copyWith(fontSize: 14),
              )),
        ],
      ),
    );
  }
}
