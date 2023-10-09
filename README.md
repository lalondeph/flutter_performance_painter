
# Flutter Performance Painter

---

This project is meant to show and explain my new implementation of the `CustomPainter` class.
I built a drawing app a few years ago in Java and eventually rebuilt it in Flutter. It looked beautiful but suffered from what I now know are predictable performance issues with non-native frameworks. Here is how I solved my problem, I'd love to hear your thoughts or see if we can make this even better!

I used multitouch in Flutter `GestureDetector` to draw paths with many points to test app performance. On the left we have the classic `CustomPainter` and on the right we have my new `PerformancePainter`. With multitouch, and screen recording on, the performance is lower than 'normal' but these results are present across tests. The classic implimentation gets worse performance over time while the performance version stays relatively steady. This is a simplified test, but the results are typical across my testing.

![New Performance Painter](https://github.com/lalondeph/flutter_performance_painter/assets/56025884/68301e88-25a2-4c1a-9a1f-8bef14fd0f98)

## TL;DR

I significantly\* boosted the performance of my Flutter painting app by using a `Stack` of 2 `CustomPainter`s.
 
- `LazyPainter` repaints drawn lines via a `Listenable`.
- `CurrentLinePainter` is inside a `GestureDetector` and repaints the current line while you draw. 

By decoupling the old and new lines, when you draw a new line, it's refreshed as if it's the only line being drawn (because it is!)

\* in testing I saw a jump from `<10 fps` to `>60 fps` \*

## User Feedback

The first/only user complaint came from my son, when he drew, the line didn't keep up with his finger. Since I built this app for my kids, his perspective was especially important.

The app was lagging on his low-end Kindle Fire Tablet. I thought it may have been an issue with the deployment on Amazon, but I was also able to recreate this lag on a 'flagship' device. Eventually, it was clear that the loop inside of the `paint` method of `CustomPainter` was to blame.

## Problems

This issue had 2 parts:

1. Current line responsiveness is directly tied to how many paths you draw. 
2. All paths (try to) refresh constantly, even if they have not changed.

## Cause

The `CustomPainter` class, continuously refreshes, and attempts to re-render the current path and all drawn paths with each refresh.

This `@override` method in `CustomPainter` is set to `true`, letting the painter know that we want to repaint on every change in the painter.
Consider setting this value to `false` to see what happens. 

```dart
/// Repaint is always true as we want to refresh and display whenever a new
/// offset is added to the current path. Or if all path data is changed.
@override
bool shouldRepaint(StandardLinePainter oldDelegate) => true;
```

You will find a standard implementation with this flaw in `flutter_standard_custom_painter`. This is common across 'Flutter Drawing App' tutorials.

## Effect

When drawing even simple drawings, the refresh rate drops down below 10fps causing unusable lag, and your current line trails far behind your finger. 

## Solution?

Here is what I did to address the 2 problems with the current implementation of `CustomPainter`

> 1. Current line responsiveness is directly tied to how many paths you draw.

Our paint app as 2 distinct line types. 
- The line you are currently drawing.
- Completed lines.

I started by creating one `CustomPainter` for each line type. With those distinct types decoupled, I can optimize the current line painter to be responsive, while the complete line painter only repaints when a new finished path is added.

> 2. All paths (try to) refresh constantly, even if they have not changed. 

The answer to this part was surprisingly elegant and partly built into `CustomPainter`.

Below is an extract from `CustomPainter`:

```dart
abstract class CustomPainter extends Listenable {
  /// Creates a custom painter.
  ///
  /// The painter will repaint whenever `repaint` notifies its listeners.
  const CustomPainter({ Listenable? repaint }) : _repaint = repaint;

  final Listenable? _repaint;
```

Here we see that `CustomPainter` **extends Listenable**! This discovery was the beginning of my solution. I can explicitly tell the painter when to redraw instead of leaving it to its own power hungry devices.

For good measure, I also added a `RepaintBoundary` widget to each CustomPainter which,

> Creates a widget that isolates repaints.

With these 2 solutions implemented, our widget ends up looking something like this. Here was have a `Stack` with 2 `CustomPainter` widgets, one of those being the child of a `GestureDetector`

```dart
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
``` 

Huge thank you to Bruno, Will and Graham for feedback and advice. Also a big thanks to the FLutter Discord for providing friendly help.
