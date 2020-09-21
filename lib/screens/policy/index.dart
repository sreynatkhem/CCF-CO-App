import 'dart:typed_data';

import 'package:chokchey_finance/components/card.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/screens/policy/policy_widget.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

const String _documentPath = 'assets/pdf/requirementchecklist.pdf';

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
      final url = "http://www.pdf995.com/samples/pdf.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
      setState(() {
        isLoading = false;
      });
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PolicyWidget(file.path, title)),
      );
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

  Future<String> prepareTestPdf() async {
    final ByteData bytes =
        await DefaultAssetBundle.of(context).load(_documentPath);
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$_documentPath';

    final file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(list);
    return tempDocumentPath;
  }

  final hrPolicy = const AssetImage('assets/images/hr_policy.png');
  final creditPolicy = const AssetImage('assets/images/credit_policy.png');

  onTapsPolicy(title) async {
    createFileOfPdfUrl(title);
  }

  var _isLoading = false;
  Future onTapDetail() async {
    setState(() {
      _isLoading = true;
    });
    await prepareTestPdf().then((path) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PolicyWidget(path, 'Loan Check List')),
      );
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
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
                  // _isLoading
                  //     ? Center(
                  //         child: CircularProgressIndicator(),
                  //       )
                  // CardState(
                  //     texts: 'loan_check_list',
                  //     images: hrPolicy,
                  //     onTaps: () => onTapDetail()),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: logolightGreen, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: InkWell(
                                    onTap: () {
                                      onTapDetail();
                                    },
                                    splashColor: Colors.blue.withAlpha(30),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 60, left: 10)),
                                          Image(
                                            image: hrPolicy,
                                            width: 45,
                                            height: 45,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10)),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(AppLocalizations.of(context)
                                                  .translate(
                                                      'loan_check_list')),
                                            ],
                                          ),
                                        ])),
                              )),
                        )
                ],
              ));
  }
}
