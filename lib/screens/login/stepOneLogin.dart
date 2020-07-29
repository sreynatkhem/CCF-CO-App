import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/screens/login/defaultLogin.dart';
import 'package:chokchey_finance/screens/login/firstChangePassword.dart';
import 'package:chokchey_finance/screens/login/stepTwoLogin.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:chokchey_finance/providers/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

import 'package:provider/provider.dart';

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
  final TextEditingController firstLogin = TextEditingController();

  var chokchey;

  bool _firstLogIn = false;
  bool _isLoading = false;
  bool autofocus = false;

  final focusPassword = FocusNode();
  final focusFirstLogin = FocusNode();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getStore();
    chokchey = const AssetImage('assets/images/chokchey.png');
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

  var _login;
  var _roles;

  onClickFirst() {
    // FocusScope.of(context).requestFocus(focusFirstLogin);
    // setState(() {
    //   _firstLogIn = true;
    // });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StepTwoLogin()),
    );
  }

// Create storage Login
  Future<void> onClickLogin(context) async {
    final String valueid = id.text;
    final String valuePassword = password.text;
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<LoginProvider>(context, listen: false)
          .fetchLogin(valueid, valuePassword)
          .catchError((onError) => {print('onError : $onError')})
          .then((value) async => {
                if (value[0].token != null)
                  {
                    await storage.write(key: "valueid", value: value[0].uid),
                    await storage.write(key: "password", value: valuePassword),
                    await storage.write(
                        key: "user_name", value: value[0].uname),
                    setState(() {
                      _isLoading = false;
                    }),

                    if (value[0].roles != null)
                      {
                        _roles = value[0].roles,
                        await storage.write(
                            key: "roles", value: _roles.toString()),
                      },
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StepTwoLogin()),
                    )
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => Home(
                    //               roles: value[0].roles,
                    //             )),
                    //     ModalRoute.withName("/login"))
                  }
              });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
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
              DefaultLogin(
                onFieldSubmittedUser: (text) {
                  if (text.length == 6) {
                    FocusScope.of(context).unfocus();
                    FocusScope.of(context).requestFocus(focusPassword);
                  }
                },
                hintTextUser: id.text,
                controllerUser: id,
                onChangedUser: (text) {
                  if (text.length == 6) {
                    FocusScope.of(context).requestFocus(focusPassword);
                  }
                },
                controllerPassword: password,
                focusNodePassword: focusPassword,
                hintTextPassword: password.text,
                onChangedPassword: (v) {},
                onFieldSubmittedPassword: (text) async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  await onClickLogin(context);
                  setState(() {
                    // _firstLogIn = true;
                    autofocus = true;
                  });
                },
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
                  child: _firstLogIn
                      ? Text(
                          "Log In",
                        )
                      : Text(
                          "Next",
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
