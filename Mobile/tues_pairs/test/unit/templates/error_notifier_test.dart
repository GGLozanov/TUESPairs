import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tues_pairs/templates/error_notifier.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();

  group('ErrorNotifier', () {
    test('Creates an errornotifier instance', () {
      ErrorNotifier errorNotifier = new ErrorNotifier();

      expect(errorNotifier, isA<ErrorNotifier>());
    });

    test('Toggles the error boolean property', () {
      ErrorNotifier errorNotifier = new ErrorNotifier();

      errorNotifier.toggleError();

      expect(errorNotifier.isError, isTrue);
    });

    test('Sets an error with a given message', () {
      ErrorNotifier errorNotifier = new ErrorNotifier();

      String errorMessage = 'Error message';
      errorNotifier.setError(errorMessage);

      expect(errorNotifier.isError, isTrue);
      expect(errorNotifier.errorMessage, equals(errorMessage));
    });

    test('Shows an error snackbar', () {
      ErrorNotifier errorNotifier = new ErrorNotifier();

      String errorMessage = 'Error message';
      errorNotifier.setError(errorMessage);
      var result = errorNotifier.showError();

      expect(result, isA<SnackBar>());
    });
  });

}