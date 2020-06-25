import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class CardMessage extends StatelessWidget {
  final String title;
  final String textMessage;

  CardMessage({this.title, this.textMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, bottom: 5),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: mainTitleBlack,
                    )),
              ),
              Container(
                width: 350,
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      textMessage,
                      style: normalTitleblack,
                      maxLines: 7,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
