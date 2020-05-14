import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';

class SpacedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 30.0),
        Divider(height: 15.0, thickness: 10.0, color: darkGreyColor),
        SizedBox(height: 30.0),
      ]
    );
  }
}
