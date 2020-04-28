import 'package:flutter/material.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/modules/user.dart';

class BaseAuth {

  final Auth _authInstance = Auth();

  final GlobalKey<FormState> _key = new GlobalKey<FormState>(debugLabel: '_formKey'); // creating a global key again to identify our form -> done
  // key can be used for validation in whichever state you want (go generics!)
  // used to identify a given form (!)
  // GlobalKey-s provide access to other objects that are associated with the elements in the generic class (ex. FormState)
  // GlobalKey-s also provide access to State.

  User user = new User(isTeacher: false, tagIDs: <String>[]);

  List<String> errorMessages = ['']; // and wrapping fields in getters and setters isn't considered a generally prudent move
  String password;
  String confirmPassword;
  bool isCurrentAdmin = false;
  bool isLoading = false;

  void toggleLoading() {
    isLoading = !isLoading;
  }

  BaseAuth({this.errorMessages});

  Auth get authInstance => _authInstance;

  get key => _key;

}