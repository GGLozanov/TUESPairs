import 'package:flutter/material.dart';
import 'package:tues_pairs/locale/app_localization.dart';
import 'package:tues_pairs/templates/baseauth.dart';

class BaseAuthErrorDisplay extends StatefulWidget {
  final BaseAuth baseAuth;

  BaseAuthErrorDisplay({
    @required this.baseAuth
  }) : assert(baseAuth != null);

  @override
  _BaseAuthErrorDisplayState createState() => _BaseAuthErrorDisplayState();
}

class _BaseAuthErrorDisplayState extends State<BaseAuthErrorDisplay> {

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizator = AppLocalizations.of(context);

    return Column(
      children: widget.baseAuth.
        errorMessages?.map((message) => Text(
          localizator.translate(message),
          style: TextStyle(
            color: Colors.red,
            fontFamily: 'Nilam',
            fontSize: 25.0,
          ),
          textAlign: TextAlign.center,
      ))?.toList() ?? []
    );
  }
}
