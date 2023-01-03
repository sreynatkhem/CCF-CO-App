import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

import 'pdfCreditOperationManual.dart';
import 'webViewUrl.dart';
// import 'package:url_launcher/url_launcher.dart';

class PolicyScreen extends StatefulWidget {
  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  Future<void>? _launched;

  // Future<void> _launchInWebViewOrVC(String url) async {
  //   logger().e("url: $url");

  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: true,
  //       forceWebView: true,
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
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
  // Future<void> _launchInBrowser(String url) async {
  //   logger().e("url: $url");
  //   if (!await launch(
  //     url,
  //     forceSafariVC: false,
  //     forceWebView: false,
  //     headers: <String, String>{'my_header_key': 'my_header_value'},
  //   )) {
  //     throw 'Could not launch $url';
  //   }
  // }

  // webView() {
  //   return WebView(
  //     initialUrl: 'https://flutter.dev',
  //   );
  // }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw 'Could not launch $url';
    }
  }

  // final Uri toLaunch = Uri(
  //     scheme: 'https',
  //     host: 'drive.google.com/file/d/1Qi050IO1aDzQNSRQmG7hfx_XiQeYqWAf/view',
  //     path: 'headers/');
  final Uri toLaunch = Uri(
    scheme: 'https',
    host: 'www.cylog.org',
  );
  @override
  Widget build(BuildContext context) {
    // var toLaunch = 'http://192.168.111.18:2020/policy/requirementchecklist.pdf';
    var toLaunchs =
        'https://drive.google.com/file/d/1Qi050IO1aDzQNSRQmG7hfx_XiQeYqWAf/view?usp=sharing';
    var creditOperationManualToLaunch =
        'https://drive.google.com/file/d/1VhkXHs3dHjSllJ47kCQN-lWw-6OHjaAi/view';
    var test =
        "https://chokcheykh-my.sharepoint.com/:w:/g/personal/dalin_sok_chokchey_com_kh/EYN91ibf2qVOloOQCNCvdCMBtIn-sJHaZ3BeWl-Vqu5Ltg?e=pHyL5C";

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
                // if (Platform.isIOS)
                //   CardPolicy(
                //     imageCard: hrPolicy,
                //     onTap: () => setState(() {
                //       _launched = _launchInWebViewOrVC(toLaunch);
                //     }),
                //     title: 'loan_check_list',
                //   ),
                //Platform For Android
                // if (Platform.isAndroid)
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
                                    url: toLaunchs,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate("loan_check_list")!,
                                    ),
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

                // if (Platform.)
                Container(
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreditOperationManualScreen()));
                    },
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
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CreditOperationManualScreen(),
                                  ),
                                );
                                // logger().e("Hello");
                                // Directory appDocDir =
                                //     await getApplicationDocumentsDirectory();
                                // print('$appDocDir');

                                // String iosBookPath =
                                //     '${appDocDir.path}/chair.epub';
                                // print(iosBookPath);
                                // String androidBookPath =
                                //     'file:///android_asset/3.epub';
                                // EpubViewer.setConfig(
                                //     themeColor: Theme.of(context).primaryColor,
                                //     identifier: "iosBook",
                                //     scrollDirection:
                                //         EpubScrollDirection.ALLDIRECTIONS,
                                //     allowSharing: true,
                                //     enableTts: false,
                                //     nightMode: false);
                                // await EpubViewer.openAsset(
                                //   'assets/cd.epub',
                                //   lastLocation: EpubLocator.fromJson({
                                //     "bookId": "2239",
                                //     "href": "/OEBPS/ch06.xhtml",
                                //     "created": 1539934158390,
                                //     "locations": {
                                //       "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                                //     }
                                //   }),
                                // );
                                // // get current locator
                                // EpubViewer.locatorStream.listen((locator) {
                                //   print(
                                //       'LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
                                // });
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
