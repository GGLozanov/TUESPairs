import 'package:flutter/material.dart';
import 'package:tues_pairs/locale/app_localization.dart';
import 'package:tues_pairs/shared/constants.dart';

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizator = AppLocalizations.of(context);

    logger.e('Error: Error encountered and being rendered');
    return Container(
      alignment: Alignment.center,
      child: Text(
        localizator.translate('error'),
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
