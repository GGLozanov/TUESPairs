import 'package:flutter/material.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/alumni.dart';

class UserCard extends StatelessWidget {

  final User user;
  UserCard({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.cyanAccent[700],
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
