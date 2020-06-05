import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/shared/constants.dart';

import '../../locale/app_localization.dart';

// TODO: Clear code duplication in derived widgets

abstract class InputField extends StatelessWidget {

  final Function onChanged;
  final int maxLines;
  final String hintText;
  String initialValue;

  InputField({
    Key key,
    @required this.onChanged,
    this.initialValue,
    this.hintText = 'enter',
    this.maxLines = 1
  }) : assert(onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizator = AppLocalizations.of(context);

    return TextFormField( // if the current user wants to be a teacher, he doesn't need GPA field
      // parse the given string to a double
      style: textInputColor,
      maxLines: maxLines,
      validator: (value) => value.isEmpty ? localizator.translate('fieldMustNotBeEmpty') : null,
      keyboardType: TextInputType.text,
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.create,
          color: Colors.orange,
        ),
        hintText: localizator.translate(hintText),
      ),
    );
  }
}
