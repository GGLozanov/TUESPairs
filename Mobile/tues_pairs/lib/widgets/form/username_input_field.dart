import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form/input_field.dart';

class UsernameInputField extends InputField {

  UsernameInputField({
    Key key,
    @required Function onChanged,
    String initialValue,
    int maxLines
  }) : super(key: key, onChanged: onChanged, initialValue: initialValue, maxLines: maxLines);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue ?? '',
      onChanged: onChanged,
      // validator property is used for the validation of separate TextFormFields (takes a function with a value and you can
      style: textInputColor,
      validator: (value) => value.isEmpty ? 'Enter a username' : null, // validator returns string (tag to put on the field if input is invalid)
      keyboardType: TextInputType.text, // optimize type set to e-mail
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.person,
          color: Colors.orange,
        ),
        hintText: 'Enter a username',
      ),
    );
  }
}
