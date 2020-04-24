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
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
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

    // TODO: Optimise filtration of users with removeWhere()

    listItems = <UserCard>[];
    var future = Future(() {});
    for(int idx = 0; idx < users.length; idx++) {
      final user = users[idx];
      if(currentUser.isTeacher != user.isTeacher
          && !currentUser.skippedUserIDs.contains(user.uid) &&
          (user.matchedUserID == null || user.matchedUserID == currentUser.uid) && !user.skippedUserIDs.contains(currentUser)) {
        // reinitializing future with lvalue helps futures wait for one-another (+then)
        future = future.then((_) {
          return Future.delayed(Duration(milliseconds: 100), () {
            final lastItemIndex = listItems.length;
            listItems.add(buildUserCard(
                currentUser,
                idx,
                users[idx],
                listIndex: lastItemIndex,
              )
            ); // add card item here
            try {
              _animatedListKey.currentState.insertItem(
                  lastItemIndex
              ); // insert the latest item here
            } catch (e) {
              logger.w('User w/ id "' + currentUser.uid + '" has navigated through match too fast!');
              // TODO: log that user has navigated through the screens too fast -> done
            }
          });
        });
      }
    }
  }

  UserCard buildUserCard(User currentUser, int index, User user, {int listIndex}) {
    final Database database = new Database(uid: currentUser.uid);

    return UserCard(
      key: Key(Keys.matchUserCard + index.toString()),
      user: user,
      userImage: images[index],
      onMatch: () async {
        if(currentUser.matchedUserID == null) {
          logger.i('UserList: Current user w/ id "' + currentUser.uid + '" is matched with user w/ id + "' + user.uid + '"');
          currentUser.matchedUserID = user.uid;
          await database.updateUserData(currentUser); // optimise later maybe
        }
        widget.reinitializeMatch();
      },
      onSkip: () async {
        currentUser.skippedUserIDs.add(user.uid);
        await database.updateUserData(currentUser); // optimise later maybe
        users.removeAt(index);
        listItems.removeAt(listIndex);
        logger.i('UserList: Current user w/ id "' + currentUser.uid + '" skipped user w/ id + "' + user.uid + '"');
        setState(() {
          // remove from both lists
          _animatedListKey.currentState.removeItem(listIndex,
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
      listIndex: listIndex, // idx of element in the filtered list
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

        return SlideTransition(
          position: animation.drive(Tween<Offset>(
            begin: const Offset(1, 0), // represent a point in Cartesian (x-y coordinate) space; dx and dy are args for points
            end: const Offset(0, 0), // points are between 1 and 0 (use that!)
          ).chain(CurveTween(curve: Curves.decelerate))),
          child: listItems[index], // get the generated user card from here
        );
      },
    );// context & index of whichever item we're iterating through
  }
}
