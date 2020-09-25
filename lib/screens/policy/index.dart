import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class PolicyScreen extends StatefulWidget {
  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  Future<void> _launched;

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  final hrPolicy = const AssetImage('assets/images/hr_policy.png');

  @override
  Widget build(BuildContext context) {
    const String toLaunch =
        'http://192.168.111.18:2020/policy/requirementchecklist.pdf';
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('policy')),
        backgroundColor: logolightGreen,
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 5.0),
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: logolightGreen, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              _launched = _launchInBrowser(toLaunch);
                            });
                          },
                          splashColor: Colors.blue.withAlpha(30),
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 60, left: 10)),
                                Image(
                                  image: hrPolicy,
                                  width: 45,
                                  height: 45,
                                ),
                                Padding(padding: EdgeInsets.only(right: 10)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(AppLocalizations.of(context)
                                        .translate('loan_check_list')),
                                  ],
                                ),
                              ])),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
