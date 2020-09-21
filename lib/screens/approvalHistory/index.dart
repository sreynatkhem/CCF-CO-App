import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/approvalHistory/index.dart';
import 'package:chokchey_finance/screens/approvalHistory/cardReport.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class ApprovalHistory extends StatefulWidget {
  @override
  _ApprovalHistoryState createState() => _ApprovalHistoryState();
}

class _ApprovalHistoryState extends State<ApprovalHistory> {
  int _pageSize = 20;
  int _pageNumber = 1;
  var status;
  var code;
  var sdate;
  var edate;

  var totalCustomer;
  var totalApproved;
  var totalReturned;
  var totalDisapproved;
  var totalRequested;
  var totalLoan;
  var totalProcessing;

  //get branch
  var bcode;
  var bname;
  var odate;
  var procode;
  var listBranch = [];
  var listCO = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getReportSummary(_pageSize, _pageNumber, '', '', '', '', '');
    getListBranches();
    getListCO('');
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales(
          AppLocalizations.of(context).translate('customer') ?? 'Customer',
          totalCustomer),
      new OrdinalSales(
          AppLocalizations.of(context).translate('approve') ?? 'Approve',
          totalApproved),
      new OrdinalSales(
          AppLocalizations.of(context).translate('processing') ?? 'Processing',
          totalApproved),
      new OrdinalSales(
          AppLocalizations.of(context).translate('return') ?? 'Return',
          totalReturned),
      new OrdinalSales(
          AppLocalizations.of(context).translate('disapprove') ?? 'Disapprove',
          totalDisapproved),
      new OrdinalSales(
          AppLocalizations.of(context).translate('request') ?? 'Request',
          totalRequested),
      new OrdinalSales(
          AppLocalizations.of(context).translate('loan') ?? 'Loan', totalLoan),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Report',
        // colorFn: (_, __) => charts.ColorUtil.fromDartColor(logolightGreen),
        colorFn: (OrdinalSales segment, _) {
          switch (segment.year) {
            case 'Approve':
              {
                return charts.ColorUtil.fromDartColor(Colors.green);
              }
            case 'យល់ព្រម':
              {
                return charts.ColorUtil.fromDartColor(Colors.green);
              }
            case "Disapprove":
              {
                return charts.ColorUtil.fromDartColor(Colors.red);
              }

            case "មិនពេញចិត្ត":
              {
                return charts.ColorUtil.fromDartColor(Colors.red);
              }
            case "Processing":
              {
                return charts.ColorUtil.fromDartColor(Colors.orange);
              }

            case "ដំណើរការ":
              {
                return charts.ColorUtil.fromDartColor(Colors.orange);
              }

            default:
              {
                return charts.ColorUtil.fromDartColor(logolightGreen);
              }
          }
        },
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
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

  Future getReportSummary(
      pageSize, pageNumber, statuses, codes, bcode, sdates, edates) async {
    await ApprovalHistoryProvider()
        .getApprovalHistorySummary(
            pageSize, pageNumber, statuses, codes, bcode, sdates, edates)
        .then((value) => {
              logger().e('value:: ${value}'),
              value.forEach((v) => {
                    setState(() {
                      totalCustomer = v['totalCustomer'];
                      totalApproved = v['totalApproved'];
                      totalReturned = v['totalReturned'];
                      totalDisapproved = v['totalDisapproved'];
                      totalRequested = v['totalRequested'];
                      totalLoan = v['totalLoan'];
                      totalProcessing = v['totalProcessing'];
                    }),
                  }),
            })
        .catchError((onError) {
      logger().e('catchError onError:: ${onError}');
    });
  }

  final TextEditingController searchId = TextEditingController();
  Future onClickApply(context) {}

  void _closeEndDrawer() {
    setState(() {
      code = null;
      bcode = null;
      controllerEndDate.text = '';
      controllerStartDate.text = '';
    });
    getReportSummary(_pageSize, _pageNumber, '', '', '', '', '');
    getListBranches();
    Navigator.of(context).pop();
  }

  _applyEndDrawer() {
    var startDate = sdate != null ? sdate : DateTime.now();
    var endDate = edate != null ? edate : DateTime.now();
    getReportSummary(
        20, 1, '', '', bcode, startDate.toString(), endDate.toString());
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

  TextEditingController controllerStartDate = new TextEditingController();
  TextEditingController controllerEndDate = new TextEditingController();

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
      child: Header(
        headerTexts: AppLocalizations.of(context).translate('report_summary') ??
            'Report Summary',
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
        bodys: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 700,
                padding: EdgeInsets.all(5),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, right: 2, bottom: 5, top: 5),
                                child: CardReport(
                                  backgroundColors: logolightGreen,
                                  iconSizes: 25.0,
                                  icons: Icons.face,
                                  text: 'total_customer',
                                  value: totalCustomer.toString(),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, right: 2, bottom: 5, top: 5),
                                child: CardReport(
                                  backgroundColors: Colors.green,
                                  iconSizes: 25.0,
                                  icons: Icons.check_box,
                                  text: 'total_approved',
                                  value: totalApproved.toString(),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, right: 2, bottom: 5, top: 5),
                                child: CardReport(
                                  backgroundColors: Colors.orange,
                                  iconSizes: 25.0,
                                  icons: Icons.replay,
                                  text: 'total_processing',
                                  value: totalProcessing.toString(),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, right: 2, bottom: 5, top: 5),
                                child: CardReport(
                                  backgroundColors: logolightGreen,
                                  iconSizes: 25.0,
                                  icons: Icons.cancel,
                                  text: 'total_returned',
                                  value: totalReturned.toString(),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, right: 2, bottom: 5, top: 5),
                                child: CardReport(
                                  backgroundColors: Colors.red,
                                  iconSizes: 25.0,
                                  icons: Icons.receipt,
                                  text: 'total_disapproved',
                                  value: totalDisapproved.toString(),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, right: 2, bottom: 5, top: 5),
                                child: CardReport(
                                  backgroundColors: logolightGreen,
                                  iconSizes: 25.0,
                                  icons: Icons.payment,
                                  text: 'total_requested',
                                  value: totalRequested.toString(),
                                )),
                          ],
                        ),
                        //New
                        Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, right: 2, bottom: 5, top: 5),
                                child: CardReport(
                                  backgroundColors: logolightGreen,
                                  iconSizes: 25.0,
                                  icons: Icons.cancel,
                                  text: 'total_loan',
                                  value: totalLoan.toString(),
                                )),
                          ],
                        ),
                        //
                        Expanded(
                          child: charts.BarChart(
                            _createSampleData(),
                            animate: true,
                            domainAxis: new charts.OrdinalAxisSpec(
                                renderSpec: new charts.SmallTickRendererSpec(

                                    // Tick and Label styling here.
                                    labelStyle: new charts.TextStyleSpec(
                                        fontSize: 10, // size in Pts.
                                        color: charts.MaterialPalette.black),

                                    // Change the line colors to match text color.
                                    lineStyle: new charts.LineStyleSpec(
                                        color: charts.MaterialPalette.black))),

                            /// Assign a custom style for the measure axis.
                            primaryMeasureAxis: new charts.NumericAxisSpec(
                                renderSpec: new charts.GridlineRendererSpec(

                                    // Tick and Label styling here.
                                    labelStyle: new charts.TextStyleSpec(
                                        fontSize: 12, // size in Pts.
                                        color: charts.MaterialPalette.black),

                                    // Change the line colors to match text color.
                                    lineStyle: new charts.LineStyleSpec(
                                        color: charts.MaterialPalette.black))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
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

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
