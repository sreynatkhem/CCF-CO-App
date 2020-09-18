import 'dart:async';
import 'dart:convert';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/models/customers.dart';
import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/models/listLoan.dart';
import 'package:chokchey_finance/models/listLoanNew.dart';
import 'package:chokchey_finance/providers/approvalHistory/index.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:chokchey_finance/components/card.dart';

import 'detailLoadRegistration.dart';

class ListLoanRegistration extends StatefulWidget {
  @override
  _ListLoanRegistrationState createState() => _ListLoanRegistrationState();
}

class _ListLoanRegistrationState extends State<ListLoanRegistration> {
  var futureListLoanRegistraiton;
  final profile = const AssetImage('assets/images/profile_create.jpg');

  onTapsDetail(value) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CardDetailLoanRegitration(
            list: value['lcode'],
            statusLoan: value['lstatus'],
          );
        },
        fullscreenDialog: true));
  }

  ScrollController _scrollController = ScrollController();
  int _pageSize = 20;
  int _pageNumber = 1;

  bool isLoading = false;

  List<Customers> _cachedItems = List.from([]);

  StreamController<List<LoanInternal>> _streamController =
      StreamController<List<LoanInternal>>();
  StreamSink<List<LoanInternal>> get itemsSink => _streamController.sink;
  Stream<List<LoanInternal>> get itemsStream => _streamController.stream;
  var data = [];
  Future _additems() async {
    setState(() {
      isLoading = true;
    });
    try {
      _pageSize += 10;
      getListLoanRegitster(_pageSize, _pageNumber, '', '', '', '', '');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      itemsSink.addError(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  _scrollListener() {
    if (_scrollController.position.maxScrollExtent >=
            _scrollController.offset &&
        _scrollController.position.maxScrollExtent - _scrollController.offset <=
            70) {
      _additems();
    }
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (_scrollController.position.maxScrollExtent >=
              _scrollController.offset &&
          _scrollController.position.maxScrollExtent -
                  _scrollController.offset <=
              1) {
        _additems();
      }
    }
    return true;
  }

  // @override
  // void initState() {
  //   _scrollController.addListener(_scrollListener);
  //   super.initState();
  // }

  // @override
  // void didUpdateWidget(ListLoanRegistration oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   futureListLoanRegistraiton = Provider.of<LoanInternal>(context)
  //       .getListLoan(20, 1, '', '', '', '', '');
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void didChangeDependencies() {
    if (mounted) {
      // futureListLoanRegistraiton = Provider.of<LoanInternal>(context)
      //     .getListLoan(20, 1, '', '', '', '', '');
      getListLoanRegitster(_pageSize, _pageNumber, '', '', '', '', '');
    }
    // setState(() {
    //   isLoading = false;
    // });
    // if (this.futureListLoanRegistraiton != futureListLoanRegistraiton) {
    //   this.futureListLoanRegistraiton = futureListLoanRegistraiton;
    //   Future.microtask(() => futureListLoanRegistraiton.doSomeHttpCall());
    // }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _streamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  var parsed;

  Future getListLoanRegitster(
      _pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    final storage = new FlutterSecureStorage();
    setState(() {
      isLoading = true;
    });
    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var level = await storage.read(key: "level");
      var bodyRow;
      var sdates = sdate != null ? sdate : '';
      var edates = edate != null ? edate : '';
      var codes = code != null ? code : '';
      var statuses = status != null ? status : '';
      var btlcode = status != null ? status : '';
      var bcodes;
      var ucode;
      if (level == '3') {
        bcodes = bcode != null ? bcode : branch;
        btlcode = '';
        ucode = code != null ? code : '';
      }

      if (level == '2') {
        bcodes = bcode != null ? bcode : branch;
        btlcode = user_ucode;
        ucode = code != null ? code : '';
      }

      if (level == '1') {
        bcodes = bcode != null ? bcode : branch;
        ucode = user_ucode;
        btlcode = '';
      }

      if (level == '4' || level == '5' || level == '6') {
        bcodes = bcode != null ? bcode : '';
        btlcode = '';
        ucode = code != null ? code : '';
      }
      // bodyRow =
      //     "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"sdate\": \"\",\n    \"edate\": \"\"\n}";
      bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"$sdates\",\n    \"edate\": \"$edates\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      logger().e("bodyRow: ${bodyRow}");

      final response = await api().post(baseURLInternal + 'loans/all/mobile',
          headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        var list = jsonDecode(response.body);
        logger().e("list: ${list}");

        if (list != null) {
          setState(() {
            parsed = list;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      logger().e("error: ${error}");
    }
  }

  final _imagesFindApproval =
      const AssetImage('assets/images/profile_create.jpg');

  Future<void> _getData() async {
    setState(() {
      getListLoanRegitster(_pageSize, _pageNumber, '', '', '', '', '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          // start loading data
          setState(() {
            isLoading = true;
            _pageSize += 10;
          });
          getListLoanRegitster(_pageSize, _pageNumber, '', '', '', '', '');
        }
      },
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text(
                AppLocalizations.of(context).translate('loan_register_list') ??
                    "Loan Register List"),
            backgroundColor: logolightGreen,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  ModalRoute.withName("/Home")),
            ),
          ),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _getData,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: parsed.length,
                      itemBuilder: (BuildContext context, int index) {
                        // var listSnapshot = snapshot.data[index].listLoans;
                        return Container(
                          height: 110,
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: logolightGreen, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    onTapsDetail(parsed[index]);
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('hello')
                                        // Row(
                                        //   children: <Widget>[
                                        //     Padding(
                                        //         padding: EdgeInsets.only(
                                        //             left: 5)),
                                        //     Image(
                                        //       image: _imagesFindApproval,
                                        //       width: 50,
                                        //       height: 50,
                                        //     ),
                                        //     Padding(
                                        //         padding: EdgeInsets.only(
                                        //             right: 15)),
                                        //     Column(
                                        //       crossAxisAlignment:
                                        //           CrossAxisAlignment
                                        //               .start,
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment
                                        //               .center,
                                        //       children: <Widget>[
                                        //         Container(
                                        //             width: 200,
                                        //             child: Text(
                                        //               '${parsed[index]['customer']}',
                                        //               style:
                                        //                   mainTitleBlack,
                                        //             )),
                                        //         if (parsed[index]
                                        //                 ['lpourpose'] !=
                                        //             '')
                                        //           Text(
                                        //               '${parsed[index]['lpourpose']}'),
                                        //         Padding(
                                        //             padding:
                                        //                 EdgeInsets.only(
                                        //                     bottom: 2)),
                                        //         Text(
                                        //             '${numFormat.format(parsed[index]['lamt'])} (${parsed[index]['currency']})'),
                                        //         Padding(
                                        //             padding:
                                        //                 EdgeInsets.only(
                                        //                     bottom: 2)),
                                        //         Text(
                                        //             'Interest ${parsed[index]['intrate']}%/m, IRR ${numFormat.format(parsed[index]['irr'])}%'),
                                        //         Padding(
                                        //             padding:
                                        //                 EdgeInsets.only(
                                        //                     bottom: 2)),
                                        //       ],
                                        //     ),
                                        //   ],
                                        // ),
                                        // Column(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.center,
                                        //   children: <Widget>[
                                        //     Padding(
                                        //         padding: EdgeInsets.only(
                                        //             bottom: 2)),
                                        //     // status,
                                        //     Padding(
                                        //         padding: EdgeInsets.only(
                                        //       top: 5,
                                        //     )),
                                        //     Text(
                                        //         '#${parsed[index]['lcode']}'),
                                        //     Text(''),
                                        //     Padding(
                                        //         padding: EdgeInsets.only(
                                        //       right: 100,
                                        //     ))
                                        //   ],
                                        // ),
                                      ]))),
                        );
                      }),
                )),
    );
  }
}
