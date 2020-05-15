import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/widgets/general/centered_text.dart';


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
            logger.i('AlreadyMatched: Received matched user w/ id "' + matchedUser.uid + '"'
                'for current user w/ id "' + currentUser.uid + '"');

            return currentUser.matchedUserID == matchedUser.uid &&
              matchedUser.matchedUserID == currentUser.uid
                ? CenteredText(
                  text: 'You are matched with: ' +
                      matchedUser.username +
                      '. Go ahead and chat!'
                  )
                : CenteredText(
                  text: 'You have sent a match request to: ' +
                      matchedUser.username +
                      '. Why not go ahead and chat with them when they accept it?'
                );
        } else return Loading();
      }
    );
  }
}
