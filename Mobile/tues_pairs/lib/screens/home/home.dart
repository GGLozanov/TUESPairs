import 'package:flutter/material.dart';
import 'package:tues_pairs/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final Auth _auth = new Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( // TO-DO: Encapsulate widget in one class
          backgroundColor: Colors.grey[400],
          title: Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              )
          ),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {_auth.logout();},
                icon: Icon(Icons.exit_to_app),
                label: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                )
            ),
            FlatButton.icon(
                onPressed: () {},
                icon: Icon(Icons.settings),
                label: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),

        body: Container()
    );
  }
}
