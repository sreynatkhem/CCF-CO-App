import 'package:chokchey_finance/XDColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adobe_xd/page_link.dart';
import './Home.dart';

class Login extends StatelessWidget {
  final ImageProvider chokchey;
  Login({
    Key key,
    this.chokchey = const AssetImage('assets/images/chokchey.png'),
  }) : super(key: key);

  String value = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              width: 172.0,
              height: 172.0,
              margin: EdgeInsets.only(top: 20),
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
                fontFamily: 'Segoe UI',
                fontSize: 20,
                color: const Color(0xff0abab5),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              ' CHOK CHEY Finance',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20,
                color: const Color(0xff0abab5),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                  onChanged: (text) {
                    value = text;
                  },
                  decoration: InputDecoration(
                      labelText: 'Email or Username',
                      labelStyle: TextStyle(fontSize: 15))),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(left: 20, right: 15),
              child: TextField(
                  onChanged: (text) {
                    value = text;
                  },
                  decoration: InputDecoration(labelText: 'Password')),
            ),
            Container(
              width: 375,
              margin: EdgeInsets.only(top: 20),
              child: RaisedButton(
                padding: const EdgeInsets.all(8.0),
                textColor: Colors.white,
                color: const Color(0xff0ABAB5),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: new Text("Add"),
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
    );
  }
}

const String _svg_vrqt87 =
    '<svg viewBox="46.0 463.0 283.0 35.0" ><path transform="translate(46.0, 463.0)" d="M 10 0 L 273 0 C 278.5228576660156 0 283 4.477152347564697 283 10 L 283 25 C 283 30.52284812927246 278.5228576660156 35 273 35 L 10 35 C 4.477152347564697 35 0 30.52284812927246 0 25 L 0 10 C 0 4.477152347564697 4.477152347564697 0 10 0 Z" fill="#0abab5" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
