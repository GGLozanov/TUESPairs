import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form_widgets/input_field.dart';

class PasswordInputField extends InputField {

  PasswordInputField({Function onChanged}) : super(onChanged: onChanged);


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
