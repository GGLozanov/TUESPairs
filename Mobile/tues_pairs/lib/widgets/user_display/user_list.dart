import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/student.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/widgets/user_display/user_card.dart';
import 'package:tues_pairs/widgets/general/error.dart';

class UserList extends StatefulWidget {

  final Function reinitializeMatch;

  UserList({this.reinitializeMatch});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  final ImageService imageService = new ImageService();

  NetworkImage currentUserImage;

  List<User> users;
  List<NetworkImage> images ;

  void getUserImages() {
    for(int i = 0; i < images.length; i++) {
      if(users[i].photoURL != null) {
        images[i] = imageService.getImageByURL(users[i].photoURL);
      }
    }
  }
  // TODO: add method that checks skipped ID array with a user ID

  @override
  Widget build(BuildContext context) {
    // access StreamProvider of QuerySnapshots info here
    final currentUser = Provider.of<User>(context);
    final Database database = new Database(uid: currentUser.uid);
    users = Provider.of<List<User>>(context) ?? []; // get the info from the stream
    images = new List<NetworkImage>(users.length); // user images
    getUserImages();

    return ListView.builder( // list of users widget
      itemCount: users.length,
      // ignore: missing_return
      itemBuilder: (context, index) {
        // TODO: get array of skipped users from database (user instance probably won't hold it) through FutureBuilder again maybe
        // TODO: then use contains method to check rendering in if statement
        // TODO: User NEVER enters this state if they have matchedUserID != null; do that check in match.dart
        final user = users[index];

        if(currentUser.uid != user.uid && currentUser.isTeacher != user.isTeacher
            && !currentUser.skippedUserIDs.contains(user.uid) &&
            (user.matchedUserID == null || user.matchedUserID == currentUser.uid) && !user.skippedUserIDs.contains(currentUser)){
          return UserCard(
            user: user,
            userImage: images[index],
            onSkip: () async {
              // TODO: append to array of skippedUserIDs here
              currentUser.skippedUserIDs.add(user.uid);
              await database.updateUserData(currentUser); // optimise later maybe
              // TODO: Add global bools for isUserAlreadySkipped to display error snack bars
              setState(() {
                users.removeAt(index);
              });
            },
            onMatch: () async {
              if(currentUser.matchedUserID == null) {
                currentUser.matchedUserID = user.uid;
                await database.updateUserData(currentUser); // optimise late maybe
              } // else throw new Exception(); // TODO: Add global bools for isUserAlreadyMatched to display error snack bars instead of Exception
              widget.reinitializeMatch();
            }
          );
        } else {
          return SizedBox();
        }
      },
    );// context & index of whichever item we're iterating through
  }
}
