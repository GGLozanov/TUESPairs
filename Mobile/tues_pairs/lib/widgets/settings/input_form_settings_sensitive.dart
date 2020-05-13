import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/main/home.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/form/confim_password_input_field.dart';
import 'package:tues_pairs/widgets/form/email_input_field.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/form/password_input_field.dart';

/// This is a seperate route, which is why the Scaffold is being rerendered
class InputFormSettingsSensitive extends StatefulWidget {
  static BaseAuth baseAuth = new BaseAuth();

  @override
  _InputFormSettingsSensitiveState createState() => _InputFormSettingsSensitiveState();
}

class _InputFormSettingsSensitiveState extends State<InputFormSettingsSensitive> {

  final Auth _auth = new Auth();

  String userPassword = '';
  final int maxSensitiveInfoLines = 5;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final currentUser = Provider.of<User>(context);

    return Scaffold( // Scaffold grants the material design palette and general layout of the app (properties like appBar)
      backgroundColor: greyColor,
      appBar: buildAppBar(pageTitle: 'Settings'),
      body: Container(
        child: Form(
          key: InputFormSettingsSensitive.baseAuth.key,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget> [
                Text( // Wrap in align?
                  'You can change your sensitive information here.',
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
                  onChanged: (value) => userPassword = value,
                  maxLines: maxSensitiveInfoLines,
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InputButton(
                        minWidth: screenSize.width / widgetReasonableWidthMargin,
                        height: screenSize.height / widgetReasonableHeightMargin,
                        text: 'Back',
                        onPressed: () {
                          Navigator.pop(context);
                        }
                    ),
                    InputButton(
                      minWidth: screenSize.width / widgetReasonableWidthMargin,
                      height: screenSize.height / widgetReasonableHeightMargin,
                      text: 'Confirm',
                      onPressed: () {
                        // check form (validate)
                        // reauthenticate
                      }
                    ),
                  ]
                ),
              ]
            ),
          )
        )
      )
    );
  }
}
