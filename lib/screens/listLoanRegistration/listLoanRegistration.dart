import 'dart:async';
import 'dart:convert';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/models/customers.dart';
import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/models/listLoan.dart';
import 'package:chokchey_finance/providers/approvalHistory/index.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
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
            list: value.lcode,
            statusLoan: value.lstatus,
          );
        },
        fullscreenDialog: true));
  }

  ScrollController _scrollController = ScrollController();
  int _pageSize = 20;
  int _pageNumber = 1;

  bool isLoading = false;

  List<Customers> _cachedItems = List.from([]);

  StreamController<List<LoanInternal>> _streamController =
      StreamController<List<LoanInternal>>();
  StreamSink<List<LoanInternal>> get itemsSink => _streamController.sink;
  Stream<List<LoanInternal>> get itemsStream => _streamController.stream;
  var data = [];
  Future _additems() async {
    setState(() {
      isLoading = true;
    });
    try {
      _pageSize += 10;
      // Fetch newItems with http
      futureListLoanRegistraiton =
          Provider.of<LoanInternal>(context, listen: false)
              .getListLoan(_pageSize, _pageNumber, '', '', '', '', '');
      setState(() {
        isLoading = false;
      });
      // _cachedItems.addAll(futureListLoanRegistraiton);
      // itemsSink.add(_cachedItems);
    } catch (e) {
      itemsSink.addError(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  _scrollListener() {
    if (_scrollController.position.maxScrollExtent >=
            _scrollController.offset &&
        _scrollController.position.maxScrollExtent - _scrollController.offset <=
            70) {
      _additems();
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
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void didUpdateWidget(ListLoanRegistration oldWidget) {
    // TODO: implement didUpdateWidget
    futureListLoanRegistraiton = Provider.of<LoanInternal>(context)
        .getListLoan(20, 1, '', '', '', '', '');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // futureListLoanRegistraiton = Provider.of<LoanInternal>(context)
    //     .getListLoan(20, 1, '', '', '', '', '');

    if (this.futureListLoanRegistraiton != futureListLoanRegistraiton) {
      this.futureListLoanRegistraiton = futureListLoanRegistraiton;
      Future.microtask(() => futureListLoanRegistraiton.doSomeHttpCall());
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _streamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    futureListLoanRegistraiton =
        Provider.of<LoanInternal>(context, listen: false)
            .getListLoan(_pageSize, _pageNumber, '', '', '', '', '');
    return NotificationListener(
      onNotification: onNotification,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : new Scaffold(
              appBar: new AppBar(
                title: new Text(AppLocalizations.of(context)
                        .translate('loan_register_list') ??
                    "Loan Register List"),
                backgroundColor: logolightGreen,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      ModalRoute.withName("/Home")),
                ),
              ),
              body: FutureBuilder<List<ListLoan>>(
                future: futureListLoanRegistraiton,
                builder: (context, snapshot) {
                  logger().e('eeee: ${snapshot}');
                  if (snapshot.hasData) {
                    return Container(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              logger()
                                  .e('eeee: ${snapshot.data[index].customer}');

                              return Column(
                                children: <Widget>[
                                  Text('ehllo')
                                  // CardState(
                                  //   texts: '${snapshot.data[index].namekhr}',
                                  //   textTwo:
                                  //       '${snapshot.data[index].nameeng != null ? snapshot.data[index].nameeng : ''}',
                                  //   id: '${snapshot.data[index].ccode}',
                                  //   phone: '${snapshot.data[index].phone1}',
                                  //   images: profile,
                                  //   onTaps: () {
                                  //     onTapsDetail(snapshot.data[index]);
                                  //   },
                                  // )
                                ],
                              );
                            }));
                  } else {
                    return Center(
                      child: Container(
                        child: Text(AppLocalizations.of(context)
                                .translate('no_list_loans') ??
                            'No list loans'),
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
