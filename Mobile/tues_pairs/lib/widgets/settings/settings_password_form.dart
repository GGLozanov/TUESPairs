import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/locale/app_localization.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/main/home.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/form/confim_password_input_field.dart';
import 'package:tues_pairs/widgets/form/password_input_field.dart';
import 'package:tues_pairs/widgets/general/baseauth_error_display.dart';
import 'package:tues_pairs/widgets/general/button_pair.dart';

class SettingsPasswordForm extends StatefulWidget {
  BaseAuth baseAuth = new BaseAuth(); // TODO: cut down on the keys because they're expensive!

  @override
  _SettingsPasswordFormState createState() => _SettingsPasswordFormState();
}

class _SettingsPasswordFormState extends State<SettingsPasswordForm> {

  final Auth _auth = new Auth();

  String oldUserPassword = '';
  String newUserPassword = '';
  String newUserConfirmPassword = '';

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);

    final screenSize = MediaQuery.of(context).size;
    final btnHeight = screenSize.height / (widgetReasonableHeightMargin - 1.25);
    final btnWidth  = screenSize.width / (widgetReasonableWidthMargin - 1.25);

    final AppLocalizations localizator = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: greyColor,
      appBar: buildAppBar(
        pageTitle: localizator.translate('editPassword'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Form(
              key: widget.baseAuth.key,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        'images/lock_tues_pairs.png'
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      localizator.translate('changePasswordHere'),
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 30.0,
                        color: Colors.orange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15.0),
                    PasswordInputField(
                      key: Key(Keys.settingsPasswordFormOldPasswordInputField),
                      hintText: 'oldPassword',
                      onChanged: (value) => oldUserPassword = value,
                    ),
                    SizedBox(height: 15.0),
                    PasswordInputField(
                      key: Key(Keys.settingsPasswordFormPasswordInputField),
                      hintText: 'newPassword',
                      onChanged: (value) => newUserPassword = value,
                    ),
                    SizedBox(height: 15.0),
                    ConfirmPasswordInputField(
                      key: Key(Keys.settingsPasswordFormConfirmPasswordInputField),
                      hintText: 'confirmNewPassword',
                      onChanged: (value) => newUserConfirmPassword = value,
                      sourcePassword: newUserPassword,
                    ),
                    SizedBox(height: 30.0),
                    ButtonPair(
                      leftBtnKey: Key(Keys.settingsPasswordFormBackButton),
                      rightBtnKey: Key(Keys.settingsPasswordFormConfirmButton),
                      btnsHeight: btnHeight,
                      btnsWidth: btnWidth,
                      onLeftPressed: () =>
                        Navigator.pop(context),
                      onRightPressed: () async {
                        final currentState = widget.baseAuth.key.currentState;
                        widget.baseAuth.errorMessages = [];

                        try {
                          if(currentState.validate() &&
                            oldUserPassword != '' &&
                            (currentUser.email != null || currentUser.email != '') &&
                            newUserConfirmPassword != '' && newUserPassword != '' &&
                            newUserPassword == newUserConfirmPassword) {

                              if(oldUserPassword == newUserPassword) {
                                logger.e('SettingsPassword: Old password and new password match!');
                                widget.baseAuth.clearAndAddError(
                                    'oldPasswordSameAsNew'
                                );
                                throw new PlatformException(
                                  code: 'ERROR_INVALID_PASSWORD_SELECTION',
                                  message: 'User has entered the same password for both new and old. Cancel update!'
                                );
                              }

                              final _authCredential = EmailAuthProvider.getCredential(
                                email: currentUser.email,
                                password: oldUserPassword
                              );

                              final currentFirebaseUser = await _auth.currentUser; // TODO: Optimise these calls to currentUser (provider?)

                              try {
                                await currentFirebaseUser.reauthenticateWithCredential(_authCredential)
                                  .then((_) async {
                                     // update the password
                                    currentFirebaseUser
                                      .updatePassword(newUserPassword).then((_) async {
                                      await currentFirebaseUser.reauthenticateWithCredential( // reauth w/ new password
                                        EmailAuthProvider.getCredential(
                                          email: currentUser.email,
                                          password: newUserPassword,
                                        )
                                      )
                                      .catchError((e) {
                                        logger.e('SettingPassword: Reauth with new password ' + e.toString());
                                        widget.baseAuth.errorMessages.add(
                                          'newPasswordsMismatchOrInvalid'
                                        );
                                        throw new PlatformException(
                                          code: 'ERROR_INCORRECT_NEW_PASSWORD',
                                          message: 'User has inputted an incorrect new password! Cancelling update and reauth!'
                                        );
                                    });
                                  }).catchError((e) {
                                    logger.e('SettingPassword: UpdatePassword ' + e.toString());
                                    widget.baseAuth.errorMessages.add(
                                        'passwordUpdateFailTryLonger'
                                    );
                                    throw new PlatformException(
                                        code: 'ERROR_BAD_PASSWORD',
                                        message: 'User has inputted a bad new password for update! Cancelling update and reauth!'
                                    );
                                  });
                                }).catchError((e) {
                                  logger.e('SettingPassword: Reauth with old password ' + e.toString());
                                  widget.baseAuth.errorMessages.add(
                                      'newPasswordsMismatchOrInvalid'
                                  );
                                  throw new PlatformException(
                                      code: 'ERROR_INCORRECT_OLD_PASSWORD',
                                      message: 'User has inputted an incorrect old password! Cancelling update and reauth!'
                                  );
                                }); // if there is no error, the password is verified and correct
                              } catch(e) {
                                logger.e('SettingsPassword: Reauthenticate ' + e.toString());
                                widget.baseAuth.errorMessages.add(
                                  'authInfoIncorrect'
                                );
                                throw new PlatformException(
                                  code: 'ERROR_INVALID_AUTH',
                                  message: 'Invalid auth info received! Cancelling update and reauth!',
                                );
                              }
                              Home.selectedIndex = 2; // change selected page indexw
                              Navigator.pop(context);
                          } else {
                            logger.e('SettingsPassword: Invalid information entered in form!');
                            widget.baseAuth.clearAndAddError(
                              'invalidInfoOrNewPasswordsMismatch'
                            );
                            throw new PlatformException(
                              code: 'ERROR_INVALID_FORM_INFO',
                              message: 'User has entered invalid information in forms! Cancelling update and reauth!',
                            );
                          }
                        } catch(e) {
                          setState(() => {}); // setState to trigger errors
                        }
                      },
                    ),
                    SizedBox(height: 30.0),
                    BaseAuthErrorDisplay(baseAuth: widget.baseAuth,)
                  ]
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
