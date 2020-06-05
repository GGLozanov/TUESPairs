import 'package:flutter/material.dart';
import 'package:tues_pairs/locale/app_localization.dart';

class CenteredText extends StatelessWidget {

  final String text;
  final double fontSize;

  CenteredText({
    this.text = 'empty',
    this.fontSize = 30.0
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizator = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Text(
          localizator.translate(text),
          style: TextStyle(
            color: Colors.orange,
            fontSize: fontSize,
            fontFamily: 'Nilam',
          ),
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}
