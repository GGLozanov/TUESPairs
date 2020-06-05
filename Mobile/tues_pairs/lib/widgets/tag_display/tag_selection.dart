import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/locale/app_localization.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/main/home.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/widgets/general/baseauth_error_display.dart';
import 'package:tues_pairs/widgets/general/button_pair.dart';
import 'package:tues_pairs/widgets/tag_display/tag_card.dart';

class TagSelection extends StatefulWidget {

  bool isCurrentUserAvailable = false;
  BaseAuth errorBaseAuth = new BaseAuth();

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

    final AppLocalizations localizator = AppLocalizations.of(context);

    return Scaffold(
      appBar: buildAppBar(
        pageTitle: widget.isCurrentUserAvailable ?
          localizator.translate('editTags') : localizator.translate('selectTags')
      ),
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
            ButtonPair(
              leftBtnKey: Key(Keys.backButton),
              rightBtnKey: Key(Keys.nextButton),
              btnsHeight: btnHeight,
              btnsWidth: btnWidth,
              rightBtnText: 'confirmTags', // no need to pass left text because set to default
              onLeftPressed: () async {
                if(widget.isCurrentUserAvailable) {
                  currentUser.tagIDs = await database.getUserById()
                      .then((usr) => usr.tagIDs);
                  Home.selectedIndex = 2; // change selected page index
                }

                // Pop the route from the stack when called from Settings/Register
                Navigator.pop(context);
              },
              onRightPressed: () async {
                // TODO: Optimise without database; keep initial tags separately
                if(widget.isCurrentUserAvailable) {
                  try {
                    await database.updateUserData(currentUser)
                      .catchError((e) {
                        logger.e('Settings: TagSelection ' + e.toString());
                      setState(() =>
                        widget.errorBaseAuth.clearAndAddError(
                            localizator.translate('tooManySubmits'))
                      );
                      throw new PlatformException(
                          code: 'ERROR_INSUFFICIENT_PERM',
                          message: 'User doesn\'t have permission to edit this info (probably due  to rapid changes in information)'
                      );
                    });
                  } catch(e) {
                    return;
                  }
                  Home.selectedIndex = 2; // change selected page index
                }

                Navigator.pop(context);
              },
            ),
            SizedBox(height: 15.0),
            BaseAuthErrorDisplay(baseAuth: widget.errorBaseAuth)
          ],
        ),
      ),
    );
  }
}
