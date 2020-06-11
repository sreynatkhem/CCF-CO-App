import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header({this.body, this.headerText, this.drawer, this.bottomNavigationBar});
  final body;
  final headerText;
  final drawer;
  final bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: Text(
          headerText,
          style: mainTitleStyle,
        ),
        backgroundColor: blueColor,
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
