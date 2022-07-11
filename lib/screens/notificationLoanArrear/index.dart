import 'package:chokchey_finance/screens/notificationLoanArrear/widgetLoanArrear.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/notification/index.dart';

class PushNotificationLoanLoanArrear extends StatefulWidget {
  const PushNotificationLoanLoanArrear({Key? key}) : super(key: key);

  @override
  State<PushNotificationLoanLoanArrear> createState() =>
      _PushNotificationLoanLoanArrearState();
}

class _PushNotificationLoanLoanArrearState
    extends State<PushNotificationLoanLoanArrear> {
  @override
  void initState() {
    getListNotificationLoanArrear();
    super.initState();
  }

  bool isLoading = false;
  List listNotificationLoanArrear = [];
  dynamic totalAccount = "";
  int totalAccountPush = 0;

  Future getListNotificationLoanArrear() async {
    setState(() {
      isLoading = true;
    });
    var datetime = DateTime.now();
    String getDateTimeNow = DateFormat("yyyyMMdd").format(datetime);

    String mgmtBranchCode = "";
    String referenEmployeeNo = "";

    await Provider.of<NotificationProvider>(context, listen: false)
        .getListLoanArrear(
      baseDate: getDateTimeNow,
      currencyCode: "",
      loanAccountNo: "",
      mgmtBranchCode: mgmtBranchCode,
      referenEmployeeNo: referenEmployeeNo,
    )
        .then((value) {
      totalAccount = value.length;
      // logger().e(totalAccount);
      setState(() {
        isLoading = false;
        totalAccount = value.length;
        listNotificationLoanArrear = value;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future onClickPushNotification() async {
    listNotificationLoanArrear.asMap().forEach((idx, val) async {
      await Provider.of<NotificationProvider>(context, listen: false)
          .pushNotificationLoanArrear(
        accountcustomer: "${val[idx]['loanAccountNo']}",
        namecustomer: "${val[idx]['customerName']}",
        overduedate: "${val[idx]['overdueDays']}",
        phone: "${val[idx]['cellPhoneNo']}",
        ucode: "${val[idx]['refereneceEmployeeNo']}",
      )
          .then((value) {
        totalAccountPush = idx + 1;
        setState(() {
          isLoading = false;
        });
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: logolightGreen,
        title: Text("Notification Loan Arrear"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  padding: EdgeInsets.all(10),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: logolightGreen, width: 1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Loan Arrear",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 5)),
                        Text(
                          "${totalAccount}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  padding: EdgeInsets.all(10),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: logolightGreen, width: 1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Loan Arrear Pushed",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 5)),
                        Text(
                          "${totalAccountPush.toString()}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 90,
                  padding: EdgeInsets.all(20),
                  child: RaisedButton.icon(
                    color: logolightGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      onClickPushNotification();
                    },
                    label: Text(
                      "Push Notification Loan Arrear",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.notification_add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
