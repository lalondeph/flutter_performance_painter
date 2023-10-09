import 'package:flutter/material.dart';

/// Inactive Path Data.
/// Used to store inactive Paths.
///
/// Associated with LazyPainter
/// a path is added to allPaths in the onPanEnd method
///
/// Author: Philip Lalonde
class AllPathData {
  final List<Offset> path;
  final double strokeWidth;
  final Color strokeColor;

  static List<AllPathData> allPaths = [];

  AllPathData(
      {required this.path,
      required this.strokeWidth,
      required this.strokeColor});
}
