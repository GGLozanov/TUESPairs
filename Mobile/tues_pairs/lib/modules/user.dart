import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/tag.dart';

class User {

  // TODO: Get tags from tags collection
  final String uid;
  final List<Tag> tags; // list of tags he'd like to have for matching with other users

  String email;
  String password; // temporary password (DESTROYED upon auth and isn't accessible later)
  String photoURL;
  double GPA;
  bool isTeacher; // is the current user a teacher or a student
  String username; // derived from email
  String matchedUserID; // matched TUESPairs user
  List<String> skippedUserIDs; // skipped TUESPairs users

  User({this.uid, this.email, this.password, this.photoURL, this.GPA, this.matchedUserID,
    this.tags, this.isTeacher, this.username, this.skippedUserIDs});

}