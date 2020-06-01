import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/locale/application.dart';

import '../../main.dart';

class LocalizationButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
          child: Flag(
            'us',
            height: 50,
            width: 100,
          ),
          onTap: () async {
            await App.sharedPreferences.setString('lang', 'English');
            applic.changeLanguage('English');
          }
        ),
        GestureDetector(
          child: Flag(
            'bg',
            height: 50,
            width: 100,
          ),
          onTap: () async {
            await App.sharedPreferences.setString('lang', 'Български');
            applic.changeLanguage('Български');
          }
        ),
      ],
    );
  }
}
