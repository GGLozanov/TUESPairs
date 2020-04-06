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


Widget centeredText(String text){
  return Center(
    child: Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.orange,
          fontSize: 30.0,
          
        ),
        textAlign: TextAlign.center,
      )
    ),
  );
}

void scrollAnimation(ScrollController scrollController){
  scrollController.animateTo (
    scrollController.position.maxScrollExtent,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOut
  );
}
