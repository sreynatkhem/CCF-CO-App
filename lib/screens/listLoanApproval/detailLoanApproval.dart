import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chokchey_finance/components/ListDatial.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/loan/loanApproval.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  onEdit(value) {}

  var detiaLoan;

  @override
  void didChangeDependencies() {
    var locode = list;
    detiaLoan = Provider.of<LoanInternal>(
      context,
    ).getLoanByID(locode['lcode']);
    getImageDocument();

    super.didChangeDependencies();
  }

  var _imageDocument;

  var futureLoanApproval;
  Future getImageDocument() async {
    var locode = list;
    var url = baseURLInternal + 'loanDocuments/byloan/' + locode['lcode'];
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    final response = await api().get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    });
    final parsed = jsonDecode(response.body);
    setState(() {
      _imageDocument = parsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CreateLoan>>(
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
                              side: BorderSide(color: logolightGreen, width: 1),
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
                                            name: 'customer_khmer_name',
                                            value:
                                                '${list['loan']['customer']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'customer_id',
                                            value: '${list['loan']['ccode']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'loan_id',
                                            value: '${list['loan']['lcode']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'loan_amount',
                                            value: '${list['loan']['lamt']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'currencies',
                                            value:
                                                '${list['loan']['currency']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'loan_product',
                                            value:
                                                '${list['loan']['loanProduct']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'number_of_term',
                                            value: '${list['loan']['ints']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'interest_rate',
                                            value: '${list['loan']['intrate']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'maintenance_fee',
                                            value: '${list['loan']['mfee']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'admin_fee',
                                            value: '${list['loan']['afee']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'repayment_method',
                                            value: '${list['loan']['rmode']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'open_date',
                                            value: getDateTimeYMD(list['loan']
                                                    ['odate'] ??
                                                DateTime.now().toString()),
                                          ),

                                          ListDetail(
                                            name: 'maturity_date',
                                            value: getDateTimeYMD(list['loan']
                                                    ['mdate'] ??
                                                DateTime.now().toString()),
                                          ),

                                          ListDetail(
                                            name: 'first_repayment_date',
                                            value: getDateTimeYMD(list['loan']
                                                    ['firdate'] ??
                                                DateTime.now().toString()),
                                          ),

                                          ListDetail(
                                            name:
                                                'generate_grace_period_number',
                                            value:
                                                '${list['loan']['graperiod']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'loan_purpose',
                                            value:
                                                '${list['loan']['lpourpose']}',
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
                                            name: 'refer_by_who',
                                            value: '${list['loan']['refby']}',
                                          ),
                                          //
                                          ListDetail(
                                            name: 'status',
                                            value: '${list['loan']['lstatus']}',
                                          ),
                                          if (_imageDocument != null)
                                            Container(
                                              width: 300,
                                              height: 600,
                                              padding: EdgeInsets.only(
                                                  top: 10, left: 20),
                                              child: GridView.count(
                                                crossAxisCount: 1,
                                                children: List.generate(
                                                    _imageDocument != null
                                                        ? _imageDocument.length
                                                        : [], (index) {
                                                  // File asset =
                                                  //     _imageDocument[index];
                                                  var uri =
                                                      _imageDocument[index]
                                                          ['filepath'];
                                                  Uint8List _bytes =
                                                      base64.decode(
                                                          uri.split(',').last);
                                                  return Stack(
                                                      children: <Widget>[
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  _imageDocument[
                                                                          index]
                                                                      [
                                                                      'description'],
                                                                  style:
                                                                      mainTitleBlack,
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            10)),
                                                                Image.memory(
                                                                  _bytes,
                                                                  height: 230,
                                                                  width: 300,
                                                                ),
                                                              ],
                                                            ))
                                                        // PDF.file(
                                                        //   asset,
                                                        //   height: 300,
                                                        //   width: 200,
                                                        // ),
                                                      ]);
                                                }),
                                              ),
                                            ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 5)),
                                        ],
                                      ),
                                    ]))),
                      ),
                    );
                  })
              : Center(child: CircularProgressIndicator());
        });
  }
}
