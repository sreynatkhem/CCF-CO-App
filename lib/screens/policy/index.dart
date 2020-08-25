import 'package:chokchey_finance/components/card.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/screens/policy/policy_widget.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class PolicyScreen extends StatefulWidget {
  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  String pathPDF = "";
  var isLoading = false;

  Future<File> createFileOfPdfUrl(title) async {
    setState(() {
      isLoading = true;
    });
    try {
      // final url = "http://www.pdf995.com/samples/pdf.pdf";
      // final filename = url.substring(url.lastIndexOf("/") + 1);
      // var request = await HttpClient().getUrl(Uri.parse(url));
      // var response = await request.close();
      // var bytes = await consolidateHttpClientResponseBytes(response);
      // String dir = (await getApplicationDocumentsDirectory()).path;
      // File file = new File('$dir/$filename');
      // await file.writeAsBytes(bytes);
      // setState(() {
      //   isLoading = false;
      // });
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => PolicyWidget(file.path, title)),
      // );
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PolicyWidget('assets/pdf/requirementchecklist.pdf', title)),
      );
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  final hrPolicy = const AssetImage('assets/images/hr_policy.png');
  final creditPolicy = const AssetImage('assets/images/credit_policy.png');

  onTapsPolicy(title) async {
    createFileOfPdfUrl(title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              AppLocalizations.of(context).translate('policy') ?? 'Policy'),
          backgroundColor: logolightGreen,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10)),
                  CardState(
                    texts: 'loan_check_list',
                    images: hrPolicy,
                    onTaps: () {
                      onTapsPolicy('Requirement Check List');
                    },
                  ),
                  // CardState(
                  //   texts: 'credit_policy',
                  //   images: creditPolicy,
                  //   onTaps: () {
                  //     onTapsPolicy('Credit Policy');
                  //   },
                  // ),
                ],
              ));
  }
}
