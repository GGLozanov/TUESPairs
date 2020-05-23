import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/modules/notification.dart';
import 'package:tues_pairs/widgets/notifications/notification_list.dart';

class MessagingService {
  static final FirebaseMessaging _messagingInstance = new FirebaseMessaging();

  static Future<String> getUserDeviceToken() async {
    return await _messagingInstance.getToken();
    // TODO: Put in Firestore user collection as a field and set it here
  }

  static MessageNotification convertMessageToMessageNotification(Map<String, dynamic> message) { // converts a cloud message to a readable notification for the user
    // TODO: Check between message and match notifications (using map lookups for keys that exists and don't exist in either notification)
    // TODO: maybe pass in user ID for notification and check whether they can have notifications sent to (checking if they're auth'd?)
    // TODO: Do this in order to not send notifications to logged out users
    final notification = message['notification']; // get the notification map w/ key
    final data = message['data'];
    final title = notification['title'];
    final msg = data['message'];

    return MessageNotification(title: title, message: msg);
  }

  static void configureFirebaseListeners() {
    // the map is the received notification w/ data in the form of a map
    _messagingInstance.configure(
      onMessage: (Map<String, dynamic> message) async { // onMessage - app in the foreground
        print('onMessage: ${message}'); // TODO: Delete
        NotificationList.notifications.add(convertMessageToMessageNotification(message));
        // might throw error due to not being instantiated as a class yet (even though it's static . . .)
      },
      onLaunch: (Map<String, dynamic> message) async { // onLaunch - app terminated and loaded,
        print('onLaunch: ${message}');
        NotificationList.notifications.add(convertMessageToMessageNotification(message));
      },
      onResume: (Map<String, dynamic> message) async { // onResume - app in the background
        print('onResume: ${message}');
        NotificationList.notifications.add(convertMessageToMessageNotification(message));
      }
    ); // configure the UI callbacks
    _messagingInstance.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

}