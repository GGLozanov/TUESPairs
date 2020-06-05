import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:tues_pairs/modules/message.dart';
import 'package:tues_pairs/modules/notification.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/teacher.dart';
import 'package:tues_pairs/modules/student.dart';
import 'package:tues_pairs/services/messaging.dart';
import 'package:tues_pairs/shared/constants.dart';

import '../main.dart';

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
  CollectionReference _notificationCollectionReference;
  // every time the user registers, we will take the unique ID and create a new document (record/row) for the user in the Cloud Firestore DB

  final String uid; // user id property
  Database({this.uid}) {
    final idMsg = this.uid != null ? uid : 'null';
    logger.i('Database: Created real Database instance w/ user id property "' + idMsg + '"; ' + toString());
    _userCollectionReference = Firestore.instance.collection('users');
    _tagsCollectionReference = Firestore.instance.collection('tags');
    _messagesCollectionReference = Firestore.instance.collection('messages');
    _notificationCollectionReference = Firestore.instance.collection('notifications');
  }

  Database.mock({this.uid}) { // named constructor for initializing a mock database
    final idMsg = this.uid != null ? uid : 'null';
    logger.i('Database: Created mock Database instance w/ user id property "' + idMsg + '"; ' + toString());
    mockInstance = new MockFirestoreInstance();
    _userCollectionReference = mockInstance.collection('users');
    _tagsCollectionReference = mockInstance.collection('tags');
    _messagesCollectionReference = mockInstance.collection('messages');
    _notificationCollectionReference = mockInstance.collection('notifications');
  }

  // ------------------------------------------
  // User Database implementation
  // ------------------------------------------

  List<User> _listUserFromQuerySnapshot(QuerySnapshot querySnapshot) {
    List<User> users = querySnapshot.documents.map((doc) => getUserBySnapshot(doc)).toList();
    users.removeWhere((user) => user == null); // remove invalid users
    return users;
  }

  CollectionReference get userCollectionReference {
    return _userCollectionReference;
  }

  // method to update user data by given information in custom registration fields
  Future updateUserData(User user, {bool isBeingLoggedOut = false}) async {
    // TODO: Fix tags method
    // TODO: Create field in users for id for matched user
    // TODO: Don't have tags be null here too; tags.forEach((tag) async => await updateTagData(tag.name, tag.color)); -> fix later

    if(user != null && uid != null) {
      logger.i('Database: UpdateUserData Received user for update w/ id "' + uid + '"');

      // PUT DEVICETOKEN AS ARRAY AND APPEND IF NOT ALREADY IN ARRAY
      // CHECK IF DEVICETOKEN ALREADY IN ARRAY HERE AND ADD IT ACCORDINGLY
      // this handles multiple devices

      // DELETE DEVICETOKEN FROM DB IF USER LOGS OUT
      // this handles user logouts

      // WHEN CHECKING TOID IN JS LISTENER, WE CAN ACCESS DEVICETOKENS ARRAY
      // WHICH MEANS WE CAN SEND TO THE APPROPRIATE LOGGED IN DEVICES W/DEVICETOKENS NOT LOGGED OUT
      // this handles user logouts

      // Handle device token filtration outside
      if(user.deviceTokens != null &&
          !user.deviceTokens.contains(App.currentUserDeviceToken) &&
          !isBeingLoggedOut) { // add the device token if not present in the not-null list and not called from logout
        user.deviceTokens.add(App.currentUserDeviceToken);
      }

      logger.i('Database: UpdateUserData Updating passed user w/ ' +
          '(GPA: "' + user.GPA.toString() + '", ' +
          'isTeacher: "' + user.isTeacher.toString() + '", ' +
          'photoURL: "' + user.photoURL.toString() + '", ' +
          'matchedUserID: "' + user.matchedUserID.toString() + '", ' +
          'skippedUserIDs: "' + user.skippedUserIDs.toString() + '", ' +
          'tagIDs: "' + user.tagIDs.toString() + '", ' +
          'description: "' + user.description.toString() + '", ' +
          'deviceToken: "' + App.currentUserDeviceToken .toString() + '", ' + // TODO: fix maybe?
          'lastUpdateTime: "' + FieldValue.serverTimestamp().toString() + '")'
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
        'description': user.description ?? '',
        'deviceTokens': user.deviceTokens ?? <String>[App.currentUserDeviceToken], // if null, list w/ current token
        'lastUpdateTime': FieldValue.serverTimestamp() // used in server-side antispam validation
      });
    }

    logger.w('Database: UpdateUserData passed user/uid is null => returning null');

    return null;
  }

  User getUserBySnapshot(DocumentSnapshot doc) {
    if(doc != null && doc.data != null) {
      logger.i('Database: Received document snapshot of user with information w/ uid "' + doc.documentID + '"');

      logger.i('Database: Receiving user w/ ' +
          '(GPA: "' + doc.data['GPA'].toString() + '", ' +
          'isTeacher: "' + doc.data['isTeacher'].toString()  + '", ' +
          'photoURL: "' + doc.data['photoURL'].toString() + '", ' +
          'matchedUserID: "' + doc.data['matchedUserID'].toString() + '", ' +
          'skippedUserIDs: "' + (doc.data['skippedUserIDs'].toString() ?? <String>[].toString()) + '", ' +
          'tagIDs: "' + doc.data['tagIDs'].toString() + '", ' +
          'description: "' + doc.data['description'].toString() +
          'deviceTokens: "' + doc.data['deviceTokens'].toString() + '", ' +
          'lastUpdateTime: "' + doc.data['lastUpdateTime'].toString() + '")'
      );

      if(doc.data['isTeacher'] == null) {
        return null;
      }

      return doc.data['isTeacher'] ?
        Teacher(
          uid: doc.documentID,
          email: doc.data['email'] ?? '',
          photoURL: doc.data['photoURL'] ?? null,
          isTeacher: doc.data['isTeacher'] ?? true,
          username: doc.data['username'] ?? '',
          matchedUserID: doc.data['matchedUserID'] ?? null,
          skippedUserIDs: doc.data['skippedUserIDs'] == null ? <String>[] : List<String>.from(doc.data['skippedUserIDs']),
          tagIDs: doc.data['tagIDs'] == null ? <String>[] : List<String>.from(doc.data['tagIDs']),
          description: doc.data['description'] ?? '',
          deviceTokens: doc.data['deviceTokens'] == null ? <String>[App.currentUserDeviceToken] // do conversion to List of Strings
              : List<String>.from(doc.data['deviceTokens']),
        ) : Student(
          uid: doc.documentID,
          email: doc.data['email'] ?? '',
          photoURL: doc.data['photoURL'] ?? null,
          GPA: double.parse(doc.data['GPA'].toString()),
          isTeacher: doc.data['isTeacher'] ?? false,
          username: doc.data['username'] ?? '',
          matchedUserID: doc.data['matchedUserID'] ?? null,
          skippedUserIDs: doc.data['skippedUserIDs'] == null ? <String>[] : List<String>.from(doc.data['skippedUserIDs']),
          tagIDs: doc.data['tagIDs'] == null ? <String>[] : List<String>.from(doc.data['tagIDs']),
          description: doc.data['description'] ?? '',
          deviceTokens: doc.data['deviceTokens'] == null ? <String>[App.currentUserDeviceToken]
              : List<String>.from(doc.data['deviceTokens']), // do conversion to List of Strings,
      );
    }

    logger.w('Database: getUserBySnapshot passed documentSnapshot data is null => returning null');

    return null;
  }

  // TODO: clean code to avoid all redundant checks
  Future<User> getUserById() async {
    // always gets called after main because AuthListener
    if(uid != null) {
      logger.i('Database: getUserById called with passed in uid for Database');
      return getUserBySnapshot(await _userCollectionReference.document(uid).get());
    }

    logger.w('Database: getUserById called without passed in uid for Database => returning null');

    return null;
  }

  Future<List<String>> getUserDeviceTokensById() async {
    if(uid != null) {
      logger.i('Database: getUserDeviceTokensById called with passed in uid for Database');
      return await _userCollectionReference.document(uid).get().then((doc) {
        if(doc != null && doc.data != null) {
          return doc.data['deviceTokens'];
        }
        return null;
      });
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
    return _userCollectionReference
        .snapshots()
        .map(
      _listUserFromQuerySnapshot
    );
  }

  Stream<List<User>> filteredUsers(User currentUser) {
    // TODO: Filter by more margins (can't chain 'or's on where()s yet and can't filter or IDs not in skippedUserIDs)
    return _userCollectionReference
        .snapshots()
        .map(
        _listUserFromQuerySnapshot
    );
  }

  // ----------------------------------
  // Tag Database Implementation
  // ----------------------------------

  List<Tag> _listTagFromQuerySnapshot(QuerySnapshot querySnapshot) {
    List<Tag> tags = querySnapshot.documents.map((doc) => getTagBySnapshot(doc)).toList();
    tags.removeWhere((tag) => tag == null);
    return tags;
  }

  Stream<List<Tag>> get tags {
    return _tagsCollectionReference
      .snapshots()
      .map(
      _listTagFromQuerySnapshot
    );
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
    if(doc != null && doc.data != null) {
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
    List<Message> messages = querySnapshot.documents.map((doc) => getMessageBySnapshot(doc)).toList();
    messages.removeWhere((message) => message == null); // remove invalid message
    return messages;
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
    if(doc != null && doc.data != null) {
      logger.i('Database: getMessageBySnapshot Received document snapshot of message with information w/ mid "' + doc.documentID + '"');

      logger.i('Database: Receiving message w/ '
          '(mid: "' + doc.documentID + '", ' +
          'content: "' + doc.data['content'].toString() + '", ' +
          'fromId: "' + doc.data['fromId'].toString() + '", ' +
          'toId: "' + doc.data['toId'].toString() + '", ' +
          'sentTime: "' + doc.data['sentTime'].toString() + '").'
      );

      return Message(
        mid: doc.documentID,
        content: doc.data['content'] ?? '',
        fromId: doc.data['fromId'] ?? '',
        toId: doc.data['toId'] ?? '',
        sentTime: doc.data['sentTime'] ?? '',
      );
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

  // ----------------------------------
  // Notification database implementation
  // ----------------------------------

  // notifications are stored in DB as 'notifications' but used as 'MessageNotification' instances here
  // because of a naming conflict with Flutter's internal modules

  // two separate method paradigms:
  //     - getters for all notifications (may be used sometime)
  //     - getters for notifications of a single user w/ passed in uid
  // only the latter is used now but the rest are kept if to be used later

  List<MessageNotification> _listNotificationFromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map(
      (doc) => getNotificationBySnapshot(doc)
    ).toList();
  }

  List<MessageNotification> _listUserNotificationFromQuerySnapshot(QuerySnapshot snapshot) { // lists only notifications for user with passed in id
    List<MessageNotification> notifications = snapshot.documents.map(
            (doc) => getNotificationBySnapshot(doc, shouldUserFilter: true)
    ).toList();

    final currentTime = DateTime.now();

    notifications.removeWhere((notification) {
      if(notification == null) {
        return true;
      }

      if(notification.isNotificationTooOld(currentTime)) {
        deleteNotification(notification.nid); // cannot await; hope it doesn't cause a problem
        return true;
      }

      return false;
    });

    return notifications;
  }

  Stream<List<MessageNotification>> get notifications {
    return _notificationCollectionReference.orderBy('sentTime', descending: true).snapshots().map(
        _listNotificationFromQuerySnapshot // map each snapshot to a list of notifications
    );
  }

  Stream<List<MessageNotification>> get userNotifications {
    if(uid != null) {
      return _notificationCollectionReference.orderBy('sentTime', descending: true).snapshots().map(
          _listUserNotificationFromQuerySnapshot // map each snapshot to a list of notifications
      );
    }

    logger.w('Database: userNotifications getter called without passed in uid => returning null.');

    return null;
  }

  MessageNotification getNotificationBySnapshot(DocumentSnapshot doc, {bool shouldUserFilter = false}) {
    if(doc != null && doc.data != null) {
      logger.i('Database: getNotificationBySnapshot Received document snapshot of notification with information w/ id "' + doc.documentID + '"');

      logger.i('Database: Receiving notification w/ '
          '(nid: "' + doc.documentID + '", ' +
          'userID: "' + doc.data['userID'].toString() + '", ' +
          'message: "' + doc.data['message'].toString() + '", ' +
          'sentTime: "' + doc.data['sentTime'].toString() + '").'
      );

      // check whether filter is needed and what to return in that case
      // entire MessageNotification result should be null if uid is null
      if(shouldUserFilter && (uid != doc.data['userID'] || uid == null)) {
        return null;
      }

      return MessageNotification(
        nid: doc.documentID,
        userID: doc.data['userID'],
        message: doc.data['message'],
        sentTime: doc.data['sentTime'],
      );
    }

    logger.w('Database: getNotificationBySnapshot doc snapshot is null => returning null');

    return null;
  }

  Future deleteNotification(String nid) async {
    if(nid != null) {
      logger.i('Database: deleteNotification called with passed in nid for deleteNotification');
      return await _notificationCollectionReference.document(nid).delete();
    }

    logger.w('Database: deleteNotification called without nid for deleteNotification => returning null');

    return null;
  }

  // our uid is the document path
  // Firestore will create this document since it doesn't exist yet
  // and we use the setData method to create a new record for this unique user ID in the DB
  // for which we pass in a map with String-dynamic pairs (dynamic can be any type)
}