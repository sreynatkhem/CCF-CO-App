import 'package:chokchey_finance/providers/loanArrearProvider/loanArrearProvider.dart';
import 'package:chokchey_finance/screens/loanArrear/widgetView.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailLoanArrear extends StatefulWidget {
  String loanAccountNo = "";
  DetailLoanArrear({required this.loanAccountNo});
  @override
  _DetailLoanArrearState createState() => _DetailLoanArrearState();
}

class _DetailLoanArrearState extends State<DetailLoanArrear> {
  @override
  void initState() {
    // TODO: implement initState
    fetchLoanArrear();
    super.initState();
  }

  dynamic listLoanArrear = [];
  bool _isLoading = false;
  Future fetchLoanArrear() async {
    setState(() {
      _isLoading = true;
    });
    var datetime = DateTime.now();
    String getDateTimeNow = DateFormat("yyyyMMdd").format(datetime);
    await Provider.of<LoanArrearProvider>(context, listen: false)
        .fetchLoanArrearProvider(
      baseDate: getDateTimeNow,
      currencyCode: "",
      loanAccountNo: "${widget.loanAccountNo}",
      mgmtBranchCode: "",
      referenceEmployeeNo: "",
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
        title: Text("Detail Loan Arrear"),
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => DetailLoanArrear(
                        //             loanAccountNo: listLoanArrear[index],
                        //           )),
                        // );
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
                              title: "DD Account : ",
                              value: listLoanArrear[index]
                                  ['alternativeTransferAccountNo']),
                          WidgetViewTextLoanArrear(
                              title: "Phone No : ",
                              value: listLoanArrear[index]['cellPhoneNo']),
                          WidgetViewTextLoanArrear(
                              title: "Branch Code : ",
                              value: listLoanArrear[index]['loanBranchCode']),
                          WidgetViewTextLoanArrear(
                              title: "Branch Name : ",
                              value: listLoanArrear[index]['branchShortName']),
                          WidgetViewTextLoanArrear(
                              title: "Currency : ",
                              value: listLoanArrear[index]['currencyCode']),
                          WidgetViewTextLoanArrear(
                              title: "Loan Date : ",
                              value: listLoanArrear[index]['loanDate']),
                          WidgetViewTextLoanArrear(
                              title: "Loan Expriry Date : ",
                              value: listLoanArrear[index]['loanExpiryDate']),
                          WidgetViewTextLoanArrear(
                              title: "Term : ",
                              value: listLoanArrear[index]
                                      ['loanPeriodMonthlyCount']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Product Code : ",
                              value: listLoanArrear[index]['productCode']),
                          WidgetViewTextLoanArrear(
                              title: "Product Name : ",
                              value: listLoanArrear[index]['productName']),
                          WidgetViewTextLoanArrear(
                              title: "Due Date : ",
                              value: listLoanArrear[index]['repaymentDate']),
                          WidgetViewTextLoanArrear(
                              title: "Over Due Days : ",
                              value: listLoanArrear[index]['overdueDays']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Outstanding Balance : ",
                              value: listLoanArrear[index]['loanBalance']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Principle : ",
                              value: listLoanArrear[index]['repayPrincipal']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Interest : ",
                              value: listLoanArrear[index]['repayInterest']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Penalty : ",
                              value: listLoanArrear[index]['overdueInterest']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Collateral Maintenance Fee : ",
                              value: listLoanArrear[index]
                                      ['collateralMaintenanceFee']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Total Repayment : ",
                              value: listLoanArrear[index]['totalAmount1']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Disbursed Amount : ",
                              value: listLoanArrear[index]['loanAmount']
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
                          WidgetViewTextLoanArrear(
                              title: "Village : ",
                              value: listLoanArrear[index]['villageName']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Commune : ",
                              value: listLoanArrear[index]['communeName']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "District : ",
                              value: listLoanArrear[index]['districtName1']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Province : ",
                              value: listLoanArrear[index]['provinceName']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Postal Address : ",
                              value: listLoanArrear[index]['postalAddress']
                                  .toString()),
                          WidgetViewTextLoanArrear(
                              title: "Occupation : ",
                              value: listLoanArrear[index]
                                      ['customerListCodeName']
                                  .toString()),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Text(
                            "Overdue Within Last 6 Months",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Table(
                              border: TableBorder.all(),
                              children: [
                                TableRow(
                                  children: [
                                    Text("1st", textAlign: TextAlign.center),
                                    Text('2nd', textAlign: TextAlign.center),
                                    Text('3rd', textAlign: TextAlign.center),
                                    Text("4th", textAlign: TextAlign.center),
                                    Text("5th", textAlign: TextAlign.center),
                                    Text("6th", textAlign: TextAlign.center),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Text(
                                        listLoanArrear[index]
                                                ['previousOverdueMonth1']
                                            .toString(),
                                        textAlign: TextAlign.center),
                                    Text(
                                        listLoanArrear[index]
                                                ['previousOverdueMonth2']
                                            .toString(),
                                        textAlign: TextAlign.center),
                                    Text(
                                        listLoanArrear[index]
                                                ['previousOverdueMonth3']
                                            .toString(),
                                        textAlign: TextAlign.center),
                                    Text(
                                        listLoanArrear[index]
                                                ['previousOverdueMonth4']
                                            .toString(),
                                        textAlign: TextAlign.center),
                                    Text(
                                        listLoanArrear[index]
                                                ['previousOverdueMonth5']
                                            .toString(),
                                        textAlign: TextAlign.center),
                                    Text(
                                        listLoanArrear[index]
                                                ['previousOverdueMonth6']
                                            .toString(),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
