import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:tues_pairs/modules/message.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/teacher.dart';
import 'package:tues_pairs/modules/student.dart';
import 'package:tues_pairs/shared/constants.dart';

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
    final idMsg = this.uid != null ? uid : 'null';
    logger.i('Database: Created real Database instance w/ user id property "' + idMsg + '"; ' + toString());
    _userCollectionReference = Firestore.instance.collection('users');
    _tagsCollectionReference = Firestore.instance.collection('tags');
    _messagesCollectionReference = Firestore.instance.collection('messages');
  }

  Database.mock({this.uid}) { // named constructor for initializing a mock database
    final idMsg = this.uid != null ? uid : 'null';
    logger.i('Database: Created mock Database instance w/ user id property "' + idMsg + '"; ' + toString());
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
    // TODO: Don't have tags be null here too; tags.forEach((tag) async => await updateTagData(tag.name, tag.color)); -> fix later

    if(user != null && uid != null) {
      logger.i('Database: UpdateUserData Received user for update w/ id "' + uid + '"');

      logger.i('Database: UpdateUserData Updating passed user w/ ' +
          '(GPA: "' + user.GPA.toString() + '", ' +
          'isTeacher: "' + user.isTeacher.toString() + '", ' +
          'photoURL: "' + user.photoURL.toString() + '", ' +
          'matchedUserID: "' + user.matchedUserID.toString() + '", ' +
          'skippedUserIDs: "' + user.skippedUserIDs.toString() + '",'
          'tagIDs: "' + user.tagIDs.toString() + '").'
      );

      return await _userCollectionReference.document(uid).setData({
        'GPA': user.GPA ?? 0.0,
        'isTeacher': user.isTeacher,
        'photoURL': user.photoURL,
        'username': user.username,
        'email': user.email,
        'matchedUserID': user.matchedUserID,
        'skippedUserIDs': user.skippedUserIDs ?? <String>[],
        'tagIDs': user.tagIDs ?? <String>[],
      });
    }

    logger.w('Database: UpdateUserData passed user/uid is null => returning null');

    return null;
  }

  User getUserBySnapshot(DocumentSnapshot doc) {
    if(doc.data != null) {
      logger.i('Database: Received document snapshot of user with information w/ uid "' + doc.documentID + '"');

      logger.i('Database: Receiving user w/ ' +
          '(GPA: "' + doc.data['GPA'].toString() + '", ' +
          'isTeacher: "' + doc.data['isTeacher'].toString()  + '", ' +
          'photoURL: "' + doc.data['photoURL'].toString() + '", ' +
          'matchedUserID: "' + doc.data['matchedUserID'].toString() + '", ' +
          'skippedUserIDs: "' + (doc.data['skippedUserIDs'].toString() ?? <String>[].toString()) + '", ' +
          'tagIDs: "' + doc.data['tagIDs'].toString() + '").'
      );

      return doc.data['isTeacher'] ?
        Teacher(
          uid: doc.documentID,
          email: doc.data['email'] ?? '',
          photoURL: doc.data['photoURL'] ?? null,
          isTeacher: doc.data['isTeacher'] ?? true,
          username: doc.data['username'] ?? '',
          matchedUserID: doc.data['matchedUserID'] ?? null,
          skippedUserIDs: doc.data['skippedUserIDs'] == null ? <String>[] : List<String>.from(doc.data['skippedUserIDs']),
          tagIDs: doc.data['tagIDs'] == null ? <String>[] : List<String>.from(doc.data['tagIDs'])
        ) : Student(
          uid: doc.documentID,
          email: doc.data['email'] ?? '',
          photoURL: doc.data['photoURL'] ?? null,
          GPA: double.parse(doc.data['GPA'].toString()),
          isTeacher: doc.data['isTeacher'] ?? false,
          username: doc.data['username'] ?? '',
          matchedUserID: doc.data['matchedUserID'] ?? null,
          skippedUserIDs: doc.data['skippedUserIDs'] == null ? <String>[] : List<String>.from(doc.data['skippedUserIDs']),
          tagIDs: doc.data['tagIDs'] == null ? <String>[] : List<String>.from(doc.data['tagIDs'])
      );
    }

    logger.w('Database: getUserBySnapshot passed documentSnapshot data is null => returning null');

    return null;
  }

  // TODO: clean code to avoid all redundant checks
  Future<User> getUserById() async {
    if(uid != null) {
      logger.i('Database: getUserById called with passed in uid for Database');
      return getUserBySnapshot(await _userCollectionReference.document(uid).get());
    }

    logger.w('Database: getUserById called without passed in uid for Database => returning null');

    return null;
  }

  Future deleteUser() async {
    if(uid != null) {
      logger.i('Database: deleteUser called with passed in uid "' + uid + '" for Database');
      return await _userCollectionReference.document(uid).delete();
    }

    logger.w('Database: deleteUser called without passed in uid for Database => returning null');

    return null;
  }

  Stream<List<User>> get users {
    return _userCollectionReference.snapshots().map(
        _listUserFromQuerySnapshot
    );
  }

  // ----------------------------------
  // Tag Database Implementation
  // ----------------------------------

  Stream<List<Tag>> get tags {
    return _tagsCollectionReference.snapshots().map(
      _listTagFromQuerySnapshot
    );
  }

  List<Tag> _listTagFromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) => getTagBySnapshot(doc)).toList();
  }

  Future updateTagData(Tag tag) async {
    if(tag != null && tag.tid != null) {
      logger.i('Database: updateTagData called with passed in tag and tagId');

      return await _tagsCollectionReference.document(tag.tid).setData({
        'name': tag.name,
        'color': tag.color,
      });
    }

    logger.w('Database: updateTagData called with null tag/tagId passed => returning null');

    return null;
  }

  Tag getTagBySnapshot(DocumentSnapshot doc) {
    if(doc.data != null) {
      logger.i('Database: getTagBySnapshot Received document snapshot of tag with information w/ tid "' + doc.documentID + '"');

      logger.i('Database: Receiving tag w/ ' +
          '(Name: "' + doc.data['name'].toString() + '", ' +
          'color: "' + doc.data['color'].toString() + '", ' + '").'
      );

      return Tag(
        tid: doc.documentID,
        name: doc.data['name'],
        color: doc.data['color'],
      );
    }

    logger.w('Database: getTagBySnapshot passed documentSnapshot data is null => returning null');

    return null;
  }

  Future<Tag> getTagByID(String tid) async {
    if(tid != null) {
      logger.i('Database: getTagByID called with passed in tid for getTagByID');
      return getTagBySnapshot(await _tagsCollectionReference.document(tid).get());
    }

    logger.w('Database: getTagByID passed w/ tid null => returning null');

    return null;
  }

  // ----------------------------------
  // Message database implementation
  // ----------------------------------

  List<Message> _listMessageFromQuerySnapshot(QuerySnapshot querySnapshot) {
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
      logger.i('Database: getMessageBySnapshot Received document snapshot of message with information w/ mid "' + doc.documentID + '"');

      logger.i('Database: Receiving message w/ '
          '(mid: "' + doc.documentID + '", ' +
          'content: "' + doc.data['content'].toString() + '", ' +
          'fromId: "' + doc.data['fromId'].toString() + '", ' +
          'toId: "' + doc.data['toId'].toString() + '", ' +
          'sentTime: "' + doc.data['sentTime'].toString() + '").'
      );

      Message message = Message(
        mid: doc.documentID,
        content: doc.data['content'] ?? null,
        fromId: doc.data['fromId'] ?? null,
        toId: doc.data['toId'] ?? null,
        sentTime: doc.data['sentTime'] ?? null,
      );

      return message;
    }

    logger.w('Database: getMessageBySnapshot passed documentSnapshot data is null => returning null');

    return null;
  }

  Future<Message> getMessageById(String mid) async {
    if(mid != null) {
      logger.i('Database: getMessageById called with passed in mid for getMessageById');
      return getMessageBySnapshot(await _messagesCollectionReference.document(mid).get());
    }

    logger.w('Database: getMessageById called without passed in mid for getMessageById => returning null');

    return null;
  }

  Future addMessage(Message message) async {
    if(message != null) {

      logger.i('Database: addMessage Received message for addition w/ fromId "' +
          message.fromId.toString() +
          '" and toId "' +
          message.toId.toString() +
          '"');

      logger.i('Database: addMessage Adding passed message w/ ' +
          '(content: "' + message.content.toString() + '", ' +
          'fromId: "' + message.fromId.toString() + '", ' +
          'toId: "' + message.toId.toString() + '", ' +
          'sentTime: "' + message.sentTime.toString() + '").'
      );

      return await _messagesCollectionReference.add({
        'content': message.content,
        'fromId': message.fromId,
        'toId': message.toId,
        'sentTime': message.sentTime
      });
    }

    logger.w('Database: addMessage passed messaage is null => returning null');

    return null;
  }

  // TODO: 'Many messages doesn't make it prudent to have one field for messages (argument is better)'. Maybe rework that philosophy?
  Future deleteMessage(String mid) async {
    if(mid != null) {
      logger.i('Database: deleteMessage called with passed in mid "' + mid + '" for deleteMessage');
      return await _messagesCollectionReference.document(mid).delete();
    }

    logger.w('Database: deleteMessage called without passed in mid for deleteMessage => returning null');

    return null;
  }

  // our uid is the document path
  // Firestore will create this document since it doesn't exist yet
  // and we use the setData method to create a new record for this unique user ID in the DB
  // for which we pass in a map with String-dynamic pairs (dynamic can be any type)
}