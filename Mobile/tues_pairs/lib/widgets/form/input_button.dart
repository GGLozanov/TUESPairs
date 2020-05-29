import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';

import '../../locale/app_localization.dart';

class InputButton extends StatelessWidget {

  final double minWidth;
  final double height;
  final Function onPressed;
  final String text;
  final Color color;

  InputButton({
    Key key,
    @required this.minWidth,
    @required this.height,
    @required this.onPressed,
    @required this.text, 
    this.color = darkGreyColor}) :
      assert(minWidth != null),
      assert(height != null),
      assert(onPressed != null),
      assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizator = AppLocalizations.of(context);

    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      child: RaisedButton(
        child: Text(
          localizator.translate(text),
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        textColor: Colors.white,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: onPressed,
      ),
    );
  }
}
