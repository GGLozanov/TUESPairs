import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/screens/login/login.dart';
import 'package:tues_pairs/screens/home/home.dart';
import 'package:provider/provider.dart';

class AuthListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // this widget is instantiated in main.dart
    // and since we're using StreamProvider and its instantiation is derived inside of the StreamProvider.value() widget
    // that means we can use the value set in the StreamProvider widget here as well!

    // using the Provider.of() generic method
    final user = Provider.of<FirebaseUser>(context); // the Provider.of() generic method takes context

    // return either register or login widget if User is auth'ed
    // user is not auth'd if Provider returns null
    // user is auth'd if Provder returns instance of FirebaseUser (or whichever class we passed as a generic parameter)

    return user == null ? Login() : Home();
  }
}
