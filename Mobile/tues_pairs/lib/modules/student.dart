import 'package:tues_pairs/modules/user.dart';

class Student extends User {
  Student({
    String uid, String email,
    String photoURL,
    double GPA, bool isTeacher,
    String username, String matchedUserID,
    List<String> skippedUserIDs, List<String> tagIDs}) :
      assert(isTeacher == false || isTeacher == null),
      super(
          uid: uid, email: email,
          photoURL: photoURL, GPA: GPA,
          isTeacher: isTeacher, username: username,
          matchedUserID: matchedUserID, skippedUserIDs: skippedUserIDs,
          tagIDs: tagIDs);
}