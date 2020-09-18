import 'dart:async';
import 'dart:convert';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/models/customers.dart';
import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/models/requestLoanApproval.dart';
import 'package:chokchey_finance/providers/listCustomerRegistration.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/loan/loanApproval.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:chokchey_finance/components/card.dart';

import 'tebBarDetail.dart';

class ListLoanApproval extends StatefulWidget {
  @override
  _ListLoanApprovalState createState() => _ListLoanApprovalState();
}

class _ListLoanApprovalState extends State<ListLoanApproval> {
  var futureLoanApproval;
  final profile = const AssetImage('assets/images/profile_create.jpg');

  onTapsDetail(value, context) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CardDetailLoan(
            value,
          );
        },
        fullscreenDialog: true));
  }

  ScrollController _scrollController = ScrollController();
  StreamController<List<LoanApproval>> _streamController =
      StreamController<List<LoanApproval>>();
  StreamSink<List<LoanApproval>> get itemsSink => _streamController.sink;
  bool isLoading = false;
  int _pageSize = 20;
  int _pageNumber = 1;
  Future _additems() async {
    logger().e('add more');

    try {
      _pageSize += 10;
      logger().e('_pageSize: $_pageSize');

      // futureLoanApproval =
      //     Provider.of<LoanApproval>(context).getLoanApproval(20, 1);
      getListLoan(_pageSize, _pageNumber);
    } catch (e) {
      logger().e('e::::');

      // itemsSink.addError(e);

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

  statusApproval(value) {
    switch (value) {
      case 'R':
        {
          return Text(
              AppLocalizations.of(context).translate('request') ?? 'Request',
              style: mainTitleBlack);
        }
        break;

      case 'A':
        {
          return Text(
              AppLocalizations.of(context).translate('approved') ?? 'Approved',
              style: mainTitleBlack);
        }
        break;

      case 'D':
        {
          return Text(
              AppLocalizations.of(context).translate('disapprove') ??
                  'Disapprove',
              style: mainTitleBlack);
        }
        break;

      case 'T':
        {
          return Text(
              AppLocalizations.of(context).translate('return') ?? 'Return',
              style: mainTitleBlack);
        }
        break;
      default:
        {
          return Text('', style: mainTitleBlack);
        }
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool _isInit = false;
  var provideerLoading;
  @override
  void didChangeDependencies() {
    if (mounted) {
      provideerLoading = Provider.of<LoanApproval>(context).isFetchingLoading;
    }
    setState(() {
      _isInit = true;
      isLoading = true;
    });
    if (_isInit) {
      setState(() {
        _isInit = false;
        isLoading = false;
      });
      futureLoanApproval = Provider.of<LoanApproval>(context, listen: false)
          .getLoanApproval(20, 1);

      getListLoan(20, 1);
      setState(() {
        _isInit = false;
        isLoading = false;
      });
      if (this.futureLoanApproval != futureLoanApproval) {
        this.futureLoanApproval = futureLoanApproval;
        Future.microtask(() => futureLoanApproval.doSomeHttpCall());
      }
    }
    setState(() {
      _isInit = false;
      isLoading = false;
    });
    super.didChangeDependencies();
  }

  var parsed = [];
  var dataListLoanApproval = [];

  getListLoan(_pageSize, _pageNumber) async {
    final storage = new FlutterSecureStorage();
    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"sdate\": \"\",\n    \"edate\": \"\"\n}";
      print('bodyRow::: ${bodyRow}');

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await api().post(baseURLInternal + 'loanRequests/byuser',
          headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        setState(() {
          parsed.addAll(listLoan[0]['listLoanRequests']);
          dataListLoanApproval = listLoan[0];
        });
      } else {
        print('statusCode::: ${response.statusCode}');
      }
    } catch (error) {}
  }

  final _imagesFindApproval =
      const AssetImage('assets/images/profile_create.jpg');

  Future<void> _getData() async {
    setState(() {
      futureLoanApproval = Provider.of<LoanApproval>(context, listen: false)
          .getLoanApproval(20, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    futureLoanApproval = Provider.of<LoanApproval>(context, listen: false)
        .getLoanApproval(20, 1);
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          // start loading data
          setState(() {
            isLoading = true;
            _pageSize += 10;
          });
          getListLoan(_pageSize, _pageNumber);
        }
      },
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text(
                AppLocalizations.of(context).translate('approval_list') ??
                    "Approval List"),
            backgroundColor: logolightGreen,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  ModalRoute.withName("/Home")),
            ),
          ),
          body: provideerLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: _getData,
                  child: FutureBuilder<List<RequestLoanApproval>>(
                      future: futureLoanApproval,
                      builder: (context, snapshot) {
                        if (provideerLoading == false) {
                          return Container(
                              padding: EdgeInsets.all(10),
                              child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: parsed.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var status = statusApproval(parsed != null
                                        ? parsed[index]['rstatus']
                                        : '');
                                    return Container(
                                      height: 110,
                                      margin: EdgeInsets.only(bottom: 5.0),
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: logolightGreen,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                              splashColor:
                                                  Colors.blue.withAlpha(30),
                                              onTap: () {
                                                var value = parsed[index];
                                                onTapsDetail(value, context);
                                              },
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5)),
                                                        Image(
                                                          image:
                                                              _imagesFindApproval,
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 15)),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Container(
                                                                width: 200,
                                                                child: Text(
                                                                  parsed[index][
                                                                          'loan']
                                                                      [
                                                                      'customer'],
                                                                  style:
                                                                      mainTitleBlack,
                                                                )),
                                                            Text(
                                                                '${parsed[index]['rcode']}'),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                            Text(
                                                                '${getDateTimeYMD(parsed[index]['loan']['odate'])}'),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                            Text(
                                                                '${parsed[index]['loan']['currency']} ${numFormat.format(parsed[index]['loan']['lamt'])}'),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 2)),
                                                        status,
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                          top: 5,
                                                        )),
                                                        if (parsed[index]
                                                                ['rdate'] !=
                                                            '')
                                                          Text(getDateTimeYMD(
                                                              parsed[index]
                                                                  ['rdate'])),
                                                        Text(''),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                          right: 100,
                                                        ))
                                                      ],
                                                    ),
                                                  ]))),
                                    );
                                  }));
                        } else {
                          return Center(
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      }),
                )),
    );
  }
}
