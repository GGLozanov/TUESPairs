import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/modules/notification.dart';
import 'package:tues_pairs/widgets/notifications/notification_list.dart';

import '../main.dart';

class MessagingService {
  static final FirebaseMessaging _messagingInstance = new FirebaseMessaging();

  static Future<String> getUserDeviceToken() async {
    return await _messagingInstance.getToken();
    // TODO: Put in Firestore user collection as a field and set it here
  }

  static void configureFirebaseListeners() {
    // the map is the received notification w/ data in the form of a map
    // just log the notification in;
    // the actual conversion to DB notification is handled on the cloud function side

    _messagingInstance.configure(
      onMessage: (Map<String, dynamic> message) async { // onMessage - app in the foreground
        logger.i('Current user w/ device token ' + App.currentUserDeviceToken + ' received onMessage: ${message}');
        // might throw error due to not being instantiated as a class yet (even though it's static . . .)
      },
      onLaunch: (Map<String, dynamic> message) async { // onLaunch - app terminated and loaded,
        logger.i('Current user w/ device token ' + App.currentUserDeviceToken + ' received onLaunch: ${message}');
      },
      onResume: (Map<String, dynamic> message) async { // onResume - app in the background
        logger.i('Current user w/ device token ' + App.currentUserDeviceToken + ' received onResume: ${message}');
      }
    ); // configure the UI callbacks
    _messagingInstance.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

}