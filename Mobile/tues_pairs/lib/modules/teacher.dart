import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/tag.dart';

class Teacher extends User {

  Teacher(bool isAdmin, String username) : super(isAdmin: isAdmin, username: username);

}