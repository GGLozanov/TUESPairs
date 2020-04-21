import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/chat_display/message_option.dart';

import '../../modules/user.dart';

class MessageCard extends StatefulWidget {
  String mid;
  String content;
  String fromId;
  String toId;
  String sentTime;
  bool isMe;
  User matchedUser;

  MessageCard({this.mid, this.content, this.fromId, this.toId, this.sentTime, this.isMe, this.matchedUser});

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {

  bool showTime = false;
  bool showOptions = false;
  final Database database = new Database();
  User currentUser;

  void deleteMessage() async{
    setState(() {
      showOptions = false;
    });
    await database.deleteMessage(widget.mid);
    logger.i('MessageCard: Deleting MessageCard w/ mid "' +
        widget.mid + '" and sent time "' +
        widget.sentTime + '" sent from current user w/ uid "' +
        currentUser.uid + '"'
    );
  }

  Widget displayImage(User user){
    if(user.photoURL != null) {
      logger.i('MessageCard: Displaying photo of MessageCard w/ mid "' +
          widget.mid + '" sent during "' +
          widget.sentTime + '" sent from user w/ uid "' +
          user.uid + '" and photo URL "' + user.photoURL + '"'
      );

      return Image.network(
        user.photoURL,
        fit: BoxFit.fill,
      );
    }

    logger.i('MessageCard: Displaying photo of MessageCard w/ mid "' +
        widget.mid + '" sent during "' +
        widget.sentTime + '" sent from user w/ uid "' +
        user.uid + '" and an empty photo URL'
    );

    return Icon(
      Icons.person,
      size: 33.5,
      color: Colors.orange,
    );
  }

  Widget displayAvatar(User user) {
    return CircleAvatar(
      radius: 22.5,
      backgroundColor: Color.fromRGBO(33, 36, 44, 1),
      child: ClipOval(
        child: SizedBox(
          width: 45.0,
          height: 45.0,
          child: displayImage(user),
        ),
      )
    );
  }

  Widget displayTime() {
    if(showTime) {
      logger.i('MessageCard: Displaying MessageCard w/ mid "' +
          widget.mid + '" sent time "' +
          widget.sentTime + '" sent from current user w/ uid "' +
          currentUser.uid + '"'
      );

      return Padding(
        padding: widget.isMe ? EdgeInsets.only(right: 10.0) : EdgeInsets.only(left: 10.0),
        child: Text(
          widget.sentTime,
          style: TextStyle(
            color: Colors.white24,
          ),
        ),
      );
    }

    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {

    currentUser = Provider.of<User>(context);

    final List<Widget> messageCard = [
      SizedBox(width: 5.0),
      Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: displayAvatar(widget.isMe ? currentUser : widget.matchedUser)
      ),
      SizedBox(width: 5.0),
      Material(
        color: widget.isMe ? Colors.orange : Color.fromRGBO(34, 34, 43, 1),
        borderRadius: BorderRadius.circular(10.0),
        elevation: 2.0,
        child: Container(
          constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Text(
            widget.content,
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: widget.isMe ? TextAlign.end : TextAlign.start,
          ),
        ),
      ),
      showOptions && widget.isMe ? MessageOptions(mid: widget.mid, showOptions: showOptions, callback: deleteMessage) : SizedBox(),
    ];

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: InkWell(
        onLongPress: (){
          setState(() {
            logger.i('MessageCard: User w/ uid "' + currentUser.uid + '" has long-pressed on the inkwell (showOptions = true)');
            showOptions = true;
          });
        },
        onTap: () {
          setState(() {
            logger.i('MessageCard: User w/ uid "' + currentUser.uid + '" has tapped on the inkwell (showOptions = false)');
            showTime = !showTime;
            showOptions = false;
          });
        },
        child: Container(
          child: Column(
            crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: !widget.isMe ? messageCard : messageCard.reversed.toList(),
              ),
              displayTime(),
            ]
          ),
        ),
      ),
    );
  }
}