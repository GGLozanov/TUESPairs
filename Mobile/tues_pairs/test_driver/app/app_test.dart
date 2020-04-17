import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/modules/user.dart';

void main() {

  final String loginTestUserEmail = 'katapultman150@gmail.com';
  final String loginTestUserPassword = 'popeye';

  // example user for registration
  final User registerUser = new User(
    email: 'example@gmail.com', password: 'examplepass',
    username: 'example',
    GPA: 5.45, isTeacher: false,
    photoURL: null,
  );

  group('App', () {

    final appFinder = find.byValueKey(Keys.app);

    final toggleToRegisterButtonFinder = find.byValueKey(Keys.toggleToRegisterButton);
    final toggleToLoginButtonFinder = find.byValueKey(Keys.toggleToLoginButton);

    final loginEmailInputFieldFinder = find.byValueKey(Keys.loginEmailInputField);
    final loginPasswordInputFieldFinder = find.byValueKey(Keys.loginPasswordInputField);
    final logInButtonFinder = find.byValueKey(Keys.logInButton);

    final registerUsernameInputFieldFinder = find.byValueKey(Keys.registerUsernameInputField);
    final registerEmailInputFieldFinder = find.byValueKey(Keys.registerEmailInputField);
    final registerPasswordInputFieldFinder = find.byValueKey(Keys.registerPasswordInputField);
    final registerConfirmPasswordInputFieldFinder = find.byValueKey(Keys.registerConfirmPasswordInputField);
    final registerGPAInputFieldFinder = find.byValueKey(Keys.registerGPAInputField);
    final isTeacherSwitchFinder = find.byValueKey(Keys.isTeacherSwitch);
    final registerButtonFinder = find.byValueKey(Keys.registerButton);

    final logOutButtonFinder = find.byValueKey(Keys.logOutButton);
    final bottomNavigationBarFinder = find.byValueKey(Keys.bottomNavigationBar);
    final settingsDeleteAccountButtonFinder = find.byValueKey(Keys.settingsDeleteAccountButton);

    FlutterDriver driver;

    Future<void> delay([int milliseconds = 250]) async { // function to simulate a delay in time
      await Future<void>.delayed(Duration(milliseconds: milliseconds));
    }

    Future<void> enterTextInFieldWithDelay(SerializableFinder field, String text, {int duration = 2000}) async {
      await driver.tap(field);

      delay(duration);

      await driver.enterText(text);

      delay(duration);
    }

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if(driver != null) {
        await driver.close();
      }
    });

    test('sign in, sign out', () async {
      // wait to ensure we're in the sign-in page and not already auth'd
      await driver.waitFor(logInButtonFinder);
      await driver.waitFor(loginEmailInputFieldFinder);
      await driver.waitFor(loginPasswordInputFieldFinder);

      await enterTextInFieldWithDelay(loginEmailInputFieldFinder, loginTestUserEmail);

      await enterTextInFieldWithDelay(loginPasswordInputFieldFinder, loginTestUserPassword);

      await driver.tap(logInButtonFinder);

      delay(2000);

      await driver.waitFor(logOutButtonFinder);

      delay(2000);

      await driver.tap(logOutButtonFinder);

    });

    test('register, delete', () async {
      await driver.waitFor(logInButtonFinder);
      await driver.waitFor(loginEmailInputFieldFinder);
      await driver.waitFor(loginPasswordInputFieldFinder);

      await driver.waitFor(toggleToRegisterButtonFinder);

      delay(2000);

      // switch to sign-up page
      await driver.tap(toggleToRegisterButtonFinder);

      delay(2000);

      // wait for the rendering of all the necessary widgets
      await driver.waitFor(registerUsernameInputFieldFinder);
      await driver.waitFor(registerEmailInputFieldFinder);
      await driver.waitFor(registerPasswordInputFieldFinder);
      await driver.waitFor(registerConfirmPasswordInputFieldFinder);
      await driver.waitFor(registerGPAInputFieldFinder);
      await driver.waitFor(isTeacherSwitchFinder);
      await driver.waitFor(registerButtonFinder);

      delay(2000);

      await enterTextInFieldWithDelay(registerEmailInputFieldFinder, registerUser.email);

      await enterTextInFieldWithDelay(registerUsernameInputFieldFinder, registerUser.username);

      await enterTextInFieldWithDelay(registerPasswordInputFieldFinder, registerUser.password);

      await enterTextInFieldWithDelay(registerConfirmPasswordInputFieldFinder, registerUser.password);

      await enterTextInFieldWithDelay(registerGPAInputFieldFinder, registerUser.GPA.toString());

      await driver.tap(registerButtonFinder);

      delay(2000);

      // wait for the rendering of navbar
      await driver.waitFor(bottomNavigationBarFinder);

      delay(2000);

      await driver.tap(find.text('Settings')); // botoomnavbar items don't have key properties, sadly

      delay(2000);

      await driver.waitFor(settingsDeleteAccountButtonFinder);

      delay(2000);

      await driver.tap(settingsDeleteAccountButtonFinder);

    });

    test('Initial app boot test', () async {
      await driver.waitFor(appFinder);
    });

    test('Check flutter driver health', () async {
      final health = await driver.checkHealth();
      expect(health.status, HealthStatus.ok);
    });

  });
}