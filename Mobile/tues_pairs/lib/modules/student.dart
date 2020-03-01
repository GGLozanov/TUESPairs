import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/tag.dart';

class Student extends User {
  final double GPA; // grade-point average from previous years

  Student(String uid, double GPA, bool isAdmin, String username) : GPA = GPA, super(uid: uid, isAdmin: isAdmin, username: username);

}