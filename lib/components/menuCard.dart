import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  MenuCard({this.onTap, this.imageNetwork, this.text, this.color});
  final dynamic onTap;
  final dynamic imageNetwork;
  final dynamic text;
  final dynamic color;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onTap,
      child: new Card(
        color: color,
        child: new Container(
          // padding: new EdgeInsets.all(0.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: imageNetwork,
                width: 80,
                height: 80,
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                text,
                style: textTextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
