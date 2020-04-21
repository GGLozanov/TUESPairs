import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
