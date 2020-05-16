import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';

class StepperButton extends StatelessWidget {

  final Key key;
  final Size screenSize;
  final Color color;
  final Widget child;
  final VoidCallback onPressed;

  const StepperButton({
    this.key,
    @required this.screenSize,
    this.color = darkGreyColor,
    @required this.onPressed,
    @required this.child
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ButtonTheme( // TODO: Maybe extract in widget
      height: screenSize.height / (widgetReasonableHeightMargin + 1),
      minWidth: screenSize.width / widgetReasonableWidthMargin,
      child: FlatButton(
        key: key,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23.0),
        ),
        child: child,
        onPressed: onPressed,
      )
    );
  }
}
