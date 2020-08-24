import 'dart:async';
import 'dart:convert';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/models/customers.dart';
import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/providers/listCustomerRegistration.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  onTapsDetail(value) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CardDetailLoanRegitration(
            list: value['lcode'],
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
    getListLoan(20, 1);
    if (this.futureListLoanRegistraiton != futureListLoanRegistraiton) {
      this.futureListLoanRegistraiton = futureListLoanRegistraiton;
      Future.microtask(() => futureListLoanRegistraiton.doSomeHttpCall());
    }
    super.didChangeDependencies();
  }

  var _isFetching = true;
  var parsed = [];

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
      final response = await api().post(baseURLInternal + 'loans/byuser',
          headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        setState(() {
          parsed = listLoan[0]['listLoans'];
        });
      } else {
        print('statusCode::: ${response.statusCode}');
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    futureListLoanRegistraiton =
        Provider.of<LoanInternal>(context).getListLoan(20, 1);
    return NotificationListener(
      onNotification: onNotification,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : new Scaffold(
              appBar: new AppBar(
                title: new Text(AppLocalizations.of(context)
                        .translate('list_loan_registration') ??
                    "List Loan Registration"),
                backgroundColor: logolightGreen,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      ModalRoute.withName("/Home")),
                ),
              ),
              body: Container(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: parsed.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CardState(
                          texts: '${parsed[index]['customer']}',
                          textTwo: '${parsed[index]['lpourpose']}',
                          id: '\$ ${parsed[index]['lamt']}',
                          phone: '${parsed[index]['currency']}',
                          images: profile,
                          onTaps: () {
                            onTapsDetail(parsed[index]);
                          },
                        );
                      }))),
    );
  }
}
