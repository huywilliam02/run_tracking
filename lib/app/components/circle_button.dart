import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    required this.widget,
    required this.backgroundColor,
    this.elevation = 2,
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Widget widget;
  final Color backgroundColor;
  final VoidCallback onTap;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: backgroundColor,
          elevation: elevation,
        ),
        child: widget);
  }
}
