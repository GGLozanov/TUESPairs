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
import 'package:tues_pairs/templates/handler.dart';
import 'package:provider/provider.dart';

import 'package:tues_pairs/widgets/avatar_wrapper.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final BaseAuth baseAuth = new BaseAuth();
  final ImageService imageService = new ImageService(); // TODO: Check image here upon instantiation to see if it exists for the given user (semi-done)

  final CurrentUserHandler currentUserHandler = new CurrentUserHandler();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: currentUserHandler.getCurrentUser(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return Container(
            color: Colors.teal[300],
            child: Center(
              child: Column(
                children: <Widget>[
                  Provider<User>.value(
                    value: currentUserHandler.currentUser,
                    child: AvatarWrapper(imageService: imageService),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          'Clear',
                        ),
                        onPressed: () {
                          // TODO: Implement clear functionality
                        },
                      ),
                      RaisedButton(
                        child: Text(
                          'Submit',
                        ),
                        onPressed: () async {
                          // TODO: Use updateUserData from Database here
                          final currentUser = currentUserHandler.currentUser;

                          imageService.uploadPicture();
                          await imageService.updateUserProfileImage(currentUser); // upload image + wait for update
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return Container(
            color: Colors.teal[300],
          ); // TODO: snapshot.hasError
        }
      },
    );
  }
}
