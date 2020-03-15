import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form_widgets/input_field.dart';

class EmailInputField extends InputField {

  EmailInputField({Function onChanged, String initialValue}) : super(onChanged: onChanged, initialValue: initialValue);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue ?? '',
      onChanged: onChanged,
      style: textInputColor,
      validator: (value) => value.isEmpty ? 'Enter an e-mail' : null,  // validator property is used for the validation of separate TextFormFields (takes a function with a value and you can
      // validator returns string (tag to put on the field if input is invalid)
      keyboardType: TextInputType.emailAddress, // optimize type set to e-mail
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.mail,
          color: Colors.orange,
        ),
        hintText: 'Enter an e-mail',
      ),
    );
  }
}
