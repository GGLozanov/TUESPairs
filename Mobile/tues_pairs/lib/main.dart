import 'package:tues_pairs/shared/keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:tues_pairs/screens/authlistener.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/modules/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  final Auth _auth = new Auth();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); // limit the orientation to portrait up and portrait down

    return StreamProvider<User>.value( // StreamProvider package allows us to send data through a stream to see whether the auth state has changed here. This data can travel through the widget tree.
      value: _auth.user, // create an instance of AuthListener() and set the value of the stream listener to the user stream (and auth.onAuthStateChanged gives that)
      child: MaterialApp( // Now MaterialApp, AuthListener, and all future widgets will have access to the value in the StreamProvider (cross-widget communication!)
        key: Key(Keys.app),
        home: AuthListener()
      )
    );
  }
}

