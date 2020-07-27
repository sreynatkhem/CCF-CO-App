import 'dart:async';
import 'package:chokchey_finance/providers/listCustomerRegistration.dart';
import 'package:chokchey_finance/screens/approval/approvalList.dart';
import 'package:chokchey_finance/providers/approvalList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/screens/login/Login.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'providers/login.dart';

Future<void> main() async {
  Provider.debugCheckInvalidValueType = null;
  Stetho.initialize();
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = new FlutterSecureStorage();
  bool _isLogin = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    isLogin();
    super.didChangeDependencies();
  }

  Future<void> isLogin() async {
    String ids = await storage.read(key: 'valueid');
    if (ids != null || ids == '') {
      setState(() {
        _isLogin = true;
      });
    } else {
      setState(() {
        _isLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<LoginProvider>(create: (_) => LoginProvider()),
        Provider<ApprovelistProvider>(create: (_) => ApprovelistProvider()),
        Provider<ListCustomerRegistrationProvider>(
            create: (_) => ListCustomerRegistrationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _isLogin ? Home() : Login(),
        routes: {ApprovalLists.routeName: (cxt) => ApprovalLists()},
      ),
    );
  }
}
