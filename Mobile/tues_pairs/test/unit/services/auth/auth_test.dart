import 'package:flutter_test/flutter_test.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  // call tests here. . .
  // test all methods in auth.dart here
  // passwords in all User classes are temporary and are never accessed beyond auth

  // Current mock supports only sign-in, not sign-up

  TestWidgetsFlutterBinding.ensureInitialized();

  group('Auth', () {

    test('Deletion of Firebase user', () async { // first methods to be tested due to being used as cleanup in later methods
      Auth auth = new Auth();
      User user = new User(email: 'example@gmail.com', password: 'examplepass');

      FirebaseUser firebaseUserResult = await auth.getFirebaseUserFromAuth(user);

      var result;
      try {
        result = await auth.deleteCurrentFirebaseUser();
      } catch(e) {}

      expect(result, isNotNull); // throws exception
    });

    test('Returns null upon failed Firebase user deletion (user does not exist)', () async {
      Auth auth = new Auth();
      User user = new User(email: 'example@gmail.com', password: 'examplepass');

      FirebaseUser firebaseUserResult = await auth.getFirebaseUserFromAuth(user);

      var result = await auth.deleteFirebaseUser(firebaseUserResult);

      expect(result, isNull); // throws exception
    });


    test('Conversion of FirebaseUser to custom User model', () async {
      Auth auth = new Auth();
      User user = new User(email: 'example@gmail.com', password: 'examplepass');

      FirebaseUser firebaseResult = await auth.getFirebaseUserFromAuth(user);
      User result = auth.FirebaseUserToUser(firebaseResult);

      expect(result.email, equals(user.email));
      await auth.deleteCurrentFirebaseUser();
    });

    test('Recieval of Firebase user from authentication', () async {
      Auth auth = new Auth();
      User user = new User(email: 'example@gmail.com', password: 'examplepass');

      FirebaseUser firebaseUserResult = await auth.getFirebaseUserFromAuth(user);

      expect(firebaseUserResult.email, equals(user.email)); // compare by such margin
      await auth.deleteCurrentFirebaseUser();
    }); // no need to test for invalid input due to app never reaching such a state wherein it receives invalid credentials for auth

    test('Login of existing user through e-mail and password', () async {
      Auth auth = new Auth.mock();
      User user = new User(email: 'example@gmail.com', password: 'examplepass');

      User result = await auth.loginUserByEmailAndPassword(user.email, user.password);

      expect(result.uid, equals('aabbcc'));
      // default Firebase auth mock string
      // no need to delete because Firebase auth mock mocks the sign-in process
    });

    test('Throws exception and returns null upon login with invalid or inexisting credentialls', () async {
      Auth auth = new Auth();
      User user = new User(email: 'nonexistentuser@gmail.com', password: 'nonexistent');

      var result = await auth.loginUserByEmailAndPassword(user.email, user.password);

      expect(result, isNull); // throws exception
    });

  });
}