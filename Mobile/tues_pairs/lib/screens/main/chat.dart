import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/message.dart';
import 'package:tues_pairs/widgets/chat_display/chat_display.dart';
import 'package:tues_pairs/widgets/chat_display/chat_input.dart';

import '../../modules/user.dart';
import '../../services/database.dart';
import '../../services/database.dart';
import '../../services/database.dart';
import '../../shared/constants.dart';
import '../loading/loading.dart';

class Chat extends StatefulWidget {

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    User matchedUser;
    final currentUser = Provider.of<User>(context);
    TextEditingController messageController = new TextEditingController();
    final Database database = new Database(uid: currentUser.matchedUserID);

    Future<void> sendMessage() async {
      if(messageController.text.length > 0){
        await database.addMessage(Message(
          content: messageController.text,
          fromId: currentUser.uid,
          toId: matchedUser.uid,
          sentTime: DateTime.now().toIso8601String().toString(),
        ));
      }
      messageController.clear();
      scrollAnimation(scrollController);
    }

    return Container(
      color: Color.fromRGBO(59, 64, 78, 1),
      child: currentUser.matchedUserID == null ? centeredText("You are not matched with anyone!") : FutureBuilder<User>(
        future: database.getUserById(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            matchedUser = snapshot.data;
            return StreamProvider<List<Message>>.value(
              value: database.messages,
              child: currentUser.matchedUserID == matchedUser.uid && matchedUser.matchedUserID == currentUser.uid 
                ? ChatDisplay(matchedUser: matchedUser, messageController: messageController, callback: sendMessage, scrollController: scrollController) 
                : centeredText("Wait until your request is accepted!")
            );
          } else return Loading();
        },
      )
    );
  }
}
