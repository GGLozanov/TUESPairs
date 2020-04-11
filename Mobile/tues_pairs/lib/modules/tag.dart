import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Tag {

  String tid; // tag id
  String name;
  Color color;

  Tag({@required this.tid, this.name, this.color}) : assert(tid != null);

}