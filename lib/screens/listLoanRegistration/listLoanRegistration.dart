import 'dart:async';
import 'dart:convert';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/models/customers.dart';
import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/providers/approvalHistory/index.dart';
import 'package:chokchey_finance/providers/listCustomerRegistration.dart';
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
  var listBranch = [];
  var listCO = [];
  var listStatus = [
    {'id': 'R', 'value': 'request'},
    {'id': 'A', 'value': 'approved'},
    {'id': 'D', 'value': 'disapprove'},
    {'id': 'T', 'value': 'return'},
  ];

  var bcode;
  var userCode;
  var scode;
  var sdate;
  var edate;

  _onClickListBranch(v) {
    setState(() {
      bcode = v['bcode'];
    });
  }

  _onClickListStatuCode(v) {
    setState(() {
      scode = v['id'];
    });
  }

  void _onClickListCO(v) {
    setState(() {
      userCode = v['ucode'];
    });
  }

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
    getListLoan(20, 1, '', '', '', '', '');
    if (this.futureListLoanRegistraiton != futureListLoanRegistraiton) {
      this.futureListLoanRegistraiton = futureListLoanRegistraiton;
      Future.microtask(() => futureListLoanRegistraiton.doSomeHttpCall());
    }
    getListBranches();
    getListCO('');
    super.didChangeDependencies();
  }

  Future getListBranches() async {
    await ApprovalHistoryProvider()
        .getListBranch()
        .then((value) => {
              setState(() {
                listBranch = value;
              }),
            })
        .catchError((onError) {});
  }

  Future getListCO(name) async {
    await ApprovalHistoryProvider()
        .getListCO(name)
        .then((value) => {
              setState(() {
                listCO = value;
              }),
            })
        .catchError((onError) {
      logger().e('getListBranches onError:: ${onError}');
    });
  }

  var _isFetching = true;
  var parsed = [];

  getListLoan(
      _pageSize, _pageNumber, ucode, sdate, edate, status, bcodes) async {
    final storage = new FlutterSecureStorage();
    setState(() {
      isLoading = true;
    });
    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var level = await storage.read(key: "level");
      var btlcode = status != null ? status : '';

      if (level == '3') {
        bcodes = bcode != null ? bcode : branch;
        ucode = userCode != null ? userCode : '';
        btlcode = '';
      }

      if (level == '2') {
        bcodes = bcode != null ? bcode : branch;
        ucode = userCode != null ? userCode : '';
        btlcode = user_ucode;
      }

      if (level == '1') {
        bcodes = bcode != null ? bcode : branch;
        ucode = user_ucode;
        btlcode = '';
      }

      if (level == '4' || level == '5' || level == '6') {
        bcodes = bcode != null ? bcode : '';
        ucode = userCode != null ? userCode : '';
        btlcode = '';
      }
      var bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"btlcode\": \"$btlcode\",\n    \"bcode\": \"$bcodes\",\n    \"sdate\": \"$sdate\",\n    \"status\": \"$status\",\n    \"edate\": \"$edate\"\n}";
      logger().e("body: ${bodyRow}");
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await api()
          .post(baseURLInternal + 'loans/all', headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        logger().e("listLoan: ${listLoan}");

        setState(() {
          parsed = listLoan[0]['listLoans'];
          isLoading = false;
        });
      } else {
        print('statusCode::: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
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

  _applyEndDrawer() {
    DateTime now = DateTime.now();
    var startDate = sdate != null ? sdate : '';
    var endDate = edate != null ? edate : '';
    var scodes = scode != null ? scode : '';

    print({
      bcode,
      userCode,
      sdate,
      edate,
      scode,
    });
    getListLoan(20, 1, userCode, startDate, endDate, scodes, '');
    Navigator.of(context).pop();
  }

  void _closeEndDrawer() {
    // Navigator.of(context).pop();
    setState(() {
      userCode = null;
      bcode = null;
      controllerEndDate.text = '';
      controllerStartDate.text = '';
    });
  }

  TextEditingController controllerStartDate = new TextEditingController();
  TextEditingController controllerEndDate = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    futureListLoanRegistraiton =
        Provider.of<LoanInternal>(context).getListLoan(20, 1);
    return NotificationListener(
      onNotification: onNotification,
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
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
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
                      if (parsed.length > 0) {
                        var status = statusApproval(parsed[index]['lstatus']);
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
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5)),
                                            Image(
                                              image: _imagesFindApproval,
                                              width: 50,
                                              height: 50,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(right: 15)),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    width: 200,
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
                                                    padding: EdgeInsets.only(
                                                        bottom: 2)),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 2)),
                                                Text(
                                                    '${parsed[index]['lamt']} (${parsed[index]['currency']})'),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 2)),
                                                Text(
                                                    '${parsed[index]['intrate']}/y'),
                                                Padding(
                                                    padding: EdgeInsets.only(
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
                                                padding:
                                                    EdgeInsets.only(bottom: 2)),
                                            status,
                                            Padding(
                                                padding: EdgeInsets.only(
                                              top: 5,
                                            )),
                                            Text('#${parsed[index]['lcode']}'),
                                            Text(''),
                                            Padding(
                                                padding: EdgeInsets.only(
                                              right: 100,
                                            ))
                                          ],
                                        ),
                                      ]))),
                        );
                      } else {
                        return Center(
                          child: Container(
                            child: Text(AppLocalizations.of(context)
                                    .translate('no_list_loans') ??
                                'No list loans'),
                          ),
                        );
                      }
                    })),
        endDrawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 35)),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.width * 0.12,
                    child: Card(
                      color: logolightGreen,
                      child: Center(
                        child: Text(
                          'Filter Loan Regeister List',
                          style: TextStyle(
                              fontWeight: fontWeight800,
                              fontSize: 15,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                        onChanged: (v) => {},
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: logolightGreen),
                            ),
                            labelText: AppLocalizations.of(context)
                                        .translate('search') +
                                    ' CO' ??
                                'Search CO',
                            labelStyle: TextStyle(
                                fontSize: 15, color: const Color(0xff0ABAB5)))),
                  ),
                  //List CO
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    AppLocalizations.of(context).translate('list_co') ??
                        'List CO',
                    style: TextStyle(
                      fontWeight: fontWeight700,
                    ),
                  ),
                  listCO != null
                      ? Container(
                          height: 150,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: ListView.builder(
                              itemCount:
                                  listCO != null ? listCO.length : [].length,
                              padding: const EdgeInsets.only(top: 10.0),
                              itemBuilder: (context, index) {
                                return Card(
                                  child: InkWell(
                                    onTap: () => _onClickListCO(listCO[index]),
                                    child: Center(
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            '${listCO[index]['uname']}',
                                            style: TextStyle(
                                                color: userCode ==
                                                        listCO[index]['ucode']
                                                    ? logolightGreen
                                                    : Colors.black),
                                          )),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Padding(padding: EdgeInsets.only(bottom: 1)),
                  //List Branch
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    AppLocalizations.of(context).translate('list_branch') ??
                        'List Branch',
                    style: TextStyle(
                      fontWeight: fontWeight700,
                    ),
                  ),
                  listBranch != null
                      ? Container(
                          height: 150,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: ListView.builder(
                              itemCount: listBranch != null
                                  ? listBranch.length
                                  : [].length,
                              padding: const EdgeInsets.only(top: 10.0),
                              itemBuilder: (context, index) {
                                return Card(
                                  child: InkWell(
                                    onTap: () =>
                                        _onClickListBranch(listBranch[index]),
                                    child: Center(
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            '${listBranch[index]['bname']}',
                                            style: TextStyle(
                                                color: bcode ==
                                                        listBranch[index]
                                                            ['bcode']
                                                    ? logolightGreen
                                                    : Colors.black),
                                          )),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Padding(padding: EdgeInsets.only(bottom: 1)),
                  //List Status
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    AppLocalizations.of(context).translate('list_status') ??
                        'List Status',
                    style: TextStyle(
                      fontWeight: fontWeight700,
                    ),
                  ),
                  listStatus != null
                      ? Container(
                          height: 150,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: ListView.builder(
                              itemCount: listStatus != null
                                  ? listStatus.length
                                  : [].length,
                              padding: const EdgeInsets.only(top: 10.0),
                              itemBuilder: (context, index) {
                                return Card(
                                  child: InkWell(
                                    onTap: () => _onClickListStatuCode(
                                        listStatus[index]),
                                    child: Center(
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                    .translate(listStatus[index]
                                                        ['value']) ??
                                                '${listStatus[index]['value']}',
                                            style: TextStyle(
                                                color: scode ==
                                                        listStatus[index]['id']
                                                    ? logolightGreen
                                                    : Colors.black),
                                          )),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Padding(padding: EdgeInsets.only(bottom: 1)),
                  //Pick start date
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: FormBuilderDateTimePicker(
                      attribute: 'date',
                      controller: controllerStartDate,
                      inputType: InputType.date,
                      onChanged: (v) {
                        setState(() {
                          sdate = v != null ? v : DateTime.now();
                        });
                      },
                      initialValue: DateTime(now.year, now.month, 1),
                      format: DateFormat("yyyy-MM-dd"),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                                .translate('start_date') ??
                            "Start date",
                      ),
                    ),
                  ),
                  //Pick date End
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: FormBuilderDateTimePicker(
                      attribute: 'date',
                      controller: controllerEndDate,
                      inputType: InputType.date,
                      onChanged: (v) {
                        setState(() {
                          edate = v != null ? v : DateTime.now();
                        });
                      },
                      initialValue: DateTime.now(),
                      format: DateFormat("yyyy-MM-dd"),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                                .translate('end_date') ??
                            "End date",
                      ),
                    ),
                  ),
                  //Bottom Reset and Apply
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          onPressed: _closeEndDrawer,
                          child: Text(
                              AppLocalizations.of(context).translate('reset') ??
                                  "Reset"),
                        ),
                        RaisedButton(
                          color: logolightGreen,
                          onPressed: _applyEndDrawer,
                          child: Text(
                            AppLocalizations.of(context).translate('apply') ??
                                "Apply",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
