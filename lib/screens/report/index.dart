import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/screens/approvalHistory/index.dart';
import 'package:chokchey_finance/screens/approvalSummary/index.dart';
import 'package:chokchey_finance/screens/disApprovalSummary/index.dart';
import 'package:chokchey_finance/screens/historyApsara/index.dart';
import 'package:chokchey_finance/screens/requestSummary/index.dart';
import 'package:chokchey_finance/screens/returnSummary/index.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Object> listReport = [
    "Report Approval",
    "Report Disapproval",
    "Report Request",
    "Report Return",
    "Report Summary",
    "Loan Approval History",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('report')!),
        backgroundColor: logolightGreen,
      ),
      body: GridView.count(
          primary: false,
          padding: const EdgeInsets.only(left: 45.0, right: 45.0, top: 20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: List.generate(listReport.length, (index) {
            if (listReport[index].toString() == 'Report Approval') {
              return MenuCardReport(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApprovalSummary()),
                ),
                color: logolightGreen,
                icons: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 50,
                ),
                imageNetwork: null,
                text: listReport[index],
              );
            }
            if (listReport[index].toString() == 'Report Disapproval') {
              return MenuCardReport(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisApprovalSummary()),
                ),
                color: logolightGreen,
                icons: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 50,
                ),
                imageNetwork: null,
                text: listReport[index],
              );
            }
            if (listReport[index].toString() == 'Report Request') {
              return MenuCardReport(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestSummary()),
                ),
                color: logolightGreen,
                icons: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 50,
                ),
                imageNetwork: null,
                text: listReport[index],
              );
            }
            if (listReport[index].toString() == 'Report Return') {
              return MenuCardReport(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReturnSummary()),
                ),
                color: logolightGreen,
                icons: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 50,
                ),
                imageNetwork: null,
                text: listReport[index],
              );
            }
            if (listReport[index].toString() == 'Report Summary') {
              return MenuCardReport(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApprovalHistory()),
                ),
                color: logolightGreen,
                icons: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 50,
                ),
                imageNetwork: null,
                text: listReport[index],
              );
            } else {
              return MenuCardReport(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryApsara()),
                ),
                color: logolightGreen,
                icons: Icon(
                  Icons.checklist,
                  color: Colors.white,
                  size: 50,
                ),
                imageNetwork: null,
                text: listReport[index],
              );
            }
          })),
    );
  }
}

class MenuCardReport extends StatelessWidget {
  MenuCardReport({
    this.onTap,
    this.imageNetwork,
    this.text,
    this.color,
    this.text2,
    this.icons,
  });
  final dynamic onTap;
  final dynamic imageNetwork;
  final dynamic text;
  final dynamic color;
  final dynamic text2;
  final dynamic icons;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onTap,
      child: new Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        color: color,
        child: new Container(
          // padding: EdgeInsets.all(45),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // icons != null
              //     ? icons
              //     : Image(
              //         image: imageNetwork,
              //         width: 55,
              //         height: 55,
              //         // color: Colors.white,
              //       ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                alignment: Alignment.center,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSizeSm,
                    color: Colors.white,
                    fontWeight: fontWeight700,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  text2 ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSizeSm,
                    color: Colors.white,
                    fontWeight: fontWeight700,
                  ),
                ),
              ),
              // Container(
              //   height: 15.0,
              //   child: FittedBox(
              //     fit: BoxFit.contain,
              //     child: Text(
              //       text,
              //       maxLines: 2,
              //       style: TextStyle(
              //         fontSize: fontSizeXs,
              //         // color: Colors.white,
              //         fontWeight: fontWeight700,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
