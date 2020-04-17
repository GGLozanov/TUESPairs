import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:tues_pairs/modules/message.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/teacher.dart';
import 'package:tues_pairs/modules/student.dart';

// Firestore - new DB by Google designed to make it easier to store information with collections and documents inside collections
// Collection reference - reference to a Firestore collection in the Firestore console (like a table in a relational DB)
// DB Class for all DB interactions

class Database {

  // ------------------------------------------
  // Class Properties
  // ------------------------------------------

  MockFirestoreInstance mockInstance; // mock instance of Firestore used in Unit tests.
  // Remains null unless DB is init with named constructor 'mock'

  CollectionReference _userCollectionReference;
  CollectionReference _tagsCollectionReference;
  CollectionReference _messagesCollectionReference;
  // every time the user registers, we will take the unique ID and create a new document (record/row) for the user in the Cloud Firestore DB

  final String uid; // user id property
  Database({this.uid}) {
    _userCollectionReference = Firestore.instance.collection('users');
    _tagsCollectionReference = Firestore.instance.collection('tags');
    _messagesCollectionReference = Firestore.instance.collection('messages');
  }

  Database.mock({this.uid}) { // named constructor for initializing a mock database
    mockInstance = new MockFirestoreInstance();
    _userCollectionReference = mockInstance.collection('users');
    _tagsCollectionReference = mockInstance.collection('tags');
    _messagesCollectionReference = mockInstance.collection('messages');
  }

  // ------------------------------------------
  // User Database implementation
  // ------------------------------------------

  List<User> _listUserFromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) => getUserBySnapshot(doc)).toList();
  }

  CollectionReference get userCollectionReference {
    return _userCollectionReference;
  }

  // method to update user data by given information in custom registration fields
  Future updateUserData(User user) async {
    // TODO: Fix tags method
    // TODO: Create field in users for id for matched user
    // TODO: Don't have tags be null here too
    // tags.forEach((tag) async => await updateTagData(tag.name, tag.color)); -> fix later
    return user != null ? await _userCollectionReference.document(uid).setData({
      'GPA': user.GPA ?? 0.0,
      'isTeacher': user.isTeacher,
      'photoURL': user.photoURL,
      'username': user.username,
      'email': user.email,
      'matchedUserID': user.matchedUserID,
      'skippedUserIDs': user.skippedUserIDs ?? <String>[],
    }) : null;
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
          GPA: double.parse(doc.data['GPA'].toString()),
          isTeacher: doc.data['isTeacher'] ?? false,
          username: doc.data['username'] ?? '',
          matchedUserID: doc.data['matchedUserID'] ?? null,
          skippedUserIDs: doc.data['skippedUserIDs'] == null ? <String>[] : List<String>.from(doc.data['skippedUserIDs']),
      );
    }
    return null;
  }

  // TODO: clean code to avoid all redundant checks
  Future<User> getUserById() async {
    return uid != null ? getUserBySnapshot(await _userCollectionReference.document(uid).get()) : null;
  }

  Future deleteUser() async {
    return uid != null ? await _userCollectionReference.document(uid).delete() : null;
  }

  Stream<List<User>> get users {
    return _userCollectionReference.snapshots().map(
        _listUserFromQuerySnapshot
    );
  }

  // ----------------------------------
  // Tag Database Implementation
  // ----------------------------------

  List<Tag> _listTagFromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) => getTagBySnapshot(doc)).toList();
  }

  Future updateTagData(Tag tag) async {
    return await _tagsCollectionReference.document(tag.tid).setData({
      'name': tag.name,
      'color': tag.color,
    });
  }

  Tag getTagBySnapshot(DocumentSnapshot doc) {
    if(doc.data != null) {
      return Tag(
        tid: doc.documentID,
        name: doc.data['name'],
        color: doc.data['color'],
      );
    }
  }

  // ----------------------------------
  // Message database implementation
  // ----------------------------------

  List<Message> _listMessageFromQuerySnapshot(QuerySnapshot querySnapshot){
    return querySnapshot.documents.map((doc) => getMessageBySnapshot(doc)).toList();
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
    if(doc.data != null) {
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
    return null;
  }

  Future<Message> getMessageById(String mid) async {
    return mid != null ? getMessageBySnapshot(await _messagesCollectionReference.document(mid).get()) : null;
  }

  Future addMessage(Message message) async {
    if(message == null) return null;
    message.encryptMessage();
    return await _messagesCollectionReference.add({
      'content': message.content,
      'fromId': message.fromId,
      'toId': message.toId,
      'sentTime': message.sentTime
    });
  }

  // TODO: 'Many messages doesn't make it prudent to have one field for messages (argument is better)'. Maybe rework that philosophy?
  Future deleteMessage(String mid) async {
    return mid != null ? await _messagesCollectionReference.document(mid).delete() : null;
  }

  // our uid is the document path
  // Firestore will create this document since it doesn't exist yet
  // and we use the setData method to create a new record for this unique user ID in the DB
  // for which we pass in a map with String-dynamic pairs (dynamic can be any type)
}