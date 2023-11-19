import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../resources/app_constants.dart';
import 'circle_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    this.height = 48,
    this.title,
    this.isClose = false,
    this.isLight = true,
    this.elevationCustom = 0.0,
    required this.onTapLeading,
    this.action,
    Key? key,
  }) : super(key: key);
  final double height;
  final String? title;
  final bool isClose;
  final bool isLight;
  final double elevationCustom;
  final VoidCallback onTapLeading;
  final List<Widget>? action;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      title: Text(
        title ?? "",
        style: TextStyleConstant.whiteBold16,
      ),
      centerTitle: true,
      leading: CircleButton(
        elevation: 0,
        widget: Icon(
          isClose ? Icons.close : Icons.arrow_back_ios_new,
          color: isLight ? ColorConstant.black : ColorConstant.white,
        ),
        backgroundColor: isLight ? ColorConstant.white : ColorConstant.primary,
        onTap: onTapLeading,
      ),
      elevation: elevationCustom,
      backgroundColor: isLight ? ColorConstant.white : ColorConstant.primary,
      actions: action,
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(height);
  }
}
