import 'package:chokchey_finance/components/cardListApproval.dart';
import 'package:chokchey_finance/modals/approvalList.dart';
import 'package:chokchey_finance/services/approvalList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Approval_widget extends StatelessWidget {
  @override
  getApprovalList(context) {
    final getApprovalList =
        Provider.of<ApprovelistProvider>(context, listen: false);
    return getApprovalList.fetchApprovals(http.Client());
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<Approval>>(
      future: getApprovalList(context),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? ApprovalListCard(approvalList: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
