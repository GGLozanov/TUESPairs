import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/locale/app_localization.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/widgets/form/email_input_field.dart';
import 'package:tues_pairs/widgets/form/password_input_field.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/general/baseauth_error_display.dart';
import 'package:tues_pairs/widgets/general/localization_buttons.dart';
import 'package:tues_pairs/widgets/general/spaced_divider.dart';
import 'package:tues_pairs/widgets/login/forgot_password_form.dart';
import 'package:tues_pairs/widgets/register/register_form.dart';
import 'package:tues_pairs/widgets/register/register_wrapper.dart';

import '../../main.dart';
import '../../templates/baseauth.dart';
import '../authlistener.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  static bool isExternalCreated = false; // check if the user has successfully created an external account (used for authlistener)

  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final BaseAuth baseAuth = new BaseAuth();
  final GlobalKey _scaffold = GlobalKey(); // global key used to track the scaffold an the currentContext

  void _configureExternalSignIn(User authUser) {
    baseAuth.user = authUser;
    baseAuth.user.isTeacher = false;
    baseAuth.user.tagIDs = <String>[];

    AuthListener.externRegister.baseAuth = baseAuth;
    Login.isExternalCreated = true;
  }

  Future<void> _handleExternalSignIn(BuildContext context,
      {ExternalSignInType signInType = ExternalSignInType.GOOGLE}) async {

    switch(signInType) {
      case ExternalSignInType.FACEBOOK:
        // handle faceboook sign-in w/ auth here...
        baseAuth.authInstance.loginWithFacebook().then((authUser) =>
            _configureExternalSignIn(authUser)
        ).catchError((e) => logger.w('Login: User has cancelled/failed Facebook Sign-In. Rerendering login page'));
        break;
      case ExternalSignInType.GITHUB:
        // handle github sign-in w/ auth here...
        break;
      case ExternalSignInType.GOOGLE:
      default:
        // handle Google sign-in w/ auth here...
        // check if user is already registered (return value of signin method)
       // TODO: Handle incorrect user entry exceptions; setState(() => {}) ?
        baseAuth.authInstance.signInWithGoogle().then((authUser) =>
          _configureExternalSignIn(authUser)
        ).catchError((e) => logger.w('Login: User has cancelled/failed Google Sign-In. Rerendering login page'));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizator = AppLocalizations.of(context);

    return baseAuth.isLoading ? Loading() : Scaffold(
      key: _scaffold,
      appBar: buildAppBar(
        pageTitle: localizator.translate('login'),
        actions: <Widget>[
          FlatButton.icon(
            key: Key(Keys.toggleToRegisterButton),
            onPressed: () => widget.toggleView(), // since the toggleView() function is known in the context of the widget, we need to address the widget and then access it
            icon: Icon(
              Icons.person,
              color: Colors.orange,
              size: 30.0,
            ),
            label: Text(
              localizator.translate('register'),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                fontSize: 25.0,
              )
            ),
          ),
        ],
      ),

      // TODO: Animate this segment w/implicit animations

      body: Container(
        color: greyColor,
        child: ListView(
          children: [
           Form(
            key: baseAuth.key,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0), // Padding accessed by EdgeInsets
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                    child: Text(
                      localizator.translate('welcome'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange,
                        letterSpacing: 1.0,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  EmailInputField(
                    key: Key(Keys.loginEmailInputField),
                    onChanged: (value) => setState(() => baseAuth.user.email = value),
                    initialValue: baseAuth.user.email,
                  ),
                  SizedBox(height: 15.0), // SizedBox widget creates an invisible box with a height/width to help separate elements
                  PasswordInputField(
                    key: Key(Keys.loginPasswordInputField),
                    onChanged: (value) => setState(() => baseAuth.password = value),
                    hintText: 'enterPassword',
                  ),
                  SizedBox(height: 25.0),
                  InputButton(
                    key: Key(Keys.logInButton),
                    minWidth: 250.0,
                    height: 60.0,
                    text: 'login',
                    onPressed: () async {
                      if(baseAuth.key.currentState.validate()) {
                        setState(() => baseAuth.toggleLoading());

                        User user = await baseAuth.authInstance.loginUserByEmailAndPassword(baseAuth.user.email, baseAuth.password); // call the login method

                        if(user == null) {
                          logger.w('Login: Failed user login (invalid credentials)');
                          setState(() {
                            baseAuth.clearAndAddError('invalidLoginCredentials');
                          });
                        } else {
                          // Add the device token if not present in DB user
                          logger.i('Login: User w/ id "' + user.uid + '" has successfully logged in');
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          ForgotPasswordForm()
                      ),
                    ),
                    child: Text(
                      localizator.translate('resetPassword'),
                      key: Key(Keys.passwordForgotText),
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Nilam',
                        fontStyle: FontStyle.normal,
                        color: Colors.orange,
                      )
                    ),
                  ),
                  SizedBox(height: 5.0),
                  BaseAuthErrorDisplay(baseAuth: baseAuth,),
                  SpacedDivider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SignInButton(
                        Buttons.Facebook,
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        onPressed: () async => await _handleExternalSignIn(
                            _scaffold.currentContext,
                            signInType: ExternalSignInType.FACEBOOK
                        ),
                      ),
                      SizedBox(height: 15.0),
                      SignInButton(
                        Buttons.Google,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        onPressed: () async => await _handleExternalSignIn(
                            _scaffold.currentContext
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        localizator.translate('comingSoon'),
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 32.0,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      IgnorePointer( // TODO: Add GitHub
                        child: SignInButton(
                          Buttons.GitHub,
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          onPressed: () => {},
                        )
                      ),
                      SizedBox(height: 20.0),
                      LocalizationButtons()
                    ]
                  ),
                ],
              ),
            )
          )
        ],
       ),
      )
    );
  }
}

