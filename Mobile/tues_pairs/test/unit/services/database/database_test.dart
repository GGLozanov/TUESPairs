import 'package:flutter_test/flutter_test.dart';
import 'package:tues_pairs/modules/message.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';

void main() {
  // call tests here. . .
  // use mocks here
  // Database has mocked instances of Firestore instances inside itself
  // which means there is no need to mock the actual DB

  TestWidgetsFlutterBinding.ensureInitialized();

  group('Database', () {

    void cleanMock(Database database) {
      database.mockInstance.dump();
    }

    // -------------------------------------
    // User tests
    // -------------------------------------

    test('Retreives a user with the specified in the Database Id', () async { // these tests are run first because of their usage in the methods below
      Database database = new Database.mock(uid: 'TestUserID');
      User testUser = new User(uid: 'TestUserID', email: 'example@gmail.com', isTeacher: false, GPA: 4.56, username: 'example');

      await database.updateUserData(testUser);

      var result = await database.getUserById();

      expect(result.uid, testUser.uid);
      cleanMock(database);
    });

    test('Returns null if user retrieval is attempted when uid is null or not present', () async {
      Database database = new Database.mock();

      var result = await database.getUserById();

      expect(result, isNull);
      cleanMock(database);
    });

    test('Updates the data at the specified Database user Id', () async {
      Database database = new Database.mock(uid: 'TestUserID');

      User testUser = new User(email: 'example@gmail.com', isTeacher: false, GPA: 4.56, username: 'example');

      await database.updateUserData(testUser);

      var result = await database.getUserById();

      expect(result, isNotNull);
      cleanMock(database);
    });

    test('Returns null upon failed user data update (no uid)', () async {
      Database database = new Database.mock();

      User testUser = new User(email: 'example@gmail.com', isTeacher: false, GPA: 4.56, username: 'example');

      var result = await database.updateUserData(testUser);

      expect(result, isNull);
      cleanMock(database);
    });

    test('Deletes user with specified Database user Id', () async {
      Database database = new Database.mock(uid: 'TestUserID');

      await database.deleteUser();

      var result = await database.getUserById();

      expect(result, isNull);
      cleanMock(database);
    });

    test('Returns null upon failed user deletion', () async {
      Database database = new Database.mock();

      var result = await database.deleteUser();

      expect(result, isNull);
      cleanMock(database);
    });

    // -------------------------------------
    // Tag tests
    // -------------------------------------

    test('Updates the tag data at the specified tag Id', () async {
      Database database = new Database.mock(uid: 'TestUserID');

      final String tid = 'exampleId';
      Tag testTag = new Tag(tid: tid, name: 'RandomTech', color: '#db2828');

      expect(database.updateTagData(testTag), isA<Future<dynamic>>());

      cleanMock(database);
    });

    test('Returns null upon failed tag data update (no tag Id)', () async {
      Database database = new Database.mock(uid: 'TestUserID');

      var result = await database.updateTagData(null);

      expect(result, isNull);
      cleanMock(database);
    });

    test('Retrieves a tag by a given snapshot with a given tag Id', () async {
      Database database = new Database.mock(uid: 'TestUserID');

      // example unit test tag - Flask. Do not delete
      final String tid = 'exampleId';
      Tag testTag = new Tag(tid: tid, name: 'RandomTech', color: '#db2828');

      await database.updateTagData(testTag);

      var result = await database.getTagByID(tid);

      expect(testTag, equals(result));
      cleanMock(database);
    });

    test('Returns null upon attempted retrieval of a tag with a null tag Id', () async {
      Database database = new Database.mock(uid: 'TestUserID');

      var result = await database.getTagByID(null);

      expect(result, isNull);

      cleanMock(database);
    });

    // -------------------------------------
    // Message tests
    // -------------------------------------

    test('Add a message to the message collection', () async {
      Database database = new Database.mock(uid: 'TestUserID');

      Message testMessage = new Message(mid: 'TestMessageId', content: 'Content', fromId: 'SenderId', toId: 'ReceiverId', sentTime: '01/12/2020');

      var result = await database.addMessage(testMessage);

      expect(result, isNotNull);
      cleanMock(database);
    });

    test('Returns null upon failed message addition to message collection', () async {
      Database database = new Database.mock(uid: 'TestUserID');

      var result = await database.addMessage(null);

      expect(result, isNull);
      cleanMock(database);
    });

    test('Retrieve a message with a specified message Id argument', () async { // DOESN'T WORK
      Database database = new Database.mock(uid: 'TestUserID');

      Message testMessage = new Message(content: 'Content', fromId: 'SenderId', toId: 'ReceiverId', sentTime: '01/12/2020');

      await database.addMessage(testMessage);

      // TODO: Fix test by fixing message ID retrieval (have it recorded in instances, not random)!

      cleanMock(database);
    });

    test('Returns null upon failed message retrieval (missing Id or nonexistant message)', () async { // DOESN'T WORK
      Database database = new Database.mock(uid: 'TestUserID');

      Message testMessage = new Message(mid: 'TestMessageId', content: 'Content', fromId: 'SenderId', toId: 'ReceiverId', sentTime: '01/12/2020');

      await database.addMessage(testMessage);

      // TODO: Fix test by fixing message ID retrieval (have it recorded in instances, not random)!

      cleanMock(database);
    });

    test('Deletes message with a given message Id', () async {
      Database database = new Database.mock(uid: 'TestUserID');
      
      Message testMessage = new Message(mid: 'TestMessageId', content: 'Content', fromId: 'SenderId', toId: 'ReceiverId', sentTime: '01/12/2020');
      
      await database.addMessage(testMessage);
      
      await database.deleteMessage(testMessage.mid);
      
      var result = await database.getMessageById(testMessage.mid);
      
      expect(result, isNull);
      cleanMock(database);
    });

    test('Returns null upon failed message deletion (message doesn\'t exist or no Id is given)', () async {
      Database database = new Database.mock(uid: 'TestUserID');

      var result = await database.deleteMessage(null);

      expect(result, isNull);
      cleanMock(database);
    });

  });
}