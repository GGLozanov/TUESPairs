import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tues_pairs/locale/application.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/widgets/tag_display/tag_card.dart';

// TODO: Clean up code here and encapsulate in classes

const textInputDecoration = InputDecoration(
  hintStyle: TextStyle(
    color: Colors.white24
  ),
  labelStyle: TextStyle(
    decorationStyle: TextDecorationStyle.solid,
    color: Colors.white24,
  ),
  enabledBorder: UnderlineInputBorder(      
    borderSide: BorderSide(
      color: Colors.orange
    ),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.orange,
    ),
  ),
);

const textInputColor = TextStyle(
    color: Colors.white,
);

const greyColor = Color.fromRGBO(59, 64, 78, 1);
const darkGreyColor = Color.fromRGBO(33, 36, 44, 1);

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 4, // number of method calls to be displayed
    errorMethodCount: 8, // number of method calls if stacktrace is provided
    lineLength: 120, // width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    printTime: false, // Should each log print contain a timestamp
  ),
);

enum TagCardType {
  SELECTION,
  ALREADY_CHOSEN_SELECTION,
  VIEW,
}

enum ExternalSignInType {
  GOOGLE,
  FACEBOOK,
  GITHUB
}

enum RegisterPageType {
  REGISTER,
  TAG_SELECTION
}

const int EXIT_CODE_SUCCESS = 1;
const double widgetReasonableHeightMargin = 15.5; // represents the (reasonable) divisor margin for the screen height corresponding a given widget
const double widgetReasonableWidthMargin = 3.75; // represents the (reasonable) divisor margin for the screen width corresponding a given widget

List<Tag> getUserMappedTags(
  List<Tag> tags,
  User user
) {
  List<Tag> userTagCards = [];
  for(var tid in user.tagIDs) {
    userTagCards.add(tags.firstWhere((tag) => tag.tid == tid));
  }

  return userTagCards;
}

List<TagCard> getUserTagCards(
    List<Tag> tags,
    User user
) {
  return mapTagsToTagCards(
      getUserMappedTags(tags, user),
      user: user
  );
}

List<TagCard> mapTagsToTagCards(
    List<Tag> tags,
    {TagCardType cardType = TagCardType.VIEW,
    User user}
) {
  return tags.map((tag) {
    int tagIndex = tags.indexOf(tag);
    switch(cardType) {
      case TagCardType.SELECTION:
        return TagCard.selection(
          key: Key(Keys.tagCard + tagIndex.toString()),
          tag: tag,
          listIndex: tagIndex,
          user: user
        );
      case TagCardType.ALREADY_CHOSEN_SELECTION:
        return TagCard.alreadyChosenSelection(
          key: Key(Keys.tagCard + tagIndex.toString()),
          tag: tag,
          listIndex: tagIndex,
          user: user
        );
      case TagCardType.VIEW:
      default:
        return TagCard.view(
          key: Key(Keys.tagCard + tagIndex.toString()),
          tag: tag,
          listIndex: tagIndex,
          user: user
        );
      }
    }
  ).toList();
}

Widget buildAppBar({
  @required pageTitle,
  List<Widget> actions = const [],
  Widget leading
}) {
  assert(pageTitle != null);
  return AppBar(
    backgroundColor: darkGreyColor,
    title: Text(
      pageTitle, // convert widget title to string
      style: TextStyle(
        color: Colors.white,
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    ),
    leading: leading,
    actions: actions
  );
}

bool usernameExists(
  String username,
  List<User> users
) {
  for(User data in users ?? []) {
    if(username == data.username) {
      logger.i('Username already exists');
      return true;
    }
  }
  logger.i('Username doesn\'t exist');
  return false;
}

void scrollAnimation(ScrollController scrollController) {
  scrollController.animateTo(
    scrollController.position.maxScrollExtent,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOut
  );
}