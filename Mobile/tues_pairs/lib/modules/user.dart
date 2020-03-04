import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/tag.dart';

class User {

  // TODO: Get tags from tags collection
  final String uid;
  final List<Tag> tags; // list of tags he'd like to have for matching with other users

  String email;
  String password;
  String photoURL;
  double GPA;
  bool isAdmin; // is the current user a teacher (admin) or an alumni
  String username; // derived from email
  String matchedUserID; // matched firebase user

  User({this.uid, this.email, this.password, this.photoURL, this.GPA, this.matchedUserID, this.tags, this.isAdmin, this.username});

}