import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/database.dart';
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

  bool showOptions = false;
  final Database database = new Database();

  void deleteMessage() async{
    setState(() {
      showOptions = false;
    });
    await database.deleteMessage(widget.mid);
  }

  Widget displayImage(User user){
    return user.photoURL == null ? Icon(
      Icons.person,
      size: 33.5,
      color: Colors.orange,
    ) : Image.network(
      user.photoURL,
      fit: BoxFit.fill,
    );
  }

  Widget displayAvatar(User user){
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

  Widget displayTime(){
    return showOptions ? Padding(
      padding: widget.isMe ? EdgeInsets.only(right: 10.0) : EdgeInsets.only(left: 10.0),
      child: Text(
        widget.sentTime,
        style: TextStyle(
          color: Colors.white24,
        ),
      ),
    ) : SizedBox();
  }

  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<User>(context);

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
            showOptions = true;
          });
        },
        onTap: () {
          setState(() {
            showOptions = false;
          });
        },
        child: Container(
          child: Column(
            crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: !widget.isMe ? messageCard : messageCard.reversed.toList() ,
              ),
              displayTime(),
            ]
          ),
        ),
      ),
    );
  }
}