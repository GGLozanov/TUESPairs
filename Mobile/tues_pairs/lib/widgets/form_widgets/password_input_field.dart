import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';

class PasswordInputField extends StatelessWidget {

  final Function onChanged;

  PasswordInputField({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true, // obscures text (like for a password)
      style: textInputColor,
      onChanged: onChanged,
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
