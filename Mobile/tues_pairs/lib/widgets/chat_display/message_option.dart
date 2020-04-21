import 'package:flutter/material.dart';

class MessageOptions extends StatefulWidget {

  String mid;
  bool showOptions;
  Function callback;
  MessageOptions({this.mid, this.showOptions, this.callback});

  @override
  _MessageOptionsState createState() => _MessageOptionsState();
}

class _MessageOptionsState extends State<MessageOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: widget.callback,
          ),
        ]
      ),
    );
  }
}