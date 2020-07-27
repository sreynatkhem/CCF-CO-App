import 'package:chokchey_finance/components/ListDatial.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'editCustomerRegistration.dart';

class CardDetailCustomer extends StatefulWidget {
  final dynamic list;

  CardDetailCustomer({
    this.list,
  });

  @override
  _CardDetailCustomerState createState() =>
      _CardDetailCustomerState(list: list);
}

class _CardDetailCustomerState extends State<CardDetailCustomer> {
  final dynamic list;

  _CardDetailCustomerState({
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

  onEdit(value) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new EditCustomerRegister(
            list: value,
          );
        },
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      headerTexts: 'Detail Customer Registration',
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
                          name: 'Full Khmer Name',
                          value: '${list.name}',
                        ),
                        //
                        ListDetail(
                          name: 'Full English Name',
                          value: '${list.name}',
                        ),
                        //
                        ListDetail(
                          name: 'ID',
                          value: '${list.id}',
                        ),
                        //
                        ListDetail(
                          name: 'Date of brith',
                          value: '12-12-1995',
                        ),
                        //
                        ListDetail(
                          name: 'Gender',
                          value: 'F',
                        ),
                        //
                        ListDetail(
                          name: 'Phone Number 1',
                          value: '093 24 54 01',
                        ),
                        //
                        ListDetail(
                          name: 'Date of Register',
                          value: '27-07-2020',
                        ),
                        //
                        ListDetail(
                          name: 'Occupation of customer',
                          value: '\$ 1000',
                        ),
                        //
                        ListDetail(
                          name: 'Nation ID, Famliy book, Passport',
                          value: '0989898989',
                        ),
                        //
                        ListDetail(
                          name: 'Next visit date',
                          value: '03-07-2020',
                        ),
                        //
                        ListDetail(
                          name: 'Prospective',
                          value: 'Yes',
                        ),
                        //
                        ListDetail(
                          name: 'G=Gurantor, C=Customer',
                          value: 'G',
                        ),
                        //
                        ListDetail(
                          name: 'Province code',
                          value: 'Phnom Penh',
                        ),
                        //
                        ListDetail(
                          name: 'District code',
                          value: 'Phnom Penh',
                        ),
                        //
                        ListDetail(
                          name: 'Commune code',
                          value: 'Phnom Penh',
                        ),
                        ListDetail(
                          name: 'Current Location',
                          value: 'Phnom Penh, Cambodia',
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
