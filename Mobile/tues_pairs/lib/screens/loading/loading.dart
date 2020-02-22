import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal[400],
      child: Center(
        child: SpinKitCircle(
          color: Colors.tealAccent[400],
          size: 80.0,
        )
      )
    );
  }
}
