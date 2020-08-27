import 'dart:async';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/models/customers.dart';
import 'package:chokchey_finance/providers/listCustomerRegistration.dart';
import 'package:chokchey_finance/screens/customerRegister/customerRegister.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chokchey_finance/components/card.dart';
import 'detailCustomerRegistration.dart';

class ListCustomerRegistration extends StatefulWidget {
  @override
  _ListCustomerRegistrationState createState() =>
      _ListCustomerRegistrationState();
}

class _ListCustomerRegistrationState extends State<ListCustomerRegistration> {
  var futureListCustomerRegistraiton;
  final profile = const AssetImage('assets/images/profile_create.jpg');

  onTapsDetail(value) async {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CardDetailCustomer(
            list: value.ccode,
          );
        },
        fullscreenDialog: true));
  }

  ScrollController _scrollController = ScrollController();
  int _pageSize = 20;
  int _pageNumber = 1;

  bool isLoading = false;

  List<Customers> _cachedItems = List.from([]);

  StreamController<List<ListCustomerRegistrationProvider>> _streamController =
      StreamController<List<ListCustomerRegistrationProvider>>();
  StreamSink<List<ListCustomerRegistrationProvider>> get itemsSink =>
      _streamController.sink;
  Stream<List<ListCustomerRegistrationProvider>> get itemsStream =>
      _streamController.stream;
  var data = [];
  Future _additems() async {
    setState(() {
      isLoading = true;
    });
    try {
      _pageSize += 10;
      // Fetch newItems with http
      futureListCustomerRegistraiton =
          Provider.of<ListCustomerRegistrationProvider>(context, listen: false)
              .fetchListCustomerRegistration(_pageSize, _pageNumber);
      setState(() {
        isLoading = false;
      });
      // _cachedItems.addAll(futureListCustomerRegistraiton);
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
  void didUpdateWidget(ListCustomerRegistration oldWidget) {
    // TODO: implement didUpdateWidget
    futureListCustomerRegistraiton =
        Provider.of<ListCustomerRegistrationProvider>(context)
            .fetchListCustomerRegistration(20, 1);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    futureListCustomerRegistraiton =
        Provider.of<ListCustomerRegistrationProvider>(context)
            .fetchListCustomerRegistration(20, 1);

    if (this.futureListCustomerRegistraiton != futureListCustomerRegistraiton) {
      this.futureListCustomerRegistraiton = futureListCustomerRegistraiton;
      Future.microtask(() => futureListCustomerRegistraiton.doSomeHttpCall());
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
    futureListCustomerRegistraiton =
        Provider.of<ListCustomerRegistrationProvider>(context, listen: false)
            .fetchListCustomerRegistration(_pageSize, _pageNumber);
    return NotificationListener(
      onNotification: onNotification,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : new Scaffold(
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
              ),
              body: FutureBuilder<List<Customers>>(
                future: futureListCustomerRegistraiton,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Container(
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    CardState(
                                      texts: '${snapshot.data[index].namekhr}',
                                      textTwo:
                                          '${snapshot.data[index].nameeng}',
                                      id: '${snapshot.data[index].ccode}',
                                      phone: '${snapshot.data[index].phone1}',
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
