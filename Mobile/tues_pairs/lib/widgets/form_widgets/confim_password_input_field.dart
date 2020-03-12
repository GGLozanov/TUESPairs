import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';

class ConfirmPasswordInputField extends StatelessWidget {

  final Function onChanged;

  ConfirmPasswordInputField({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true, // obscures text (like for a password)
      style: textInputColor,
      onChanged: onChanged,
      validator: (value) => value.isEmpty ? 'Confirm password' : null,
      keyboardType: TextInputType.visiblePassword,
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.repeat,
          color: Colors.orange,
        ),
        hintText: 'Confirm password',
      ),
    );
  }
}
