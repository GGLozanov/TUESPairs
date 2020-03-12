import 'package:flutter/material.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/screens/main/settings.dart';
import 'package:tues_pairs/screens/main/chat.dart';
import 'package:tues_pairs/widgets/user_display_widgets/user_list.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/modules/user.dart';

class Match extends StatefulWidget {
  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<User>>.value(
      value: Database().users,
      child: Container(
        color: Color.fromRGBO(59, 64, 78, 1),
        child: UserList(),
      ),
    );
  }
}
