import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/tag.dart';

class User {

  final String id; // user id
  final double GPA; // grade-point average from previous years
  final List<Tag> tags; // list of tags he'd like to have for matching with other users
  final bool isAdmin;
  final String photoURL;

  User({this.id, this.GPA, this.tags, this.isAdmin, this.photoURL});

}