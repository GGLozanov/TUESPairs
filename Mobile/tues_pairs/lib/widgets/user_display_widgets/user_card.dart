import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/student.dart';
import 'package:tues_pairs/services/database.dart';

class UserCard extends StatefulWidget {

  final User user;
  final Function onSkip;
  final Function onMatch;
  final NetworkImage userImage;

  UserCard({this.user, this.onSkip, this.onMatch, this.userImage});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final Database database = new Database();

  @override
  Widget build(BuildContext context) {
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
                  size: 50.0,
                  color: Colors.orange,
                ) : Image(
                  image: widget.userImage,
                  fit: BoxFit.fill,
                ),
              )
            ),
          ),
          subtitle: ButtonBar(
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  // TODO: set matchedUserID here
                  widget.onMatch();
                },
                child: Text(
                'Match',
                ),
                backgroundColor: Colors.deepOrangeAccent
              ),
              FloatingActionButton(
                onPressed: () {
                  // TODO: append to array of skippedUserIDs here
                  widget.onSkip(); // destroy the widget
                },
                child: Text(
                  'Skip',
                ),
                backgroundColor: Colors.deepOrangeAccent
              ),
            ],
          ),
          trailing: Text(
            widget.user.username,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
