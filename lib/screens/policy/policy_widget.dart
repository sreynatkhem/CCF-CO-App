import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PolicyWidget extends StatefulWidget {
  String pathPDF = "";
  String title;
  PolicyWidget(this.pathPDF, this.title);

  @override
  _PolicyWidgetState createState() => _PolicyWidgetState(pathPDF, title);
}

class _PolicyWidgetState extends State<PolicyWidget> {
  String pathPDF = "";
  String title;

  _PolicyWidgetState(this.pathPDF, this.title);

  @override
  Widget build(BuildContext context) {
    // return PDFViewerScaffold(
    //     appBar: AppBar(
    //       title: Text('$title'),
    //       backgroundColor: logolightGreen,
    //       actions: <Widget>[
    //         IconButton(
    //           icon: Icon(Icons.share),
    //           onPressed: () {},
    //         ),
    //       ],
    //     ),
    //     path: pathPDF);
    return PDFViewerScaffold(
        appBar: AppBar(
          backgroundColor: logolightGreen,
          title: Text(AppLocalizations.of(context).translate(title) ?? title),
        ),
        path: pathPDF);
  }
}
