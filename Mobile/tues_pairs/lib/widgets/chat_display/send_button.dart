import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final String label;
  final VoidCallback callback;
  SendButton({this.label, this.callback});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: callback,
      color: Color.fromRGBO(34, 34, 43, 1),
      textColor: Colors.white,
      child: Icon(
        Icons.send,
        size: 26,
        color: Colors.orange,
      ),
      padding: EdgeInsets.all(14),
      shape: CircleBorder(),
    );
  }
}