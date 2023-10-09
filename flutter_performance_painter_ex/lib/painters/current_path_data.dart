import 'package:flutter/material.dart';

/// The path being actively drawn.
///
/// Associated with CurrentLinePainter
/// and the onPan methods
///
/// Author: Philip Lalonde
class CurrentPathData {
  final List<Offset> path;
  final double strokeWidth;
  final Color strokeColor;

  static List<Offset> currentPath = [];

  CurrentPathData(
      {required this.path,
      required this.strokeWidth,
      required this.strokeColor});
}
