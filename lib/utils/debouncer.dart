import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  Debouncer({required this.milliseconds, this.timer, this.action});
  final int milliseconds;
  VoidCallback? action;
  Timer? timer;

  void run(VoidCallback action) {
    if (timer != null) {
      timer?.cancel();
    }

    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
