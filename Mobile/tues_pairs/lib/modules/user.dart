import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/tag.dart';

class User {

  final List<Tag> tags; // list of tags he'd like to have for matching with other users
  final bool isAdmin;
  final FirebaseUser firebaseUser;

  User({this.tags, this.isAdmin, this.firebaseUser});

}