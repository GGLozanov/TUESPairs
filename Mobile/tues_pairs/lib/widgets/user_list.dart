import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/modules/student.dart';
import 'package:tues_pairs/widgets/user_card.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  User currentUser;

  final database = new Database();

  final auth = new Auth();

  Future<FirebaseUser> getCurrentFirebaseUser () async {
    return await auth.auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    // access StreamProvider of QuerySnapshots info here


    final users = Provider.of<List<User>>(context) ?? []; // get the info from the stream

    return FutureBuilder(
      future: getCurrentFirebaseUser().then((value) async {
        currentUser = await database.getUserById(value.uid);
      }),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(// list of users widget
          itemCount: users.length,
          // ignore: missing_return
          itemBuilder: (context, index){
              final user = users[index];
              if(currentUser.uid != user.uid && currentUser.isAdmin != user.isAdmin){
                return UserCard(user: users[index]);
              }
              else{
                return SizedBox();
              }
            },
          );
        }else {
          return Container();
        }
      }, // context & index of whichever item we're iterating through
    );
  }
}
