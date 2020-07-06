import 'dart:convert';

import 'package:chokchey_finance/modals/listApproval.dart';
import 'package:chokchey_finance/services/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import '../dummy/list_detail.js' as list_detail;
import '../dummy/header_detail.js' as header_detail;

class ListDetail extends StatefulWidget {
  final List<ListApproval> approvalListDetail;
  ListDetail({Key key, this.approvalListDetail}) : super(key: key);
  @override
  _ListDetailState createState() => _ListDetailState(this.approvalListDetail);
}

class _ListDetailState extends State<ListDetail> {
  final List<ListApproval> approvalListDetail;

  _ListDetailState(this.approvalListDetail);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getValue();
    super.didChangeDependencies();
  }

  final data = [];
  var isLoading = false;

  Future<void> getValue() async {
    setState(() {
      isLoading = true;
    });
    try {
      final bodyRowbodyRowDetail =
          "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"loanApprovalApplicationNo\": \"0120202002050238\"\n    }\n}\n";
      final response =
          await post().post(baseUrl + 'LRA0003', body: bodyRowbodyRowDetail);
      final parsed = jsonDecode(response.body);
      final list = parsed['body']['loanApplicationDetailInfo'];
      setState(() {
        isLoading = false;
        data.add(list);
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('error: $error');
    }
    // return data.add(list);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: approvalListDetail.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            for (var i in header_detail.header_detail)
                              Container(
                                width: 240,
                                child: Text(
                                  i.toString() + ':',
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(height: 2, fontSize: 15),
                                ),
                              ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            for (var i in list_detail.list_detail)
                              Container(
                                width: 150,
                                child: Text(
                                  data[0][i.toString() ?? ''].toString(),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                      height: 2,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
