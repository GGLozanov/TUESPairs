import 'package:flutter/material.dart';

class StepInfo {
  final int stepIdx;
  final String name;
  final GlobalKey<FormState> formKey; // globalkeys used to validate each stepper form
  bool isInputField;

  StepInfo({
    @required this.stepIdx,
    @required this.name,
    this.formKey
  }) : assert(stepIdx != null), assert(name != null) {
    isInputField = formKey == null ? false : true;
  }

  bool isFormValid({bool shouldSave = true}) {
    if(!isInputField) {
      return true;
    }

    final currentFormState = formKey.currentState;

    if(currentFormState == null) {
      return false;
    }

    if(shouldSave) {
      currentFormState.save();
    }

    return currentFormState.validate();
  }

}