import 'dart:io';

import 'package:chokchey_finance/components/ListDatial.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

import 'editLoanRegistration.dart';

class CardDetailLoanRegitration extends StatefulWidget {
  final dynamic list;

  CardDetailLoanRegitration({
    this.list,
  });

  @override
  _CardDetailLoanRegitrationState createState() =>
      _CardDetailLoanRegitrationState(list: list);
}

class _CardDetailLoanRegitrationState extends State<CardDetailLoanRegitration> {
  final dynamic list;

  _CardDetailLoanRegitrationState({
    this.list,
  });
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

  onEdit(value) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new EditLoanRegister(
            list: value,
          );
        },
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Header(
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
      bodys: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 5.0),
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
                          name: 'Customer Name',
                          value: '${list.name}',
                        ),
                        //
                        ListDetail(
                          name: 'Customer ID',
                          value: '${list.name}',
                        ),
                        //
                        ListDetail(
                          name: 'Loan amount',
                          value: '\$ 15000',
                        ),
                        // //
                        //
                        ListDetail(
                          name: 'Number of term',
                          value: '13 Months',
                        ),
                        //
                        ListDetail(
                          name: 'Interest rate',
                          value: '1.5',
                        ),
                        //
                        ListDetail(
                          name: 'Maintenance fee',
                          value: '3.5',
                        ),
                        //
                        // ListDetail(
                        //   name: 'Phone Number 2',
                        //   value: '',
                        // ),
                        //
                        ListDetail(
                          name: 'Admin fee',
                          value: '3.7',
                        ),
                        //
                        ListDetail(
                          name: 'Repayment method',
                          value: 'Declining',
                        ),
                        //
                        ListDetail(
                          name: 'Open date',
                          value: '12-08-2020',
                        ),
                        //
                        ListDetail(
                          name: 'Maturity date',
                          value: '03-07-2020',
                        ),
                        //
                        ListDetail(
                          name: 'First repayment date',
                          value: '03-07-2020',
                        ),
                        //
                        ListDetail(
                          name: 'Generate grace period number',
                          value: '12',
                        ),
                        //
                        ListDetail(
                          name: 'Loan purpose',
                          value: 'Buy Car',
                        ),
                        //
                        ListDetail(
                          name: 'Refer by who',
                          value: 'Mr.Mean',
                        ),
                        //
                        ListDetail(
                          name: 'Status',
                          value: 'Open',
                        ),
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
      ),
    );
  }
}
