import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';

class ImagePickers extends StatelessWidget {
  var onPressed;
  ImagePickers({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10)),
          FloatingActionButton(
            onPressed: onPressed,
            backgroundColor: logolightGreen,
            tooltip: 'Pick Image',
            child: Icon(
              Icons.add_a_photo,
            ),
          ),
        ],
      ),
    );
  }
}
