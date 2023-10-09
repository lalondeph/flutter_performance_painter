import 'package:flutter/material.dart';

/// Offsets for the
/// path being actively drawn.
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
