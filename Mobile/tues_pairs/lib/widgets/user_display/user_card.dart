import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/tag_display/tag_card.dart';

class UserCard extends StatefulWidget {

  final Key key;
  final User user;
  final Function onSkip;
  final Function onMatch;
  final NetworkImage userImage;
  final List<TagCard> tagCards;
  final int listIndex;

  UserCard({this.key, this.user, this.onSkip, this.onMatch,
    this.userImage, this.listIndex, this.tagCards}) : super(key: key);

  @override
  bool operator ==(other) {
    return other is UserCard ? user.uid == other.user.uid : false;
  }

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final Database database = new Database();
  
  @override
  Widget build(BuildContext context) {

    logger.i('UserCard: Rendering user card for user w/ id "' + widget.user.uid + '"');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5.0,
        color: darkGreyColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListTile(
            title: Column(
              children: <Widget>[
                Text(
                  widget.user.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 5.0),
                !widget.user.isTeacher ? Text(
                  'GPA ' + widget.user.GPA.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ) : SizedBox(),
              ]
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  buttonPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  children: <Widget>[
                    FloatingActionButton(
                      key: Key(Keys.matchMatchButton + widget.listIndex.toString()),
                      onPressed: () {
                        widget.onMatch();
                      },
                      child: Text(
                        'Match',
                      ),
                      backgroundColor: Colors.deepOrangeAccent
                    ),
                    FloatingActionButton(
                      key: Key(Keys.matchSkipButton + widget.listIndex.toString()),
                      onPressed: () {
                        widget.onSkip(); // destroy the widget
                      },
                      child: Text(
                        'Skip',
                      ),
                      backgroundColor: Colors.deepOrangeAccent
                    ),
                  ],
                ),
              ]
            ),
            leading: CircleAvatar(
              radius: 32.0,
              backgroundColor: darkGreyColor, // TODO: Use user photoURL here
              child: ClipOval(
                  child: SizedBox(
                    width: 175.0,
                    height: 300.0,
                    child: widget.userImage == null ? Icon(
                      Icons.person,
                      size: 55.0,
                      color: Colors.orange,
                    ) : Image(
                      image: widget.userImage,
                      fit: BoxFit.fill,
                    ),
                  )
              ),
            ),
          ),
          Wrap(
            children: widget.tagCards,
          ),
          SizedBox(height: 10.0),
          ]
        ),
      )
    );
  }
}
