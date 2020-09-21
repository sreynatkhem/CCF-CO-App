import 'dart:convert';

import 'package:chokchey_finance/components/card.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/approvalHistory/index.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import 'detailCustomerRegistration.dart';

class ListCustomerRegistrations extends StatefulWidget {
  @override
  _ListCustomerRegistrationsState createState() =>
      _ListCustomerRegistrationsState();
}

class _ListCustomerRegistrationsState extends State<ListCustomerRegistrations> {
  var parsed = [];
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _isLoading = true;
    });
    if (mounted) {
      getListCustomer(20, 1, '', '', '', '', '')
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
    }
  }

  onTapsDetail(value) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CardDetailCustomer(
            list: value['ccode'],
          );
        },
        fullscreenDialog: true));
  }

  ScrollController _scrollController = ScrollController();
  Future getListCustomer(
      _pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    setState(() {
      // _isLoading = true;
    });
    final storage = new FlutterSecureStorage();
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
      bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"btlcode\": \"$btlcode\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"$sdates\",\n    \"edate\": \"$edates\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await api().post(baseURLInternal + 'customers/all',
          headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        setState(() {
          parsed = listLoan[0]['listCustomers'];
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

  var listBranch = [];
  var listCO = [];
  var status;
  var code;
  var sdate;
  var edate;
  var bcode;
  final profile = const AssetImage('assets/images/profile_create.jpg');

  void _closeEndDrawer() {
    setState(() {
      code = null;
      bcode = null;
      controllerEndDate.text = '';
      controllerStartDate.text = '';
    });
    getListCustomer(20, 1, '', '', '', '', '');
    getListBranches();
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

    var startDate = sdate != null ? sdate : DateTime(now.year, now.month, 1);
    var endDate = edate != null ? edate : DateTime.now();
    getListCustomer(20, 1, '', '', bcode, startDate, endDate);
    Navigator.of(context).pop();
  }

  _onClickListBranch(v) {
    setState(() {
      bcode = v['bcode'];
    });
  }

  TextEditingController controllerStartDate = new TextEditingController();
  TextEditingController controllerEndDate = new TextEditingController();

  Future<void> _getData() async {
    setState(() {
      _isLoading = true;
    });
    getListCustomer(20, 1, '', '', '', '', '')
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
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
              AppLocalizations.of(context).translate('customer_list') ??
                  "Customer List"),
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
        body: _isLoading
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : RefreshIndicator(
                onRefresh: _getData,
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: parsed.length,
                    itemBuilder: (BuildContext context, int index) {
                      // print("snapshot.data.length: ${snapshot.data.length}");
                      return Column(
                        children: <Widget>[
                          CardState(
                            texts: '${parsed[index]['namekhr']}',
                            textTwo:
                                '${parsed[index]['nameeng'] != null ? parsed[index]['nameeng'] : ''}',
                            id: '${parsed[index]['ccode']}',
                            phone: '${parsed[index]['phone1']}',
                            images: profile,
                            onTaps: () {
                              onTapsDetail(parsed[index]);
                            },
                          )
                        ],
                      );
                    }),
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
