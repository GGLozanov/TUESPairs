import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/avatar/avatar_wrapper.dart';
import 'package:tues_pairs/widgets/settings/form_settings.dart';
import 'package:tues_pairs/templates/error_notifier.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/widgets/settings/form_settings_email.dart';
import 'package:tues_pairs/widgets/tag_display/tag_selection.dart';

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

  void setError(String errorMessage) {
    setState(() => errorNotifier.setError(errorMessage));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);

    final users = Provider.of<List<User>>(context) ?? [];
    final tags = Provider.of<List<Tag>>(context) ?? [];

    ImageService imageService = new ImageService();
    database = new Database(uid: currentUser.uid);

    final screenSize = MediaQuery.of(context).size;
    final btnHeight = screenSize.height / widgetReasonableHeightMargin;
    final btnWidth = screenSize.width / widgetReasonableWidthMargin;

    return Provider<ImageService>.value(
      value: imageService,
      child: Container(
        color: greyColor,
        child: ListView(
          key: Key(Keys.settingsListView),
          children: <Widget>[
            SizedBox(height: 15.0),
            AvatarWrapper(),
            FormSettings(),
            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: InputButton(
                key: Key(Keys.settingsEditTagsButton),
                minWidth: btnWidth * 1.25, // wider
                height: btnHeight, // shorter
                text: 'Edit Tags',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MultiProvider( // need to pass in the providers again due to different route
                      providers: [
                        Provider<List<Tag>>.value(
                          value: tags,
                        ),
                        Provider<User>.value(
                          value: currentUser,
                        )
                      ],
                      child: TagSelection.settings(),
                    ),
                  ));
                },
              ),
            ),
            SizedBox(height: 15.0),
            !currentUser.isExternalUser ? Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: InputButton(
                key: Key(Keys.settingsEditSensitiveButton),
                minWidth: btnWidth * 1.25, // wider
                height: btnHeight, // shorter
                text: 'Edit Sensitive Info',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Provider.value(
                      value: currentUser,
                      child: FormSettingsEmail()
                    ),
                  ));
                },
              ),
            ) : SizedBox(),
            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 20.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 5.0,
                spacing: 5.0,
                children: <Widget>[
                  SizedBox(height: 15.0),
                  InputButton(
                    key: Key(Keys.settingsClearMatchedUserButton),
                    minWidth: btnWidth,
                    height: btnHeight,
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
                    minWidth: btnWidth,
                    height: btnHeight,
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
                    minWidth: btnWidth,
                    height: btnHeight,
                    text: 'Submit',
                    onPressed: () async {
                      // TODO: Use updateUserData from Database here -> done
                      final FormState currentState = FormSettings.baseAuth.key.currentState;
                      if(currentState.validate() &&
                          currentUser.email != null &&
                          currentUser.username != null &&
                      !usernameExists(currentUser.username, users)) {
                        currentUser.photoURL = await imageService.uploadImage()
                            ?? currentUser.photoURL; // check if pfp changed

                        logger.i('Settings: User w/ id "' +
                            currentUser.uid.toString() +
                            '" has updated his settings w/ photoURL "' +
                            currentUser.photoURL.toString() + '"');

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
                        setError("Invalid info in fields or username already exists!");
                      }
                    },
                  ),
                  SizedBox(width: 15.0),
                  // TODO: Implement alertDialog onPressed for Delete button
                  InputButton(
                    key: Key(Keys.settingsDeleteAccountButton),
                    minWidth: btnWidth,
                    height: btnHeight,
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

                      await ImageService().deleteImage(currentUser.photoURL);
                      await database.deleteUser();
                      await auth.deleteCurrentFirebaseUser();
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
    );
  }
}
