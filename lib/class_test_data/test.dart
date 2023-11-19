import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class Testhhh extends StatelessWidget {
   Testhhh({super.key,required this.image});
Uint8List image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.memory(image),
      ),
    );
  }
}