import 'dart:convert';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/approvalHistory/index.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class HistoryApsara extends StatefulWidget {
  @override
  _HistoryApsaraState createState() => _HistoryApsaraState();
}

class _HistoryApsaraState extends State<HistoryApsara> {
  final GlobalKey<ScaffoldState> _scaffoldKeyHistoryApsara =
      new GlobalKey<ScaffoldState>();
  var listHistory;
  bool _isLoading = false;
  DateTime now = DateTime.now();
  String? startDateTimeDidMounted;
  String? endDateTimeDidMounted;

  //Fetch API
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (mounted) {
      var startDate = DateTime(now.year, now.month, now.day - 7);
      var endDate = DateTime.now();

      setState(() {
        startDateTimeDidMounted = DateFormat("yyyy-MM-dd").format(startDate);
        endDateTimeDidMounted = DateFormat("yyyy-MM-dd").format(DateTime.now());
        status = "2";
        startDateTime = DateFormat("yyyyMMdd").format(startDate);
        endDateTime = DateFormat("yyyyMMdd").format(endDate);
      });
      fetchHistory();
      getListCO();
      getListBranches();
    }

    super.didChangeDependencies();
  }

  String? userNameLogin;
  String? userIDLogin;
  bool _isSelectedUserIDLogin = false;
  String _isSelectedUserLogin = "";
  final storage = new FlutterSecureStorage();
  String? levelConvert;
  int level = 2;

  // status 1:Process, 2:Approval, 9:Reject
  fetchHistory() async {
    DateTime now = DateTime.now();

    // var endDate = edate != null ? edate : DateTime.now();
    // String? endDateTime = DateFormat("yyyyMMdd").format(endDate);
    String? selectedStatus;
    String? selectedBranch;
    setState(() {
      _isLoading = true;
    });
    if (status == null) {
      selectedStatus = '2';
    }
    if (status == "") {
      selectedStatus = '2';
    }
    if (status != null && status != "") {
      selectedStatus = status;
    }
    if (bcode == "") {
      selectedBranch = '';
    }
    if (bcode != "") {
      selectedBranch = bcode;
    }
    if (bcode == null) {
      selectedBranch = '';
    }
    if (userIDLogin == null) {
      userIDLogin = await storage.read(key: 'user_id');
    }
    userNameLogin = await storage.read(key: 'user_name');
    userIDLogin = await storage.read(key: 'user_id');
    levelConvert = await storage.read(key: 'level');
    level = int.parse(levelConvert!);
    // await Provider.of<ApprovelistProvider>(context, listen: false)
    //     // ignore: unnecessary_brace_in_string_interps
    //     .fetchHistoryAPSARA("${selectedBranch}", "", "${userIDLogin}",
    //         "${startDateTime}", "${endDateTime}", "${selectedStatus}")
    //     .then((value) => setState(() {
    //           listHistory = value;
    //           _isLoading = false;
    //         }))
    //     .catchError((onError) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    try {
      final storage = new FlutterSecureStorage();
      String? userId = await storage.read(key: 'user_id');
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(baseUrl + 'LRA0005'));
      request.body =
          "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n		\"channelTypeCode\" :\"08\",\n		\"previousTransactionID\" :\"\",\n		\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"branchCode\": \"$selectedBranch\",\n    \"customerNo\": \"\",\n    \"authorizerEmployeeNo\" :\"$userId\",\n   \"inquiryFromDate\": \"$startDateTime\",\n   \"inquiryToDate\": \"$endDateTime\",\n   \"loanApprovalApplicationStatusCode\": \"$selectedStatus\"\n    }\n}\n";
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        var json = jsonDecode(respStr);
        setState(() {
          _isLoading = false;
          listHistory = json['body'];
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      logger().e("error: $error");
    }
  }

  var sdate;
  var edate;
  bool _isSelectedApproved = false;
  bool _isStatuSelectedReject = false;
  bool _isStatuSelectedReturn = false;
  String? status;
  TextEditingController controllerStartDate = new TextEditingController();
  TextEditingController controllerEndDate = new TextEditingController();
  String? startDateTime = "";
  String? endDateTime = "";
  void _closeEndDrawer() {
    setState(() {
      controllerEndDate.text = '';
      controllerStartDate.text = '';
      var startDate = DateTime(now.year, now.month, now.day - 7);
      startDateTimeDidMounted = DateFormat("yyyy-MM-dd").format(startDate);
      endDateTimeDidMounted = DateFormat("yyyy-MM-dd").format(DateTime.now());
      status = "2";
      bcode = "";
      _isSelectedApproved = false;
      _isStatuSelectedReject = false;
      _isStatuSelectedReturn = false;
    });
    var startDate = DateTime(now.year, now.month, now.day - 7);
    startDateTime = DateFormat("yyyyMMdd").format(startDate);
    var endDate = DateTime.now();
    endDateTime = DateFormat("yyyyMMdd").format(endDate);
    fetchHistory();
    Navigator.of(context).pop();
  }

  _applyEndDrawer() async {
    Navigator.of(context).pop();
    DateTime now = DateTime.now();

    var startDate =
        sdate != null ? sdate : DateTime(now.year, now.month, now.day - 7);
    var endDate = edate != null ? edate : DateTime.now();
    String? startDateTime = DateFormat("yyyyMMdd").format(startDate);
    String? endDateTime = DateFormat("yyyyMMdd").format(endDate);
    String? selectedStatus;
    String? selectedUserID;
    String? selectedBranch;

    if (status == null) {
      selectedStatus = '2';
    }
    if (status == "") {
      selectedStatus = '2';
    }
    if (status != null && status != "") {
      selectedStatus = status!;
    }
    if (userID == "") {
      selectedUserID = '';
    }
    if (userID != "") {
      selectedUserID = userID;
    }
    if (_isSelectedUserIDLogin == true) {
      selectedUserID = _isSelectedUserLogin;
    }

    if (bcode == "") {
      selectedBranch = '';
    }
    if (bcode != "") {
      selectedBranch = bcode;
    }
    if (bcode == null) {
      selectedBranch = '';
    }

    String startDateTimeShow = DateFormat("yyyy-MM-dd").format(startDate);
    String endDateTimeShow = DateFormat("yyyy-MM-dd").format(endDate);
    setState(() {
      _isLoading = true;
      startDateTimeDidMounted = startDateTimeShow;
      endDateTimeDidMounted = endDateTimeShow;
    });

    try {
      final storage = new FlutterSecureStorage();
      String? userId = await storage.read(key: 'user_id');
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(baseUrl + 'LRA0005'));
      request.body =
          "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n		\"channelTypeCode\" :\"08\",\n		\"previousTransactionID\" :\"\",\n		\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"branchCode\": \"$selectedBranch\",\n    \"customerNo\": \"$selectedUserID\",\n    \"authorizerEmployeeNo\" :\"$userId\",\n   \"inquiryFromDate\": \"$startDateTime\",\n   \"inquiryToDate\": \"$endDateTime\",\n   \"loanApprovalApplicationStatusCode\": \"$selectedStatus\"\n    }\n}\n";
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        var json = jsonDecode(respStr);
        setState(() {
          _isLoading = false;
          listHistory = json['body'];
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      logger().e("error: $error");
    }
  }

  String valueStringStatus = "";
  getDateTimeApprove(time) {
    DateTime dateTimeApproved = DateTime.parse(time);
    String dateTime = DateFormat("yyyy-MM-dd").format(dateTimeApproved);
    return Text(
      dateTime,
      style: TextStyle(fontWeight: fontWeight700),
    );
  }

  String userID = "";
  bool _isSelectedUserID = false;

  var listCO = [];
  var listBranch = [];

  void _onClicklistCO(v) {
    setState(() {
      userID = v['ucode'];
    });
    if (userID != "") {
      setState(() {
        _isSelectedUserID = false;
        _isSelectedUserIDLogin = false;
      });
    }
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

  String coName = "";
  Future getListCO() async {
    logger().e("coName: $coName");
    await ApprovalHistoryProvider()
        .getListCO(coName)
        .then((value) => {
              setState(() {
                listCO = value;
              }),
            })
        .catchError((onError) {});
  }

  var bcode;
  _onClickListBranch(v) {
    setState(() {
      bcode = v['bcode'];
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    if (status == "2") {
      valueStringStatus =
          AppLocalizations.of(context)!.translate('approved') ?? 'Approved';
    }

    if (status == "1") {
      valueStringStatus =
          AppLocalizations.of(context)!.translate('processing') ?? 'Processing';
    }

    if (status == "9") {
      valueStringStatus =
          AppLocalizations.of(context)!.translate('reject') ?? 'Reject';
    }
    return Scaffold(
        key: _scaffoldKeyHistoryApsara,
        appBar: AppBar(
          backgroundColor: logolightGreen,
          title: Text(AppLocalizations.of(context)!
                  .translate('loan_approval_history') ??
              "Loan Approval History"),
          // leading: new IconButton(
          //   icon: new Icon(Icons.arrow_back),
          //   onPressed: () => Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(builder: (context) => Home()),
          //       ModalRoute.withName("/Home")),
          // ),
        ),
        endDrawer: Drawer(
            child: Container(
          color: Colors.grey.shade100,
          child: SingleChildScrollView(
            child: Container(
                color: Colors.grey.shade100,
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
                              AppLocalizations.of(context)!
                                      .translate('filter') ??
                                  "Filter",
                              style: TextStyle(
                                  fontWeight: fontWeight800, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      //List CO
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context)!.translate('by_user') ??
                              'By User',
                          style: TextStyle(
                            fontWeight: fontWeight700,
                          ),
                        ),
                      ),
                      if (level >= 3)
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 5),
                          child: Card(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isSelectedUserID = !_isSelectedUserID;
                                });
                                if (_isSelectedUserID == true) {
                                  setState(() {
                                    userID = "";
                                    _isSelectedUserIDLogin = false;
                                  });
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.67,
                                color: _isSelectedUserID == true
                                    ? logolightGreen
                                    : null,
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  AppLocalizations.of(context)!
                                          .translate('all_user') ??
                                      "All User",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: _isSelectedUserID == true
                                          ? Colors.white
                                          : null),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 5),
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isSelectedUserIDLogin =
                                    !_isSelectedUserIDLogin;
                              });
                              if (_isSelectedUserIDLogin == true) {
                                setState(() {
                                  _isSelectedUserLogin = userIDLogin!;
                                  _isSelectedUserID = false;
                                });
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.67,
                              color: _isSelectedUserIDLogin == true
                                  ? logolightGreen
                                  : null,
                              padding: EdgeInsets.all(4),
                              child: Text(
                                "$userIDLogin " + "$userNameLogin",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: _isSelectedUserIDLogin == true
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (level >= 3)
                        listCO != null
                            ? Container(
                                height: 180,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: ListView.builder(
                                    itemCount: listCO != null
                                        ? listCO.length
                                        : [].length,
                                    padding: const EdgeInsets.only(top: 5.0),
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: InkWell(
                                          onTap: () =>
                                              _onClicklistCO(listCO[index]),
                                          child: Center(
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  '${listCO[index]['uname']}',
                                                  style: TextStyle(
                                                      color: userID ==
                                                              listCO[index]
                                                                  ['ucode']
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
                      if (level >= 3)
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            AppLocalizations.of(context)!
                                    .translate('by_branch') ??
                                'By Branch',
                            style: TextStyle(
                              fontWeight: fontWeight700,
                            ),
                          ),
                        ),
                      if (level >= 3)
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
                                          onTap: () => _onClickListBranch(
                                              listBranch[index]),
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
                                  : DateTime(now.year, now.month, now.day - 7);
                            });
                          },
                          initialValue:
                              DateTime(now.year, now.month, now.day - 7),
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
                      Padding(padding: EdgeInsets.only(top: 10)),

                      Card(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isSelectedApproved = !_isSelectedApproved;
                              _isStatuSelectedReject = false;
                              _isStatuSelectedReturn = false;
                              status = '2';
                            });
                          },
                          child: Container(
                            color: _isSelectedApproved == true
                                ? logolightGreen
                                : null,
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                        .translate('approved') ??
                                    'Approved',
                                style: TextStyle(
                                    color: _isSelectedApproved == true
                                        ? Colors.white
                                        : null),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          color: _isStatuSelectedReject == true
                              ? logolightGreen
                              : null,
                          width: MediaQuery.of(context).size.width * 1,
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isStatuSelectedReject =
                                    !_isStatuSelectedReject;
                                _isSelectedApproved = false;
                                _isStatuSelectedReturn = false;
                                status = '9';
                              });
                            },
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                        .translate('reject') ??
                                    'Reject',
                                style: TextStyle(
                                    color: _isStatuSelectedReject == true
                                        ? Colors.white
                                        : null),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isStatuSelectedReturn = !_isStatuSelectedReturn;
                              _isStatuSelectedReject = false;
                              _isSelectedApproved = false;
                              status = '1';
                            });
                          },
                          child: Container(
                            color: _isStatuSelectedReturn == true
                                ? logolightGreen
                                : null,
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                        .translate('processing') ??
                                    'Processing',
                                style: TextStyle(
                                    color: _isStatuSelectedReturn == true
                                        ? Colors.white
                                        : null),
                              ),
                            ),
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
                            ElevatedButton(
                              onPressed: _closeEndDrawer,
                              child: Text(AppLocalizations.of(context)!
                                      .translate('reset') ??
                                  "Reset"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: logolightGreen,
                              ),
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
                    ])),
          ),
        )),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate('total') ??
                                "Total: ",
                            style: TextStyle(fontWeight: fontWeight800),
                          ),
                          Text(
                            ": ${listHistory['judgementListCount']}",
                            style: TextStyle(fontWeight: fontWeight800),
                          ),
                        ],
                      )),
                  Container(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate('status') ??
                                "Status: ",
                          ),
                          Text(
                            valueStringStatus != null
                                ? ": " + valueStringStatus
                                : "",
                            style: TextStyle(fontWeight: fontWeight800),
                          ),
                        ],
                      )),
                  Container(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                    .translate('from_date') ??
                                "From Date: ",
                          ),
                          Text(
                            ": $startDateTimeDidMounted",
                            style: TextStyle(fontWeight: fontWeight800),
                          ),
                        ],
                      )),
                  Container(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                    .translate('end_date') ??
                                "End Date: ",
                          ),
                          Text(
                            ": $endDateTimeDidMounted",
                            style: TextStyle(fontWeight: fontWeight800),
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                        itemCount: listHistory['judgementList'].length,
                        itemBuilder: (context, index) {
                          var list = listHistory['judgementList'];
                          return Container(
                            padding: EdgeInsets.all(5),
                            child: Card(
                                elevation: 5,
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           GroupLoanApproveDetail(
                                    //             groupLoanID: list[index],
                                    //           )),
                                    // );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Authorizer: '),
                                                Text(
                                                  "${list[index]['authorizerEmpName']}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          fontWeight700),
                                                ),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.all(2)),
                                            Row(
                                              children: [
                                                Text('Customer Name: '),
                                                Text(
                                                  '${list[index]['customerName']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          fontWeight700),
                                                ),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.all(2)),
                                            Row(
                                              children: [
                                                Text('Application Amount: '),
                                                Text(
                                                  '${list[index]['applicationAmount']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          fontWeight700),
                                                ),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.all(2)),
                                            Row(
                                              children: [
                                                Text('Currency:'),
                                                Text(
                                                  '${list[index]['currencyCode']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          fontWeight700),
                                                ),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.all(2)),
                                            Row(
                                              children: [
                                                Text('Product: '),
                                                Container(
                                                  width: 170,
                                                  child: Text(
                                                    '${list[index]['productName']}',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            fontWeight700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.all(2)),
                                            Row(
                                              children: [
                                                Text('Interest Rate:'),
                                                Text(
                                                  '${list[index]['applyInterestRate']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          fontWeight700),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Application Date: '),
                                                getDateTimeApprove(list[index]
                                                    ['applicationDate']),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Branch: '),
                                            Text(
                                              '${list[index]['applicationBranchCode']}',
                                              style: TextStyle(
                                                  fontWeight: fontWeight700),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        }),
                  ),
                ],
              ));
  }
}
