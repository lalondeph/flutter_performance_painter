import 'package:flutter/material.dart';

import 'performance_drawing_view.dart';

/// Performance Painter Example Project
///
/// Problem:
/// CustomPainter falls to unacceptably low FPS
/// when many lines are painted.
/// This is caused by all paths being re-drawn on each refresh
/// Even on powerful devices, this lag causes noticeable lag
/// and impacts user experience.
///
/// Solution:
/// Repaint all inactive paths using a listener.
/// Repaint active path on each refresh (as close to 60fps as possible)
///
/// Author: Philip Lalonde
void main() async {
  runApp(const FlutterPerformancePainter());
}

class FlutterPerformancePainter extends StatelessWidget {
  const FlutterPerformancePainter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PerformanceDrawingView(),
    );
  }
}
