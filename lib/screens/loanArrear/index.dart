import 'package:chokchey_finance/providers/loanArrearProvider/loanArrearProvider.dart';
import 'package:chokchey_finance/screens/loanArrear/detail.dart';
import 'package:chokchey_finance/screens/loanArrear/widgetView.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
      setState(() {
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
                              value: listLoanArrear[index]['loanAccountNo']),
                          WidgetViewTextLoanArrear(
                              title: 'Customer No : ',
                              value: listLoanArrear[index]['customerNo']),
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
              },
            ),
    );
  }
}
