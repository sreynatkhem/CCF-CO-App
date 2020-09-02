import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:flutter/material.dart';

class CardReport extends StatelessWidget {
  var text;
  var backgroundColors;
  var icons;
  var iconSizes;
  var onTap;
  String value;

  CardReport(
      {this.backgroundColors,
      this.iconSizes,
      this.icons,
      this.onTap,
      this.value,
      this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      child: Card(
        elevation: 10,
        color: backgroundColors,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: Colors.white),
        ),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(padding: EdgeInsets.only(top: 10)),
                Icon(
                  icons,
                  size: iconSizes,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context).translate(text) ?? text,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                value != null
                    ? Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          value.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    : Center()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
