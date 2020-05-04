import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/constants.dart';

class Auth {

  FirebaseAuth _auth = FirebaseAuth.instance; // property to receive a default FirebaseAuth instance
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogIn = FacebookLogin();

  // auth changes are listened by streams which are a generic class returning an instance of the stream of what we want
  // streams send their data one by one, allowing for listening in changes
  // Need to use instance.collection('users') and set custom fields through there (?)

  Auth();

  Auth.mock({final auth}) {
    _auth = auth;
  }

  User firebaseUserToUser(FirebaseUser user, {bool isExtern = false}) {
    return user != null ? User(
      uid: user.uid ?? '',
      email: user.email ?? '',
      photoURL: user.photoUrl,
      isExternalUser: isExtern,
    ) : null;
  }

  FirebaseAuth get auth {
    return _auth;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) {
      // determine whether a user has signed in from google or facebook or any other platform
      if(user != null && user.providerData != null) {
        bool isExternPlatform = false;

        for(var userInfo in user.providerData) {
          switch(userInfo.providerId) {
            case 'google.com':
            case 'facebook.com':
            case 'github.com':
              isExternPlatform = true;
              break;
            default: break;
          }
        }
        return isExternPlatform
            ? firebaseUserToUser(user, isExtern: true)
            : firebaseUserToUser(user);
      }
      return firebaseUserToUser(user);
    });
    // getter method which returns whether Auth State has changed (returns null if it hasn't)
    // map the current stream to the conversion method for FirebaseUser to our custom User
  }

  Future<FirebaseUser> get currentUser async {
    return await _auth.currentUser();
  }

  Future<FirebaseUser> getFirebaseUserFromAuth(User authUser, String password) async {
    AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: authUser.email, password: password);
    return authResult.user;
  }
  
  // -----------------------
  // Register/SignUp

  Future registerUserByEmailAndPassword(User authUser, String password) async { // async function returns Future (placeholder variable until callback from other thread is received)
    try {
      FirebaseUser firebaseUser = await getFirebaseUserFromAuth(authUser, password);

      logger.i('Auth: Successfully registered Firebase user w/ id "' + firebaseUser.uid + '" to auth.');

      // -----------------------------------
      // User has successfully auth'd at this point
      // -----------------------------------

      await Database(uid: firebaseUser.uid).updateUserData(authUser); // create the document when the user registers
      await firebaseUser.sendEmailVerification();

      logger.i('Auth: Successfully registered Firebase user w/ id "' + firebaseUser.uid + '" to database & sent mail verification.');

      User user = firebaseUserToUser(firebaseUser); // return the user property garnered by the authResult
      logger.i('Auth: User w/ username ' + authUser.username + ' has been successfully registered');
      return user; // TODO: just return authUser instead of firebaseUser and have authUser passed down as currentUser (better architecture??)
    } catch(exception) {
      logger.e('Auth: ' + exception.toString());
      return null;
    }
  }
  // -----------------------

  // -----------------------
  // SignIn/Login

  Future loginUserByEmailAndPassword(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return firebaseUserToUser(authResult.user);
    } catch(exception) {
      logger.e('Auth: ' + exception.toString());
      return null;
    }
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn(); // invoke the signIn() method and prop the user for signing in

    if(googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuth = await googleSignInAccount.authentication; // receive whether the auth has been successful or not

      if(googleSignInAuth != null && googleSignInAuth.accessToken != null && googleSignInAuth.idToken != null) {
        final AuthCredential authCredential = GoogleAuthProvider.getCredential( // get the auth credential by which to sign in w/ in Firebase
            idToken: googleSignInAuth.idToken,
            accessToken: googleSignInAuth.accessToken
        );

        final authResult = await _auth.signInWithCredential(authCredential);
        final firebaseUser = authResult.user;

        return firebaseUserToUser(firebaseUser, isExtern: true);
      } else {
        throw new PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN', message: 'User does not have required Google Auth token; revert to login UI'
        );
      }
    } else {
      throw new PlatformException(
        code: 'ERROR_GOOGLE_CANCELLED_BY_USER', message: 'User has cancelled Google sign-in; revert to login UI'
      );
    }
  }
  
  Future<User> loginWithFacebook() async {
    facebookLogIn.loginBehavior = FacebookLoginBehavior.webViewOnly; // set to only the webView UI

    final FacebookLoginResult facebookLoginResult =
      await facebookLogIn.logIn(<String>['email', 'public_profile']);

    if(facebookLoginResult.accessToken != null) {
      final authResult = await _auth.signInWithCredential(
          FacebookAuthProvider.getCredential(
            accessToken: facebookLoginResult.accessToken.token,
      ));

      final firebaseUser = authResult.user;

      return firebaseUserToUser(firebaseUser, isExtern: true);
    } else {
      throw new PlatformException(
        code: 'ERROR_FACEBOOK_CANCELLED_BY_USER', message: 'User has cancelled Facebook sign-in; revert to login UI'
      );
    }
  }

  // -----------------------

  Future deleteCurrentFirebaseUser() async {
    try{
      FirebaseUser firebaseUser = await _auth.currentUser();
      await firebaseUser.delete();
      await logout();
      logger.i('Auth: Successfully deleted current Firebase User');
      return EXIT_CODE_SUCCESS; // exit code for success
    } catch(exception){
      logger.e('Auth: ' + exception.toString());
      return null;
    }
  }

  Future deleteFirebaseUser(FirebaseUser firebaseUser) async {
    try{
      final id = firebaseUser.uid;
      await firebaseUser.delete();
      await logout();
      logger.i('Auth: Successfully deleted Firebase user w/ id "' + id + '"');
      return EXIT_CODE_SUCCESS;
    } catch(exception){
      logger.e('Auth: ' + exception.toString());
      return null;
    }
  }

  Future logout() async {
    // TODO: Fix logout and deletion. . .
    try {
      try {
        await googleSignIn.signOut();
        await facebookLogIn.logOut();
      } catch(e) {
        logger.w('Auth: Cannot log out External user: ' + e.toString());
      }
      await _auth.signOut();
      logger.i('Auth: Successfully logged out current Firebase user');
      return EXIT_CODE_SUCCESS;
    } catch(exception) {
      logger.e('Auth: ' + exception.toString());
      return null;
    }
  }

}