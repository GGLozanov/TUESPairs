import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form/input_field.dart';

class ConfirmPasswordInputField extends InputField {

  ConfirmPasswordInputField({
    Key key,
    @required Function onChanged,
    int maxLines
  }) : super(key: key, onChanged: onChanged, maxLines: maxLines);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true, // obscures text (like for a password)
      onChanged: onChanged,
      style: textInputColor,
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
