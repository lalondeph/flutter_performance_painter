import 'package:flutter/material.dart';
import 'package:flutter_standard_custom_painter/standard_drawing_view.dart';



/// Standard implementation of 
/// Flutter CustomPainter Example Project
///
/// Author: Philip Lalonde
void main() async {
  runApp(const FlutterStandardPainter());
}

class FlutterStandardPainter extends StatelessWidget {
  const FlutterStandardPainter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StandardDrawingView(),
    );
  }
}
