import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/locale/app_localization.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/main/home.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/form/confim_password_input_field.dart';
import 'package:tues_pairs/widgets/form/email_input_field.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form/password_input_field.dart';
import 'package:tues_pairs/widgets/general/baseauth_error_display.dart';
import 'package:tues_pairs/widgets/general/button_pair.dart';

import 'settings_password_form.dart';

/// This is a seperate route, which is why the Scaffold is being rerendered
class SettingsEmailForm extends StatefulWidget {
  BaseAuth baseAuth = new BaseAuth();

  @override
  _SettingsEmailFormState createState() => _SettingsEmailFormState();
}

class _SettingsEmailFormState extends State<SettingsEmailForm> {

  final Auth _auth = new Auth();

  String userPassword = '';
  String userConfirmPassword = '';
  final int maxSensitiveInfoLines = 5;

  bool isInvalidReauth = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);

    final screenSize = MediaQuery.of(context).size;
    final btnHeight = screenSize.height / (widgetReasonableHeightMargin - 1.25);
    final btnWidth = screenSize.width / (widgetReasonableWidthMargin - 1.25);

    final AppLocalizations localizator = AppLocalizations.of(context);

    return Scaffold( // Scaffold grants the material design palette and general layout of the app (properties like appBar)
      backgroundColor: greyColor,
      appBar: buildAppBar(
        pageTitle: localizator.translate('editEmail')
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Form(
              key: widget.baseAuth.key,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget> [
                    Center(
                      child: Image.asset(
                        'images/envelope_tues_pairs.png'
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text( // Wrap in align?
                      localizator.translate('changeSensitiveInformation'),
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 30.0,
                        color: Colors.orange,
                      ),
                      textAlign: TextAlign.center,
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
                      hintText: 'enterYourPassword',
                      maxLines: maxSensitiveInfoLines,
                    ),
                    SizedBox(height: 10.0),
                    ConfirmPasswordInputField(
                      onChanged: (value) => userConfirmPassword = value,
                      maxLines: maxSensitiveInfoLines,
                      sourcePassword: userPassword,
                    ),
                    SizedBox(height: 30.0),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          Provider<User>.value(
                              value: currentUser,
                              child: SettingsPasswordForm()
                          ),
                        )
                      ),
                      child: Text(
                        localizator.translate('changePassword'),
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
                      btnsHeight: btnHeight,
                      btnsWidth: btnWidth,
                      onLeftPressed: () =>
                        Navigator.pop(context),
                      onRightPressed: () async {
                        final currentState = widget.baseAuth.key.currentState;
                        widget.baseAuth.errorMessages = [];

                        try {
                          if(currentState.validate() &&
                              userPassword != '' &&
                              (currentUser.email != null || currentUser.email != '') &&
                              userConfirmPassword == userPassword) {

                            final currentFirebaseUser = await _auth.currentUser;
                            String currentEmail = currentFirebaseUser.email; // email in FirebaseSDK

                            if(currentEmail == currentUser.email) {
                              widget.baseAuth.errorMessages.add('emailNotChanged');
                              throw new PlatformException(
                                  code: 'ERROR_EMAIL_NOT_CHANGED',
                                  message: 'User has entered an unchanged e-mail. Do not update e-mail!'
                              );
                            }

                            try {
                              await currentFirebaseUser.updateEmail(
                                  currentUser.email
                              ).catchError((e) {
                                logger.e('SettingsSensitive: UpdateEmail ' + e.toString());
                                widget.baseAuth.errorMessages.add('emailNotChangedRelog');
                                throw new PlatformException(
                                    code: 'ERROR_INCORRECT_EMAIL',
                                    message: 'User has entered an incorrect e-mail (may be in use). Do not update e-mail!'
                                );
                              });
                              await currentFirebaseUser.reauthenticateWithCredential(
                                EmailAuthProvider.getCredential(
                                  email: currentUser.email,
                                  password: userPassword,
                                )
                              ).catchError((e) async {
                                  logger.e('SettingsSensitive: Reauthenticate ' + e.toString());
                                  currentUser.email = currentEmail;
                                  await currentFirebaseUser.updateEmail(currentEmail); // update back to old e-mail
                                  widget.baseAuth.errorMessages.add('invalidPassword');
                                  throw new PlatformException(
                                    code: 'ERROR_INCORRECT_PASSWORD',
                                    message: 'User has entered an incorrect password. Do not update e-mail!'
                                  );
                              });
                            } catch(e) {
                              logger.e('SettingsSensitive: UpdateEmail ' +
                                  e.toString());
                              logger.i(
                                  'SettingsSensitive: Reauth is invalid. Ending.');

                              throw new PlatformException(
                                code: 'ERROR_REAUTH_FAILED',
                                message: 'User reauth has failed. Do not update e-mail!'
                              );
                            }

                            setState(() =>
                                widget.baseAuth.toggleLoading()
                            );
                            await Database(uid: currentUser.uid).updateUserData(currentUser); // update e-mail in DB
                            Home.selectedIndex = 2; // change selected page indexw
                            Navigator.pop(context);

                          } else {
                            logger.e('SettingsSensitive: Current user has entered incorrect form information.');
                            widget.baseAuth
                                .clearAndAddError('invalidFormsOrPasswordsMismatch');
                            throw new PlatformException(
                                code: 'ERROR_FORM_INVALID',
                                message: 'User has written incorrect info in forms. Cancel update!'
                            );
                          }
                        } catch(e) {
                          setState(() => {}); // trigger setState for errors
                        }
                      }
                    ),
                    SizedBox(height: 30.0),
                    BaseAuthErrorDisplay(baseAuth: widget.baseAuth,)
                  ]
                ),
              )
            ),
          ],
        )
      )
    );
  }
}
