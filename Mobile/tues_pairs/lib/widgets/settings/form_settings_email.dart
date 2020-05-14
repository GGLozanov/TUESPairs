import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/main/home.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/form/confim_password_input_field.dart';
import 'package:tues_pairs/widgets/form/email_input_field.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form/password_input_field.dart';
import 'package:tues_pairs/widgets/general/button_pair.dart';
import 'package:tues_pairs/widgets/general/spaced_divider.dart';

import 'form_settings_password.dart';

/// This is a seperate route, which is why the Scaffold is being rerendered
class FormSettingsEmail extends StatefulWidget {
  BaseAuth baseAuth = new BaseAuth();

  @override
  _FormSettingsEmailState createState() => _FormSettingsEmailState();
}

class _FormSettingsEmailState extends State<FormSettingsEmail> {

  final Auth _auth = new Auth();

  String userPassword = '';
  String userConfirmPassword = '';
  final int maxSensitiveInfoLines = 5;

  void _triggerError() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final currentUser = Provider.of<User>(context);

    return Scaffold( // Scaffold grants the material design palette and general layout of the app (properties like appBar)
      backgroundColor: greyColor,
      appBar: buildAppBar(pageTitle: 'Settings'),
      body: Container(
        child: Form(
          key: widget.baseAuth.key,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget> [
                Text( // Wrap in align?
                  'You can change your sensitive information (E-mail, password) in these pages.',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 30.0,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 25.0),
                EmailInputField(
                  onChanged: (value) => currentUser.email = value,
                  initialValue: currentUser.email,
                  maxLines: maxSensitiveInfoLines,
                ),
                SizedBox(height: 10.0),
                PasswordInputField(
                  onChanged: (value) => userPassword = value,
                  hintText: 'Enter your password',
                  maxLines: maxSensitiveInfoLines,
                ),
                SizedBox(height: 10.0),
                ConfirmPasswordInputField(
                  onChanged: (value) => userConfirmPassword = value,
                  maxLines: maxSensitiveInfoLines,
                ),
                SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        Provider<User>.value(
                            value: currentUser,
                            child: FormSettingsPassword()
                        ),
                      )
                  ),
                  child: Text(
                      'Change password?',
                      style: TextStyle(
                        fontFamily: 'Nilam',
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      )
                  ),
                ),
                SizedBox(height: 30.0),
                ButtonPair(
                  leftBtnKey: Key(Keys.settingsEmailFormBackButton),
                  rightBtnKey: Key(Keys.settingsEmailFormConfirmButton),
                  btnsHeight: screenSize.height / widgetReasonableHeightMargin,
                  btnsWidth: screenSize.width / widgetReasonableWidthMargin,
                  onLeftPressed: () =>
                    Navigator.pop(context),
                  onRightPressed: () async {
                    final currentState = widget.baseAuth.key.currentState;
                    if(currentState.validate() &&
                        userPassword != '' &&
                        (currentUser.email != null || currentUser.email != '') &&
                        userConfirmPassword == userPassword) {
                      setState(() =>
                          widget.baseAuth.toggleLoading());
                      final currentFirebaseUser = await _auth.currentUser;
                      try {
                        currentFirebaseUser.updateEmail(currentUser.email).then((_) async =>
                          await currentFirebaseUser.reauthenticateWithCredential(
                              EmailAuthProvider.getCredential(
                                email: currentUser.email,
                                password: userPassword,
                              )
                          )
                        ).catchError((e) => logger.e('SettingsSensitive: ' + e.toString()));
                      } catch(e) {
                        logger.e('SettingsSensitive: ' + e.toString());
                        _triggerError();
                        return;
                      }

                      await Database(uid: currentUser.uid).updateUserData(currentUser); // update e-mail in DB
                      widget.baseAuth.errorMessages = [];
                      Navigator.pop(context);
                    } else {
                      _triggerError();
                    }
                  }
                ),
                SizedBox(height: 30.0),
                Column(
                  children: widget.baseAuth.
                    errorMessages?.map((message) => Text(
                    "$message",
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Nilam',
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ))?.toList() ?? [],
                ),
              ]
            ),
          )
        )
      )
    );
  }
}
