import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chokchey_finance/components/ListDatial.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import 'editLoanRegistration.dart';
import 'listLoanRegistration.dart';

class CardDetailLoanRegitration extends StatefulWidget {
  final dynamic list;
  final dynamic statusLoan;

  CardDetailLoanRegitration({this.list, this.statusLoan});

  @override
  _CardDetailLoanRegitrationState createState() =>
      _CardDetailLoanRegitrationState(list: list, statusLoan: statusLoan);
}

class _CardDetailLoanRegitrationState extends State<CardDetailLoanRegitration> {
  final dynamic list;
  final dynamic statusLoan;

  _CardDetailLoanRegitrationState({this.list, this.statusLoan});
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

  var detiaLoan;
  var _imageDocument = [];
  @override
  void didChangeDependencies() {
    var locode = list;
    detiaLoan = Provider.of<LoanInternal>(
      context,
    ).getLoanByID(locode);
    super.didChangeDependencies();
    getImageDocument();
  }

  //fetch image referent document loan
  Future getImageDocument() async {
    var url = baseURLInternal + 'loanDocuments/byloan/' + list;
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    try {
      final response = await api().get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      });
      final parsed = jsonDecode(response.body);
      setState(() {
        _imageDocument = parsed;
      });
    } catch (error) {
      logger().e(error);
    }
  }

  var onStatus;

  @override
  Widget build(BuildContext context) {
    var locode = list;
    detiaLoan = Provider.of<LoanInternal>(
      context,
    ).getLoanByID(locode);
    return Header(
        leading: BackButton(
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ListLoanRegistration(),
              ),
              ModalRoute.withName('/')),
        ),
        headerTexts: 'detail_loan_registration',
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
                    if (statusLoan != 'R' &&
                        statusLoan != 'D' &&
                        statusLoan != 'A') {
                      onEdit(list);
                    }
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
                                                name: 'customer_khmer_name',
                                                value:
                                                    '${snapshot.data[index].customer}',
                                              ),
                                              //
                                              //
                                              ListDetail(
                                                name: 'customer_id',
                                                value:
                                                    '${snapshot.data[index].ccode}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'loan_amount',
                                                value:
                                                    '\$ ${snapshot.data[index].lamt}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'currencies',
                                                value:
                                                    '${snapshot.data[index].currency}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'loan_product',
                                                value:
                                                    '${snapshot.data[index].loanProduct}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'number_of_term',
                                                value:
                                                    '${snapshot.data[index].ints}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'interest_rate',
                                                value:
                                                    '${snapshot.data[index].intrate}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'maintenance_fee',
                                                value:
                                                    '${snapshot.data[index].mfee}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'admin_fee',
                                                value:
                                                    '${snapshot.data[index].afee}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'repayment_method',
                                                value:
                                                    '${snapshot.data[index].rmode}',
                                              ),
                                              //
                                              ListDetail(
                                                name:
                                                    'generate_grace_period_number',
                                                value:
                                                    '${snapshot.data[index].graperiod}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'loan_purpose',
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
                                                name: 'refer_by_who',
                                                value:
                                                    '${snapshot.data[index].refby}',
                                              ),
                                              //
                                              ListDetail(
                                                name: 'status',
                                                value:
                                                    '${snapshot.data[index].lstatus}',
                                              ),
                                              //
                                              if (_imageDocument != null &&
                                                  _imageDocument.length > 0)
                                                Container(
                                                  width: 300,
                                                  height: 600,
                                                  padding: EdgeInsets.only(
                                                      top: 10, left: 20),
                                                  child: GridView.count(
                                                    crossAxisCount: 1,
                                                    children: List.generate(
                                                        _imageDocument.length,
                                                        (index) {
                                                      // File asset =
                                                      //     _imageDocument[index];
                                                      var uri =
                                                          _imageDocument[index]
                                                              ['filepath'];
                                                      Uint8List _bytes =
                                                          base64.decode(uri
                                                              .split(',')
                                                              .last);
                                                      return Stack(children: <
                                                          Widget>[
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                if (_imageDocument !=
                                                                    null)
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
                                                                if (_imageDocument !=
                                                                    null)
                                                                  Image.memory(
                                                                    _bytes,
                                                                    height: 230,
                                                                    width: 300,
                                                                  ),
                                                              ],
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
