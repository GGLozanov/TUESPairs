class User {

  // TODO: Get tags from tags collection
  final String uid;

  String email;
  String photoURL;
  double GPA;

  bool isTeacher; // is the current user a teacher or a student
  String username;
  String description; // student idea or teacher expertise description

  String matchedUserID; // matched TUESPairs user
  List<String> skippedUserIDs = <String>[]; // skipped TUESPairs users
  List<String> tagIDs = <String>[]; // list of tags he'd like to have for matching with other users

  bool isExternalUser;

  List<String> deviceTokens = <String>[]; // tokens for devices from which the user is currently logged in

  User({
    this.uid,
    this.email,
    this.photoURL,
    this.GPA = 0,
    this.matchedUserID,
    this.tagIDs,
    this.isTeacher = false,
    this.username,
    this.description = '',
    this.skippedUserIDs,
    this.isExternalUser = false,
    this.deviceTokens
  });

  @override
  bool operator ==(other) {
    return other is User ? uid == other.uid : false;
  }

  bool isInvalid() {
    return uid == null || email == null || isTeacher == null || username == null;
  }

}