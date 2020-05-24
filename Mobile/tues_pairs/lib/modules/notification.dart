import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tues_pairs/shared/constants.dart';

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

  bool isNotificationTooOld(DateTime currentTime) {
    // if notification is a day old, delete it
    DateFormat dateFormatter = new DateFormat().add_yMd().add_jm();
    DateTime sentDateTime = DateTime.parse(sentTime).toLocal();

    _formatSentDateTime(dateFormatter, sentDateTime);

    return diffInDays(currentTime, sentDateTime) > 1;
  }

}