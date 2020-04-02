import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final String label;
  final VoidCallback callback;
  SendButton({this.label, this.callback});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(label),
    );
  }
}