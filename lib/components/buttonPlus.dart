import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class ButtonPlus extends StatelessWidget {
  ButtonPlus(
      {this.heights,
      this.widths,
      this.bottom,
      this.right,
      this.animation3,
      this.color,
      this.onTap,
      this.text});

  final dynamic animation3;
  final dynamic color;
  final dynamic text;
  final dynamic onTap;
  final dynamic bottom;
  final dynamic right;
  final dynamic widths;
  final dynamic heights;

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        bottom: bottom,
        right: right,
        child: new Container(
          child: new Row(
            children: <Widget>[
              new ScaleTransition(
                scale: animation3,
                alignment: FractionalOffset.center,
                child: new Container(
                  margin: new EdgeInsets.only(right: 16.0),
                  child: new Text(
                    text,
                    style: new TextStyle(
                      fontSize: 13.0,
                      fontFamily: fontFamily,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              new ScaleTransition(
                scale: animation3,
                alignment: FractionalOffset.center,
                child: new Material(
                    color: color,
                    type: MaterialType.circle,
                    elevation: 6.0,
                    child: new GestureDetector(
                      child: new Container(
                          width: 40.0,
                          height: 40.0,
                          child: new InkWell(
                            borderRadius: BorderRadius.circular(100),
                            splashColor: Colors.red,
                            onTap: onTap,
                            child: new Center(
                              child: new Icon(
                                Icons.add,
                                color: new Color(0xFFFFFFFF),
                              ),
                            ),
                          )),
                    )),
              ),
            ],
          ),
        ));
  }
}
