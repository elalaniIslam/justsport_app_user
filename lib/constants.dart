import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kTextFieldStyle = InputDecoration(

    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
    hintText: 'Type your message here...',
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: Color(0xfff9aa33),width: 2)
    ),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: Colors.yellow,width: 2)
    )
);
const kColorBlack=Color(0xff344955);
const kColorOrange=Color(0xfff9aa33);
const kColorBlue=Color(0xffe2ebf4);
const kProductTitleStyle=TextStyle(
  color: Colors.black,
  fontSize: 12,
  fontWeight: FontWeight.bold,
);
const kProductPriceStyle=TextStyle(
  color: kColorOrange,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);