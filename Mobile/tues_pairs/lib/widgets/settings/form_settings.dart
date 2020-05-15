import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/avatar/avatar_wrapper.dart';
import 'package:tues_pairs/widgets/form/GPA_input_field.dart';
import 'package:tues_pairs/widgets/form/email_input_field.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/widgets/form/username_input_field.dart';
import 'package:path/path.dart';

// TODO: Improve code here by creating reusable input form for register and login

class FormSettings extends StatefulWidget {
  static BaseAuth baseAuth = new BaseAuth();

  @override
  FormSettingsState createState() => FormSettingsState();

}

class FormSettingsState extends State<FormSettings> {

  ImageService imageService;
  User currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<User>(context);
    imageService = Provider.of<ImageService>(context);
    return Center(
      child: Form(
        key: FormSettings.baseAuth.key,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              currentUser.username != '' &&
                  currentUser.username != null ?
                UsernameInputField(
                    onChanged: (value) => setState(() => currentUser.username = value),
                    initialValue: currentUser.username
                ) : SizedBox(),
              currentUser.isTeacher ? SizedBox() : GPAInputField(onChanged: (value) => setState(() => currentUser.GPA = double.tryParse(value)),
                  initialValue: currentUser.GPA.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
