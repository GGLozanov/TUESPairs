import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form/input_field.dart';

import '../../locale/app_localization.dart';

class PasswordInputField extends InputField {

  PasswordInputField({
    Key key,
    @required Function onChanged,
    @required String hintText,
    int maxLines
  }) : assert(onChanged != null),
       assert(hintText != null),
        super(
          key: key,
          onChanged: onChanged,
          maxLines: maxLines,
          hintText: hintText
  );

  @override
  Widget build(BuildContext context) {

    final AppLocalizations localizator = AppLocalizations.of(context);

    return TextFormField(
      obscureText: true, // obscures text (like for a password)
      onChanged: onChanged,
      style: textInputColor,
      validator: (value) {
        if(value.isEmpty) {
          return localizator.translate('enterPassword');
        }
        if(value.length < 6) {
          return localizator.translate('longerPassword');
        }
        return null;
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.lock,
          color: Colors.orange,
        ),
        hintText: localizator.translate(hintText),
      ),
    );
  }
}
