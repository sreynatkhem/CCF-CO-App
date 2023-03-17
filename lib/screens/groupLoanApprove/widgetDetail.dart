import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class DetailWidget {
  var title;
  var subTitle;
  var context;
  DetailWidget({this.title, this.subTitle, this.context});

  getTextDetail() {
    return Row(
      children: [
        Text(
            AppLocalizations.of(context)!.translate(title.toString()) ?? title),
        Text(
          ": " + subTitle,
          style: TextStyle(fontWeight: fontWeight700),
        ),
      ],
    );
  }
}
