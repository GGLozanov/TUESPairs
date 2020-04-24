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
  final Database database = new Database();

  final unchosenColor = greyColor; // TODO: export into constants -> done

  bool isChosen = false;

  TagCard({this.key, @required this.tag, this.listIndex}) :
        assert(tag != null), super(key: key);

  @override
  _TagCardState createState() => _TagCardState();
}

class _TagCardState extends State<TagCard> {

  // Reuse for Settings but render different layout with cards (only remove option)

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if(user.tagIDs.contains(widget.tag.tid)) widget.isChosen = true;

    return Card(
      color: widget.isChosen ? HexColor(widget.tag.color) : widget.unchosenColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        leading: Icon(
          widget.isChosen ? Icons.remove_circle : Icons.add_circle,
        ),
        title: Text(
          widget.tag.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'BebasNeue',
          ),
        ),
        onTap: () {
          widget.isChosen ? user.tagIDs.remove(widget.tag.tid) : user.tagIDs.add(widget.tag.tid);
          logger.i('User has ' + (widget.isChosen ? 'removed' : 'chosen') + ' tag w/ list index ' + widget.listIndex.toString());
          setState(() => widget.isChosen = !widget.isChosen);
        },
      )
    );
  }
}
