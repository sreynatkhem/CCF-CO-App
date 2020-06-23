import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chokchey_finance/screens/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final FirebaseApp app = await FirebaseApp.configure(
  //   name: 'userID',
  //   options: Platform.isIOS
  //       ? const FirebaseOptions(
  //           googleAppID: '1:805483562052:android:ed75b94bbcef00b3c56811',
  //           gcmSenderID: '805483562052',
  //           databaseURL: 'https://cff-application-test.firebaseio.com',
  //         )
  //       : const FirebaseOptions(
  //           googleAppID: '1:805483562052:ios:84c9ecab5a575bd9c56811',
  //           apiKey: 'AIzaSyB7llYDJa-csVh54U-RPSziUssDAc4wtaM',
  //           databaseURL: 'https://cff-application-test.firebaseio.com',
  //         ),
  // );
  Stetho.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return new MaterialApp(initialRoute: '/login', routes: routes);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  // Widget build(BuildContext context) {
  //   return Login();
  // }
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Container(child: Login()),
      ),
      onWillPop: () async => false,
    );
  }
}
