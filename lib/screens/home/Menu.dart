import 'package:chokchey_finance/components/approvalList.dart';
import 'package:chokchey_finance/components/approved.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final paddingCard = const EdgeInsets.all(8);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ApprovalLists()),
            ),
            child: new Card(
              color: lightGreen,
              child: new Container(
                padding: new EdgeInsets.all(32.0),
                child: new Column(
                  children: <Widget>[
                    Image.network(
                      'https://assets.webiconspng.com/uploads/2017/01/Resume-Simple-Icon.png',
                      width: 80,
                      height: 80,
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'Approval Lists',
                      style: textTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ),
          new GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Approved()),
            ),
            child: new Card(
              color: lightBlue,
              child: new Container(
                padding: new EdgeInsets.all(32.0),
                child: new Column(
                  children: <Widget>[
                    Image.network(
                      'https://www.iconsdb.com/icons/download/orange/approval-512.png',
                      width: 80,
                      height: 80,
                      color: iconMenu,
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'Approved',
                      style: textTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ),
          new GestureDetector(
            onTap: () => null,
            child: new Card(
              color: lightBlue,
              child: new Container(
                padding: new EdgeInsets.all(32.0),
                child: new Column(
                  children: <Widget>[
                    Image.network(
                      'https://image.flaticon.com/icons/png/512/2258/2258595.png',
                      width: 80,
                      height: 80,
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'Rejected',
                      style: textTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ),
          new GestureDetector(
            onTap: () => null,
            child: new Card(
              color: primaryBlue,
              child: new Container(
                padding: new EdgeInsets.all(32.0),
                child: new Column(
                  children: <Widget>[
                    Image.network(
                      'https://assets.webiconspng.com/uploads/2017/01/Resume-Simple-Icon.png',
                      width: 80,
                      height: 80,
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'Rejected',
                      style: textTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ),
          new GestureDetector(
            onTap: () => null,
            child: new Card(
              color: lightPink,
              child: new Container(
                padding: new EdgeInsets.all(32.0),
                child: new Column(
                  children: <Widget>[
                    Image.network(
                      'https://assets.webiconspng.com/uploads/2017/01/Resume-Simple-Icon.png',
                      width: 80,
                      height: 80,
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'Approval',
                      style: textTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ),
          new GestureDetector(
            onTap: () => null,
            child: new Card(
              color: lightPurple,
              child: new Container(
                padding: new EdgeInsets.all(32.0),
                child: new Column(
                  children: <Widget>[
                    Image.network(
                      'https://assets.webiconspng.com/uploads/2017/01/Resume-Simple-Icon.png',
                      width: 80,
                      height: 80,
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'Approval',
                      style: textTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
