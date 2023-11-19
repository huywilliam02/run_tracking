import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/resources/app_constants.dart';

class ListTitleSport extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCheck;
  const ListTitleSport(
      {super.key,
      required this.icon,
      required this.title,
      required this.isCheck});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // onTap: (){
      //   if(!isCheck){
      //     Get.snackbar("Message","Comming soon",backgroundColor: Colors.white);
      //   }
      //   Get.back();
      // },
        title: Text(
          title,
          style: TextStyle(
              color: isCheck == true ? ColorConstant.primary : Colors.grey),
        ),
        // tileColor:
        leading: Icon(icon,
            color: isCheck == true ? ColorConstant.primary : Colors.grey),
        trailing: isCheck == true
            ? Icon(
                Icons.check,
                color: ColorConstant.primary,
              )
            : null);
  }
}
