import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class CardState extends StatelessWidget {
  final images;
  final texts;
  final onTaps;
  final id;
  final createdAt;
  final email;
  final phone;
  final iconRight;
  final textTwo;

  CardState(
      {this.images,
      this.texts,
      this.onTaps,
      this.id,
      this.createdAt,
      this.email,
      this.phone,
      this.textTwo,
      this.iconRight});
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (texts != null)
                        Text(AppLocalizations.of(context)!.translate(texts) ??
                            texts.toString()),
                      if (textTwo != '') Text(textTwo),
                      if (id != null) Text(id.toString()),
                      if (createdAt != null) Text(createdAt.toString()),
                      if (email != null) Text(email.toString()),
                      if (phone != null) Text(phone.toString()),
                    ],
                  ),
                ])),
          )),
    );
  }
}
