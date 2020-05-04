import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form/input_field.dart';

class PasswordInputField extends InputField {

  PasswordInputField({Key key, Function onChanged}) : super(key: key, onChanged: onChanged);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true, // obscures text (like for a password)
      onChanged: onChanged,
      style: textInputColor,
      validator: (value) => value.isEmpty ? 'Enter a password' : null,
      keyboardType: TextInputType.visiblePassword,
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.lock,
          color: Colors.orange,
        ),
        hintText: 'Enter a password',
      ),
    );
  }
}
