import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( // TO-DO: Encapsulate widget in one class
            backgroundColor: Colors.grey[400],
            title: Text(
                'Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                )
            ),
        ),

        body: Container()
    );
  }
}
