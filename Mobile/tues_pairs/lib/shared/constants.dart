import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/widgets/tag_display/tag_card.dart';

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

List<TagCard> renderTagCards(List<Tag> tags) { // TBA for settings page function
  return tags.map((tag) {
    int tagIndex = tags.indexOf(tag);
    return TagCard(
      key: Key(Keys.tagCard + tagIndex.toString()),
      tag: tag,
      listIndex: tagIndex,
      );
    }
  ).toList();
}

Widget centeredText(String text) {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.orange,
          fontSize: 30.0,
        ),
        textAlign: TextAlign.center,
      )
    ),
  );
}

void scrollAnimation(ScrollController scrollController) {
  scrollController.animateTo(
    scrollController.position.maxScrollExtent,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOut
  );
}
