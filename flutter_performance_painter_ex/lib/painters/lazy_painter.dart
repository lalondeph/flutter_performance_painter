import 'package:flutter/material.dart';
import 'package:flutter_performance_painter_ex/painters/all_path_data.dart';

import '../components/repaint_listener.dart';

/// Stored the finished Paths. Redrawn via a listener
///
/// Author: Philip Lalonde
class LazyPainter extends CustomPainter {
  final List<AllPathData> paths;

  final RepaintListener repaintListener;

  LazyPainter(this.paths, this.repaintListener)
      : super(repaint: repaintListener);

  @override
  void paint(Canvas canvas, Size size) {
    for (AllPathData pathData in paths) {
      Paint paint = Paint()
        ..color = pathData.strokeColor
        ..strokeWidth = pathData.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      Path pathToDraw = Path();
      for (int i = 0; i < pathData.path.length; i++) {
        if (i == 0) {
          pathToDraw.moveTo(pathData.path[i].dx, pathData.path[i].dy);
        } else if (i > 0) {
          pathToDraw.lineTo(pathData.path[i].dx, pathData.path[i].dy);
        }
      }
      canvas.drawPath(pathToDraw, paint);
    }
  }

  /// repaint is controlled by a listener.
  /// Only called when a path is added to PathData.allPaths[] in onPanEnd
  @override
  bool shouldRepaint(LazyPainter oldDelegate) {
    return oldDelegate.repaintListener.toString() != repaintListener.toString();
  }
}
