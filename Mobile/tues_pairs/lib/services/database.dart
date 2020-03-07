import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/teacher.dart';
import 'package:tues_pairs/modules/student.dart';
import 'package:tues_pairs/templates/baseauth.dart';

// Firestore - new DB by Google designed to make it easier to store information with collections and documents inside collections

class Database { // DB Class for all DB interactions

  // Collection reference - reference to a Firestore collection in the Firestore console (like a table in a relational DB)

  final CollectionReference _userCollectionReference = Firestore.instance.collection('users');
  final CollectionReference _tagsCollectionReference = Firestore.instance.collection('tags');
  // TODO: Remove tags field from user and put it as another document
  // keep the users' info in the DB? First collection?
  // every time the user registers, we will take the unique ID and create a new document (record/row) for the user in the Cloud Firestore DB

  final String uid; // user id property
  Database({this.uid});

  List<User> _listUserFromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) => getUserBySnapshot(doc)).toList();
  }

  // method to update user data by given information in custom registration fields
  Future updateUserData(User user) async {
    // TODO: Fix tags method
    // TODO: Create field in users for id for matched user
    // TODO: Don't have tags be null here too
    // tags.forEach((tag) async => await updateTagData(tag.name, tag.color)); -> fix later
    return await _userCollectionReference.document(uid).setData({
      'GPA': user.GPA ?? 0.0,
      'isTeacher': user.isTeacher,
      'photoURL': user.photoURL,
      'username': user.username,
    });
  }

  Future updateTagData(Tag tag) async {
    return await _tagsCollectionReference.document(tag.name).setData({
      'name': tag.name,
      'color': tag.color,
    });
  }

  Future updateUserPhotoURL(User user, String photoURL) async {
    return await _userCollectionReference.document(user.uid).setData({
      'GPA': user.GPA ?? 0,
      'isTeacher': user.isTeacher,
      'photoURL': photoURL,
      'username': user.username,
    });
  }

  Stream<List<User>> get users {
    return _userCollectionReference.snapshots().map(
      _listUserFromQuerySnapshot
    );
  }

  User getUserBySnapshot(DocumentSnapshot doc) {
    
    if(doc.data != null){
      return doc.data['isTeacher'] ?
        Teacher(
          doc.documentID,
          doc.data['email'] ?? '',
          doc.data['photoURL'] ?? null,
          doc.data['isTeacher'] ?? true,
          doc.data['username'] ?? '',
        ) : Student(
          doc.documentID,
          doc.data['email'] ?? '',
          doc.data['photoURL'] ?? null,
          doc.data['GPA'],
          doc.data['isTeacher'] ?? false,
          doc.data['username'] ?? '',
        );
    }
  }

  CollectionReference userCollectionReference() {
    return _userCollectionReference;
  }

  Future<User> getUserById(String uid) async {
    return getUserBySnapshot(await _userCollectionReference.document(uid).get());
  }


  // our uid is the document path
  // Firestore will create this document since it doesn't exist yet
  // and we use the setData method to create a new record for this unique user ID in the DB
  // for which we pass in a map with String-dynamic pairs (dynamic can be any type)

}