import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/widgets/tag_display/tag_card.dart';

class TagSelection extends StatefulWidget {

  final Function switchPage;
  final AnimationController animationController;

  bool isCurrentUserAvailable = false;

  Function triggerAnimation = () => Register.currentPage = Register.topPageIndex; // or maybe just !isShrink?

  TagSelection({@required this.switchPage, this.animationController}) : assert(switchPage != null);

  TagSelection.settings({@required this.switchPage, this.animationController}) :
        assert(switchPage != null) {
    isCurrentUserAvailable = true;
  }

  @override
  _TagSelectionState createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelection> {

  void switchToNextPage() { // rebuild the parent widget to switch to next page in Stack
    setState(widget.triggerAnimation);
    widget.switchPage();
  }

  User user;
  Database database;

  @override
  Widget build(BuildContext context) {

    if(widget.isCurrentUserAvailable) {
      user = Provider.of<User>(context);
      database = new Database(uid: user.uid);
    } else user = Provider.of<BaseAuth>(context).user;

    final tags = Provider.of<List<Tag>>(context) ?? [];
    final tagCards = mapTagsToTagCards(tags, cardType: TagCardType.SELECTION);

    final tagSelection = Container(
      color: greyColor,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 500.0,
            child: Provider<User>.value(
              value: user,
              child: ListView(
                children: tagCards,
              ),
            ),
          ),
          SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InputButton(
                key: Key(Keys.backButton),
                minWidth: 150.0,
                height: 60.0,
                text: 'Back',
                onPressed: () async {
                  // TODO: Optimise without database; keep initial tags separately
                  user.tagIDs = widget.isCurrentUserAvailable ?
                   await database.getUserById().then((usr) => usr.tagIDs)
                     : [];
                  print('User tids: ${user.tagIDs}');
                  switchToNextPage();
                },
              ),
              InputButton(
                key: Key(Keys.nextButton),
                minWidth: 150.0,
                height: 60.0,
                text: 'Confirm tags',
                onPressed: () {
                  if(widget.isCurrentUserAvailable) database.updateUserData(user);
                  switchToNextPage();
                },
              ),
            ],
          ),
        ],
      ),
    );

    return AnimatedBuilder(
      animation: widget.animationController,
      child: tagSelection,
      builder: (context, child) =>
        Transform.translate(
          offset: Offset(Register.currentPage == Register.topPageIndex ?
          widget.animationController.value * 345.0 : 0.0, 0.0),
          child: child,
        ),
    );
  }
}
