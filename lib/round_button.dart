import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  RoundButton({@required this.color,@required this.onPress,@required this.text,this.textColor});

  final Color color;
  final String text;
  final Function onPress;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(30.0),
      elevation: 5.0,
      child: MaterialButton(
        onPressed: onPress,
        minWidth: 290.0,
        height: 42.0,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
