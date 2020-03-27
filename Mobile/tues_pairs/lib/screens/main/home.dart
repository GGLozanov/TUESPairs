import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/screens/main/settings.dart';
import 'package:tues_pairs/screens/main/chat.dart';
import 'package:tues_pairs/screens/main/match.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/widgets/general/error.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 1; // selected index for page (first is the middle one

  // ---------------
  // NavigationBar properties:
  // ---------------

  final Auth _auth = new Auth();
  PageController _controller = PageController(
    initialPage: 1,
    keepPage: true,
  );

  List<Widget> _widgets = [
    Chat(),
    Match(),
    Settings(),
  ]; // list of children widgets to navigate between

  void onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.animateToPage(
          index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    }); // set the selected index to the index given
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 36, 44, 1),
        title: Text(
          _widgets[_selectedIndex].toString(),
          // convert widget title to string
          style: TextStyle(
            color: Colors.white,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: <Widget>[
          FlatButton.icon(
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
        onPageChanged: onItemTap,
        pageSnapping: true,
      ),

      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        onTap: onItemTap,
        backgroundColor: Color.fromRGBO(33, 36, 44, 1),
      ),
    );
  }
}
