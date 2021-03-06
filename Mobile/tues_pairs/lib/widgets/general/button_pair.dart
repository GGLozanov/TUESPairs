import 'package:flutter/material.dart';
import 'package:tues_pairs/locale/app_localization.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';

class ButtonPair extends StatelessWidget {

  final Key leftBtnKey;
  final Key rightBtnKey;
  final double btnsWidth;
  final double btnsHeight;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;
  final String leftBtnText;
  final String rightBtnText;
  final Color leftBtnColor;
  final Color rightBtnColor;

  ButtonPair({
    Key key,
    this.leftBtnKey,
    this.rightBtnKey,
    this.btnsHeight = 600 / widgetReasonableHeightMargin,
    this.btnsWidth = 300 / widgetReasonableWidthMargin,
    @required this.onLeftPressed,
    @required this.onRightPressed,
    this.leftBtnText = 'back',
    this.rightBtnText = 'confirm',
    this.leftBtnColor = darkGreyColor,
    this.rightBtnColor = darkGreyColor
  }) :
      assert(onLeftPressed != null),
      assert(onRightPressed != null),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InputButton(
          key: leftBtnKey,
          minWidth: btnsWidth,
          height: btnsHeight,
          text: leftBtnText,
          onPressed: onLeftPressed,
          color: leftBtnColor
        ),
        SizedBox(width: 5.0),
        InputButton(
          key: rightBtnKey,
          minWidth: btnsWidth,
          height: btnsHeight,
          text: rightBtnText,
          onPressed: onRightPressed,
          color: rightBtnColor
        ),
      ],
    );
  }
}
