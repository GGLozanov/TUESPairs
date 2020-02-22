import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';

// Firestore - new DB by Google designed to make it easier to store information with collections and documents inside collections

class Database { // DB Class for all DB interactions

  // Collection reference - reference to a Firestore collection in the Firestore console (like a table in a relational DB)

  final CollectionReference _collectionReference = Firestore.instance.collection('users');
  // keep the users' info in the DB? First collection?
  // every time the user registers, we will take the unique ID and create a new document (record/row) for the user in the Cloud Firestore DB

  final String uid; // user id property
  Database({this.uid});

  // method to update user data by given information in custom registration fields
  Future updateUserData(List<Tag> tags, double GPA, bool isAdmin) async {
    return await _collectionReference.document(uid).setData({
      'tags': tags,
      'GPA': GPA,
      'isAdmin': isAdmin,
    });

    // our uid is the document path
    // Firestore will create this document since it doesn't exist yet
    // and we use the setData method to create a new record for this unique user ID in the DB
    // for which we pass in a map with String-dynamic pairs (dynamic can be any type)
  }

}