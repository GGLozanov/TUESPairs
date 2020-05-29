import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/chat_display/send_button.dart';

import '../../locale/app_localization.dart';

class MessageInput extends StatelessWidget {

  TextEditingController messageController;
  final VoidCallback callback;
  ScrollController scrollController;
  MessageInput({this.messageController, this.callback, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizator = AppLocalizations.of(context);

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  color: Colors.white
                ),
                onSubmitted: (value) => callback(),
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hintText: 'enterMessage',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: darkGreyColor, width: 2.0),
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
            label: localizator.translate('send'),
            callback: callback,
          )
        ],
      ),
    );
  }
}