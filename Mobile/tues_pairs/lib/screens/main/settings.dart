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
import 'package:tues_pairs/templates/user_handler.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/widgets/avatar_widgets/avatar_wrapper.dart';
import 'package:tues_pairs/widgets/form_widgets/GPA_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/email_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/username_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/password_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/confim_password_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/input_button.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final BaseAuth baseAuth = new BaseAuth();
  final ImageService imageService = new ImageService(); // TODO: Check image here upon instantiation to see if it exists for the given user (semi-done)

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);
    final Database database = new Database(uid: currentUser.uid);

    return Container(
      color: Color.fromRGBO(59, 64, 78, 1),
      child: Center(
        child: Column(
          children: <Widget>[
            AvatarWrapper(imageService: imageService),
            SizedBox(height: 15.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Column(
                  children: <Widget>[

                  ],
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InputButton(
                  minWidth: 100.0,
                  height: 50.0,
                  text: 'Clear',
                  onPressed: () {
                    setState(() {
                      currentUser.email = '';
                      currentUser.username = '';
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
                    imageService.uploadImage();
                    currentUser.photoURL = basename(imageService?.profileImage?.path);
                    await database.updateUserData(currentUser); // upload image + wait for update
                  },
                )
              ],
            ),

            SizedBox(height: 15.0),
            Center(
              child: Text(
                'Warning: Modifications on account only take change after hitting the Submit button!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}