import 'dart:convert';

import 'package:chokchey_finance/components/groupFormBuilder.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/groupLoan/selectGroupLoan.dart';
import 'package:chokchey_finance/screens/groupLoanApprove/detail.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GroupLoanApprove extends StatefulWidget {
  @override
  _GroupLoanApproveState createState() => _GroupLoanApproveState();
}

class _GroupLoanApproveState extends State<GroupLoanApprove> {
  bool _isLoading = false;
  dynamic listGroupLoanApprove;
  static List<String> items;
  List<dynamic> newDataList;

  getListLoan(_pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    final storage = new FlutterSecureStorage();
    setState(() {
      _isLoading = true;
    });
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
      bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"btlcode\": \"$btlcode\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"$sdates\",\n    \"edate\": \"$edates\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await api().post(baseURLInternal + 'loanRequests/all',
          headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        setState(() {
          listGroupLoanApprove = listLoan[0]['listLoanRequests'];
          _isLoading = false;
          items = List<String>.generate(
              listGroupLoanApprove.length,
              (index) =>
                  "${listGroupLoanApprove[index]['rcode']} - ${listGroupLoanApprove[index]['loan']['customer']} - ${listGroupLoanApprove[index]['loan']['currency']} ${numFormat.format(listGroupLoanApprove[index]['loan']['lamt'])}");
          newDataList = List.from(items);
        });
      } else {
        setState(() {
          listGroupLoanApprove = [];
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (mounted) {
      getListLoan(20, 1, '', '', '', '', '');
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      headerTexts: "group_loan_approve",
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            ModalRoute.withName("/Home")),
      ),
      bodys: Container(
        padding: EdgeInsets.all(10),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: newDataList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(new MaterialPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return new GroupLoanApproveDetail(
                                        groupName: "Static Group Name",
                                        leaderGroupLoan:
                                            "Static Leader Group A",
                                        memberGroupLoan: newDataList[index],
                                      );
                                    },
                                    fullscreenDialog: true));
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 1,
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.credit_card,
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 10)),
                                  Container(
                                      // alignment: Alignment.topCenter,
                                      width: isIphoneX(context) ? 290 : 280,
                                      child: Text("${newDataList[index]}")),
                                ],
                              )),
                        ));
                      }),
                  flex: 1,
                )
              ]),
      ),
    );
  }
}
