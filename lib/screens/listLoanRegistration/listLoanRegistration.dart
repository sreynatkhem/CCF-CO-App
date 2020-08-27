import 'dart:async';
import 'dart:convert';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/models/customers.dart';
import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/providers/listCustomerRegistration.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  StreamController<List<LoanInternal>> _streamController =
      StreamController<List<LoanInternal>>();
  StreamSink<List<LoanInternal>> get itemsSink => _streamController.sink;
  bool isLoading = false;
  int _pageSize = 20;
  int _pageNumber = 1;
  Future _additems() async {
    setState(() {
      isLoading = true;
    });
    try {
      _pageSize += 10;
      // Fetch newItems with http
      futureListLoanRegistraiton =
          Provider.of<LoanInternal>(context, listen: false)
              .getListLoan(_pageSize, _pageNumber);

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

  @override
  void didChangeDependencies() {
    futureListLoanRegistraiton =
        Provider.of<LoanInternal>(context).getListLoan(20, 1);
    getListLoan(20, 1);
    if (this.futureListLoanRegistraiton != futureListLoanRegistraiton) {
      this.futureListLoanRegistraiton = futureListLoanRegistraiton;
      Future.microtask(() => futureListLoanRegistraiton.doSomeHttpCall());
    }
    super.didChangeDependencies();
  }

  var _isFetching = true;
  var parsed = [];

  getListLoan(_pageSize, _pageNumber) async {
    final storage = new FlutterSecureStorage();
    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"sdate\": \"\",\n    \"edate\": \"\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await api().post(baseURLInternal + 'loans/byuser',
          headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        setState(() {
          parsed = listLoan[0]['listLoans'];
        });
      } else {
        print('statusCode::: ${response.statusCode}');
      }
    } catch (error) {}
  }

  final _imagesFindApproval =
      const AssetImage('assets/images/profile_create.jpg');
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
      case 'O':
        {
          return Text(AppLocalizations.of(context).translate('open') ?? 'Open',
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
  Widget build(BuildContext context) {
    futureListLoanRegistraiton =
        Provider.of<LoanInternal>(context).getListLoan(20, 1);
    return NotificationListener(
      onNotification: onNotification,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : new Scaffold(
              appBar: new AppBar(
                title: new Text(AppLocalizations.of(context)
                        .translate('loan_register_list') ??
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
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                          itemCount: parsed.length,
                          itemBuilder: (BuildContext context, int index) {
                            var status =
                                statusApproval(parsed[index]['lstatus']);
                            return Container(
                              height: 110,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: logolightGreen, width: 1),
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
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5)),
                                                Image(
                                                  image: _imagesFindApproval,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 15)),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                        child: Text(
                                                      '${parsed[index]['customer']}',
                                                      style: mainTitleBlack,
                                                    )),
                                                    if (parsed[index]
                                                            ['lpourpose'] !=
                                                        '')
                                                      Text(
                                                          '${parsed[index]['lpourpose']}'),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 2)),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 2)),
                                                    Text(
                                                        '${parsed[index]['lamt']} (${parsed[index]['currency']})'),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 2)),
                                                    Text(
                                                        '${parsed[index]['intrate']}/y'),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 2)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 2)),
                                                status,
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                  top: 5,
                                                )),
                                                Text(
                                                    '#${parsed[index]['lcode']}'),
                                                Text(''),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                  right: 100,
                                                ))
                                              ],
                                            ),
                                          ]))),
                            );
                          }))),
    );
  }
}
