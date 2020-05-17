import 'package:flutter/material.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/form/email_input_field.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/widgets/general/baseauth_error_display.dart';
import 'package:tues_pairs/widgets/general/button_pair.dart';

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {

  String userEmail = '';
  final BaseAuth baseAuth = new BaseAuth();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final btnHeight = screenSize.height / (widgetReasonableHeightMargin - 1);
    final btnWidth = screenSize.width / (widgetReasonableWidthMargin - 1);

    return Scaffold(
      backgroundColor: greyColor,
      appBar: buildAppBar(
        pageTitle: 'Redo Password'
      ),
      body: Container(
        child: Form(
          key: baseAuth.key,
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
                Text( // Wrap in align?
                  'You can recover your password here. Please enter your E-mail to do so.',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 30.0,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25.0),
                EmailInputField(
                  key: Key(Keys.passwordForgotEmailInputField),
                  onChanged: (value) => userEmail = value,
                  initialValue: userEmail,
                ),
                SizedBox(height: 30.0),
                ButtonPair(
                  leftBtnKey: Key(Keys.passwordForgotBackButton),
                  rightBtnKey: Key(Keys.passwordForgotSubmitButton),
                  btnsHeight: btnHeight,
                  btnsWidth: btnWidth,
                  onLeftPressed: () {
                    // Pop the route from the stack when called from Login
                    Navigator.pop(context);
                  },
                  onRightPressed: () async {
                    final currentFormState = baseAuth.key.currentState;
                    if(currentFormState.validate()) {
                      currentFormState.save();
                      try {
                        await baseAuth.authInstance.auth.sendPasswordResetEmail(
                            email: userEmail
                        );
                      } catch(e) {
                        logger.e('ForgotPassword: ' + e.toString());
                        setState(() =>
                            baseAuth.clearAndAddError('Invalid E-mail address! Make sure you\'ve registered with the correct E-mail!')
                        );
                        return;
                      }
                      Navigator.pop(context);
                    } else {
                      setState(() =>
                        baseAuth.clearAndAddError('Invalid info in forms! Please try again with valid information!')
                      );
                    }
                  },
                ),
                SizedBox(height: 30.0),
                BaseAuthErrorDisplay(baseAuth: baseAuth,)
              ]
            ),
          ),
        )
      ),
    );
  }
}
