import 'package:firebase_auth/firebase_auth.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:path/path.dart';
import 'package:tues_pairs/modules/user.dart';

class CurrentUserHandler {
  static User currentUser;

  Future getCurrentUser(User authUser) async {
    if(authUser == null) {
      currentUser = null;
    } else {
      currentUser = await Database(uid: authUser.uid).getUserById();
    }
  }

}