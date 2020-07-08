import 'package:chokchey_finance/modals/listApproval.dart';
import 'package:chokchey_finance/widget/list_detail_widget.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  final loanApprovalApplicationNo;
  final future;

  Detail(this.loanApprovalApplicationNo, this.future);
  @override
  _DetailState createState() => _DetailState(loanApprovalApplicationNo, future);
}

class _DetailState extends State<Detail> {
  final loanApprovalApplicationNo;
  final future;
  _DetailState(this.loanApprovalApplicationNo, this.future);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10),
        child: FutureBuilder<List<ListApproval>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListDetail(
                    approvalListDetail: snapshot.data,
                    loanApprovalApplicationNo: loanApprovalApplicationNo)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
