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

  onTapsDetail(value) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CardDetailCustomer(
            list: value,
          );
        },
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    futureListCustomerRegistraiton =
        Provider.of<ListCustomerRegistrationProvider>(context)
            .fetchListCustomerRegistration();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit Customer Registration"),
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
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            CardState(
                              texts: '${snapshot.data[index].name}',
                              id: '${snapshot.data[index].id}',
                              phone: '${snapshot.data[index].phone}',
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
    );
  }
}
