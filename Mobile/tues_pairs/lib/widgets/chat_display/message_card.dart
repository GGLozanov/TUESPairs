import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../modules/user.dart';

class MessageCard extends StatelessWidget {

  String content;
  String fromId;
  String toId;
  String sentTime;
  bool isMe;
  User matchedUser;

  MessageCard({this.content, this.fromId, this.toId, this.sentTime, this.isMe, this.matchedUser});



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

  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<User>(context);


    final List<Widget> messageCard = [
      SizedBox(width: 5.0),
      Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: displayAvatar(isMe ? currentUser : matchedUser)
      ),
      SizedBox(width: 5.0),
      Material(
        color: isMe ? Colors.orange : Color.fromRGBO(34, 34, 43, 1),
        borderRadius: BorderRadius.circular(10.0),
        elevation: 6.0,
        child: Container(
          constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Text(
            content,
            style: TextStyle(
              color: Colors.white
            ),
          textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: !isMe ? messageCard : messageCard.reversed.toList() ,
            ),
            Text(
              sentTime,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ]
        ),
      ),
    );
  }
}