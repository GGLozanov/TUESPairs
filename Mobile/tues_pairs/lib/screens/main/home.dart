import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/notification.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/screens/main/settings.dart';
import 'package:tues_pairs/screens/main/chat.dart';
import 'package:tues_pairs/screens/main/match.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/widgets/notifications/notification_list.dart';
import 'dart:io' show Platform, exit;

import '../../main.dart';

class Home extends StatefulWidget {
  static int selectedIndex = 1; 
  // selected index for page (first is the middle one); change throughout route navigation
  // static due to change in Settings routes

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // ---------------
  // NavigationBar properties:
  // ---------------

  final Auth _auth = new Auth();

  PageController _controller = PageController(
    initialPage: Home.selectedIndex,
  );

  List<Widget> _widgets = [
    Chat(),
    Match(),
    Settings(),
  ]; // list of children widgets to navigate between

  void onItemSwipe(int index) {
    setState(() {
      Home.selectedIndex = index;
      _controller.animateToPage(
          index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    }); // set the selected index to the index given
  }

  void onItemTap(int index) {
    setState(() {
      Home.selectedIndex = index;
      _controller.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<List<MessageNotification>>(context);
    final currentUser = Provider.of<User>(context);

    return Scaffold(
      key: Key(Keys.homeScaffold),
      appBar: buildAppBar(
        pageTitle: _widgets[Home.selectedIndex].toString(),
        leading: Builder( // need to get new context because it uses the current scaffold state context (either this or a key)
          builder: (context) => Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu, size: 35.0),
                alignment: Alignment.centerRight,
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              notifications == null || notifications.length == 0 ? SizedBox() : Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  margin: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 17,
                    minHeight: 17,
                  ),
                  child: Text(
                    '${notifications.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ]
          ),
        ), // ListView to display all notifications
        actions: <Widget>[
          FlatButton.icon(
            key: Key(Keys.logOutButton),
            onPressed: () async {
              Home.selectedIndex = 1; // restores back to match page on logout

              currentUser.deviceTokens.remove(App.currentUserDeviceToken); // TODO: Check/optimize
              await Database(uid: currentUser.uid).updateUserData(currentUser, isBeingLoggedOut: true); // set the flag to true in order to not re-add the token

              await _auth.logout();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.orange,
              size: 25.0,
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ]
      ),
      
      drawer: Drawer(
        child: NotificationList(),
      ),

      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        children: _widgets,
        onPageChanged: onItemSwipe,
        pageSnapping: true,
      ),

      bottomNavigationBar: BottomNavigationBar(
        key: Key(Keys.bottomNavigationBar),
        fixedColor: Colors.orange,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text(
              'Chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
                letterSpacing: 1.0,
              ),
            ),
            backgroundColor: Colors.deepOrangeAccent,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(
                'Match',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                  letterSpacing: 1.0,
                ),
              ),
              backgroundColor: Colors.deepOrangeAccent
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
                letterSpacing: 1.0,
              ),
            ),
            backgroundColor: Colors.deepOrangeAccent
          ),
        ],
        currentIndex: Home.selectedIndex,
        onTap: onItemTap,
        backgroundColor: darkGreyColor,
      ),
    );
  }
}
