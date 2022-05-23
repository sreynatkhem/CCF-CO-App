import 'package:flutter/material.dart';

class WidgetNotificatioinLoanArrear extends StatelessWidget {
  WidgetNotificatioinLoanArrear(this.title, this.value, this.styleLoanArrear);
  String title;
  String value;
  TextStyle? styleLoanArrear;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            title,
            style: styleLoanArrear,
          ),
        ),
        Container(
          child: Text(value),
        )
      ],
    );
  }
}
