import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final dynamic? onTap;
  final bool showDecoration;
  dynamic? isFlag;

  CustomListTile(this.icon, this.text, this.onTap, this.isFlag,
      {this.showDecoration = true});
  @override
  Widget build(BuildContext context) {
    //ToDO
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: this.showDecoration
            ? BoxDecoration(
                border: Border(bottom: BorderSide(color: logolightGreen)))
            : null,
        child: InkWell(
            //splashColor: Colors.orangeAccent,
            onTap: onTap,
            child: Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        if (isFlag != null)
                          Image(
                            image: isFlag,
                            height: 20,
                            fit: BoxFit.fill,
                          ),
                        // Icon(
                        //   icon,
                        //   size: 20,
                        // ),
                        if (isFlag != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                          ),
                        Text(
                          text!,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ))),
      ),
    );
  }
}
