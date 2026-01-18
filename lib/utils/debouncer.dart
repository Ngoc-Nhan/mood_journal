import 'dart:async';
import 'package:flutter/foundation.dart'; // for VoidCallback

class Debouncer {
  final Duration interval;
  VoidCallback? _action;
  Timer? _timer;

  Debouncer({
    this.interval = const Duration(milliseconds: 500),
  }); // 500ms is a good default

  void run(VoidCallback action) {
    _action = action;
    _timer?.cancel(); // Cancel the previous timer
    _timer = Timer(interval, _executeAction); // Start a new timer
  }

  void _executeAction() {
    _action?.call();
    _timer = null;
  }
}
