import 'dart:async';

import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/approvalSummary/index.dart';
import 'package:chokchey_finance/screens/approvalHistory/cardReport.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ApprovalSummary extends StatefulWidget {
  @override
  _ApprovalSummaryState createState() => _ApprovalSummaryState();
}

class _ApprovalSummaryState extends State<ApprovalSummary> {
  var futureApprovalSummary;
  var isLoading = false;
  var listApprovalSummary;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      getReportApprovalSummary();
    }
  }

  Future getReportApprovalSummary() async {
    setState(() {
      isLoading = true;
    });
    futureApprovalSummary = await ApprovalSummaryProvider()
        .getApprovalSummary(
          _pageSize,
          _pageNumber,
          '',
          '',
          '',
          '',
          '',
        )
        .then((value) => {
              value.forEach((v) => {
                    setState(() {
                      isLoading = false;
                      listApprovalSummary = v;
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
      futureApprovalSummary =
          Provider.of<ApprovalSummaryProvider>(context, listen: false)
              .getApprovalSummary(
        _pageSize,
        _pageNumber,
        '',
        '',
        '',
        '',
        '',
      );
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

  /// Create one series with sample hard coded data.
  List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales(
          AppLocalizations.of(context).translate('approve') ?? 'Approve',
          listApprovalSummary['totalApprove']),
      new OrdinalSales(
          AppLocalizations.of(context).translate('return') ?? 'Return',
          listApprovalSummary['totalReturn']),
      new OrdinalSales(
          AppLocalizations.of(context).translate('disapprove') ?? 'Disapprove',
          listApprovalSummary['totalDisapprove']),
      new OrdinalSales(
          AppLocalizations.of(context).translate('request') ?? 'Request',
          listApprovalSummary['totalRequest']),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Report',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(logolightGreen),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
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

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotification,
      child: Header(
        headerTexts: 'report_approval' ?? 'Report Approval',
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
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: ListView.builder(
                        itemCount: listApprovalSummary.length,
                        itemBuilder: (BuildContext context, int index) {
                          logger().e(
                              'listApprovalSummary[index]: ${listApprovalSummary['listLoanApplications']}');
                          if (listApprovalSummary.length > 0) {
                            return Center(
                                child: Column(
                              children: [
                                Container(
                                  height: 100,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: logolightGreen, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: InkWell(
                                          splashColor:
                                              Colors.blue.withAlpha(30),
                                          onTap: () {
                                            // onTapsDetail(parsed[index]);
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
                                                        // Container(
                                                        //     width: 200,
                                                        //     child: Text(
                                                        //       '${listApprovalSummary[index]['listLoanApplications']['userName']}',
                                                        //       style: mainTitleBlack,
                                                        //     )),
                                                        // if (listApprovalSummary[
                                                        //             index]
                                                        //         ['lpourpose'] !=
                                                        //     '')
                                                        //   Text(
                                                        //       '${listApprovalSummary[index]['listLoanApplications']['lcode']}'),
                                                        // Padding(
                                                        //     padding:
                                                        //         EdgeInsets.only(
                                                        //             bottom: 2)),
                                                        // Padding(
                                                        //     padding:
                                                        //         EdgeInsets.only(
                                                        //             bottom: 2)),
                                                        // Text(
                                                        //     '${listApprovalSummary[index]['listLoanApplications']['lamt']} (${listApprovalSummary[index]['listLoanApplications']['adate']})'),
                                                        // Padding(
                                                        //     padding:
                                                        //         EdgeInsets.only(
                                                        //             bottom: 2)),
                                                        // Text(
                                                        //     '${listApprovalSummary[index]['lamt']} (${listApprovalSummary[index]['listLoanApplications']['adate']})'),
                                                        // Padding(
                                                        //     padding:
                                                        //         EdgeInsets.only(
                                                        //             bottom: 2)),
                                                        // Text(
                                                        //     '${listApprovalSummary[index]['intrate']}/y'),
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
                                                    // Padding(
                                                    //     padding: EdgeInsets.only(
                                                    //         bottom: 2)),
                                                    // status,
                                                    // Padding(
                                                    //     padding: EdgeInsets.only(
                                                    //   top: 5,
                                                    // )),
                                                    // // Text(
                                                    // //     '#${parsed[index]['lcode']}'),
                                                    // Text(''),
                                                    // Padding(
                                                    //     padding: EdgeInsets.only(
                                                    //   right: 100,
                                                    // ))
                                                  ],
                                                ),
                                              ]))),
                                ),
                              ],
                            ));
                          }
                        }),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
