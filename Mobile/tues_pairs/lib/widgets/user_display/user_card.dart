import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/shared/constants.dart';

class UserCard extends StatefulWidget {

  final Key key;
  final User user;
  final Function onSkip;
  final Function onMatch;
  final NetworkImage userImage;
  final int listIndex;

  UserCard({this.key, this.user, this.onSkip, this.onMatch, this.userImage, this.listIndex}) : super(key: key);

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
        color: Color.fromRGBO(33, 36, 44, 1),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Color.fromRGBO(33, 36, 44, 1), // TODO: Use user photoURL here
            child: ClipOval(
              child: SizedBox(
                width: 100.0,
                height: 100.0,
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
          subtitle: ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
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
          trailing: Column(
            children: <Widget>[
              Text(
                widget.user.username,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5.0),
              !widget.user.isTeacher ? Text(
                'GPA ' + widget.user.GPA.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ) : SizedBox(),
            ]
          ),
        ),
      )
    );
  }
}
