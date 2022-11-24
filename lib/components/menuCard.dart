import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  MenuCard({
    this.onTap,
    this.imageNetwork,
    this.text,
    this.color,
    this.text2,
    this.icons,
  });
  final dynamic onTap;
  final dynamic imageNetwork;
  final dynamic text;
  final dynamic color;
  final dynamic text2;
  final dynamic icons;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onTap,
      child: new Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        color: color,
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icons != null
                  ? icons
                  : Image(
                      image: imageNetwork,
                      width: 55,
                      height: 55,
                      // color: Colors.white,
                    ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                alignment: Alignment.center,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSizeXs,
                    color: Colors.white,
                    fontWeight: fontWeight700,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  text2 ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSizeXs,
                    color: Colors.white,
                    fontWeight: fontWeight700,
                  ),
                ),
              ),
              // Container(
              //   height: 15.0,
              //   child: FittedBox(
              //     fit: BoxFit.contain,
              //     child: Text(
              //       text,
              //       maxLines: 2,
              //       style: TextStyle(
              //         fontSize: fontSizeXs,
              //         // color: Colors.white,
              //         fontWeight: fontWeight700,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
