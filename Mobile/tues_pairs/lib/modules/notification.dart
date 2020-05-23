import 'dart:ui';

import 'package:flutter/material.dart';

class MessageNotification {
  String title;
  String message;
  Color color = Colors.orange; // TODO: Add random colour generation

  MessageNotification({
    @required this.title,
    @required this.message,
  });
}