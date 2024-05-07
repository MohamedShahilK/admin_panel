// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// import 'package:elegant_notification/elegant_notification.dart';

void customLoader(BuildContext context) {
  return Loader.show(
    context,
    progressIndicator: LoadingAnimationWidget.horizontalRotatingDots(
      color: Colors.purple[400]!,
      size: 40,
    ),
  );
}
