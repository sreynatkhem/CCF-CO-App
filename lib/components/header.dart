import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header(
      {this.bodys,
      this.headerTexts,
      this.drawers,
      this.bottomNavigationBars,
      this.floatingActionButtons});
  final bodys;
  final headerTexts;
  final drawers;
  final bottomNavigationBars;
  final floatingActionButtons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawers,
      appBar: AppBar(
        title: Text(
          headerTexts,
          style: mainTitleStyle,
        ),
        actions: <Widget>[
          // Using Stack to show Notification Badge
          new Stack(
            children: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.notifications,
                    size: 25,
                  ),
                  onPressed: () {}),
              12 != 0
                  ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '12',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : new Container()
            ],
          ),
        ],
        backgroundColor: blueColor,
      ),
      body: bodys,
      bottomNavigationBar: bottomNavigationBars,
      floatingActionButton: floatingActionButtons,
    );
  }
}
