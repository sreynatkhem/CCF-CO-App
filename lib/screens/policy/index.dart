import 'dart:io';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/screens/policy/card.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'webViewUrl.dart';
// import 'package:url_launcher/url_launcher.dart';

class PolicyScreen extends StatefulWidget {
  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  Future<void>? _launched;

  Future<void> _launchInWebViewOrVC(String url) async {
    logger().e("url: $url");

    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
  // Future<void> _launchInBrowser(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: false,
  //       forceWebView: false,
  //       headers: <String, String>{'my_header_key': 'my_header_value'},
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  final hrPolicy = const AssetImage('assets/images/hr_policy.png');
  Future<void> _launchInBrowser(String url) async {
    logger().e("url: $url");
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  webView() {
    return WebView(
      initialUrl: 'https://flutter.dev',
    );
  }

  @override
  Widget build(BuildContext context) {
    // var toLaunch = 'http://192.168.111.18:2020/policy/requirementchecklist.pdf';
    var toLaunch =
        'https://drive.google.com/file/d/1Qi050IO1aDzQNSRQmG7hfx_XiQeYqWAf/view?usp=sharing';
    var creditOperationManualToLaunch =
        'https://drive.google.com/file/d/1VhkXHs3dHjSllJ47kCQN-lWw-6OHjaAi/view';
    // var test =
    // "https://stackoverflow.com/questions/69345255/the-application-could-not-be-installed-install-parse-failed-manifest-malformed";
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('policy')!),
        backgroundColor: logolightGreen,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Platform For IOS
                if (Platform.isIOS)
                  CardPolicy(
                    imageCard: hrPolicy,
                    onTap: () => setState(() {
                      _launched = _launchInWebViewOrVC(toLaunch);
                    }),
                    title: 'loan_check_list',
                  ),
                if (Platform.isIOS)
                  CardPolicy(
                    imageCard: hrPolicy,
                    onTap: () => setState(() {
                      _launched =
                          _launchInWebViewOrVC(creditOperationManualToLaunch);
                    }),
                    title: 'credit_operation_manual',
                  ),
                //Platform For Android
                if (Platform.isAndroid)
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: logolightGreen, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 10)),
                          CircleAvatar(
                            radius: 23.0,
                            backgroundImage:
                                AssetImage("assets/images/hr_policy.png"),
                            backgroundColor: Colors.transparent,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewUrl(
                                      title: "loan_check_list",
                                      url: toLaunch,
                                    ),
                                  ),
                                );
                              },
                              splashColor: Colors.blue.withAlpha(30),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 60, left: 10)),
                                  Padding(padding: EdgeInsets.only(right: 10)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Loann Check List"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (Platform.isAndroid)
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: logolightGreen, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 10)),
                          CircleAvatar(
                            radius: 23.0,
                            backgroundImage:
                                AssetImage("assets/images/hr_policy.png"),
                            backgroundColor: Colors.transparent,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewUrl(
                                      title: "credit_operation_manual",
                                      url: creditOperationManualToLaunch,
                                    ),
                                  ),
                                );
                              },
                              splashColor: Colors.blue.withAlpha(30),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 60, left: 10)),
                                  Padding(padding: EdgeInsets.only(right: 10)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Credit Operation Manual"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                // CardPolicy(
                //   imageCard: hrPolicy,
                //   // onTap: () => setState(() {
                //   //   _launched =
                //   //       _launchInWebViewOrVC(creditOperationManualToLaunch);
                //   // }),
                //   onTap: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => WebViewUrl(
                //         title: "credit_operation_manual",
                //         url: creditOperationManualToLaunch,
                //       ),
                //     ),
                //   ),
                //   title: 'credit_operation_manual',
                // ),

                ////
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => WebViewUrl(
                //                 title: "credit_operation_manual",
                //                 url: creditOperationManualToLaunch,
                //               )),
                //     );
                //   },
                //   child: Text("hello world"),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
