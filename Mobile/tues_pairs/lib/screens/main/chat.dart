import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/message.dart';
import 'package:tues_pairs/widgets/chat_display/chat_display.dart';

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

  @override
  Widget build(BuildContext context) {
    User matchedUser;
    final currentUser = Provider.of<User>(context);
    Database database = new Database();

    TextEditingController messageController = new TextEditingController();
    ScrollController scrollController = new ScrollController();

    Future<void> sendMessage() async{
      if(messageController.text.length > 0){
        await database.addMessage(Message(
          content: messageController.text,
          fromId: currentUser.uid,
          toId: matchedUser.uid,
          sentTime: DateTime.now().toIso8601String().toString(),
        ));

      }
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut
      );

    }


    return currentUser.matchedUserID == null ? Container(
      color: Color.fromRGBO(59, 64, 78, 1),
      child: centeredText("You are not matched with anyone!"),
    ) : FutureBuilder<User>(
      future: Database(uid: currentUser.matchedUserID).getUserById(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          matchedUser = snapshot.data;
          return StreamProvider<List<Message>>.value(
            value: Database().messages,
            child: Container(
              color: Color.fromRGBO(59, 64, 78, 1),
              child: currentUser.matchedUserID == matchedUser.uid && matchedUser.matchedUserID == currentUser.uid 
              ? ChatDisplay(matchedUser: matchedUser, messageController: messageController, callback: sendMessage, scrollController: scrollController) 
              : centeredText("Wait until your request is accepted!")
            ),
          );
        }else return Loading();
      },
    );
  }
}
