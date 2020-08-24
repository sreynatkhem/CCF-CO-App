import 'dart:convert';

import 'package:chokchey_finance/components/ListDatial.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/models/detialApproval.dart';
import 'package:chokchey_finance/models/requestDetailLoan.dart';
import 'package:chokchey_finance/models/requestLoanApproval.dart';
import 'package:chokchey_finance/providers/loan/loanApproval.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class ApprovalListCard extends StatefulWidget {
  final dynamic list;

  ApprovalListCard(
    this.list,
  );

  @override
  _ApprovalListCardState createState() => _ApprovalListCardState();
}

class _ApprovalListCardState extends State<ApprovalListCard> {
  final images = const AssetImage('assets/images/request.png');

  final _imagesList = const AssetImage('assets/images/list.png');

  final _imagesFindApproval =
      const AssetImage('assets/images/findApproval.png');

  final _imageReturn = const AssetImage('assets/images/return.png');

  final _imageReject = const AssetImage('assets/images/reject.png');

  onClickCard(value, context) {}

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
      default:
        {
          return Text('', style: mainTitleBlack);
        }
        break;
    }
  }

  var futureLoanApproval;
  var parsed = [];
  var dataListLoanApproval = [];

  @override
  void didChangeDependencies() {
    futureLoanApproval =
        Provider.of<LoanApproval>(context).getLoanApproval(20, 1);
    getListLoan(20, 1);
    getDetail();

    if (this.futureLoanApproval != futureLoanApproval) {
      this.futureLoanApproval = futureLoanApproval;
      Future.microtask(() => futureLoanApproval.doSomeHttpCall());
    }
    super.didChangeDependencies();
  }

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
      final response = await api().post(baseURLInternal + 'loanRequests/byuser',
          headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        setState(() {
          parsed = listLoan[0]['listLoanRequests'];
          dataListLoanApproval = listLoan[0];
        });
      } else {
        print('statusCode::: ${response.statusCode}');
      }
    } catch (error) {}
  }

  var getListDetail = [];
  getDetail() async {
    final storage = new FlutterSecureStorage();
    try {
      var token = await storage.read(key: 'user_token');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await api().get(
        baseURLInternal + 'loanRequests/Applications/' + widget.list['rcode'],
        headers: headers,
      );
      if (response.statusCode == 200) {
        var list = jsonDecode(response.body);
        setState(() {
          getListDetail = list['loanApplications'];
        });
      } else {
        print('statusCode::: ${response.statusCode}');
      }
    } catch (error) {}
  }

  var futureLoanApprovalDetail;
  @override
  Widget build(BuildContext context) {
    var status = statusApproval(widget.list['rstatus']);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            margin: EdgeInsets.all(10),
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: logolightGreen, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {},
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 5)),
                              Image(
                                image: _imagesFindApproval,
                                width: 50,
                                height: 50,
                              ),
                              Padding(padding: EdgeInsets.only(right: 15)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      child: Text(
                                    '${widget.list['user']}',
                                    style: mainTitleBlack,
                                  )),
                                  Text('${widget.list['lcode']}'),
                                  Padding(padding: EdgeInsets.only(bottom: 2)),
                                  Text('${widget.list['rcode']}'),
                                  Padding(padding: EdgeInsets.only(bottom: 2)),
                                  Text(
                                      '${getDateTimeYMD(widget.list['rdate'])}'),
                                  Padding(padding: EdgeInsets.only(bottom: 2)),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(bottom: 2)),
                              status,
                              Padding(
                                  padding: EdgeInsets.only(
                                top: 5,
                              )),
                              if (widget.list['rdate'] != '')
                                Text(getDateTimeYMD(widget.list['rdate'])),
                              Text(''),
                              Padding(
                                  padding: EdgeInsets.only(
                                right: 100,
                              ))
                            ],
                          ),
                        ]))),
          ),
          Expanded(
              flex: 3,
              child: ListView.builder(
                  itemCount: getListDetail.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100,
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: logolightGreen, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {},
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(left: 5)),
                                        Image(
                                          image: _imagesList,
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
                                                child: Text(
                                              '${getListDetail[index]['userName']}',
                                              style: mainTitleBlack,
                                            )),
                                            Text(
                                                '${getListDetail[index]['branchName']}'),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 2)),
                                            Text(
                                                '${widget.list['loan']['currency']} ${getListDetail[index]['lamt']}'),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 2)),
                                            Text(
                                                '${getDateTimeYMD(getListDetail[index]['adate'])}'),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 2)),
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
                                        statusApproval(
                                            getListDetail[index]['lstatus']),
                                        Padding(
                                            padding: EdgeInsets.only(
                                          top: 5,
                                        )),
                                        if (widget.list['rdate'] != '')
                                          Text(getDateTimeYMD(
                                              widget.list['rdate'])),
                                        Text(''),
                                        Padding(
                                            padding: EdgeInsets.only(
                                          right: 100,
                                        ))
                                      ],
                                    ),
                                  ]))),
                    );
                  })),
        ],
      ),
    );
  }
}
