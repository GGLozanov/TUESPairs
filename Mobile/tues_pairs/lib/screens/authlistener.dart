import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/screens/register/extern_register.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/screens/login/login.dart';
import 'package:tues_pairs/screens/main/match.dart';
import 'package:tues_pairs/screens/main/home.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/screens/authenticate/authenticate.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/templates/baseauth.dart';

class AuthListener extends StatefulWidget {

  static ExternRegister externRegister = ExternRegister();

  AuthListener.callback({ExternRegister externRegister}) { // TODO: Utilise this in future GitHub sign-in
    AuthListener.externRegister = externRegister;
  }

  AuthListener();

  @override
  _AuthListenerState createState() => _AuthListenerState();
}

class _AuthListenerState extends State<AuthListener> {
  @override
  Widget build(BuildContext context) {

    // this widget is instantiated in main.dart
    // and since we're using StreamProvider and its instantiation is derived inside of the StreamProvider.value() widget
    // that means we can use the value set in the StreamProvider widget here as well!

    // using the Provider.of() generic method
    // return either register or login widget if User is auth'ed
    // user is not auth'd if Provider returns null
    // user is auth'd if Provder returns instance of FirebaseUser (or whichever class we passed as a generic parameter)

    // TODO: give callback for here to setState() from register??
    User authUser = Provider.of<User>(context);

    if(authUser != null) {
      logger.i('AuthListener: Auth user w/ id "' + authUser.uid + '" received');
      return FutureBuilder<User>( // Get current user here for use down the entire widget tree
        future: Database(uid: authUser.uid).getUserById(), // the Provider.of() generic method takes context,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            final user = snapshot.data;

            if(user == null) {
              if(!authUser.isExternalUser && !Login.isExternalCreated) {
                Auth().deleteCurrentFirebaseUser();
                return Authenticate();
              } else { // check if there has actually been a user in login
                AuthListener.externRegister.callback = () => setState(() => {});
                return AuthListener.externRegister;
              }
            }

            logger.i('AuthListener: Current user w/ username "' + user.username + '" received and authenticated');
            return Provider<User>.value(
              value: user,
              child: Home(),
            );
          } else return Loading();
        }
      );
    } else {
      logger.i('AuthListener: Current user not authenticated and going to authenticate');
      return Authenticate();
    }
  }
}
