import 'package:flutter/material.dart';


const textInputDecoration = InputDecoration(
  
  hintStyle: TextStyle(
    color: Colors.white24
  ),
  labelStyle: TextStyle(
    decorationStyle: TextDecorationStyle.solid,
    color: Colors.white24,
  ),
  enabledBorder: UnderlineInputBorder(      
    borderSide: BorderSide(
      color: Colors.orange
    ),   
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.orange,
    ),
  ),  

);

const textInputColor = TextStyle(
    color: Colors.white,
);