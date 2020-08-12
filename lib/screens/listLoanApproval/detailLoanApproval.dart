import 'dart:io';

import 'package:chokchey_finance/components/ListDatial.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/loan/loanApproval.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:provider/provider.dart';

class CardDetailLoanRegitration extends StatefulWidget {
  final dynamic list;
  // var isRefresh;

  CardDetailLoanRegitration(
    this.list,
  );

  @override
  _CardDetailLoanRegitrationState createState() =>
      _CardDetailLoanRegitrationState(this.list);
}

class _CardDetailLoanRegitrationState extends State<CardDetailLoanRegitration> {
  final dynamic list;

  _CardDetailLoanRegitrationState(
    this.list,
  );
  getDateTimeApprove(time) {
    DateTime dateTimeApproved = DateTime.parse(time);
    String dateTime = DateFormat("yyyy-MM-dd").format(dateTimeApproved);
    return dateTime;
  }

  getDate(time) {
    DateTime dateTimeApproved = DateTime.parse(time);
    String dateTime = DateFormat("yyyy-MM-dd").format(dateTimeApproved);
    return dateTime;
  }

  List<Asset> images = List<Asset>();
  List<File> fileName;
  var onEditData;

  onEdit(value) {
    // var locode = list;
    // detiaLoan = Provider.of<LoanInternal>(context, listen: false)
    //     .getLoanByID(locode)
    //     .then((value) => {
    //           // Navigator.of(context).push(new MaterialPageRoute<Null>(
    //           //     builder: (BuildContext context) {
    //           //       return new EditLoanRegister(
    //           //         list: value[0],
    //           //       );
    //           //     },
    //           //     fullscreenDialog: true)),
    //           setState(() {
    //             onEditData = value[0];
    //           }),
    //         });
  }

  // void onLoading() async {
  //   await new Future.delayed(new Duration(seconds: 1), () {
  //     setState(() {
  //       isRefresh = false;
  //     });
  //   });
  // }

  var detiaLoan;

  @override
  void didChangeDependencies() {
    var locode = list;
    // detiaLoan = Provider.of<LoanInternal>(
    //   context,
    // ).getLoanByID(locode);
    super.didChangeDependencies();
  }

  var futureLoanApproval;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: logolightGreen, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListDetail(
                        name: 'Customer Khmer Name',
                        value: '${list['loan']['customer']}',
                      ),
                      //
                      ListDetail(
                        name: 'Customer ID',
                        value: '${list['loan']['ccode']}',
                      ),
                      //
                      ListDetail(
                        name: 'Loan ID',
                        value: '${list['loan']['lcode']}',
                      ),
                      //
                      ListDetail(
                        name: 'Loan amount',
                        value: '${list['loan']['lamt']}',
                      ),
                      //
                      ListDetail(
                        name: 'Currency',
                        value: '${list['loan']['currency']}',
                      ),
                      //
                      ListDetail(
                        name: 'Loan Product',
                        value: '${list['loan']['loanProduct']}',
                      ),
                      //
                      ListDetail(
                        name: 'Number of term',
                        value: '${list['loan']['ints']}',
                      ),
                      //
                      ListDetail(
                        name: 'Interest rate',
                        value: '${list['loan']['intrate']}',
                      ),
                      //
                      ListDetail(
                        name: 'Maintenance fee',
                        value: '${list['loan']['mfee']}',
                      ),
                      //
                      ListDetail(
                        name: 'Admin fee',
                        value: '${list['loan']['afee']}',
                      ),
                      //
                      ListDetail(
                        name: 'Repayment method',
                        value: '${list['loan']['rmode']}',
                      ),
                      //
                      ListDetail(
                        name: 'Open date',
                        value: getDateTimeYMD(
                            list['loan']['odate'] ?? DateTime.now().toString()),
                      ),

                      ListDetail(
                        name: 'Maturity date',
                        value: getDateTimeYMD(
                            list['loan']['mdate'] ?? DateTime.now().toString()),
                      ),

                      ListDetail(
                        name: 'First repayment date',
                        value: getDateTimeYMD(list['loan']['firdate'] ??
                            DateTime.now().toString()),
                      ),

                      ListDetail(
                        name: 'Generate grace period number',
                        value: '${list['loan']['graperiod']}',
                      ),
                      //
                      ListDetail(
                        name: 'Loan purpose',
                        value: '${list['loan']['lpourpose']}',
                      ),
                      //
                      ListDetail(
                        name: 'LTV',
                        value: '${list['loan']['ltv']}',
                      ),
                      //
                      ListDetail(
                        name: 'Dscr',
                        value: '${list['loan']['dscr']}',
                      ),
                      //
                      ListDetail(
                        name: 'Refer by who',
                        value: '${list['loan']['refby']}',
                      ),
                      //
                      ListDetail(
                        name: 'Status',
                        value: '${list['loan']['lstatus']}',
                      ),
                      //
                      if ([].length != 0)
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Image')),
                      if ([].length != 0)
                        Container(
                          width: 375,
                          height: [].length >= 4 ? 270 : 135,
                          padding: EdgeInsets.only(top: 10),
                          child: GridView.count(
                            crossAxisCount: 3,
                            children: List.generate([].length, (index) {
                              Asset asset = images[index];
                              return Stack(children: <Widget>[
                                AssetThumb(
                                  asset: asset,
                                  width: 300,
                                  height: [].length >= 6 ? 500 : 200,
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          images.removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ))
                              ]);
                            }),
                          ),
                        ),
                      if (fileName != null)
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('PDF')),
                      if (fileName != null)
                        Container(
                          width: 375,
                          height: 135,
                          padding: EdgeInsets.only(top: 10),
                          child: GridView.count(
                            crossAxisCount: 3,
                            children: List.generate(
                                fileName != null ? fileName.length : [],
                                (index) {
                              File asset = fileName[index];
                              return Stack(children: <Widget>[
                                Text('PDF'),
                                PDF.file(
                                  asset,
                                  height: 300,
                                  width: 200,
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          fileName.removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ))
                              ]);
                            }),
                          ),
                        ),
                      Padding(padding: EdgeInsets.only(bottom: 5)),
                    ],
                  ),
                ]))),
      ),
    );
  }
}
