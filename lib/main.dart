import 'package:chokchey_finance/route/route.dart';
import 'package:chokchey_finance/screens/login/Login.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
