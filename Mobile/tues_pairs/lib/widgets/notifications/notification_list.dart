import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/notification.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  // Message service class here . . .
  // TODO: Convert DB notifications beforehand and have them initialized here

  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<List<MessageNotification>>(context);
    final currentUser = Provider.of<User>(context);

    return Container(
      color: greyColor,
      child: ListView.builder( // notification drawer
        itemCount: notifications == null ? 0 : notifications.length,
        itemBuilder: (context, idx) {
          return Tooltip(
            message: 'Swipe to dismiss!',
            height: 25.0,
            verticalOffset: 50.0,
            textStyle: TextStyle(
              fontFamily: 'Nilam',
              fontSize: 15.0,
              color: Colors.white,
            ),
            child: Dismissible(
              key: Key(Keys.dismissibleNotification + idx.toString()), // avoid duplicate keys
              direction: DismissDirection.endToStart,
              background: Container(
                color: darkGreyColor,
              ),
              onDismissed: (direction) async {
                setState(() {
                  String nid = notifications[idx].nid;
                  notifications.removeAt(idx); // remove dismissed notification from list
                  Database(uid: currentUser.uid)
                      .deleteNotification(nid); // delete notification from DB
                }); // needs to be called first or throws exception; needles overhead :(
              },
              child: Card(
                color: notifications[idx].color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        notifications[idx].message,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Nilam',
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'At: ' + notifications[idx].sentTime,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Nilam',
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              ),
            ),
          );
        }
      ),
    );
  }
}
