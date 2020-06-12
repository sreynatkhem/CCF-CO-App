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
        backgroundColor: blueColor,
      ),
      body: bodys,
      bottomNavigationBar: bottomNavigationBars,
      floatingActionButton: floatingActionButtons,
    );
  }
}
