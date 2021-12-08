import 'dart:io';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewUrl extends StatefulWidget {
  String title = "";
  String url = "";

  WebViewUrl({required this.title, required this.url});

  @override
  _WebViewUrlState createState() => _WebViewUrlState();
}

class _WebViewUrlState extends State<WebViewUrl> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text(
            AppLocalizations.of(context)!.translate(widget.title)!,
          ),
          backgroundColor: logolightGreen,
          centerTitle: true),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
