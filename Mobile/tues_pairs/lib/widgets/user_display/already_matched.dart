import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/loading/loading.dart';


import '../../shared/constants.dart';

class AlreadyMatched extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);

    return FutureBuilder<User>( // TODO: export into home dart without killing app
      future: Database(uid: currentUser.matchedUserID).getUserById(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
            final matchedUser = snapshot.data;
            return currentUser.matchedUserID == matchedUser.uid && matchedUser.matchedUserID == currentUser.uid 
                ? centeredText('You are matched with: ' + matchedUser.username + '. Go ahead and chat!')
                : centeredText('You have sent a match request to: ' + matchedUser.username + '. Why not go ahead and chat with them when they accept it?');
        } else return Loading();
      }
    );
  }
}
