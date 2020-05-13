import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/main/home.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/widgets/tag_display/tag_card.dart';

class TagSelection extends StatefulWidget {

  bool isCurrentUserAvailable = false;

  TagSelection();

  TagSelection.settings() {
    isCurrentUserAvailable = true;
  }

  @override
  _TagSelectionState createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelection> {

  User currentUser;
  Database database;

  @override
  Widget build(BuildContext context) {

    if(widget.isCurrentUserAvailable) {
      currentUser = Provider.of<User>(context);
      database = new Database(uid: currentUser.uid);
    } else currentUser = Provider.of<BaseAuth>(context).user;

    final tags = Provider.of<List<Tag>>(context) ?? [];
    final tagCards = mapTagsToTagCards(tags, cardType: TagCardType.SELECTION, user: currentUser);

    final screenSize = MediaQuery.of(context).size; // can't put in a single var due to required BuildContext param
    final btnHeight = screenSize.height / (widgetReasonableHeightMargin - 1.25);
    final btnWidth = screenSize.width / (widgetReasonableWidthMargin - 1.25);

    return Scaffold(
      appBar: buildAppBar(pageTitle: 'Register'),
      body: Container(
        color: greyColor,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: widget.isCurrentUserAvailable ? screenSize.height / 1.6 :
                screenSize.height / 1.5, // keep as magic amounts here (no use in using reasonableWidth constant here, will only bring more magic amounts)
              child: Provider<User>.value(
                value: currentUser,
                child: ListView(
                  children: tagCards,
                ),
              ),
            ),
            SizedBox(height: screenSize.height / widgetReasonableHeightMargin),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InputButton(
                  key: Key(Keys.backButton),
                  minWidth: btnWidth,
                  height: btnHeight,
                  text: 'Back',
                  onPressed: () async {
                    // TODO: Optimise without database; keep initial tags separately
                    if(widget.isCurrentUserAvailable) {
                      currentUser.tagIDs = await database.getUserById()
                          .then((usr) => usr.tagIDs);
                    }

                    // Pop the route from the stack when called from Settings/Register
                    Navigator.pop(context);
                  },
                ),
                InputButton(
                  key: Key(Keys.nextButton),
                  minWidth: btnWidth,
                  height: btnHeight,
                  text: 'Confirm tags',
                  onPressed: () {
                    if(widget.isCurrentUserAvailable) {
                      database.updateUserData(currentUser);
                    }

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
