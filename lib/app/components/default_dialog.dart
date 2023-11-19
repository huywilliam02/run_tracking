import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DefaultDialog extends StatelessWidget {
  const DefaultDialog({
    Key? key,
    required this.confirm,
    required this.cancel,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);
  final String confirm;
  final String cancel;
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: false,
          child: Text(cancel),
          onPressed:(){
            Get.back();
            onCancel;
          } ,
        ),
        CupertinoDialogAction(
          child: Text(confirm),
          onPressed: onConfirm,
        )
      ],
    );
  }
}
