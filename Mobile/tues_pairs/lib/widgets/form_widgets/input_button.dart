import 'package:flutter/material.dart';

class InputButton extends StatelessWidget {

  final double minWidth;
  final double height;
  final Function onPressed;
  final String text;

  InputButton({this.minWidth, this.height, this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        textColor: Colors.white,
        color: Color.fromRGBO(33, 36, 44, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () => onPressed(),
      ),
    );
  }
}
