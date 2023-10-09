# flutter_standard_custom_painter

A simple paint app using a standard implementation of the Flutter CustomPainter class.

# Problem
App performance is directly tied to how many paths you draw. 
This means that the more paths you have, the more lag you experience.

# Cause
The `CustomPainter` class, continuously refreshes, and attempts to re-render the current path and all drawn paths with each refresh.

This `@override` method in `CustomPainter` is set to `true`, letting the painter know that we want to repaint on every change in the painter.
Consider setting this value to `false` to see what happens. 

```dart
/// Repaint is always true as we want to refresh and display whenever a new
/// offset is added to the current path. Or if all path data is changed.
@override
bool shouldRepaint(StandardLinePainter oldDelegate) => true;
```

# Effect
When drawing even simple drawings, the refresh rate drops down below 10fps causing unusable lag, and your current line trails far behind your finger. 

# Soloution?
What would happen if we decouple the refresh of all lines, from the refresh of the current line? 
Why are we refreshing all drawn lines, when they are not changing?

Check out https://github.com/lalondeph/flutter_performance_painter for an optimized implementation of Flutter CustomPainter.

To compare flutter to native Java painter, check out https://github.com/lalondeph/java_painter