import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/student.dart';

class UserCard extends StatelessWidget {

  final User user;
  final NetworkImage userImage;

  UserCard({this.user, this.userImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.cyanAccent[700], // TODO: Use user photoURL here
            child: ClipOval(
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: userImage == null ? Icon(
                  Icons.person,
                  size: 100.0,
                  color: Colors.orange,
                ) : Image(
                  image: userImage,
                  fit: BoxFit.fill,
                ),
              )
            ),
          ),
          subtitle: ButtonBar(
            children: <Widget>[
            FloatingActionButton(
              onPressed: () {},
              child: Text(
              'Match',
              )
            ),
            FloatingActionButton(
              onPressed: () {},
              child: Text(
                'Skip',
              )
            ),
            ],
          ),
          trailing: Text(
            user.username,
          ),
        ),
      ),
    );
  }
}
