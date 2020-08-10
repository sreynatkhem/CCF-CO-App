import 'dart:io';

import 'package:chokchey_finance/components/ListDatial.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:provider/provider.dart';

import 'editLoanRegistration.dart';
import 'listLoanRegistration.dart';

class CardDetailLoanRegitration extends StatefulWidget {
  final dynamic list;
  var isRefresh;

  CardDetailLoanRegitration({this.list, this.isRefresh});

  @override
  _CardDetailLoanRegitrationState createState() =>
      _CardDetailLoanRegitrationState(list: list, isRefresh: isRefresh);
}

class _CardDetailLoanRegitrationState extends State<CardDetailLoanRegitration> {
  final dynamic list;
  var isRefresh = false;

  _CardDetailLoanRegitrationState({this.list, this.isRefresh});
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
    var locode = list;
    detiaLoan = Provider.of<LoanInternal>(context, listen: false)
        .getLoanByID(locode)
        .then((value) => {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new EditLoanRegister(
                      list: value[0],
                    );
                  },
                  fullscreenDialog: true)),
              setState(() {
                onEditData = value[0];
              }),
            });
  }

  void onLoading() async {
    await new Future.delayed(new Duration(seconds: 1), () {
      setState(() {
        isRefresh = false;
      });
    });
  }

  var detiaLoan;

  @override
  void didChangeDependencies() {
    var locode = list;
    detiaLoan = Provider.of<LoanInternal>(
      context,
    ).getLoanByID(locode);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var locode = list;
    detiaLoan = Provider.of<LoanInternal>(
      context,
    ).getLoanByID(locode);
    if (isRefresh == true) {
      // onLoading();
    }
    return Header(
        leading: BackButton(
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ListLoanRegistration(),
              ),
              ModalRoute.withName('/')),
        ),
        headerTexts: 'Detail Loan Registration',
        actionsNotification: <Widget>[
          // Using Stack to show edit registration
          new Stack(
            children: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 25,
                  ),
                  onPressed: () {
                    onEdit(list);
                  }),
            ],
          ),
        ],
        bodys: FutureBuilder<List<CreateLoan>>(
            future: detiaLoan,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: logolightGreen, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                    splashColor: Colors.blue.withAlpha(30),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ListDetail(
                                                name: 'Customer Khmer Name',
                                                value:
                                                    '${snapshot.data[index].customer}',
                                              ),
                                              //
                                              //
                                              ListDetail(
                                                name: 'Customer ID',
                                                value:
                                                    '${snapshot.data[index].ccode}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Loan amount',
                                                value:
                                                    '\$ ${snapshot.data[index].lamt}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Currency',
                                                value:
                                                    '${snapshot.data[index].currency}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Loan Product',
                                                value:
                                                    '${snapshot.data[index].loanProduct}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Number of term',
                                                value:
                                                    '${snapshot.data[index].ints}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Interest rate',
                                                value:
                                                    '${snapshot.data[index].intrate}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Maintenance fee',
                                                value:
                                                    '${snapshot.data[index].mfee}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Admin fee',
                                                value:
                                                    '${snapshot.data[index].afee}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Repayment method',
                                                value:
                                                    '${snapshot.data[index].rmode}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Open date',
                                                value: getDateTimeYMD(snapshot
                                                        .data[index].odate ??
                                                    DateTime.now().toString()),
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Maturity date',
                                                value: getDateTimeYMD(snapshot
                                                        .data[index].mdate ??
                                                    DateTime.now().toString()),
                                              ),
                                              //
                                              ListDetail(
                                                name: 'First repayment date',
                                                value: getDateTimeYMD(snapshot
                                                        .data[index].firdate ??
                                                    DateTime.now().toString()),
                                              ),
                                              //
                                              ListDetail(
                                                name:
                                                    'Generate grace period number',
                                                value:
                                                    '${snapshot.data[index].graperiod}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Loan purpose',
                                                value:
                                                    '${snapshot.data[index].lpourpose}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'LTV',
                                                value:
                                                    '${snapshot.data[index].ltv}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Dscr',
                                                value:
                                                    '${snapshot.data[index].dscr}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Refer by who',
                                                value:
                                                    '${snapshot.data[index].refby}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'Status',
                                                value:
                                                    '${snapshot.data[index].lstatus}',
                                              ),
                                              //
                                              if ([].length != 0)
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text('Image')),
                                              if ([].length != 0)
                                                Container(
                                                  width: 375,
                                                  height: [].length >= 4
                                                      ? 270
                                                      : 135,
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: GridView.count(
                                                    crossAxisCount: 3,
                                                    children: List.generate(
                                                        [].length, (index) {
                                                      Asset asset =
                                                          images[index];
                                                      return Stack(children: <
                                                          Widget>[
                                                        AssetThumb(
                                                          asset: asset,
                                                          width: 300,
                                                          height: [].length >= 6
                                                              ? 500
                                                              : 200,
                                                        ),
                                                        Positioned(
                                                            top: 0,
                                                            right: 0,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  images
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ))
                                                      ]);
                                                    }),
                                                  ),
                                                ),
                                              if (fileName != null)
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text('PDF')),
                                              if (fileName != null)
                                                Container(
                                                  width: 375,
                                                  height: 135,
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: GridView.count(
                                                    crossAxisCount: 3,
                                                    children: List.generate(
                                                        fileName != null
                                                            ? fileName.length
                                                            : [], (index) {
                                                      File asset =
                                                          fileName[index];
                                                      return Stack(
                                                          children: <Widget>[
                                                            Text('PDF'),
                                                            PDF.file(
                                                              asset,
                                                              height: 300,
                                                              width: 200,
                                                            ),
                                                            Positioned(
                                                                top: 0,
                                                                right: 0,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      fileName.removeAt(
                                                                          index);
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ))
                                                          ]);
                                                    }),
                                                  ),
                                                ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5)),
                                            ],
                                          ),
                                        ]))),
                          ),
                        );
                      })
                  : Center(child: CircularProgressIndicator());
            }));
  }
}
