import 'package:flutter/material.dart';
import 'package:flutter_performance_painter_ex/painters/all_path_data.dart';
import 'package:flutter_performance_painter_ex/painters/current_line_painter.dart';
import 'package:flutter_performance_painter_ex/painters/current_path_data.dart';
import 'package:flutter_performance_painter_ex/painters/lazy_painter.dart';

import 'components/repaint_listener.dart';

/// Main view of the app.
/// You should see a blank white canvas with a garbage can icon
///
/// Author: Philip Lalonde
class PerformanceDrawingView extends StatefulWidget {
  const PerformanceDrawingView({Key? key}) : super(key: key);

  @override
  State<PerformanceDrawingView> createState() =>
      _PerformanceDrawingView();
}

class _PerformanceDrawingView extends State<PerformanceDrawingView> {
  /// Custom Listener
  RepaintListener repaintListener = RepaintListener();

  /// Keys
  final GlobalKey linePainterKey = GlobalKey();
  final GlobalKey currentPainterKey = GlobalKey();

  /// Stroke details
  final Color strokeColor = Colors.black;
  final double strokeWidth = 10.0;

  clear() {
    setState(() {
      AllPathData.allPaths.clear();
      repaintListener.notifyListeners();
    });
  }

  /// Clear Widget
  Widget clearBtn(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.delete,
        size: 35,
      ),
      onPressed: () {
        clear();
      },
    );
  }

  /// onPan Methods for current line
  void _onPanStart(DragStartDetails details) {
    setState(() {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      Offset position = renderBox.globalToLocal(details.globalPosition);
      CurrentPathData.currentPath.add(position);
      /// Add the same position again to create a dot
      CurrentPathData.currentPath.add(position);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      CurrentPathData.currentPath
          .add(renderBox.globalToLocal(details.globalPosition));
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      repaintListener.notifyListeners();
      AllPathData.allPaths.add(AllPathData(
        path: List.from(CurrentPathData.currentPath),
        strokeWidth: strokeWidth,
        strokeColor: strokeColor,
      ));
      CurrentPathData.currentPath.clear();
    });
  }

  /// Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            /// Stack for holding 2 painters and UI
            child: Stack(
              children: [
                /// Background Custom Paint - LazyPainter
                RepaintBoundary(
                  key: linePainterKey,
                  child: Container(
                    color: Colors.white,
                    child: CustomPaint(
                      willChange: false,
                      isComplex: true,
                      size: Size.infinite,
                      painter: LazyPainter(AllPathData.allPaths, repaintListener),
                    ),
                  ),
                ),

                /// Current Path Custom Paint - CurrentLinePainter
                GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: RepaintBoundary(
                    key: currentPainterKey,
                    child: CustomPaint(
                      isComplex: true,
                      size: Size.infinite,
                      painter: CurrentLinePainter(
                        CurrentPathData.currentPath,
                        strokeWidth,
                        strokeColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: clearBtn(context),
    );
  }
}


