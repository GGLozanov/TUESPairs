import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/locale/app_localization.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/tag_display/tag_card.dart';

class UserCard extends StatefulWidget {

  final Key key;
  final User user;
  Function onSkip;
  Function onMatch;
  final NetworkImage userImage;
  final List<TagCard> tagCards;
  int listIndex;
  final User currentUser;

  bool hasUserSentMatchRequestToCurrent = false;
  bool isViewCard = false;

  UserCard({
    this.key,
    @required this.user,
    @required this.onSkip,
    @required this.onMatch,
    this.userImage,
    @required this.listIndex,
    this.tagCards,
    @required this.currentUser
  }) :
    assert(user != null),
    assert(onSkip != null),
    assert(onMatch != null),
    assert(listIndex != null),
    assert(currentUser != null),
    super(key: key) {
      hasUserSentMatchRequestToCurrent = currentUser.uid == user.matchedUserID;
  }

  UserCard.view({
    this.key,
    @required this.user,
    this.userImage,
    this.tagCards,
    @required this.currentUser
  }) :
        assert(user != null),
        assert(currentUser != null),
        super(key: key) {
    isViewCard = true;
  }

  @override
  bool operator ==(other) {
    return other is UserCard ? user.uid == other.user.uid : false;
  }

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {

    logger.i('UserCard: Rendering user card for user w/ id "' + widget.user.uid + '"');
    final AppLocalizations localizator = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5.0,
        color: widget.hasUserSentMatchRequestToCurrent ? Colors.black54 : darkGreyColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 15.0),
            CircleAvatar(
              radius: 80.0,
              backgroundColor: darkGreyColor, // TODO: Use user photoURL here
              child: ClipOval(
                child: SizedBox(
                  width: 175.0,
                  height: 400.0,
                  child: widget.userImage == null ? Icon(
                    Icons.person,
                    size: 75.0,
                    color: Colors.orange,
                  ) : Image(
                    image: widget.userImage,
                    fit: BoxFit.fill,
                  ),
                )
              ),
            ),
            SizedBox(height: 10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.user.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center
                ),
                SizedBox(height: !widget.user.isTeacher ? 10.0 : 0.0),
                !widget.user.isTeacher ? Text(
                  localizator.translate('GPA') + ': '+ widget.user.GPA.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ) : SizedBox(),
                widget.hasUserSentMatchRequestToCurrent ? Text(
                  localizator.translate('userHasSentMatchRequest'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold
                  ),
                ) : SizedBox(),
                SizedBox(height: widget.user.description != '' ? 5.0 : 0.0),
                widget.user.description != '' ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    widget.user.isTeacher ?
                    localizator.translate('qualifiedIn') : 
                    localizator.translate('interestedIn'),
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center
                  ),
                ) : SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.user.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center
                  ),
                ),
                SizedBox(height: widget.user.description != '' ? 7.5 : 0.0),
              ]
            ),
            !widget.isViewCard ? ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 75.0,
                  padding: EdgeInsets.only(left: 20.0),
                  child: FittedBox(
                    child: FloatingActionButton(
                      key: Key(Keys.matchMatchButton + widget.listIndex.toString()),
                      onPressed: () {
                        widget.onMatch();
                      },
                      child: Text(
                        localizator.translate('match'),
                      ),
                      backgroundColor: Colors.deepOrange
                    ),
                  ),
                ),
                Container(
                  width: 150.0,
                  height: 75.0,
                  padding: EdgeInsets.only(right: 20.0),
                  child: FittedBox(
                    child: FloatingActionButton(
                      key: Key(Keys.matchSkipButton + widget.listIndex.toString()),
                      onPressed: () {
                        widget.onSkip(); // destroy the widget
                      },
                      child: Text(
                        localizator.translate('skip'),
                      ),
                      backgroundColor: Colors.deepOrange
                    ),
                  ),
                ),
              ],
            ) : SizedBox(),
            SizedBox(height: 10.0),
            IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: widget.tagCards,
                ),
              )
            ),
            SizedBox(height: 10.0),
          ]
        ),
      )
    );
  }
}
