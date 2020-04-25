import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/avatar/avatar_wrapper.dart';
import 'package:tues_pairs/widgets/form/input_form_settings.dart';
import 'package:tues_pairs/templates/error_notifier.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/widgets/register/tag_selection.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import '../../services/image.dart';

class Settings extends StatefulWidget {
  
  // TODO: export clear tracking into database and keep track of it in cloud
  static int currentMatchedUserClears = 0;
  static final int maxMatchedUserClears = 5;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with SingleTickerProviderStateMixin {

  Database database;
  final Auth auth = new Auth();
  ErrorNotifier errorNotifier = new ErrorNotifier();
  AnimationController _controller;

  void setError(String errorMessage) {
    setState(() => errorNotifier.setError(errorMessage));
  }

  void switchToNextPage(int pageidx) {
    setState(() => Register.currentPage = pageidx);
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _controller.forward();
  }


  @override
  void deactivate() {
    super.deactivate();
    Register.currentPage = Register.topPageIndex; // reset page back to settings page if user leaves
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
      child: IndexedStack(
        index: Register.currentPage, // always 0 at the start of any new widget (duh)
        children: <Widget>[
          TagSelection.settings(
            switchPage: () => switchToNextPage(Register.topPageIndex),
            animationController: _controller,
          ),
          Container(
            color: greyColor,
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
                        key: Key(Keys.settingsEditTagsButton),
                        minWidth: 200.0,
                        height: 50.0,
                        text: 'Edit tags',
                        onPressed: () {
                          switchToNextPage(0);
                        },
                      ),
                      SizedBox(height: 15.0),
                      InputButton(
                        key: Key(Keys.settingsClearMatchedUserButton),
                        minWidth: 100.0,
                        height: 50.0,
                        text: currentUser.isTeacher ? 'Clear Student' : 'Clear Teacher',
                        onPressed: () async {
                          // TODO: Use updateUserData from Database here to update matchedUserID
                          // TODO: Safeguard this option when two people are matched (have the other user consent to it w/bool flag notification maybe?)
                          // TODO: if both users have pressed this button, then their matchedUserID becomes null; until then, it isn't null.
                          if(currentUser.matchedUserID != null) {
                            if(Settings.currentMatchedUserClears++ < Settings.maxMatchedUserClears) {
                              logger.i('Settings: User w/ id "' +
                                  currentUser.uid +
                                  '" has cleared matched user w/ id "' +
                                  currentUser.matchedUserID + '"');
                              currentUser.matchedUserID = null; // to be changed
                              await database.updateUserData(currentUser);
                            } else {
                              logger.w('Settings: User w/ id "' +
                                  currentUser.uid +
                                  '" has attempted too many clears of matched teacher/student!');
                              setError("Too many clears!");
                            }
                          }
                        },
                      ),
                      SizedBox(width: 15.0),
                      InputButton(
                        key: Key(Keys.settingsClearSkippedUsersButton),
                        minWidth: 100.0,
                        height: 50.0,
                        text: 'Clear Skipped',
                        onPressed: () async {
                          if(currentUser.skippedUserIDs != []) {
                            logger.i('Settings: User w/ id "' + currentUser.uid +
                                '" has cleared skipped users w/ ids "' +
                                currentUser.skippedUserIDs.join(' ') + '"');
                            currentUser.skippedUserIDs = [];
                            await database.updateUserData(currentUser);
                          }
                        }
                      ),
                      InputButton(
                        key: Key(Keys.settingsSubmitButton),
                        minWidth: 100.0,
                        height: 50.0,
                        text: 'Submit',
                        onPressed: () async {
                          // TODO: Use updateUserData from Database here -> done
                          final FormState currentState = InputFormSettings.baseAuth.key.currentState;
                          if(currentState.validate() && currentUser.email != null && currentUser.username != null) {
                            currentUser.photoURL = await imageService.uploadImage()
                                ?? currentUser.photoURL; // check if pfp changed

                            logger.i('Settings: User w/ id "' +
                                currentUser.uid.toString() +
                                '" has updated his settings w/ photoURL "' +
                                currentUser.photoURL.toString() + '"');

                            await auth.currentUser.then((firebaseUser) async {
                              await firebaseUser.updateEmail(currentUser.email);
                            });
                            await database.updateUserData(currentUser); // upload image + wait for update
                            // TODO: Update w/ more fields in the future

                            logger.i('Settings: User w/ id "' + currentUser.uid.toString() +
                                '" has updated his settings w/ params ' +
                                '(username: "' + currentUser.username.toString() + '", ' +
                                'GPA: "' + currentUser.GPA.toString() + '", ' + '")');

                            setState(() {});
                          } else {
                            logger.w('Settings: User w/ id "' +
                                currentUser.uid +
                                '" has entered invalid information in Settings fields!');
                            setError("Invalid info in fields!");
                          }
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
                          logger.i('Settings: User w/ id "' +
                              currentUser.uid +
                              '" has been deleted.');
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Center(
                  child: Text(
                    'Warning: Modifications on account text fields and profile images only take change after hitting the Submit button!',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nilam',
                      fontSize: 20.0,
                    ),
                  ),
                ),
                errorNotifier.isError ? errorNotifier.showError() : SizedBox(),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
