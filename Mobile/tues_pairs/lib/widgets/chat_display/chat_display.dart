import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/message.dart';
import 'package:tues_pairs/widgets/chat_display/chat_input.dart';
import 'package:tues_pairs/widgets/chat_display/message_card.dart';

import '../../locale/app_localization.dart';
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
    final AppLocalizations localizator = AppLocalizations.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.scrollController.hasClients) {
        scrollAnimation(widget.scrollController);
      }
    });

    List<Message> messages = Provider.of<List<Message>>(context) ?? [];
    logger.i('ChatDisplay: Rendering ChatDisplay and receiving all Messages');

    User currentUser = Provider.of<User>(context);
    User matchedUser = widget.matchedUser;
    DateFormat formatterDateAndTime = new DateFormat().add_yMd().add_jm();
    DateFormat formatterDate = new DateFormat().add_yMd();
    String previousDate = null;
    String today = formatterDate.format(DateTime.now());

    List<Widget> messageCards = messages.map((message) {
      DateTime time = DateTime.parse(message.sentTime);
      String sentTime = formatterDateAndTime.format(time);
      String sentDate = formatterDate.format(time);

      if((message.fromId == currentUser.uid && message.toId == matchedUser.uid) || (message.fromId == matchedUser.uid && message.toId == currentUser.uid)) {
        bool isMe = message.fromId == currentUser.uid;

        logger.i('ChatDisplay: Rendering MessageCard w/ mid "' +
            message.mid + '" and sent time "' +
            message.sentTime + '" between current user w/ uid "' +
            currentUser.uid + '" and matched user w/ uid "' + matchedUser.uid + '"'
        );

        MessageCard messageCard = MessageCard(
          mid: message.mid,
          content: message.content,
          fromId: message.fromId,
          toId: message.toId,
          sentTime: sentTime,
          isMe: isMe,
          matchedUser: isMe ? null : matchedUser,
        );


        if(previousDate == null || previousDate != sentDate) {
          previousDate = sentDate;
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  sentDate == today ? localizator.translate('today') : sentDate,
                  style: TextStyle(
                    color: Colors.white24,
                  ),
                ),
              ),
              messageCard,
            ],
          );
        } else {
            return messageCard;
        }
      }
      return null;
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