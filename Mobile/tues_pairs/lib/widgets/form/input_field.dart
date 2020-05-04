import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/shared/constants.dart';

// TODO: Clear code duplication in derived widgets

abstract class InputField extends StatelessWidget {

  final Key key;
  final Function onChanged;
  String initialValue;

  InputField({this.key, this.onChanged, this.initialValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField( // if the current user wants to be a teacher, he doesn't need GPA field
      // parse the given string to a double
      style: textInputColor,
      validator: (value) => value.isEmpty ? 'Field must not be empty' : null,
      keyboardType: TextInputType.text,
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.create,
          color: Colors.orange,
        ),
        hintText: 'Enter GPA throughout 8-12th grade',
      ),
    );
  }
}
