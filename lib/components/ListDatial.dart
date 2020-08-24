import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class ListDetail extends StatelessWidget {
  final name;
  final value;
  final iconName;

  ListDetail({this.name, this.value, this.iconName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    AppLocalizations.of(context).translate(name.toString()) ??
                        '${name.toString()}:',
                  )),
            ],
          ),
          Container(
              padding: EdgeInsets.only(left: 10, top: 5),
              width: 300,
              child: Text(
                value.toString(),
                style: mainTitleBlack,
              )),
        ],
      ),
    );
  }
}
