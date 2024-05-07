import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension OnPressed on Widget {
  Widget ripple(
    BuildContext context,
    Function onPressed, {
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(5)),
    Color? overlayColor,
  }) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: borderRadius),
                ),
                overlayColor: MaterialStateProperty.all(
                  overlayColor ?? Colors.green.withOpacity(.25),
                ),
              ),
              onPressed: () async {
                await HapticFeedback.vibrate();
                onPressed();
              },
              // onPressed: Feedback.wrapForTap(
              //   () async {
              //     await HapticFeedback.vibrate();
              //     onPressed();
              //   },
              //   context,
              // ),
              child: Container(),
            ),
          )
        ],
      );
}
