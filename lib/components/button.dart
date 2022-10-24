import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button(
      {this.widtdButton,
      this.heightButton,
      this.borderRadius,
      this.color,
      this.onPressed,
      this.text});

  final dynamic widtdButton;
  final dynamic heightButton;
  final dynamic borderRadius;
  final dynamic color;
  final dynamic text;
  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widtdButton,
      height: heightButton,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 3),
            blurRadius: 5,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSizeXs,
              color: Colors.white),
        ),
      ),
    );
  }
}
