import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form/input_field.dart';

class ConfirmPasswordInputField extends InputField {

  final String sourcePassword;

  ConfirmPasswordInputField({
    Key key,
    @required Function onChanged,
    @required this.sourcePassword,
    String hintText = 'Confirm password',
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
    return TextFormField(
      obscureText: true, // obscures text (like for a password)
      onChanged: onChanged,
      style: textInputColor,
      validator: (value) {
        if(value.isEmpty) {
          return 'Enter confirm password';
        }

        if(value != sourcePassword) {
          return 'Passwords do not match!';
        }

        return null;
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.repeat,
          color: Colors.orange,
        ),
        hintText: hintText,
      ),
    );
  }
}
