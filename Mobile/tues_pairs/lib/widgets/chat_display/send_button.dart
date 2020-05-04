import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';

class SendButton extends StatelessWidget {
  final String label;
  final VoidCallback callback;
  SendButton({this.label, this.callback});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: callback,
      color: darkGreyColor,
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