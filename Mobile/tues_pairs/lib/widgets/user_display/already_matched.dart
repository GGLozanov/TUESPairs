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
          // highly non-optimal because same user is used in chat.dart later...
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
            final matchedUser = snapshot.data;
            logger.i('AlreadyMatched: Received matched user w/ id "' + matchedUser.uid + '"'
                'for current user w/ id "' + currentUser.uid + '"');

            final isCurrentUserMatched = currentUser.matchedUserID == matchedUser.uid &&
                matchedUser.matchedUserID == currentUser.uid;

            final alreadyMatchedText = {
              'title' : !isCurrentUserMatched ?
                  'sentRequestTo' : 'matchedWith',
              'description' : !isCurrentUserMatched ?
                  'goAheadAndChatWhenAccepted' : 'goAheadAndChat'
            };

            return ListView(
              key: Key(Keys.alreadyMatchedListView),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 10.0),
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
