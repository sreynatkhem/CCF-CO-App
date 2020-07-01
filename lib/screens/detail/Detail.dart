import 'package:chokchey_finance/modals/listApproval.dart';
import 'package:chokchey_finance/services/detailList.dart';
import 'package:chokchey_finance/widget/list_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  final loanApprovalApplicationNo;
  Detail(this.loanApprovalApplicationNo);
  @override
  _DetailState createState() => _DetailState(loanApprovalApplicationNo);
}

class _DetailState extends State<Detail> {
  final loanApprovalApplicationNo;
  _DetailState(this.loanApprovalApplicationNo);

  @override
  void didChangeDependencies() {
    getDetail();
    super.didChangeDependencies();
  }

  Future<void> getDetail() async {
    await fetchListDetail(http.Client(), loanApprovalApplicationNo);
  }

  @override
  Widget build(BuildContext context) {
    var _futureAlbum =
        fetchListDetail(http.Client(), loanApprovalApplicationNo);
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10),
        child: FutureBuilder<List<ListApproval>>(
          future: fetchListDetail(http.Client(), loanApprovalApplicationNo),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListDetail(approvalListDetail: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
