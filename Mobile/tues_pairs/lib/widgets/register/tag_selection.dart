import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';

class TagSelection extends StatefulWidget {

  final Function switchPage;

  TagSelection({@required this.switchPage}) : assert(switchPage != null);

  @override
  _TagSelectionState createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelection> {

  void triggerAnimation() {
    Register.currentPage = Register.registerPageIndex; // or maybe just !isShrink?
  }

  void switchToNextPage() { // rebuild the parent widget to switch to next page in Stack
    triggerAnimation();
    widget.switchPage();
  }

  @override
  Widget build(BuildContext context) {
    final baseAuth = Provider.of<BaseAuth>(context);
    final tags = Provider.of<List<Tag>>(context) ?? [];
    final tagCards = mapTagsToTagCards(tags, cardType: TagCardType.SELECTION);

    final tagSelection = Container(
      color: greyColor,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 500.0,
            child: Provider<User>.value(
              value: baseAuth.user,
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
                onPressed: () {
                  baseAuth.user.tagIDs = [];
                  switchToNextPage();
                },
              ),
              InputButton(
                key: Key(Keys.nextButton),
                minWidth: 150.0,
                height: 60.0,
                text: 'Confirm tags',
                onPressed: () {
                  switchToNextPage();
                },
              ),
            ],
          ),
        ],
      ),
    );

    return AnimatedBuilder(
      animation: Register.controller,
      child: tagSelection,
      builder: (context, child) =>
        Transform.translate(
          offset: Offset(Register.currentPage == Register.registerPageIndex ? Register.controller.value * 345.0 : 0.0, 0.0),
          child: child,
        ),
    );
  }
}
