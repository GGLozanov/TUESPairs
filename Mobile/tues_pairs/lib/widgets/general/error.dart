import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Oops, an error occurred!',
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
