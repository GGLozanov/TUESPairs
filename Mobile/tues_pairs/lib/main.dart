import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/screens/authlistener.dart';
import 'package:tues_pairs/services/auth.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value( // StreamProvider package allows us to send data through a stream to see whether the auth state has changed here. This data can travel through the widget tree.
      value: Auth().user, // create an instance of AuthListener() and set the value of the stream listener to the user stream (and auth.onAuthStateChanged gives that)
      child: MaterialApp( // Now MaterialApp, AuthListener, and all future widgets will have access to the value in the StreamProvider (cross-widget communication!)
        home: AuthListener()
      )
    );
  }
}

