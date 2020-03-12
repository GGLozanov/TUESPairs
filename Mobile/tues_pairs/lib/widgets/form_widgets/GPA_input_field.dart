import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';

class GPAInputField extends StatelessWidget {

  final Function onChanged;
  final String initialValue;

  GPAInputField({this.onChanged, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField( // if the current user wants to be a teacher, he doesn't need GPA field
      // parse the given string to a double
      initialValue: initialValue,
      style: textInputColor,
      onChanged: onChanged,
      validator: (value) {
        double GPA = double.tryParse(value);
        if(GPA == null || value.isEmpty || GPA < 2 || GPA > 6){
          return "Incorrect GPA (Range: 2 to 6)";
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.border_color,
          color: Colors.orange,
        ),
        hintText: 'Enter GPA throughout 8-12th grade',
      ),
    );
  }
}
