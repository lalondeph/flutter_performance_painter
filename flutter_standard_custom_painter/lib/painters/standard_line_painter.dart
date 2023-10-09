import 'package:flutter/material.dart';

import 'all_path_data.dart';

/// Standard Line Painter
///
/// Author: Philip Lalonde
class StandardLinePainter extends CustomPainter {
  final List<Offset> currentPath;
  final List<AllPathData> allPaths;

  final double strokeWidth;
  final Color strokeColor;

  StandardLinePainter(this.currentPath, this.allPaths, this.strokeWidth, this.strokeColor, );

  @override
  void paint(Canvas canvas, Size size) {
    for (AllPathData pathData in allPaths) {
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

    if (currentPath.isNotEmpty) {
      Paint paint = Paint()
        ..color = strokeColor
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      Path currentPathToDraw = Path();
      currentPathToDraw.moveTo(currentPath.first.dx, currentPath.first.dy);
      for (int i = 1; i < currentPath.length; i++) {
        currentPathToDraw.lineTo(currentPath[i].dx, currentPath[i].dy);
      }
      canvas.drawPath(currentPathToDraw, paint);
    }
  }

  /// Repaint is always true as we want to refresh and display whenever a new
  /// offset is added to the current path. Or if all path data is changed.
  @override
  bool shouldRepaint(StandardLinePainter oldDelegate) => true;
}
