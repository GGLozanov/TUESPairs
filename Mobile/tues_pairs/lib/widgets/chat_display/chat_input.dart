import 'package:flutter/material.dart';
import 'package:tues_pairs/widgets/chat_display/send_button.dart';

class MessageInput extends StatelessWidget {

  TextEditingController messageController;
  final VoidCallback callback;
  MessageInput({this.messageController, this.callback});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              style: TextStyle(
                color: Colors.white
              ),
              onSubmitted: (value) => callback(),
              decoration: InputDecoration(
                hintText: "Enter a Message...",
                border: const OutlineInputBorder(),
                
              ),
              controller: messageController,
            ),
          ),
          SendButton(
            label: "Send",
            callback: callback,
          )
        ],
      ),
    );
  }
}