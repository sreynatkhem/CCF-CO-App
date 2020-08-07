import 'dart:async';

import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/models/customers.dart';
import 'package:chokchey_finance/providers/listCustomerRegistration.dart';
import 'package:chokchey_finance/providers/loan/createLoan.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
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
      print("e $e");
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

    if (this.futureListLoanRegistraiton != futureListLoanRegistraiton) {
      this.futureListLoanRegistraiton = futureListLoanRegistraiton;
      Future.microtask(() => futureListLoanRegistraiton.doSomeHttpCall());
    }
    super.didChangeDependencies();
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
                title: new Text("List Loan Registration"),
                backgroundColor: logolightGreen,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      ModalRoute.withName("/Home")),
                ),
              ),
              body: FutureBuilder<List<CreateLoan>>(
                future: futureListLoanRegistraiton,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Container(
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    CardState(
                                      texts:
                                          '${snapshot.data[index].customer.namekhr}',
                                      textTwo:
                                          '${snapshot.data[index].customer.nameeng}',
                                      id: '\$ ${snapshot.data[index].lamt}',
                                      phone:
                                          '${snapshot.data[index].lpourpose}',
                                      images: profile,
                                      onTaps: () {
                                        onTapsDetail(snapshot.data[index]);
                                      },
                                    )
                                  ],
                                );
                              }))
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ),
    );
  }
}
