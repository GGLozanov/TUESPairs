import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/modules/user.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final BaseAuth baseAuth = new BaseAuth();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal[300],
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 15.0),
            RaisedButton(
            child: Text(
                'Get current user',
              ),
              onPressed: () async {
                final User currentUser = baseAuth.authInstance.FireBaseUsertoUser(await baseAuth.authInstance.auth.currentUser());
                // currentUser() returns a future, which is why we need to await it
              },
            ),
          ],
        ),
      ),
    );
  }
}
