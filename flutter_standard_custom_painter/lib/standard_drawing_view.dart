import 'package:flutter/material.dart';
import 'package:flutter_standard_custom_painter/painters/all_path_data.dart';
import 'package:flutter_standard_custom_painter/painters/standard_line_painter.dart';
import 'package:flutter_standard_custom_painter/painters/current_path_data.dart';

/// Main view of the app.
/// You should see a blank white canvas with a garbage can icon
///
/// Author: Philip Lalonde
class StandardDrawingView extends StatefulWidget {
  const StandardDrawingView({Key? key}) : super(key: key);

  @override
  State<StandardDrawingView> createState() =>
      _StandardDrawingView();
}

class _StandardDrawingView extends State<StandardDrawingView> {

  /// Keys
  final GlobalKey standardPainterKey = GlobalKey();

  /// Stroke details
  final Color strokeColor = Colors.black;
  final double strokeWidth = 10.0;

  clear() {
    setState(() {
      AllPathData.allPaths.clear();
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
            child: Stack(
              children: [
                GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: RepaintBoundary(
                    key: standardPainterKey,
                    child: CustomPaint(
                      isComplex: true,
                      size: Size.infinite,
                      painter: StandardLinePainter(
                        CurrentPathData.currentPath,
                        AllPathData.allPaths,
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


