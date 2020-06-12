import 'package:chokchey_finance/components/header.dart';
import 'package:flutter/material.dart';

class Approved extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Header(
      headerTexts: 'Approved',
      bodys: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 220,
        width: double.maxFinite,
        child: Card(
          elevation: 5,
        ),
      ),
    );
  }
}
