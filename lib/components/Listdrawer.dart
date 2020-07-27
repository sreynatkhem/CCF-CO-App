import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    //ToDO
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: logolightGreen))),
        child: InkWell(
            splashColor: Colors.orangeAccent,
            onTap: onTap,
            child: Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          icon,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                        ),
                        Text(
                          text,
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
