import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/widgets/general/centered_text.dart';
import 'package:tues_pairs/widgets/user_display/user_card.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/services/image.dart';

class AlreadyMatched extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);
    final tags = Provider.of<List<Tag>>(context);

    return FutureBuilder<User>( // TODO: export into home dart without killing app
      future: Database(uid: currentUser.matchedUserID).getUserById(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
            final matchedUser = snapshot.data;
            logger.i('AlreadyMatched: Received matched user w/ id "' + matchedUser.uid + '"'
                'for current user w/ id "' + currentUser.uid + '"');

            final isCurrentUserMatched = currentUser.matchedUserID == matchedUser.uid &&
                matchedUser.matchedUserID == currentUser.uid;

            final alreadyMatchedText = {
              'title' : !isCurrentUserMatched ?
                  'You have sent a match request to ' : 'You are matched with ',
              'description' : !isCurrentUserMatched ?
                  'Why not go ahead and chat with them when they accept it?' : 'Go ahead and chat!'
            };

            return ListView(
              key: Key(Keys.alreadyMatchedListView),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CenteredText(
                      text: alreadyMatchedText['title']
                    ),
                    SizedBox(height: 10.0),
                    UserCard.view(
                      user: matchedUser,
                      tagCards: getUserTagCards(tags, matchedUser),
                      userImage: ImageService.getImageByURL(matchedUser.photoURL),
                      currentUser: currentUser
                    ),
                    SizedBox(height: 10.0),
                    CenteredText(
                      text: alreadyMatchedText['description'],
                    )
                  ],
                ),
              ]
            );
        } else return Loading();
      }
    );
  }
}
