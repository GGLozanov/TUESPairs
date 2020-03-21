import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/tag.dart';

class Student extends User {
  Student({
    String uid, String email,
    String photoURL,
    double GPA, bool isTeacher,
    String username, String matchedUserID,
    List<String> skippedUserIDs}) :
        super(
          uid: uid, email: email,
          photoURL: photoURL, GPA: GPA,
          isTeacher: isTeacher, username: username,
          matchedUserID: matchedUserID, skippedUserIDs: skippedUserIDs);

}