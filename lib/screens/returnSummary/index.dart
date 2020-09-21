import 'dart:async';

import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/approvalHistory/index.dart';
import 'package:chokchey_finance/providers/approvalSummary/index.dart';
import 'package:chokchey_finance/screens/approvalHistory/cardReport.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'summaryDetail.dart';

class ReturnSummary extends StatefulWidget {
  @override
  _ReturnSummaryState createState() => _ReturnSummaryState();
}

class _ReturnSummaryState extends State<ReturnSummary> {
  var isLoading = false;
  var listTotal;
  var listApproval;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      getReportApprovalSummary(
          _pageSize, _pageNumber, '', '', '', '', '', 'Return');
      getListBranches();
      getListCO('');
    }
  }

  Future getReportApprovalSummary(_pageSize, _pageNumber, status, code, bcode,
      sdate, edate, statusRequest) async {
    setState(() {
      isLoading = true;
    });
    await ApprovalSummaryProvider()
        .getApprovalSummary(
            _pageSize, _pageNumber, status, code, bcode, sdate, edate, 'Return')
        .then((value) => {
              value.forEach((v) => {
                    setState(() {
                      isLoading = false;
                      listTotal = v;
                      listApproval = v['listLoanRequests'];
                    }),
                  }),
            })
        .catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  ScrollController _scrollController = ScrollController();
  StreamController _streamController = StreamController();
  StreamSink get itemsSink => _streamController.sink;

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

  int _pageSize = 20;
  int _pageNumber = 1;

  Future _additems() async {
    setState(() {
      isLoading = true;
    });
    try {
      _pageSize += 10;
      // Fetch newItems with http
      await Provider.of<ApprovalSummaryProvider>(context, listen: false)
          .getApprovalSummary(
              _pageSize, _pageNumber, '', '', '', '', '', 'Return');
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
              AppLocalizations.of(context).translate('request') ?? 'request',
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

  final _imagesFindApproval =
      const AssetImage('assets/images/profile_create.jpg');

  onTapsDetail(value) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CardDetailLoanRegitration(
            list: value['loan']['lcode'],
            statusLoan: value['loan']['lstatus'],
          );
        },
        fullscreenDialog: true));
  }

  var status;
  var code;
  var sdate;
  var edate;
  //get branch
  var bcode;
  var bname;
  var odate;
  var procode;
  var listBranch = [];
  var listCO = [];

  TextEditingController controllerStartDate = new TextEditingController();
  TextEditingController controllerEndDate = new TextEditingController();
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

  void _closeEndDrawer() {
    setState(() {
      code = null;
      bcode = null;
      controllerEndDate.text = '';
      controllerStartDate.text = '';
    });
    getReportApprovalSummary(
        _pageSize, _pageNumber, '', '', '', '', '', 'Return');
    getListBranches();
    // getListCO('');
    Navigator.of(context).pop();
  }

  void _onClickListCO(v) {
    setState(() {
      code = v['ucode'];
    });
  }

  _onClickListBranch(v) {
    setState(() {
      bcode = v['bcode'];
    });
  }

  _applyEndDrawer() {
    var startDate = sdate != null ? sdate : DateTime.now();
    var endDate = edate != null ? edate : DateTime.now();
    getReportApprovalSummary(20, 1, '', '', bcode, startDate.toString(),
        endDate.toString(), 'Return');
    Navigator.of(context).pop();
  }

  Future<bool> _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        ModalRoute.withName("/Home"));
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: NotificationListener(
        onNotification: onNotification,
        child: Header(
          headerTexts: 'report_return' ?? 'Report Return',
          actionsNotification: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                ModalRoute.withName("/Home")),
          ),
          bodys: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(4),
                          width: MediaQuery.of(context).size.width * 1,
                          color: logolightGreen,
                          child: Center(
                              child: Text(
                            AppLocalizations.of(context)
                                    .translate('total_return') +
                                ': ${listTotal['total'].toString()}',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ))),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: ListView.builder(
                            itemCount: listApproval.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (listApproval.length > 0) {
                                return Center(
                                    child: Column(
                                  children: [
                                    Container(
                                      height: 90,
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
                                                onTapsDetail(
                                                    listApproval[index]);
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
                                                                  '${listApproval[index]['loan']['customer']}',
                                                                  style:
                                                                      mainTitleBlack,
                                                                )),
                                                            Text(
                                                                '${listApproval[index]['rcode']}'),
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
                                                                '${listApproval[index]['loan']['currency']} ${numFormat.format(listApproval[index]['loan']['lamt'])}'),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                            // Text(
                                                            //     '${listTotal[index]['lamt']} (${listTotal[index]['listLoanApplications']['adate']})'),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                            // Text(
                                                            //     '${listTotal[index]['intrate']}/y'),
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
                                                        if (listApproval[index]
                                                                ['adate'] !=
                                                            null)
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            child: Text(
                                                                '${getDateTimeYMD(listApproval[index]['adate'])}'),
                                                          ),
                                                      ],
                                                    ),
                                                  ]))),
                                    ),
                                  ],
                                ));
                              } else {
                                return Text('No list');
                              }
                            }),
                      ),
                    ),
                  ],
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
                        AppLocalizations.of(context).translate('list_branch') ??
                            'List Branch',
                        style: TextStyle(
                          fontWeight: fontWeight700,
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
                            child: Text(AppLocalizations.of(context)
                                    .translate('reset') ??
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
      ),
    );
  }
}
