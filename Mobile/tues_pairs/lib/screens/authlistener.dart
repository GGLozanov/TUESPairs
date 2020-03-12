import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/screens/login/login.dart';
import 'package:tues_pairs/screens/main/match.dart';
import 'package:tues_pairs/screens/main/home.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/screens/authenticate/authenticate.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/templates/user_handler.dart';

class AuthListener extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // this widget is instantiated in main.dart
    // and since we're using StreamProvider and its instantiation is derived inside of the StreamProvider.value() widget
    // that means we can use the value set in the StreamProvider widget here as well!

    // using the Provider.of() generic method
    // return either register or login widget if User is auth'ed
    // user is not auth'd if Provider returns null
    // user is auth'd if Provder returns instance of FirebaseUser (or whichever class we passed as a generic parameter)


    final authUser = Provider.of<User>(context);

    print(authUser);

    return FutureBuilder( // Get current user here for use down the entire widget tree
      future: CurrentUserHandler().getCurrentUser(authUser), // the Provider.of() generic method takes context,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return Provider<User>.value(
              value: CurrentUserHandler.currentUser,
              child: CurrentUserHandler.currentUser == null ? Authenticate() : Home(),
          );
        } else return Loading();
      }
    );
  }
}
