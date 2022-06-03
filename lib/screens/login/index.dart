import 'dart:convert';

import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/screens/login/defaultLogin.dart';
import 'package:chokchey_finance/screens/login/stepTwoLogin.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:chokchey_finance/providers/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final ImageProvider chokchey;
  Login({
    this.chokchey = const AssetImage('assets/images/chokchey.png'),
  });
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final storage = new FlutterSecureStorage();

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
    getStore();
    chokchey = const AssetImage('assets/images/chokchey.png');
    super.didChangeDependencies();
  }

  Future<void> getStore() async {
    String ids = await storage.read(key: 'user_id');
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

  // onClickFirst() {
  //   // FocusScope.of(context).requestFocus(focusFirstLogin);
  //   // setState(() {
  //   //   _firstLogIn = true;
  //   // });
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => StepTwoLogin(
  //               token: '',
  //               userId: '',
  //             )),
  //   );
  // }

  final GlobalKey<ScaffoldState> _scaffoldKeySignUp =
      new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value, colorsBackground) {
    _scaffoldKeySignUp.currentState!.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: colorsBackground,
    ));
  }

// Create storage Login
  Future<void> onClickLogin(context) async {
    final String user_id = id.text;
    final String valuePassword = password.text;
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<LoginProvider>(context, listen: false)
          .fetchLogin(user_id, valuePassword)
          .then((value) async => {
                if (value[0]['token'] != null)
                  {
                    showInSnackBar('Welcome!', logolightGreen),
                    await storage.write(
                        key: "user_ucode", value: value[0]['ucode']),
                    await storage.write(
                        key: "user_token", value: value[0]['token']),
                    await storage.write(
                        key: "branch", value: value[0]['branch']),
                    await storage.write(
                        key: "level", value: value[0]['level'].toString()),
                    await storage.write(
                        key: "isapprover",
                        value: value[0]['isapprover'].toString()),
                    await storage.write(
                        key: "roles", value: value[0]['roles'].toString()),
                    setState(() {
                      _isLoading = false;
                    }),
                    if (value[0]['roles'] != null)
                      {
                        _roles = value[0]['roles'],
                        await storage.write(
                            key: "roles", value: _roles.toString()),
                      },
                    if (value[0]['token'] != null &&
                        (value[0]['changePassword'] == null ||
                            value[0]['changePassword'] == 'N'))
                      {
                        // user need to change password
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StepTwoLogin(
                                  storeUser: value,
                                  valuePassword: valuePassword)),
                        )
                      }
                    else
                      {
                        await storage.write(
                            key: "user_id", value: value[0]['uid']),
                        await storage.write(
                            key: "password", value: valuePassword),
                        await storage.write(
                            key: "user_token", value: value[0]['token']),
                        await storage.write(
                            key: "user_name", value: value[0]['uname']),
                        await storage.write(
                            key: "user_ucode", value: value[0]['ucode']),
                        await storage.write(
                            key: "branch", value: value[0]['branch']),
                        await storage.write(
                            key: "level", value: value[0]['level'].toString()),
                        await storage.write(
                            key: "isapprover",
                            value: value[0]['isapprover'].toString()),
                        FirebaseMessaging.instance
                            .getToken()
                            .then((String? token) {
                          assert(token != null);
                          postTokenPushNotification(token);
                        }),
                        // already change password
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          ModalRoute.withName("/login"),
                        )
                      }
                  }
                else
                  {
                    showInSnackBar('Invalid User and Password!', Colors.red),
                  }
              })
          .catchError(
        (e) {
          setState(() {
            _isLoading = false;
          });
          showInSnackBar('Invalid User and Password!', Colors.red);
        },
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  postTokenPushNotification(tokens) async {
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    final Map<String, dynamic> bodyRow = {"mtoken": "$tokens"};
    try {
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'users/' + user_ucode + '/mtoken'),
          headers: headers,
          body: json.encode(bodyRow));
    } catch (error) {
      print('error:: ${error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeySignUp,
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
                  await onClickLogin(context);
                  setState(() {
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
                    await onClickLogin(context);
                  },
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
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
