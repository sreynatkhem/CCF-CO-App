import 'package:chokchey_finance/components/cardListApproval.dart';
import 'package:chokchey_finance/modals/approvalList.dart';
import 'package:chokchey_finance/providers/approvalList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Approval_widget extends StatefulWidget {
  @override
  _Approval_widgetState createState() => _Approval_widgetState();
}

class _Approval_widgetState extends State<Approval_widget> {
  _Approval_widgetState();

  var futureApprovalList;
  var _isLoading;

  Widget build(BuildContext context) {
    final appState = Provider.of<ApprovelistProvider>(context);
    _isLoading = appState.isFetching;
    futureApprovalList =
        Provider.of<ApprovelistProvider>(context).fetchApprovals();
    return FutureBuilder<List<Approval>>(
      future: futureApprovalList,
      builder: (context, snapshot) {
        return ApprovalListCard(approvalList: snapshot.data);
      },
    );
  }
}
