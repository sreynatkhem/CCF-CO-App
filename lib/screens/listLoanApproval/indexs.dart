import 'dart:convert';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/approvalHistory/index.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/screens/listLoanApproval/tebBarDetail.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class ListLoanApprovals extends StatefulWidget {
  @override
  _ListLoanApprovalsState createState() => _ListLoanApprovalsState();
}

class _ListLoanApprovalsState extends State<ListLoanApprovals> {
  var parsed = [];
  var _isLoading = false;
  int _pageSize = 20;
  int _pageNumber = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _isLoading = true;
    });
    if (mounted) {
      getListLoan(20, 1, '', '', '', '', '')
          .then((value) => {
                setState(() {
                  _isLoading = false;
                })
              })
          .catchError((onError) {
        setState(() {
          _isLoading = false;
        });
      });
      getListBranches();
      getListCO('');
    }
  }

  Future getListLoan(
      _pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    final storage = new FlutterSecureStorage();
    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var level = await storage.read(key: "level");
      var sdates = sdate != null ? sdate : '';
      var edates = edate != null ? edate : '';
      var codes = code != null ? code : '';
      var statuses = status != null ? status : '';
      var btlcode = status != null ? status : '';
      var bcodes;
      var ucode;
      if (level == '3') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        btlcode = '';
        ucode = codes != null && codes != "" ? codes : "";
      }

      if (level == '2') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        btlcode = user_ucode;
        ucode = code != null && code != "" ? code : '';
      }

      if (level == '1') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        ucode = user_ucode;
        btlcode = '';
      }

      if (level == '4' || level == '5' || level == '6') {
        bcodes = bcode != null && bcode != "" ? bcode : '';
        btlcode = '';
        ucode = code != null && code != "" ? code : '';
      }
      final Map<String, dynamic> bodyRow = {
        "pageSize": "$_pageSize",
        "pageNumber": "$_pageNumber",
        "ucode": "$ucode",
        "bcode": "$bcodes",
        "btlcode": "$btlcode",
        "status": "",
        "code": "",
        "sdate": "$sdates"
      };
      print({
        "pageSize": "$_pageSize",
        "pageNumber": "$_pageNumber",
        "ucode": "$ucode",
        "bcode": "$bcodes",
        "btlcode": "$btlcode",
        "status": "",
        "code": "",
        "sdate": "$sdates"
      });

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      logger().e(headers);
      logger().e(baseURLInternal + 'loanRequests/all');

      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'loanRequests/all'),
          headers: headers,
          body: json.encode(bodyRow));
      logger().e("response: ${response.statusCode}");

      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        logger().e("listLoan: listLoan");

        setState(() {
          parsed = listLoan[0]['listLoanRequests'];
        });
        return listLoan;
      } else {
        setState(() {
          parsed = [];
        });
      }
    } catch (error) {
      print('error::: ${error}');
    }
  }

  ScrollController _scrollController = ScrollController();
  statusApproval(value) {
    switch (value) {
      case 'R':
        {
          return Text(
              AppLocalizations.of(context)!.translate('request') ?? 'Request',
              style: mainTitleBlack);
        }
        break;

      case 'A':
        {
          return Text(
              AppLocalizations.of(context)!.translate('approved') ?? 'Approved',
              style: mainTitleBlack);
        }
        break;

      case 'D':
        {
          return Text(
              AppLocalizations.of(context)!.translate('disapprove') ??
                  'Disapprove',
              style: mainTitleBlack);
        }
        break;

      case 'T':
        {
          return Text(
              AppLocalizations.of(context)!.translate('return') ?? 'Return',
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

  final _imagesFindApproval =
      const AssetImage('assets/images/profile_create.jpg');

  void _closeEndDrawer() {
    setState(() {
      code = null;
      bcode = null;
      controllerEndDate.text = '';
      controllerStartDate.text = '';
      _isLoading = true;
    });
    getListLoan(20, 1, '', '', '', '', '')
        .then((value) => {
              setState(() {
                _isLoading = false;
              }),
            })
        .catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
    getListBranches();
    getListCO('');
    Navigator.of(context).pop();
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

  _applyEndDrawer() async {
    DateTime now = DateTime.now();
    setState(() {
      _isLoading = true;
    });
    var startDate = sdate != null ? sdate : DateTime(now.year, now.month, 1);
    var endDate = edate != null ? edate : DateTime.now();
    getListLoan(20, 1, '', '', bcode, startDate, endDate)
        .then((value) => {
              setState(() {
                _isLoading = false;
              })
            })
        .catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
    Navigator.of(context).pop();
  }

  var listBranch = [];
  var listCO = [];
  var status;
  var code;
  var sdate;
  var edate;
  var bcode;

  Future getListCO(name) async {
    final storage = new FlutterSecureStorage();

    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final Response response = await api().get(
        Uri.parse(
            baseURLInternal + 'valuelists/users/co/' + user_ucode + '/' + ''),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var list = jsonDecode(response.body);
        setState(() {
          listCO = list;
        });
        return list;
      }
    } catch (error) {
      logger().e('error :: ${error}');
    }
  }

  void _onClickListCO(v) {
    if (mounted) {
      setState(() {
        code = v['ucode'];
      });
    }
  }

  TextEditingController controllerStartDate = new TextEditingController();
  TextEditingController controllerEndDate = new TextEditingController();

  _onClickListBranch(v) {
    setState(() {
      bcode = v['bcode'];
    });
  }

  Future loadMore(_pageSizeParam, _pageNumberParam, statusParam, codeParam,
      bcodeParam, sdateParam, edateParam) async {
    final storage = new FlutterSecureStorage();
    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var level = await storage.read(key: "level");
      var sdates = sdateParam != null ? sdateParam : '';
      var edates = edateParam != null ? edateParam : '';
      var codes = codeParam != null ? codeParam : '';
      var statuses = statusParam != null ? statusParam : '';
      var btlcode = statusParam != null ? statusParam : '';
      var bcodes;
      var ucode;
      if (level == '3') {
        bcodes =
            bcodeParam != null && bcodeParam != "" ? bcodeParam : bcodeParam;
        btlcode = '';
        ucode = codes != null && codes != "" ? codes : "";
      }

      if (level == '2') {
        bcodes = bcodeParam != null && bcodeParam != "" ? bcodeParam : branch;
        btlcode = user_ucode;
        ucode = codeParam != null && codeParam != "" ? codeParam : '';
      }

      if (level == '1') {
        bcodes = bcodeParam != null && bcodeParam != "" ? bcodeParam : branch;
        ucode = user_ucode;
        btlcode = '';
      }

      if (level == '4' || level == '5' || level == '6') {
        bcodes = bcodeParam != null && bcodeParam != "" ? bcodeParam : '';
        btlcode = '';
        ucode = codeParam != null && codeParam != "" ? codeParam : '';
      }
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final Map<String, dynamic> bodyRow = {
        "pageSize": "$_pageSizeParam",
        "pageNumber": "$_pageNumberParam",
        "ucode": "$ucode",
        "bcode": "$bcodes",
        "btlcode": "$btlcode",
        "status": "",
        "code": "",
        "sdate": "$sdates",
        "edate": "$edates",
      };
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'loanRequests/all'),
          headers: headers,
          body: json.encode(bodyRow));
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        setState(() {
          parsed = listLoan[0]['listLoanRequests'];
        });
        return listLoan;
      } else {
        setState(() {
          parsed = [];
        });
      }
    } catch (error) {
      print('error::: ${error}');
    }
  }

  onTapsDetail(value, context) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CardDetailLoan(
            value,
          );
        },
        fullscreenDialog: true));
  }

  Future<void> _getData() async {
    setState(() {
      _isLoading = true;
    });
    getListLoan(20, 1, '', '', '', '', '')
        .then((value) => {
              setState(() {
                _isLoading = false;
              })
            })
        .catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        ModalRoute.withName("/Home"));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // start loading data
            setState(() {
              _pageSize += 10;
            });
            loadMore(_pageSize, _pageNumber, '', '', '', '', '');
          }
          return false;
        },
        child: Scaffold(
          appBar: new AppBar(
            title: new Text(
                AppLocalizations.of(context)!.translate('approval_list') ??
                    "Approval List"),
            backgroundColor: logolightGreen,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ],
          ),
          body: _isLoading
              ? Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                )
              : parsed.length > 0
                  ? RefreshIndicator(
                      onRefresh: _getData,
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: parsed.length,
                          itemBuilder: (BuildContext context, int index) {
                            var status = statusApproval(
                                parsed != null ? parsed[index]['rstatus'] : '');
                            return Container(
                              padding: EdgeInsets.all(3),
                              // height: 100,
                              // padding: EdgeInsets.only(
                              //     left: 4, right: 4, top: 4, bottom: 4),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: logolightGreen, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: InkWell(
                                        splashColor: Colors.blue.withAlpha(30),
                                        onTap: () {
                                          var value = parsed[index];
                                          onTapsDetail(value, context);
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
                                                  // Padding(
                                                  //     padding: EdgeInsets.only(
                                                  //         right: 15)),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                          width: widthView(
                                                              context, 0.5),
                                                          child: Text(
                                                            parsed[index]
                                                                    ['loan']
                                                                ['customer'],
                                                            style:
                                                                mainTitleBlack,
                                                          )),
                                                      Text(
                                                          '${parsed[index]['rcode']}'),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 2)),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 2)),
                                                      Text(
                                                          '${getDateTimeYMD(parsed[index]['loan']['odate'])}'),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 2)),
                                                      Text(
                                                          '${parsed[index]['loan']['currency']} ${numFormat.format(parsed[index]['loan']['lamt'])}'),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 2)),
                                                      Container(
                                                        width: widthView(
                                                            context, 0.5),
                                                        child: Text(
                                                            '${parsed[index]['loan']['user'].substring(9)} - ${parsed[index]['loan']['branch']}'),
                                                      ),
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
                                                  if (parsed[index]['rdate'] !=
                                                      '')
                                                    Text(getDateTimeYMD(
                                                        parsed[index]
                                                            ['rdate'])),
                                                  Text(''),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                    right: 100,
                                                  ))
                                                ],
                                              ),
                                            ])),
                                  )),
                            );
                          }),
                    )
                  : Center(
                      child: Container(
                        child: Text(
                          AppLocalizations.of(context)!.translate('no_data') ??
                              "",
                        ),
                      ),
                    ),
          endDrawer: Drawer(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 35)),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list),
                          Padding(padding: EdgeInsets.only(right: 5)),
                          Text(
                            'Filter',
                            style: TextStyle(
                                fontWeight: fontWeight800, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        AppLocalizations.of(context)!
                                .translate('list_branch') ??
                            'List Branch',
                        style: TextStyle(
                            // fontWeight: fontWeight700,
                            ),
                      ),
                    ),
                    listBranch != null
                        ? Container(
                            height: 180,
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
                    //Pick start date
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: FormBuilderDateTimePicker(
                        name: 'date',
                        controller: controllerStartDate,
                        inputType: InputType.date,
                        onChanged: (v) {
                          setState(() {
                            sdate = v != null
                                ? v
                                : DateTime(now.year, now.month, 1);
                          });
                        },
                        initialValue: DateTime(now.year, now.month, 1),
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!
                                  .translate('start_date') ??
                              "Start date",
                        ),
                      ),
                    ),
                    //Pick date End
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: FormBuilderDateTimePicker(
                        name: 'date',
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
                          labelText: AppLocalizations.of(context)!
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
                            child: Text(AppLocalizations.of(context)!
                                    .translate('reset') ??
                                "Reset"),
                          ),
                          RaisedButton(
                            color: logolightGreen,
                            onPressed: _applyEndDrawer,
                            child: Text(
                              AppLocalizations.of(context)!
                                      .translate('apply') ??
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
      ),
    );
  }
}
