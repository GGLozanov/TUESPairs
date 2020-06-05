import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form/input_field.dart';

import '../../locale/app_localization.dart';

class EmailInputField extends InputField {

  EmailInputField({
    Key key,
    @required Function onChanged,
    String initialValue,
    String hintText = 'email',
    int maxLines
  }) : super(
      key: key,
      onChanged: onChanged,
      initialValue: initialValue,
      hintText: hintText,
      maxLines: maxLines
    );

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizator = AppLocalizations.of(context);

    return TextFormField(
      initialValue: initialValue ?? '',
      onChanged: onChanged,
      style: textInputColor,
      validator: (value) {
        if(value.isEmpty) {
          return localizator.translate('enterEmail');
        }
        if(!EmailValidator.validate(value)) {
          return localizator.translate('enterFormattedEmail');
        }
        return null;
      }, // validator property is used for the validation of separate TextFormFields (takes a function with a value and you can
      // validator returns string (tag to put on the field if input is invalid)
      keyboardType: TextInputType.emailAddress, // optimize type set to e-mail
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.mail,
          color: Colors.orange,
        ),
        hintText: localizator.translate(hintText),
      ),
    );
  }
}
