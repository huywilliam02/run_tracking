import 'package:flutter/material.dart';

import '../../../resources/data_constant.dart';

class DrinkButton extends StatelessWidget {
  final String icon;
  final String label;
  final double size;
  final void Function() onTap;

  const DrinkButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.size,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(icon, width: size, height: size),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: Palette.foregroundColor)),
        ],
      ),
    );
  }
}
