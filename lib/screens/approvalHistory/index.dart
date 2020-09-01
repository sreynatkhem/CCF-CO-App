import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/approvalHistory/index.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class ApprovalHistory extends StatefulWidget {
  @override
  _ApprovalHistoryState createState() => _ApprovalHistoryState();
}

class _ApprovalHistoryState extends State<ApprovalHistory> {
  int _pageSize = 20;
  int _pageNumber = 1;
  var status = '';
  var code = '';
  var sdate = '';
  var edate = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getReportSummary();
  }

  Future getReportSummary() async {
    await ApprovalHistoryProvider()
        .getApprovalHistorySummary(
            _pageSize, _pageNumber, status, code, sdate, edate)
        .then((value) => {logger().e('value:: ${value}')})
        .catchError((onError) {
      logger().e('onError:: ${onError}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      headerTexts: AppLocalizations.of(context).translate('approval_history') ??
          'Approval History',
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            ModalRoute.withName("/Home")),
      ),
      bodys: Center(
          child: Container(
        child: Text('hello'),
      )),
    );
  }
}
