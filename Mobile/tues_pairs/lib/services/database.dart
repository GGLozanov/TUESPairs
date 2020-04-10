import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tues_pairs/modules/message.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/teacher.dart';
import 'package:tues_pairs/modules/student.dart';

// Firestore - new DB by Google designed to make it easier to store information with collections and documents inside collections

class Database { // DB Class for all DB interactions

  // Collection reference - reference to a Firestore collection in the Firestore console (like a table in a relational DB)

  final CollectionReference _userCollectionReference = Firestore.instance.collection('users');
  final CollectionReference _tagsCollectionReference = Firestore.instance.collection('tags');
  final CollectionReference _messagesCollectionReference = Firestore.instance.collection('messages');
  // TODO: Remove tags field from user and put it as another document
  // keep the users' info in the DB? First collection?
  // every time the user registers, we will take the unique ID and create a new document (record/row) for the user in the Cloud Firestore DB

  final String uid; // user id property
  Database({this.uid});

  List<User> _listUserFromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) => getUserBySnapshot(doc)).toList();
  }

  List<Tag> _listTagFromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) => getTagBySnapshot(doc)).toList();
  }

  List<Message> _listMessageFromQuerySnapshot(QuerySnapshot querySnapshot){
    return querySnapshot.documents.map((doc) => getMessageBySnapshot(doc)).toList();
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
      'email': user.email,
      'matchedUserID': user.matchedUserID,
      'skippedUserIDs': user.skippedUserIDs ?? <String>[],
    });
  }

  Future deleteUser() async {
    return await _userCollectionReference.document(uid).delete();
  }

  Future updateTagData(Tag tag) async {
    return await _tagsCollectionReference.document(tag.name).setData({
      'name': tag.name,
      'color': tag.color,
    });
  }

  Stream<List<User>> get users {
    return _userCollectionReference.snapshots().map(
      _listUserFromQuerySnapshot
    );
  }

  Tag getTagBySnapshot(DocumentSnapshot doc) {
    if(doc.data != null) {
      return Tag(
        name: doc.data['name'],
        color: doc.data['color'],
      );
    }
  }

  User getUserBySnapshot(DocumentSnapshot doc) {
    if(doc.data != null) {
      return doc.data['isTeacher'] ?
        Teacher(
          uid: doc.documentID,
          email: doc.data['email'] ?? '',
          photoURL: doc.data['photoURL'] ?? null,
          isTeacher: doc.data['isTeacher'] ?? true,
          username: doc.data['username'] ?? '',
          matchedUserID: doc.data['matchedUserID'] ?? null,
          skippedUserIDs: doc.data['skippedUserIDs'] == null ? <String>[] : List<String>.from(doc.data['skippedUserIDs']),
        ) : Student(
          uid: doc.documentID,
          email: doc.data['email'] ?? '',
          photoURL: doc.data['photoURL'] ?? null,
          GPA: doc.data['GPA'],
          isTeacher: doc.data['isTeacher'] ?? false,
          username: doc.data['username'] ?? '',
          matchedUserID: doc.data['matchedUserID'] ?? null,
          skippedUserIDs: doc.data['skippedUserIDs'] == null ? <String>[] : List<String>.from(doc.data['skippedUserIDs']),
      );
    }
  }

  CollectionReference get userCollectionReference {
    return _userCollectionReference;
  }

  Future<User> getUserById() async {
    return getUserBySnapshot(await _userCollectionReference.document(uid).get());
  }

  Stream<List<Message>> get messages {
    return _messagesCollectionReference.orderBy('sentTime').snapshots().map(
      _listMessageFromQuerySnapshot
    );
  }

  CollectionReference get messageCollectionReference {
    return _messagesCollectionReference;
  }

  Message getMessageBySnapshot(DocumentSnapshot doc){
    if(doc.data != null){
      
      Message message = Message(
        mid: doc.documentID,
        content: doc.data['content'] ?? null,
        fromId: doc.data['fromId'] ?? null,
        toId: doc.data['toId'] ?? null,
        sentTime: doc.data['sentTime'] ?? null,
      );
      message.decryptMessage();
      return message;
    }
  }

  Future addMessage(Message message) async{

    message.encryptMessage();
    return await _messagesCollectionReference.add({
      'content': message.content,
      'fromId': message.fromId,
      'toId': message.toId,
      'sentTime': message.sentTime
    });
  }

  Future deleteMessage(String mid) async {
    return await _messagesCollectionReference.document(mid).delete();
  }


  // our uid is the document path
  // Firestore will create this document since it doesn't exist yet
  // and we use the setData method to create a new record for this unique user ID in the DB
  // for which we pass in a map with String-dynamic pairs (dynamic can be any type)

}