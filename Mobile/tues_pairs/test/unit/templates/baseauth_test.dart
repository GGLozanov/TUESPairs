import 'package:flutter_test/flutter_test.dart';
import 'package:tues_pairs/templates/baseauth.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();

  group('BaseAuth', () {
    test('Creates a baseauth instance', () {
      BaseAuth baseAuth = new BaseAuth();

      expect(baseAuth, isA<BaseAuth>());
    });

    test('Toggles the error boolean property', () {
      BaseAuth baseAuth = new BaseAuth();

      baseAuth.toggleLoading();

      expect(baseAuth.isLoading, isTrue);
    });
  });
}