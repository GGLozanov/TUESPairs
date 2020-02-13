import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        title: Text(
            'TUESPairs',
            style: TextStyle(
              color: Colors.deepOrangeAccent[400],
           )
      ),

        centerTitle: true,
      ),

      body: Container(
        color: Colors.amber[600],
      )
    );
  }
}

