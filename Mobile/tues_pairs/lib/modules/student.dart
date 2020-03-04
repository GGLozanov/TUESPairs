import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/tag.dart';

class Student extends User {
  Student(String uid, String email, String photoURL, double GPA, bool isAdmin, String username) :
        super(uid: uid, email: email, photoURL: photoURL, isAdmin: isAdmin, username: username);

}