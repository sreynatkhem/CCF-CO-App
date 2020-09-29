import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/screens/policy/card.dart';
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
              CardPolicy(
                imageCard: hrPolicy,
                onTap: () {
                  setState(() {
                    _launched = _launchInBrowser(toLaunch);
                  });
                },
                title: 'loan_check_list',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
