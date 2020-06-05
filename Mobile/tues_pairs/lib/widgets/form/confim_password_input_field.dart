import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form/input_field.dart';

import '../../locale/app_localization.dart';

class ConfirmPasswordInputField extends InputField {

  final String sourcePassword;

  ConfirmPasswordInputField({
    Key key,
    @required Function onChanged,
    @required this.sourcePassword,
    String hintText = 'confirmPassword',
    int maxLines
  }) :
    assert(onChanged != null),
    assert(sourcePassword != null),
    super(
      key: key,
      onChanged: onChanged,
      hintText: hintText,
      maxLines: maxLines,
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
          return localizator.translate('enterConfirmPassword');
        }

        if(value != sourcePassword) {
          return localizator.translate('passwordsDoNotMatch');
        }

        return null;
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.repeat,
          color: Colors.orange,
        ),
        hintText: localizator.translate(hintText),
      ),
    );
  }
}
