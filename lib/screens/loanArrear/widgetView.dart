import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class WidgetViewTextLoanArrear extends StatelessWidget {
  WidgetViewTextLoanArrear({required this.title, required this.value});
  late String title;
  late String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: widthView(context, 0.4),
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
              width: widthView(context, 0.5),
              child: Text(
                value,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
