import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageNotification {
  String nid; // notification id
  String userID; // id to which the notification belongs to
  String message;
  String sentTime;
  Color color = Colors.orange; // TODO: Add random colour generation

  MessageNotification({
    @required this.nid,
    @required this.userID,
    @required this.message,
    @required this.sentTime,
  }) :
      assert(nid != null),
      assert(userID != null),
      assert(message != null),
      assert(sentTime != null);

  bool isNotificationValidForUserId(String id) {
    return userID == id;
  }

  void _formatSentDateTime(DateFormat formatter, DateTime sentTime) {
    this.sentTime = formatter.format(sentTime);
  }

  int diffInDays(DateTime date1, DateTime date2) {
    return ((date1.difference(date2) - Duration(hours: date1.hour) + Duration(hours: date2.hour)).inHours / 24).round();
  }

  bool isNotificationTooOld(DateTime currentTime) {
    // if notification is a day old, delete it
    DateFormat dateFormatter = new DateFormat().add_yMd().add_jm();
    DateTime sentDateTime = DateTime.parse(sentTime).toLocal();

    _formatSentDateTime(dateFormatter, sentDateTime);

    return diffInDays(currentTime, sentDateTime) > 1;
  }

}