import 'package:flutter/material.dart';

class ErrorNotifier {
  final String errorMessage;
  bool isError = false;

  ErrorNotifier({this.errorMessage});

  void toggleError() {
    isError = !isError;
  }

  void setError(String errorMessage) {
    errorMessage = errorMessage;
    toggleError();
  }

  SnackBar showError() { // Wrap in setState() always
    toggleError();
    return SnackBar(
      content: Text(
        errorMessage,
      ),
    );
  }

}