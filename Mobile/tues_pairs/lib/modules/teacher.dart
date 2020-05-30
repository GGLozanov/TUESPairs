import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';

class Teacher extends User {
  Teacher({
    String uid,
    String email,
    String photoURL,
    bool isTeacher,
    String username,
    String description,
    String matchedUserID,
    List<String> skippedUserIDs,
    List<String> tagIDs,
    List<String> deviceTokens
  }) :
      assert(isTeacher == true || isTeacher == null),
      super(
        uid: uid,
        email: email,
        photoURL: photoURL,
        isTeacher: isTeacher,
        username: username,
        description: description,
        matchedUserID: matchedUserID,
        skippedUserIDs: skippedUserIDs,
        tagIDs: tagIDs,
        deviceTokens: deviceTokens
    );

}