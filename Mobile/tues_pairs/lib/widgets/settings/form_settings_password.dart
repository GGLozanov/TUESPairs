import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/form/confim_password_input_field.dart';
import 'package:tues_pairs/widgets/form/password_input_field.dart';
import 'package:tues_pairs/widgets/general/button_pair.dart';

class FormSettingsPassword extends StatefulWidget {
  BaseAuth baseAuth = new BaseAuth(); // TODO: cut down on the keys because they're expensive!

  @override
  _FormSettingsPasswordState createState() => _FormSettingsPasswordState();
}

class _FormSettingsPasswordState extends State<FormSettingsPassword> {

  final Auth _auth = new Auth();

  String oldUserPassword = '';
  String newUserPassword = '';
  String newUserConfirmPassword = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final currentUser = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: greyColor,
      appBar: buildAppBar(pageTitle: 'Settings'),
      body: Container(
        child: Form(
          key: widget.baseAuth.key,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Text(
                  'You can change your password here.',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 30.0,
                    color: Colors.orange,
                  )
                ),
                SizedBox(height: 15.0),
                PasswordInputField(
                  key: Key(Keys.settingsPasswordFormOldPasswordInputField),
                  hintText: 'Enter your old password',
                  onChanged: (value) => oldUserPassword = value,
                ),
                SizedBox(height: 15.0),
                PasswordInputField(
                  key: Key(Keys.settingsPasswordFormPasswordInputField),
                  hintText: 'Enter your new password',
                  onChanged: (value) => newUserPassword = value,
                ),
                SizedBox(height: 15.0),
                ConfirmPasswordInputField(
                  key: Key(Keys.settingsPasswordFormConfirmPasswordInputField),
                  hintText: 'Confirm your new password',
                  onChanged: (value) => newUserConfirmPassword = value,
                ),
                SizedBox(height: 15.0),
                ButtonPair(
                  leftBtnKey: Key(Keys.settingsPasswordFormBackButton),
                  rightBtnKey: Key(Keys.settingsPasswordFormConfirmButton),
                  btnsHeight: screenSize.height / widgetReasonableHeightMargin,
                  btnsWidth: screenSize.width / widgetReasonableWidthMargin,
                  onLeftPressed: () =>
                    Navigator.pop(context),
                  onRightPressed: () async {
                    final currentState = widget.baseAuth.key.currentState;
                    if(currentState.validate() &&
                      oldUserPassword != '' &&
                      (currentUser.email != null || currentUser.email != '') &&
                      newUserConfirmPassword != '' && newUserPassword != '' &&
                      newUserPassword == newUserConfirmPassword) {
                        final _authCredential = EmailAuthProvider.getCredential(
                          email: currentUser.email,
                          password: oldUserPassword
                        );

                        final currentFirebaseUser = await _auth.currentUser; // TODO: Optimise these calls to currentUser (provider?)

                        currentFirebaseUser.reauthenticateWithCredential(_authCredential)
                          .then((_) async {
                             // update the password
                            await currentFirebaseUser
                                .updatePassword(newUserPassword).then((_) async =>
                              await currentFirebaseUser.reauthenticateWithCredential( // reauth w/ new password
                                EmailAuthProvider.getCredential(
                                  email: currentUser.email,
                                  password: newUserPassword,
                              )
                            ));
                          }) // if there is no error, the password is verified and correct
                          .catchError((e) {
                            logger.e('');
                            setState(() =>
                              widget.baseAuth.clearAndAddError(
                                'Invalid information. Old password is incorrect!'
                              )
                            );
                          }
                        );
                    } else {
                      setState(() =>
                          widget.baseAuth.clearAndAddError('Invalid information. New passwords do not match!')
                      );
                    }
                  },
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
          ),
        ),
      ),
    );
  }
}
