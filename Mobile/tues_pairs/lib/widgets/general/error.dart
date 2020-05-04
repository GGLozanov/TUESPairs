import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.e('Error: Error encountered and being rendered');
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Oops, an error occurred!',
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
