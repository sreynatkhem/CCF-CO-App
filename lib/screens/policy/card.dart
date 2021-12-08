import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardPolicy extends StatefulWidget {
  var imageCard;
  var onTap;
  var title;
  CardPolicy({this.imageCard, this.onTap, this.title});
  @override
  _CardPolicyState createState() =>
      _CardPolicyState(imageCard: imageCard, onTap: onTap, title: title);
}

class _CardPolicyState extends State<CardPolicy> {
  var imageCard;
  var onTap;
  var title;

  _CardPolicyState({this.imageCard, this.onTap, this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: logolightGreen, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: InkWell(
              onTap: onTap,
              splashColor: Colors.blue.withAlpha(30),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 60, left: 10)),
                Image(
                  image: imageCard,
                  width: 45,
                  height: 45,
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.translate(title)!),
                  ],
                ),
              ])),
        ),
      ),
    );
  }
}
