import 'package:flutter/material.dart';

class ErrorNotifier {
  String errorMessage;
  bool isError = false;

  ErrorNotifier({this.errorMessage});

  void toggleError() {
    isError = !isError;
  }

  void setError(String errorMessage) {
    this.errorMessage = errorMessage;
    isError = true;
  }

  SnackBar showError() { // Wrap in setState() always
    isError = false;
    return SnackBar(
      content: Text(
        errorMessage,
      ),
    );
  }
}