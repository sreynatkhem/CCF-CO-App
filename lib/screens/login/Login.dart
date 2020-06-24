import 'package:chokchey_finance/modals/index.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/services/login.dart';
import 'package:chokchey_finance/services/manageService.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Login extends StatefulWidget {
  final ImageProvider chokchey;
  Login({
    Key key,
    this.chokchey = const AssetImage('assets/images/chokchey.png'),
  }) : super(key: key);
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final storage = new FlutterSecureStorage();

  final TextEditingController id = TextEditingController();
  final TextEditingController password = TextEditingController();

  final chokchey = const AssetImage('assets/images/chokchey.png');

  bool _isLogin = false;

  final focus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getStore();
  }

  Future<void> getStore() async {
    String ids = await storage.read(key: 'valueid');
    String passwords = await storage.read(key: 'password');
    if (mounted) {
      setState(() {
        id.text = ids;
        password.text = passwords;
      });
    }
  }

// Create storage Login
  Future<void> onClickLogin(context) async {
    final String valueid = id.text;
    final String valuePassword = password.text;

    await storage.write(key: "valueid", value: valueid);
    await storage.write(key: "password", value: valuePassword);

    await FirebaseDatabase.instance
        .reference()
        .child("userID")
        .once()
        .then((dataSnapshot) => {
              dataSnapshot.value.forEach(([key, value]) async => {
                    if (key['user_id'] == valueid && valuePassword == '1234')
                      {
                        print('user_id: ${key['user_id']}'),
                        setState(() {
                          _isLogin = false;
                        }),
                        await storage.write(
                            key: "user_name", value: key['user_name']),
                        await storage.write(
                            key: "user_id", value: key['user_id']),
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                            ModalRoute.withName("/login"))
                      }
                    else
                      {
                        setState(() {
                          _isLogin = false;
                        }),
                      }
                  }),
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: 300.0,
                height: 250.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(42.0),
                  image: DecorationImage(
                    image: chokchey,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                'Welcome',
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: fontSizeLg,
                  color: logolightGreen,
                  fontWeight: fontWeight700,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
              Text(
                ' CHOK CHEY Finance',
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: fontSizeLg,
                  color: logolightGreen,
                  fontWeight: fontWeight700,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                    autofocus: true,
                    controller: id,
                    maxLength: 6,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus);
                    },
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        labelText: 'User ID',
                        hintText: id.text,
                        labelStyle: TextStyle(fontSize: 15))),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 20, right: 15),
                child: TextField(
                    controller: password,
                    focusNode: focus,
                    obscureText: true,
                    onSubmitted: (s) async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                      await onClickLogin(context);
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: password.text,
                    )),
              ),
              Container(
                width: 320,
                height: 45,
                margin: EdgeInsets.only(top: 40, bottom: 20),
                child: FlatButton(
                  color: logolightGreen,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                    await onClickLogin(context);
                  },
                  // onPressed: () => {onClickLogin(context)},
                  child: Text(
                    "Log In",
                  ),
                ),
              ),
              Text(
                'Forgot passwrod',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 12,
                  color: const Color(0xff39a5ef),
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const String _svg_vrqt87 =
    '<svg viewBox="46.0 463.0 283.0 35.0" ><path transform="translate(46.0, 463.0)" d="M 10 0 L 273 0 C 278.5228576660156 0 283 4.477152347564697 283 10 L 283 25 C 283 30.52284812927246 278.5228576660156 35 273 35 L 10 35 C 4.477152347564697 35 0 30.52284812927246 0 25 L 0 10 C 0 4.477152347564697 4.477152347564697 0 10 0 Z" fill="#0abab5" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
