import 'package:chokchey_finance/screens/notificationLoanArrear/widgetLoanArrear.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class PushNotificationLoanLoanArrear extends StatefulWidget {
  const PushNotificationLoanLoanArrear({Key? key}) : super(key: key);

  @override
  State<PushNotificationLoanLoanArrear> createState() =>
      _PushNotificationLoanLoanArrearState();
}

class _PushNotificationLoanLoanArrearState
    extends State<PushNotificationLoanLoanArrear> {
  List<dynamic> notification = [
    {
      "name": "Vensopraet",
      "account": "000222143",
      "phoneNumber": "0987654123",
      "overDay": "12",
    },
    {
      "name": "Sokhun",
      "account": "939399990",
      "phoneNumber": "0987654123",
      "overDay": "34",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          setState(() {});
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: logolightGreen,
          title: Text("Notificatio loan arrear"),
        ),
        body: ListView.builder(
          itemCount: notification.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: widthView(context, 0.4),
                          child: Text("Employee Name : ",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18)),
                        ),
                        Container(
                          width: widthView(context, 0.4),
                          child: Text(notification[index]['name'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: widthView(context, 0.4),
                          child: Text(
                            "Account Number : ",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Container(
                          width: widthView(context, 0.4),
                          child: Text(
                            notification[index]['account'],
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: widthView(context, 0.4),
                          child: Text(
                            "Phone Number : ",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Container(
                          width: widthView(context, 0.4),
                          child: Text(
                            notification[index]['phoneNumber'],
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: widthView(context, 0.4),
                          child: Text(
                            "Overday : ",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Container(
                          width: widthView(context, 0.4),
                          child: Text(
                            notification[index]['overDay'],
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
