import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';

class ListCustomerRegistration extends StatefulWidget {
  @override
  _ListCustomerRegistrationState createState() =>
      _ListCustomerRegistrationState();
}

class _ListCustomerRegistrationState extends State<ListCustomerRegistration> {
  Route routes(RouteSettings settings) {
    if (settings.name == '/Home') {
      return MaterialPageRoute(
        builder: (context) {
          return Home();
        },
      );
    }
  }

  getList() {}
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("List Customer Registration"),
        backgroundColor: logolightGreen,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              ModalRoute.withName("/Home")),
        ),
      ),
      body: FutureBuilder(
        future: getList(),
        builder: (context, snapshot) {
          return Container(
              child: ListView.builder(
                  itemCount: [
                    'hello',
                    'hello',
                    'hello',
                    'hello',
                    'hello',
                  ].length,
                  // scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        Text('Name'),
                      ],
                    );
                  }));
        },
      ),
    );
  }
}
