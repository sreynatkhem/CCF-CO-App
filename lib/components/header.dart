import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header(
      {this.bodys,
      this.leading,
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
  final leading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawers,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate(headerTexts) ?? headerTexts,
          style: mainTitleStyle,
        ),
        actions: actionsNotification,
        backgroundColor: logolightGreen,
        leading: leading,
      ),
      body: bodys,
      bottomNavigationBar: bottomNavigationBars,
      floatingActionButton: floatingActionButtons,
    );
  }
}
