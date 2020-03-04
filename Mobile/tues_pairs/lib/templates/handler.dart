import 'package:firebase_auth/firebase_auth.dart';
import 'package:tues_pairs/services/auth.dart';

class UserHandler {
  final auth = new Auth();

  Future<FirebaseUser> getCurrentFirebaseUser () async {
    return await auth.auth.currentUser();
  }

}