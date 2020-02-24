import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/alumni.dart';
import 'package:tues_pairs/widgets/user_card.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    // access StreamProvider of QuerySnapshots info here

    final users = Provider.of<List<User>>(context); // get the info from the stream

    return ListView.builder( // list of users widget
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserCard(user: users[index]);
      }, // context & index of whichever item we're iterating through
    );
  }
}
