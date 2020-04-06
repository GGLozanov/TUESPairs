import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/message.dart';
import 'package:tues_pairs/widgets/chat_display/chat_input.dart';
import 'package:tues_pairs/widgets/chat_display/message_card.dart';

import '../../modules/user.dart';
import '../../modules/user.dart';
import '../../shared/constants.dart';

class ChatDisplay extends StatefulWidget {

  User matchedUser;
  VoidCallback callback;
  TextEditingController messageController;
  ScrollController scrollController;
  ChatDisplay({this.matchedUser, this.callback, this.messageController, this.scrollController});

  @override
  _ChatDisplayState createState() => _ChatDisplayState();
}

class _ChatDisplayState extends State<ChatDisplay> {


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.scrollController.hasClients){
        scrollAnimation(widget.scrollController);
      }
    });
    List<Message> messages = Provider.of<List<Message>>(context) ?? [];

    User currentUser = Provider.of<User>(context);
    User matchedUser = widget.matchedUser;
    DateFormat formatter = new DateFormat().add_yMd().add_jm();
  
    List<Widget> messageCards = messages.map((message) {
      DateTime time = DateTime.parse(message.sentTime);
      if((message.fromId == currentUser.uid && message.toId == matchedUser.uid) || (message.fromId == matchedUser.uid && message.toId == currentUser.uid)){
        bool isMe = message.fromId == currentUser.uid ? true : false;
        return MessageCard(
          mid: message.mid,
          content: message.content,
          fromId: message.fromId,
          toId: message.toId,
          sentTime: formatter.format(time),
          isMe: isMe,
          matchedUser: isMe ? null : matchedUser,
        );
      }
    }).toList();

    messageCards.removeWhere((messageCard) => messageCard == null);
    

    return SafeArea(
      child: Column(
        children: <Widget>[
          
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              children: messageCards,
            ),
          ),

          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MessageInput(messageController: widget.messageController, callback: widget.callback, scrollController: widget.scrollController),
                )
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}