import 'dart:convert';

import 'package:chokchey_finance/components/maxWidthWrapper.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/approvalHistory/index.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'detailLoadRegistration.dart';

class ListLoanRegistrations extends StatefulWidget {
  @override
  _ListLoanRegistrationsState createState() => _ListLoanRegistrationsState();
}

class _ListLoanRegistrationsState extends State<ListLoanRegistrations> {
  int _pageSize = 20;
  int _pageNumber = 1;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      getListLoanRegitster(_pageSize, _pageNumber, '', '', '', '', '')
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

  var parsed = [];
  Future getListLoanRegitster(
      _pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    final storage = new FlutterSecureStorage();
    try {
      var token = await storage.read(key: 'user_token');
      var userUcode = await storage.read(key: "user_ucode");
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
        btlcode = userUcode;
        ucode = code != null && code != "" ? code : '';
      }

      if (level == '1') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        ucode = userUcode;
        btlcode = '';
      }

      if (level == '4' || level == '5' || level == '6') {
        bcodes = bcode != null && bcode != "" ? bcode : '';
        btlcode = '';
        ucode = code != null && code != "" ? code : '';
      }
      // bodyRow =
      //     "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"$sdates\",\n    \"edate\": \"$edates\"\n}";
      final Map<String, dynamic> bodyRow = {
        "pageSize": "$_pageSize",
        "pageNumber": "$_pageNumber",
        "ucode": "$ucode",
        "bcode": "$bcodes",
        "status": "$sdates",
        "edate": "$edates",
      };

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'loans/all/mobile'),
          headers: headers,
          body: json.encode(bodyRow));
      if (response.statusCode == 200) {
        var list = jsonDecode(response.body);
        setState(() {
          parsed = list;
        });
        return list;
      }
    } catch (error) {
      logger().e("error: $error");
    }
  }

  ScrollController _scrollController = ScrollController();
  final _imagesFindApproval =
      const AssetImage('assets/images/profile_create.jpg');

  onTapsDetail(value) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CardDetailLoanRegitration(
                list: value['lcode'], statusLoan: value['lstatus'])));
  }

  Future<void> _getData() async {
    setState(() {
      _isLoading = true;
    });
    getListLoanRegitster(_pageSize, _pageNumber, '', '', '', '', '')
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

  void _closeEndDrawer() {
    setState(() {
      code = null;
      bcode = null;
      controllerEndDate.text = '';
      controllerStartDate.text = '';
      _isLoading = true;
    });
    getListLoanRegitster(20, 1, '', '', '', '', '')
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
    Navigator.of(context).pop();
  }

  _applyEndDrawer() {
    DateTime now = DateTime.now();
    setState(() {
      _isLoading = true;
    });
    var startDate = sdate != null ? sdate : DateTime(now.year, now.month, 1);
    var endDate = edate != null ? edate : DateTime.now();
    getListLoanRegitster(20, 1, '', '', bcode, startDate, endDate)
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
    await ApprovalHistoryProvider()
        .getListCO(name)
        .then((value) => {
              setState(() {
                listCO = value;
              }),
            })
        .catchError((onError) {});
  }

  void _onClickListCO(v) {
    setState(() {
      code = v['ucode'];
    });
  }

  TextEditingController controllerStartDate = new TextEditingController();
  TextEditingController controllerEndDate = new TextEditingController();

  _onClickListBranch(v) {
    setState(() {
      bcode = v['bcode'];
    });
  }

  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        ModalRoute.withName("/Home"));
    return false;
  }

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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            setState(() {
              _pageSize += 10;
              // parsed = [];
            });
            getListLoanRegitster(_pageSize, _pageNumber, '', '', '', '', '');
          }
          return false;
        },
        child: Scaffold(
          appBar: new AppBar(
            title: new Text(
                AppLocalizations.of(context)!.translate('loan_register_list') ??
                    "Loan Register List"),
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
                      child: MaxWidthWrapper(
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: parsed.length,
                            itemBuilder: (BuildContext context, int index) {
                              var irr;
                              if (parsed[index]['irr'] != null &&
                                  parsed[index]['irr'] != 0.0) {
                                irr = numFormat.format(parsed[index]['irr']);
                              } else {
                                irr = '0.0';
                              }
                              var status = statusApproval(parsed != null
                                  ? parsed[index]['lstatus']
                                  : '');
                              return Container(
                                // height: 130,
                                // padding: EdgeInsets.all(3),
                                // padding:
                                //     EdgeInsets.only(left: 5, right: 5, top: 3),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: logolightGreen, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: InkWell(
                                          splashColor:
                                              Colors.blue.withAlpha(30),
                                          onTap: () {
                                            onTapsDetail(parsed[index]);
                                          },
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Image(
                                                          image:
                                                              _imagesFindApproval,
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              '${parsed[index]['customer']}',
                                                              style:
                                                                  mainTitleBlack,
                                                            ),
                                                            Text(
                                                                '${parsed[index]['purpose']}'),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                            Text(
                                                                '${numFormat.format(parsed[index]['lamt'])} (${parsed[index]['currency']})'),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                            Row(
                                                              children: [
                                                                Text(AppLocalizations.of(
                                                                        context)!
                                                                    .translate(
                                                                        'interest')!),
                                                                Text(
                                                                    '${parsed[index]['intrate']}%/m, IRR $irr%'),
                                                              ],
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                            Text(
                                                                '${parsed[index]['user'].substring(9)} - ${parsed[index]['branch']}'),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      status,
                                                      Text(
                                                          '#${parsed[index]['lcode']}'),
                                                    ],
                                                  ),
                                                ),
                                                // if (isLoading == true)
                                                //   Center(child: CircularProgressIndicator())
                                              ])),
                                    )),
                              );
                            }),
                      ),
                    )
                  : Center(
                      child: Container(
                          child: Text(AppLocalizations.of(context)!
                              .translate('no_data')!))),
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
