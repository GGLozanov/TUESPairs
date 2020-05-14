import 'package:flutter/material.dart';

class CenteredText extends StatelessWidget {

  final String text;

  CenteredText({
    this.text = ''
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
            fontSize: 30.0,
          ),
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}
