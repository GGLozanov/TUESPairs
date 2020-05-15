import 'package:flutter/material.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/screens/main/settings.dart';
import 'package:tues_pairs/screens/main/chat.dart';
import 'package:tues_pairs/screens/main/match.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';

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
    return Scaffold(
      key: Key(Keys.homeScaffold),
      appBar: buildAppBar(
        pageTitle: _widgets[Home.selectedIndex].toString(),
        actions: <Widget>[
          FlatButton.icon(
            key: Key(Keys.logOutButton),
            onPressed: () => _auth.logout(),
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.orange,
              size: 35.0,
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
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
