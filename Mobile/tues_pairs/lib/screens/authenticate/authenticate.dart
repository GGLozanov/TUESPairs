import 'package:flutter/material.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/screens/login/login.dart';

// wrapper widget for authentication purposes (whether to show Register or Login widget)
// TO-DO: optimise current setup by putting all common properties and methods inside this widget and have Register and Login inherit from them
// TO-DO: Don't have register and login take the function as a property, just have them inherit this class

class Authenticate extends StatefulWidget { // widget
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> { // state

  bool isLoginView = true;
  void toggleView() {
    setState(() => isLoginView = !isLoginView); // setState() method reruns the build method and the function it's been given
  }

  @override
  Widget build(BuildContext context) {
    return isLoginView ? Login(toggleView: toggleView) : Register(toggleView: toggleView);
    // give the toggleView function to the Register and Login widgets for usage in their own contexts
  }
}
