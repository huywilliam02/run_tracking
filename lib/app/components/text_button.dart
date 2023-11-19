import 'package:flutter/material.dart';
import 'package:tracker_run/app/resources/app_constants.dart';

class ButtonText extends StatelessWidget {
  const ButtonText(
      {Key? key,
      required this.onTap,
      required this.text,
      this.backgroundColor = ColorConstant.cyanResume,
      this.textStyle = TextStyleConstant.whiteRegular16,
      this.hasIcon})
      : super(key: key);
  final VoidCallback onTap;
  final Color backgroundColor;
  final String text;
  final IconData? hasIcon;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
      child: hasIcon != null
          ? Row(
              children: [
                Expanded(flex: 2, child: SizedBox()),
                Expanded(
                    flex: 1,
                    child: Icon(
                      hasIcon,
                      color: ColorConstant.blue265AE8,
                    )),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        text,
                        style: textStyle,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 2, child: SizedBox()),
              ],
            )
          : SizedBox(
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: textStyle,
                ),
              ),
            ),
    );
  }
}
