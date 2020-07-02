import 'package:chokchey_finance/components/cardListApproval.dart';
import 'package:chokchey_finance/modals/approvalList.dart';
import 'package:chokchey_finance/services/approvalList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Approval_widget extends StatefulWidget {
  @override
  _Approval_widgetState createState() => _Approval_widgetState();
}

class _Approval_widgetState extends State<Approval_widget> {
  _Approval_widgetState();

  var futureApprovalList;
  // var _isInit = true;
  var _isLoading;

  // @override
  // void didChangeDependencies() {
  //   if (_isLoading == false || _isInit) {
  //     futureApprovalList = Provider.of<ApprovelistProvider>(context)
  //         .fetchApprovals(http.Client());
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     futureApprovalList = Provider.of<ApprovelistProvider>(context)
  //         .fetchApprovals(http.Client());
  //   });
  // }

  Widget build(BuildContext context) {
    final appState = Provider.of<ApprovelistProvider>(context);
    _isLoading = appState.isFetching;
    futureApprovalList =
        Provider.of<ApprovelistProvider>(context).fetchApprovals(http.Client());
    return FutureBuilder<List<Approval>>(
      future: futureApprovalList,
      builder: (context, snapshot) {
        return _isLoading
            ? Center(child: CircularProgressIndicator())
            : ApprovalListCard(approvalList: snapshot.data);
      },
    );
  }
}
