import 'package:flutter/material.dart';
import 'package:tues_pairs/services/auth.dart';

class BaseAuth {

  final Auth _authInstance = Auth();

  final _key = GlobalKey<FormState>(); // creating a global key again to identify our form -> done
  // key can be used for validation in whichever state you want (go generics!)
  // used to identify a given form (!)
  // GlobalKey-s provide access to other objects that are associated with the elements in the generic class (ex. FormState)
  // GlobalKey-s also provide access to State.

  String email = ''; // TO-DO: optimise code later on with one superwidget containing email, password, and error message -> done
  String password = ''; // also, apparently in Dart fields and getters/setters are on the same level, so encapsulation doesn't matter that much
  String errorMessage = ''; // and wrapping fields in getters and setters isn't considered a generally prudent move
  double GPA = 0.0;
  bool isCurrentAdmin = false;
  bool isLoading = false;

  void toggleLoading() {
    isLoading = !isLoading;
  }

  BaseAuth({this.email, this.password, this.errorMessage});

  Auth get authInstance => _authInstance;

  get key => _key;

}