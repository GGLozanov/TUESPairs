import 'package:flutter/material.dart';
import 'package:tues_pairs/widgets/form/input_field.dart';
import 'package:tues_pairs/shared/constants.dart';

class DescriptionInputField extends InputField {

  final bool isTeacher; // is the user a teacher or not
  String descriptionTag; // tag to append at the end ('interest'/'idea')

  DescriptionInputField({
    Key key,
    @required onChanged,
    @required this.isTeacher,
    String initialValue,
    int maxLines
  }) : assert(isTeacher != null),
    descriptionTag = isTeacher ? 'qualifiactions as a teacher' :
    'TUES diploma project idea',
    super(
      key: key,
      onChanged: onChanged,
      initialValue: initialValue,
      hintText: 'Describe your ' + (isTeacher ? 'qualifiactions as a teacher' :
        'TUES diploma project idea') + ' (Optional)', // have to repeat this here because descriptionTag isn't static
      maxLines: maxLines,
    );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue ?? '',
      onChanged: onChanged,
      style: textInputColor,
      validator: (value) {
        if(value.length > 200) {
          return 'Enter a shorter' + descriptionTag;
        }
        return null;
      }, // validator property is used for the validation of separate TextFormFields (takes a function with a value and you can
      // validator returns string (tag to put on the field if input is invalid)
      keyboardType: TextInputType.multiline, // optimize type set to e-mail
      textCapitalization: TextCapitalization.sentences,
      maxLines: null,
      decoration: textInputDecoration.copyWith(
        icon: Icon(
          Icons.code,
          color: Colors.orange,
        ),
        hintText: hintText,
      ),
    );
  }

}