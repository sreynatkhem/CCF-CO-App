import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';

class ImagePickers extends StatelessWidget {
  Function onPressed;
  IconData icon;
  String heroTag;

  ImagePickers({this.onPressed, this.icon, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10)),
          FloatingActionButton(
            heroTag: heroTag,
            onPressed: onPressed,
            backgroundColor: logolightGreen,
            tooltip: 'Pick Image',
            child: Icon(
              icon,
            ),
          ),
        ],
      ),
    );
  }
}
