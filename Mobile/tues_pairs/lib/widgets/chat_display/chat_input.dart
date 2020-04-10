import 'package:flutter/material.dart';
import 'package:tues_pairs/widgets/chat_display/send_button.dart';

class MessageInput extends StatelessWidget {

  TextEditingController messageController;
  final VoidCallback callback;
  ScrollController scrollController;
  MessageInput({this.messageController, this.callback, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(
                  color: Colors.white
                ),
                onSubmitted: (value) => callback(),
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hintText: "Enter a Message...",
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Color.fromRGBO(34, 34, 43, 1), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                ),
                controller: messageController,
              ),
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