import 'package:firebase_auth/firebase_auth.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:path/path.dart';
import 'package:tues_pairs/modules/user.dart';

class CurrentUserHandler {
  final auth = new Auth();
  final Database database = new Database();
  User currentUser;

  Future<FirebaseUser> getCurrentFirebaseUser () async {
    return await auth.auth.currentUser();
  }

  Future<void> getCurrentUser() async {
    await getCurrentFirebaseUser().then((value) async {
      currentUser = await database.getUserById(value.uid);
    });
  }

}