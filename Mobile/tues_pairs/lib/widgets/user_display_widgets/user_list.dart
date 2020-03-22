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
import 'package:tues_pairs/widgets/user_display_widgets/user_card.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  final ImageService imageService = new ImageService();

  NetworkImage currentUserImage;

  List<User> users;
  List<NetworkImage> images;

  Future getUserImages() async {
    for(int i = 0; i < images.length; i++) {
      images[i] = await imageService.getImageByURL(users[i].photoURL);
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

    return FutureBuilder(
      future: getUserImages(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              'Oops an error occurred!',
              style: TextStyle(color: Colors.black),
            ),
          );
        } else if(snapshot.connectionState == ConnectionState.done) {
          return ListView.builder( // list of users widget
            itemCount: users.length,
            // ignore: missing_return
            itemBuilder: (context, index) {
              // TODO: get array of skipped users from database (user instance probably won't hold it) through FutureBuilder again maybe
              // TODO: then use contains method to check rendering in if statement
              final user = users[index];

              if(currentUser.uid != user.uid && currentUser.isTeacher != user.isTeacher){
                return UserCard(
                  user: user,
                  userImage: images[index],
                  onSkip: () async {
                    // TODO: append to array of skippedUserIDs here
                    if(!currentUser.skippedUserIDs.contains(user.uid)) {
                      print(currentUser.skippedUserIDs);
                      currentUser.skippedUserIDs.add(user.uid);
                      await database.updateUserData(currentUser); // optimise later maybe
                    } // TODO: Add global bools for isUserAlreadySkipped to display error snack bars
                    setState(() {
                        users.removeAt(index);
                    });
                  },
                  onMatch: () async {
                    if(currentUser.matchedUserID == null) {
                      currentUser.matchedUserID = user.uid;
                      await database.updateUserData(currentUser); // optimise late maybe
                    } else throw new Exception(); // TODO: Add global bools for isUserAlreadyMatched to display error snack bars instead of Exception
                    setState(() {
                      // TODO: set matchedUserID here
                      users.removeAt(index);
                    });
                  }
                );
              } else {
                return SizedBox();
              }
            },
          );
        } else {
          return Container();
        }
      }, // context & index of whichever item we're iterating through
    );
  }
}
