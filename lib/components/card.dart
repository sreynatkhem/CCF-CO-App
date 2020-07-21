import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';

class CardState extends StatelessWidget {
  final images;
  final texts;
  final onTaps;

  CardState({this.images, this.texts, this.onTaps});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: logolightGreen, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
              onTap: onTaps,
              splashColor: Colors.blue.withAlpha(30),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 60, left: 10)),
                Image(
                  image: images,
                  width: 45,
                  height: 45,
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Text(texts),
              ]))),
    );
  }
}
