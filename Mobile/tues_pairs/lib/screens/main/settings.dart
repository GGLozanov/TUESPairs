import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:tues_pairs/services/database.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:tues_pairs/widgets/avatar/avatar_wrapper.dart';
import 'package:tues_pairs/widgets/form/GPA_input_field.dart';
import 'package:tues_pairs/widgets/form/email_input_field.dart';
import 'package:tues_pairs/widgets/form/input_form_settings.dart';
import 'package:tues_pairs/widgets/form/username_input_field.dart';
import 'package:tues_pairs/widgets/form/password_input_field.dart';
import 'package:tues_pairs/widgets/form/confim_password_input_field.dart';
import 'package:tues_pairs/templates/error_notifier.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';

class Settings extends StatefulWidget {

  static int currentMatchedUserClears = 0;
  static final int maxMatchedUserClears = 5;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  Database database;
  ErrorNotifier errorNotifier = new ErrorNotifier();

  void setError(String errorMessage) {
    setState(() => errorNotifier.setError(errorMessage));
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<User>(context);
    ImageService imageService = new ImageService();
    database = new Database(uid: currentUser.uid);

    return MultiProvider(
      providers: [
        Provider<User>.value(value: currentUser),
        Provider<ImageService>.value(value: imageService),
      ],
      child: Container(
        color: Color.fromRGBO(59, 64, 78, 1),
        child: Column(
          children: <Widget>[
            SizedBox(height: 15.0),
            AvatarWrapper(),
            InputFormSettings(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0, bottom: 20.0),
              child: Row(
                children: <Widget>[
                  InputButton(
                    minWidth: 100.0,
                    height: 50.0,
                    text: currentUser.isTeacher ? 'Clear Student' : 'Clear Teacher',
                    onPressed: () async {
                      // TODO: Use updateUserData from Database here to update matchedUserID
                      // TODO: Safeguard this option when two people are matched (have the other user consent to it w/bool flag notification maybe?)
                      // TODO: if both users have pressed this button, then their matchedUserID becomes null; until then, it isn't null.
                      print(Settings.currentMatchedUserClears);
                      if(Settings.currentMatchedUserClears++ < Settings.maxMatchedUserClears) {
                        currentUser.matchedUserID = null; // to be changed
                        await database.updateUserData(currentUser);
                      } else setError("Too many clears!");
                    },
                  ),
                  SizedBox(width: 15.0),
                  InputButton(
                    minWidth: 100.0,
                    height: 50.0,
                    text: 'Clear Skipped',
                    onPressed: () async {
                      currentUser.skippedUserIDs = [];
                      await database.updateUserData(currentUser);
                    }
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0, top: 15.0, right: 60.0, bottom: 20.0),
              child: Row(
                children: <Widget>[
                  InputButton(
                    minWidth: 100.0,
                    height: 50.0,
                    text: 'Submit',
                    onPressed: () async {
                      // TODO: Use updateUserData from Database here -> done
                      final FormState currentState = InputFormSettings.baseAuth.key.currentState;
                      if(currentState.validate() && currentUser.email != null && currentUser.username != null) {
                        currentUser.photoURL = await imageService.uploadImage();
                        await database.updateUserData(currentUser); // upload image + wait for update
                      } else setError("Invalid info in fields!");
                    },
                  ),
                  SizedBox(width: 15.0),
                  InputButton(
                    minWidth: 100.0,
                    height: 50.0,
                    text: 'Clear',
                    onPressed: () {
                      setState(() {
                        currentUser.email = null;
                        currentUser.username = null;
                        if(!currentUser.isTeacher) currentUser.GPA = null;
                        currentUser.photoURL = null;
                        imageService.profileImage = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Center(
              child: Text(
                'Warning: Modifications on account fields only take change after hitting the Submit button!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
            errorNotifier.isError ? errorNotifier.showError() : SizedBox(),
          ],
        ),
      ),
    );
  }
}
