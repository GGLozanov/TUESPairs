import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/notification.dart';
import 'package:tues_pairs/shared/constants.dart';

class NotificationList extends StatefulWidget {
  static List<MessageNotification> notifications = List<MessageNotification>(); // list of notifications received from the current instance

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  // Message service class here . . .
  @override
  Widget build(BuildContext context) {
    return Container(
      color: greyColor,
      child: ListView.builder( // notification drawer
        itemCount: NotificationList.notifications == null ? 0 : NotificationList.notifications.length,
        itemBuilder: (context, idx) {
          return Card(
            color: NotificationList.notifications[idx].color,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    NotificationList.notifications[idx].title ?? '',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Nilam',
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    NotificationList.notifications[idx].message,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Nilam',
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
          );
        }
      ),
    );
  }
}
