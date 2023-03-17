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
            Expanded(
              child: SizedBox(
                  //width: widthView(context, 0.4),
                  child: Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: SizedBox(
                //width: widthView(context, 0.5),
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
