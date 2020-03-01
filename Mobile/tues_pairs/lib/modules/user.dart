import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/tag.dart';

class User {

  // TODO: Get tags from tags collection
  final String uid;
  final List<Tag> tags; // list of tags he'd like to have for matching with other users
  final bool isAdmin; // is the current user a teacher (admin) or an alumni
  final String photoUrl;
  final String username; // derived from email
  FirebaseUser matchedUser; // matched firebase user

  User({ this.uid, this.tags, this.isAdmin, this.photoUrl, this.username});

}