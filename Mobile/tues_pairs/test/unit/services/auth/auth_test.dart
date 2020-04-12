import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {}
class AuthResultMock extends Mock implements AuthResult {}
class FirebaseUserMock extends Mock implements FirebaseUser {}

void main() {
  // call tests here. . .
  // test all methods in auth.dart here
  // passwords in all User classes are temporary and are never accessed beyond auth

  // Current mock supports only sign-in, not sign-up

  TestWidgetsFlutterBinding.ensureInitialized();

  group('Auth', () {

    // mock setup here
    final FirebaseAuthMock firebaseAuthMock = new FirebaseAuthMock();
    final FirebaseUserMock firebaseUserMock = new FirebaseUserMock();
    final AuthResultMock authResultMock = new AuthResultMock();
    User user = new User(email: 'example@gmail.com', password: 'examplepass');

    when(firebaseUserMock.delete()).thenAnswer((_) => null);
    when(firebaseUserMock.email).thenReturn(user.email);
    when(authResultMock.user).thenReturn(firebaseUserMock);
    when(firebaseAuthMock.signInWithEmailAndPassword(email: user.email, password: user.password)).thenAnswer((_) => Future<AuthResultMock>.value(authResultMock));
    when(firebaseAuthMock.createUserWithEmailAndPassword(email: user.email, password: user.password)).thenAnswer((_) => Future<AuthResultMock>.value(authResultMock));

    test('Deletion of Firebase user', () async { // first methods to be tested due to being used as cleanup in later methods
      Auth auth = new Auth.mock(auth: firebaseAuthMock);

      FirebaseUser firebaseUserResult = await auth.getFirebaseUserFromAuth(user);

      var result;
      try {
        result = await auth.deleteFirebaseUser(firebaseUserResult);
      } catch(e) {}

      expect(result, 1); // throws exception
    });

    test('Returns null upon failed Firebase user deletion (user does not exist)', () async {
      when(firebaseUserMock.delete()).thenThrow(new Exception('ERROR_USER_NOT_FOUND'));
      Auth auth = new Auth.mock(auth: firebaseAuthMock);

      FirebaseUser firebaseUserResult = await auth.getFirebaseUserFromAuth(user);

      var result = await auth.deleteFirebaseUser(firebaseUserResult);

      expect(result, isNull); // throws exception
    });


    test('Conversion of FirebaseUser to custom User model', () async {
      Auth auth = new Auth.mock(auth: firebaseAuthMock);

      FirebaseUser firebaseResult = await auth.getFirebaseUserFromAuth(user);
      User result = auth.FirebaseUserToUser(firebaseResult);

      expect(result.email, equals(user.email));
    });

    test('Receival of Firebase user from authentication', () async {
      Auth auth = new Auth.mock(auth: firebaseAuthMock);

      FirebaseUser firebaseUserResult = await auth.getFirebaseUserFromAuth(user);

      expect(firebaseUserResult.email, equals(user.email)); // compare by such margin
    }); // no need to test for invalid input due to app never reaching such a state wherein it receives invalid credentials for auth

    test('Login of existing user through e-mail and password', () async {
      Auth auth = new Auth.mock(auth: firebaseAuthMock);

      FirebaseUser firebaseUserResult = await auth.getFirebaseUserFromAuth(user);

      User result = await auth.loginUserByEmailAndPassword(user.email, user.password);

      expect(result.email, user.email);
    });

    test('Throws exception and returns null upon login with invalid or inexisting credentialls', () async {
      User user = new User(email: 'nonexistentuser@gmail.com', password: 'nonexistent');
      when(firebaseAuthMock.signInWithEmailAndPassword(email: user.email, password: user.password)).thenAnswer((_) => null);
      Auth auth = new Auth.mock(auth: firebaseAuthMock);

      var result = await auth.loginUserByEmailAndPassword(user.email, user.password);

      expect(result, isNull); // throws exception
    });

  });
}