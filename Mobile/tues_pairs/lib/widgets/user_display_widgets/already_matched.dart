import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/widgets/general/error.dart';

class AlreadyMatched extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);

    return FutureBuilder<User>(
      future: Database(uid: currentUser.matchedUserID).getUserById(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Error();
        } else if(snapshot.connectionState == ConnectionState.done) {
          final user = snapshot.data;
          return Container(
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    // TODO: mass clear in DB if condition for both matched is met (clear matchedUserIDs wherein it matches user ID)
                    currentUser.matchedUserID == user.uid && user.matchedUserID == currentUser.uid ? 'You are matched with: ' + user.username + '. Go ahead and chat!':
                  'You have sent a match request to: ' + user.username + '. Why not go ahead and chat with them when they accept it?',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]
            ),
          );
        } else return Container();
      }
    );
  }
}
