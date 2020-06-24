import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header(
      {this.bodys,
      this.headerTexts,
      this.drawers,
      this.bottomNavigationBars,
      this.floatingActionButtons,
      this.actionsNotification});
  final bodys;
  final headerTexts;
  final drawers;
  final bottomNavigationBars;
  final floatingActionButtons;
  final actionsNotification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawers,
      appBar: AppBar(
        title: Text(
          headerTexts,
          style: mainTitleStyle,
        ),
        actions: actionsNotification,
        backgroundColor: logolightGreen,
      ),
      body: bodys,
      bottomNavigationBar: bottomNavigationBars,
      floatingActionButton: floatingActionButtons,
    );
  }
}
