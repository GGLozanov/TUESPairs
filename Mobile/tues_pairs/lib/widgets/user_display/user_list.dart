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

  List<User> users = <User>[];
  List<NetworkImage> images;
  List<UserCard> listItems;

  bool isFirstBuild = true;

  final _animatedListKey = GlobalKey<AnimatedListState>(); // key used to follow our animated list through its states

  void getUserImages() {
    for(int i = 0; i < images.length; i++) {
      if(users[i].photoURL != null) {
        images[i] = imageService.getImageByURL(users[i].photoURL);
      }
    }
  }

  void loadListItems(User currentUser, List<User> users) {
      // method that utilises a Future delay to simulate a smooth loading effect.
      // Credit to user NearHuscarl from the thread https://stackoverflow.com/questions/57100219/how-to-animate-the-items-rendered-initially-using-animated-list-in-flutter
      // for the solution
      // users = fetchedUsers
      listItems = <UserCard>[];
      var future = Future(() {});
      for(int i = 0; i < users.length; i++) {
        future = future.then((_) { // reinitializing future with lvalue helps futures wait for one-another (+then)
          return Future.delayed(Duration(milliseconds: 100), () {
            listItems.add(buildUserCard(
                currentUser, i, users[i])); // add card item here
            _animatedListKey.currentState.insertItem(
                listItems.length - 1); // insert the latest item here
          });
        });
    }
  }

  UserCard buildUserCard(User currentUser, int index, User user) {
    final Database database = new Database(uid: currentUser.uid);
    return UserCard(
      user: user,
      userImage: images[index],
      onMatch: () async {
        if(currentUser.matchedUserID == null) {
          currentUser.matchedUserID = user.uid;
          await database.updateUserData(currentUser); // optimise late maybe
        } // TODO: Add global bools for isUserAlreadyMatched to display error snack bars instead of Exception
        widget.reinitializeMatch();
      },
      onSkip: () async {
        // TODO: append to array of skippedUserIDs here
        currentUser.skippedUserIDs.add(user.uid);
        await database.updateUserData(currentUser); // optimise later maybe
        // TODO: Add global bools for isUserAlreadySkipped to display error snack bars
        users.removeAt(index);
        listItems.removeAt(index);
        setState(() {
          // remove from both lists
          _animatedListKey.currentState.removeItem(index,
                (context, animation) => SlideTransition(
                  position: CurvedAnimation(
                  curve: Curves.easeOut,
                  parent: animation,
                ).drive(Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: const Offset(0, 0),
                )
              )
            )
          );
        });
      },
    );
  }

  // TODO: add method that checks skipped ID array with a user ID

  @override
  Widget build(BuildContext context) {
    // access StreamProvider of QuerySnapshots info here
    final currentUser = Provider.of<User>(context);
    if(users.length == 0) { // if list is just initialized (first build run)
      users = Provider.of<List<User>>(context) ?? [];
      loadListItems(currentUser, users);
      images = new List<NetworkImage>(users.length); // user images
      getUserImages();
    } // get the info from the stream

    return AnimatedList( // list of users widget
      key: _animatedListKey,
      initialItemCount: listItems.length,
      // ignore: missing_return
      itemBuilder: (context, index, animation) {
        // TODO: get array of skipped users from database (user instance probably won't hold it) through FutureBuilder again maybe -> done
        // TODO: then use contains method to check rendering in if statement -> done
        // TODO: User NEVER enters this state if they have matchedUserID != null; do that check in match.dart -> done
        final user = users[index];

        if(currentUser.isTeacher != user.isTeacher
            && !currentUser.skippedUserIDs.contains(user.uid) &&
            (user.matchedUserID == null || user.matchedUserID == currentUser.uid) && !user.skippedUserIDs.contains(currentUser)) {
          return SlideTransition(
            position: animation.drive(Tween<Offset>(
              begin: const Offset(1, 0), // represent a point in Cartesian (x-y coordinate) space; dx and dy are args for points
              end: const Offset(0, 0), // points are between 1 and 0 (use that!)
            ).chain(CurveTween(curve: Curves.decelerate))),
            child: listItems[index], // get the generated user card from here
          );
        } else {
          return SizedBox();
        }
      },
    );// context & index of whichever item we're iterating through
  }
}
