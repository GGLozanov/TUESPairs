class User {

  // TODO: Get tags from tags collection
  final String uid;

  String email;
  String photoURL;
  double GPA;
  bool isTeacher; // is the current user a teacher or a student
  String username; // derived from email
  String matchedUserID; // matched TUESPairs user
  List<String> skippedUserIDs; // skipped TUESPairs users
  List<String> tagIDs; // list of tags he'd like to have for matching with other users

  bool isExternalUser;

  User({this.uid, this.email, this.photoURL, this.GPA, this.matchedUserID,
    this.tagIDs, this.isTeacher, this.username, this.skippedUserIDs, this.isExternalUser = false});

  @override
  bool operator ==(other) {
    return other is User ? uid == other.uid : false;
  }

  bool isInvalid() {
    return uid == null || email == null || isTeacher == null || username == null;
  }

}