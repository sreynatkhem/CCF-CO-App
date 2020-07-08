import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getStore();
    super.didChangeDependencies();
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
                    if (key['user_id'] == valueid)
                      {
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
                child: TextField(
                    autofocus: true,
                    controller: id,
                    maxLength: 6,
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
                    onChanged: (text) {
                      if (text.length == 6) {
                        FocusScope.of(context).requestFocus(focus);
                      }
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    // onFieldSubmitted: (v) {
                    //   FocusScope.of(context).requestFocus(focus);
                    // },
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: logolightGreen),
                        ),
                        labelText: 'User ID',
                        hintText: id.text,
                        labelStyle: TextStyle(
                            fontSize: 15, color: const Color(0xff0ABAB5)))),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 20, right: 15),
                child: TextField(
                    enabled: false,
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
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: logolightGreen),
                        ),
                        labelText: 'Password',
                        hintText: password.text,
                        labelStyle: TextStyle(
                            fontSize: 15, color: const Color(0xff0ABAB5)))),
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
