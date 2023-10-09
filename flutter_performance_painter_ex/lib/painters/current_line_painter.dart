import 'package:flutter/material.dart';

/// Current Line Painter
/// Defines the current line
///
/// Author: Philip Lalonde
class CurrentLinePainter extends CustomPainter {
  final List<Offset> currentPath;
  final double strokeWidth;
  final Color strokeColor;

  CurrentLinePainter(this.currentPath, this.strokeWidth, this.strokeColor);

  @override
  void paint(Canvas canvas, Size size) {
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

  /// repaint current line without lag
  @override
  bool shouldRepaint(CurrentLinePainter oldDelegate) => true;
}
