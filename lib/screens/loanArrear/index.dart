import 'package:chokchey_finance/providers/loanArrearProvider/loanArrearProvider.dart';
import 'package:chokchey_finance/screens/listLoanApproval/indexs.dart';
import 'package:chokchey_finance/screens/loanArrear/detail.dart';
import 'package:chokchey_finance/screens/loanArrear/widgetView.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:platform/platform.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class LoanArrearScreen extends StatefulWidget {
  const LoanArrearScreen({Key? key}) : super(key: key);

  @override
  _LoanArrearScreenState createState() => _LoanArrearScreenState();
}

class _LoanArrearScreenState extends State<LoanArrearScreen> {
  @override
  void initState() {
    // TODO: implement initState
    fetchLoanArrear();
    super.initState();
  }

  dynamic listLoanArrear = [];
  bool _isLoading = false;
  dynamic overviewmonth = 0.0;
  dynamic currencyUSD = 0.0;
  dynamic currencyKhmer = 0.0;
  var format = NumberFormat.simpleCurrency(name: 'KHM');

  Future fetchLoanArrear() async {
    // branch
    String branch = await storage.read(key: 'branch');
    String level = await storage.read(key: 'level');
    String user_ucode = await storage.read(key: 'user_ucode');

    setState(() {
      _isLoading = true;
    });
    var datetime = DateTime.now();
    String getDateTimeNow = DateFormat("yyyyMMdd").format(datetime);

    String mgmtBranchCode = "";
    String referenEmployeeNo = "";

    if (branch != "0100") {
      mgmtBranchCode = branch;
    }

    if (level == '3') {
      mgmtBranchCode = branch;
    }
    if (level == '1') {
      mgmtBranchCode = branch;
      referenEmployeeNo = user_ucode;
    }

    await Provider.of<LoanArrearProvider>(context, listen: false)
        .fetchLoanArrearProvider(
      baseDate: getDateTimeNow,
      currencyCode: "",
      loanAccountNo: "",
      mgmtBranchCode: mgmtBranchCode,
      referenEmployeeNo: referenEmployeeNo,
    )
        .then((value) {
      var totalAcount = {"totalAcount": "${value.length}"};
      value.forEach((dynamic e) {
        if (e['currencyCode'] == "USD") {
          currencyUSD += e['totalAmount1'];
        } else {
          currencyKhmer += e['totalAmount1'];
        }
      });
      setState(() {
        value = [totalAcount, ...value];
        listLoanArrear = value;
        _isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loan Arrear"),
        backgroundColor: logolightGreen,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: listLoanArrear.length,
              itemBuilder: (context, index) {
                dynamic sumItem = listLoanArrear[index];
                if (index == 0) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          width: 180,
                          height: 100,
                          padding: EdgeInsets.all(10),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "\#Acc",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 5)),
                                Text(
                                  "${sumItem['totalAcount']}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 180,
                          padding: EdgeInsets.all(10),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "\$Overview Amt",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 5)),
                                Column(
                                  children: [
                                    Text(
                                      "\$ USD",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "${currencyUSD.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "៛ KHR",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "${currencyKhmer.toStringAsFixed(0)}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.all(10),
                    child: Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailLoanArrear(
                                      loanAccountNo: listLoanArrear[index]
                                              ['loanAccountNo']
                                          .toString(),
                                    )),
                          );
                        },
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 10)),
                            WidgetViewTextLoanArrear(
                                title: 'Loan Account No : ',
                                // value: listLoanArrear[index]['loanAccountNo']
                                //     .substring(3)),
                                value: sumItem['totalAmount1'].toString()),
                            WidgetViewTextLoanArrear(
                                title: 'Customer No : ',
                                value: listLoanArrear[index]['customerNo']
                                    .substring(5)),
                            WidgetViewTextLoanArrear(
                                title: "Customer Name : ",
                                value: listLoanArrear[index]['customerName']),
                            WidgetViewTextLoanArrear(
                                title: "Phone No : ",
                                value: listLoanArrear[index]['cellPhoneNo']),
                            WidgetViewTextLoanArrear(
                                title: "Over Due Days : ",
                                value: listLoanArrear[index]['overdueDays']
                                    .toString()),
                            WidgetViewTextLoanArrear(
                                title: "Total Repayment : ",
                                value: listLoanArrear[index]['totalAmount1']
                                    .toString()),
                            WidgetViewTextLoanArrear(
                                title: "CO Name : ",
                                value: listLoanArrear[index]['employeeName']
                                    .toString()),
                            WidgetViewTextLoanArrear(
                                title: "CO ID : ",
                                value: listLoanArrear[index]
                                        ['refereneceEmployeeNo']
                                    .toString()),
                            Padding(padding: EdgeInsets.only(bottom: 10))
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
