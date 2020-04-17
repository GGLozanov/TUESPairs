import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/widgets/avatar/avatar_wrapper.dart';
import 'package:tues_pairs/widgets/form/input_form_settings.dart';
import 'package:tues_pairs/templates/error_notifier.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import '../../services/image.dart';

class Settings extends StatefulWidget {

  static int currentMatchedUserClears = 0;
  static final int maxMatchedUserClears = 5;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  Database database;
  final Auth auth = new Auth();
  ErrorNotifier errorNotifier = new ErrorNotifier();

  void setError(String errorMessage) {
    setState(() => errorNotifier.setError(errorMessage));
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<User>(context);
    final users = Provider.of<List<User>>(context) ?? [];
    ImageService imageService = new ImageService();
    database = new Database(uid: currentUser.uid);

    return MultiProvider(
      providers: [
        Provider<User>.value(value: currentUser),
        Provider<ImageService>.value(value: imageService),
      ],
      child: Container(
        color: Color.fromRGBO(59, 64, 78, 1),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 5.0),
            AvatarWrapper(),
            InputFormSettings(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 20.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 5.0,
                spacing: 5.0,
                children: <Widget>[
                  InputButton(
                    minWidth: 100.0,
                    height: 50.0,
                    text: currentUser.isTeacher ? 'Clear Student' : 'Clear Teacher',
                    onPressed: () async {
                      // TODO: Use updateUserData from Database here to update matchedUserID
                      // TODO: Safeguard this option when two people are matched (have the other user consent to it w/bool flag notification maybe?)
                      // TODO: if both users have pressed this button, then their matchedUserID becomes null; until then, it isn't null.
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
                  // TODO: Implement alertDialog onPressed for Delete button
                  InputButton(
                    key: Key(Keys.settingsDeleteAccountButton),
                    minWidth: 100.0,
                    height: 50.0,
                    text: 'Delete',
                    onPressed: () async {
                      for(int i = 0; i < users.length; i++) {
                        Database userDatabase = new Database(uid: users[i].uid);
                        if(users[i].skippedUserIDs.contains(currentUser.uid)){
                          users[i].skippedUserIDs.remove(currentUser.uid);
                          await userDatabase.updateUserData(users[i]);
                        }
                        if(users[i].matchedUserID == currentUser.uid){
                          users[i].matchedUserID = null;
                          await userDatabase.updateUserData(users[i]);
                        }
                      }

                      await auth.deleteCurrentFirebaseUser();
                      await ImageService().deleteImage(currentUser.photoURL);
                      await database.deleteUser();
                      await auth.logout();
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
