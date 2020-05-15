import 'package:flutter/material.dart';

class CenteredText extends StatelessWidget {

  final String text;
  final double fontSize;

  CenteredText({
    this.text = '',
    this.fontSize = 30.0
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.orange,
            fontSize: fontSize,
          ),
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}
