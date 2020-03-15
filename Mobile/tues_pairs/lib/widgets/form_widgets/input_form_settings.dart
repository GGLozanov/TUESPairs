import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/avatar_widgets/avatar_wrapper.dart';
import 'package:tues_pairs/widgets/form_widgets/GPA_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/email_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/input_button.dart';
import 'package:tues_pairs/widgets/form_widgets/username_input_field.dart';
import 'package:path/path.dart';

// TODO: Improve code here by creating reusable input form for register and login

class InputFormSettings extends StatefulWidget {

  @override
  InputFormSettingsState createState() => InputFormSettingsState();

}

class InputFormSettingsState extends State<InputFormSettings> {

  BaseAuth baseAuth = new BaseAuth();
  bool isUserModified = false;
  User currentUser = new User();

  @override
  Widget build(BuildContext context) {
    if(!isUserModified) currentUser = Provider.of<User>(context);
    print(currentUser.username);
    print(currentUser.email);
    print(currentUser.GPA);
    final ImageService imageService = Provider.of<ImageService>(context);
    final Database database = new Database(uid: currentUser.uid);

    return Center(
      child: Form(
        key: baseAuth.key,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AvatarWrapper(),
              SizedBox(height: 15.0),
              UsernameInputField(onChanged: (value) => setState(() => currentUser.username = value), initialValue: currentUser.username),
              EmailInputField(onChanged: (value) => setState(() => currentUser.email = value), initialValue: currentUser.email),
              currentUser.isTeacher ? SizedBox() : GPAInputField(onChanged: (value) => setState(() => currentUser.GPA = double.tryParse(value)),
                  initialValue: currentUser.GPA.toString()),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InputButton(
                    minWidth: 100.0,
                    height: 50.0,
                    text: 'Clear',
                    onPressed: () {
                      isUserModified = true;
                      setState(() {
                        currentUser.email = null;
                        currentUser.username = null;
                        currentUser.GPA = null;
                        currentUser.photoURL = null;
                        imageService.profileImage = null;
                      });
                    },
                  ),
                  InputButton(
                    minWidth: 100.0,
                    height: 50.0,
                    text: 'Submit',
                    onPressed: () async {
                      // TODO: Use updateUserData from Database here -> done
                      final FormState currentState = baseAuth.key.currentState;
                      if(currentState.validate()) {
                        if(imageService.uploadImage() != null) {
                          currentUser.photoURL = basename(imageService?.profileImage?.path);
                        }
                        await database.updateUserData(currentUser); // upload image + wait for update
                      }
                    },
                  )
                ],
              ),
              SizedBox(height: 15.0),
              InputButton(
                minWidth: 100.0,
                height: 50.0,
                text: currentUser.isTeacher ? 'Clear Matched Student' : 'Clear Matched Teacher',
                onPressed: () async {
                  // TODO: Use updateUserData from Database here -> done
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
