import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class CardMessage extends StatelessWidget {
  final String? title;
  final String? textMessage;

  CardMessage({this.title, this.textMessage});

  @override
  Widget build(BuildContext context) {
    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 15.0 : 0.0;
    return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, bottom: 5),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title!,
                  style: mainTitleBlack,
                )),
          ),
          Center(
            child: Container(
              width: 375,
              margin: EdgeInsets.only(right: bottomPadding),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: logolightGreen, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    textMessage!,
                    style: normalTitleblack,
                    maxLines: 7,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
