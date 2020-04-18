import 'package:firebase_auth/firebase_auth.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/constants.dart';

class Auth {

  FirebaseAuth _auth = FirebaseAuth.instance; // property to receive a default FirebaseAuth instance

  // auth changes are listened by streams which are a generic class returning an instance of the stream of what we want
  // streams send their data one by one, allowing for listening in changes
  // Need to use instance.collection('users') and set custom fields through there (?)

  Auth();

  Auth.mock({final auth}) {
    _auth = auth;
  }

  User FirebaseUserToUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid ?? '', email: user.email ?? '', photoURL: user.photoUrl) : null;
  }

  FirebaseAuth get auth {
    return _auth;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) => FirebaseUserToUser(user));
    // getter method which returns whether Auth State has changed (returns null if it hasn't)
    // map the current stream to the conversion method for FirebaseUser to our custom User
  }

  Future<FirebaseUser> get currentUser async {
    return await _auth.currentUser();
  }

  Future<FirebaseUser> getFirebaseUserFromAuth(User authUser) async {
    AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: authUser.email, password: authUser.password);
    return authResult.user;
  }

  Future registerUserByEmailAndPassword(User authUser) async { // async function returns Future (placeholder variable until callback from other thread is received)
    try {
      FirebaseUser firebaseUser = await getFirebaseUserFromAuth(authUser);

      logger.i('Auth: Successfully registered Firebase user w/ id "' + firebaseUser.uid + '" to auth.');

      // -----------------------------------
      // User has successfully auth'd at this point
      // -----------------------------------

      await Database(uid: firebaseUser.uid).updateUserData(authUser); // create the document when the user registers
      await firebaseUser.sendEmailVerification();

      logger.i('Auth: Successfully registered Firebase user w/ id "' + firebaseUser.uid + '" to database & sent mail verification.');

      User user = FirebaseUserToUser(firebaseUser); // return the user property garnered by the authResult
      logger.i('Auth: User w/ username ' + authUser.username + 'has been successfully registered');
      return user; // TODO: just return authUser instead of firebaseUser and have authUser passed down as currentUser (better architecture??)
    } catch(exception) {
      logger.e('Auth: ' + exception.toString());
      return null;
    }
  }

  Future loginUserByEmailAndPassword(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return FirebaseUserToUser(authResult.user);
    } catch(exception) {
      logger.e('Auth: ' + exception.toString());
      return null;
    }
  }

  Future deleteCurrentFirebaseUser() async{
    try{
      FirebaseUser firebaseUser = await _auth.currentUser();
      await firebaseUser.delete();
      logger.i('Auth: Successfully deleted current Firebase User');
      return 1; // exit code for success
    } catch(exception){
      logger.e('Auth: ' + exception.toString());
      return null;
    }
  }

  Future deleteFirebaseUser(FirebaseUser firebaseUser) async {
    try{
      final id = firebaseUser.uid;
      await firebaseUser.delete();
      logger.i('Auth: Successfully deleted Firebase user w/ id "' + id + '"');
      return 1;
    } catch(exception){
      logger.e('Auth: ' + exception.toString());
      return null;
    }
  }

  Future logout() async {
    try {
      await _auth.signOut();
      logger.i('Auth: Successfully logged out current Firebase user');
      return 1;
    } catch(exception) {
      logger.e('Auth: ' + exception.toString());
      return null;
    }
  }

}