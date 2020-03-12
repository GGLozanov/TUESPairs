import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';

class UsernameInputField extends StatelessWidget {

  final Function onChanged;
  final String initialValue;

  UsernameInputField({this.onChanged, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue ?? '',
      onChanged: onChanged, // onChanged property takes a function with val and can be used to update our form properties with the passed values
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
