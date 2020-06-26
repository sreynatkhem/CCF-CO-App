import 'dart:async';
import 'package:chokchey_finance/services/approvalList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/screens/login/Login.dart';

Future<void> main() async {
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
    super.didChangeDependencies();
    isLogin();
  }

  Future<void> isLogin() async {
    String ids = await storage.read(key: 'valueid');
    if (ids != null) {
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
    return ChangeNotifierProvider(
      create: (cxt) => ApprovelistProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _isLogin ? Home() : Login(),
      ),
    );
  }
}
//  routes: {
//         "/": (context) => InitialPage(),  //This is what you are missing i guess
//         "/home": (context) => HomePage(),
//         "/page1": (context) => Page1(),
//       },
