import 'dart:async';

import 'package:flutter/cupertino.dart';

/// Listener to trigger a repaint of all paths
///
/// Author: Philip Lalonde
class RepaintListener implements Listenable {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  @override
  void addListener(VoidCallback listener) {
    _controller.stream.listen((_) => listener());
  }

  @override
  void removeListener(VoidCallback listener) {}

  void notifyListeners() {
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
