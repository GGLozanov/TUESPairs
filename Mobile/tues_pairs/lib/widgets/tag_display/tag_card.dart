import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/general/hex_color.dart';

class TagCard extends StatefulWidget {

  final Key key;
  final Tag tag;
  final int listIndex;

  bool isChosen;
  bool isViewTag = false;

  final unchosenColor = darkGreyColor; // TODO: export into constants -> done

  double tagHeight;
  double tagWidth;

  Function onTap;

  TagCard.selection({this.key, @required this.tag, this.listIndex}) :
        assert(tag != null), super(key: key) {

    isChosen = false;
    tagWidth = 215.0;
    tagHeight = 100.0;
    onTap = (user) {
      isChosen ? user.tagIDs.remove(tag.tid) : user.tagIDs.add(tag.tid);
      logger.i('User has ' + (isChosen ? 'removed' : 'chosen') + ' tag w/ list index ' + listIndex.toString());
      isChosen = !isChosen;
    };
  }

  TagCard.alreadyChosenSelection({this.key, @required this.tag, this.listIndex}) :
        assert(tag != null), super(key: key) {

    isChosen = true;
    tagWidth = 215.0;
    tagHeight = 100.0;
    onTap = (user) {
      isChosen ? user.tagIDs.remove(tag.tid) : user.tagIDs.add(tag.tid);
      logger.i('User has ' + (isChosen ? 'removed' : 'chosen') + ' tag w/ list index ' + listIndex.toString());
      isChosen = !isChosen;
    };
  }

  TagCard.view({this.key, @required this.tag, this.listIndex}) :
        assert(tag != null), super(key: key) {

    isChosen = true;
    tagWidth = 155.0;
    tagHeight = 55.0;
    isViewTag = true;
    onTap = (user) => {}; // literally does nothing :o
  }

  @override
  _TagCardState createState() => _TagCardState();
}

class _TagCardState extends State<TagCard> {

  // Reuse for Settings but render different layout with cards (only remove option)

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // TODO: For future reference, UI errors with tags can be caused due to fontsize (decrease)
    final tagName = Text(
      widget.tag.name,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'BebasNeue',
      ),
    );

    if(user.tagIDs.contains(widget.tag.tid)) widget.isChosen = true;

    return Container(
      height: widget.tagHeight,
      width: widget.tagWidth,
      child: Card(
          elevation: 5.0,
          color: widget.isChosen ? HexColor(widget.tag.color) : widget.unchosenColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListTile(
              leading: widget.isViewTag ? tagName : Icon(
                widget.isChosen ? Icons.remove_circle : Icons.add_circle,
              ),
              title: widget.isViewTag ? SizedBox() : tagName,
              onTap: () {
                widget.onTap(user);
                setState(() => {});
                // re-render because onTap(); there are some useless re-renders with this but oh well
              }
          )
      ),
    );
  }
}
