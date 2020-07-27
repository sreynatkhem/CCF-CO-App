// import 'dart:html';

import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/screens/detail/index.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class ApprovalListCard extends StatelessWidget {
  final List<Approval> approvalList;

  final images = const AssetImage('assets/images/request.png');
  ApprovalListCard({Key key, this.approvalList}) : super(key: key);

  onClickCard(value, context) {
    final loanApprovalApplicationNo = value.loanApprovalApplicationNo;
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new TabBarMenu(loanApprovalApplicationNo);
        },
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    if (approvalList == null ||
        approvalList.length == 0 ||
        approvalList.length <= 0) {
      return Center(
        child: Text(
          'No approval list',
          style: mainTitleBlack,
        ),
      );
    } else {
      return ListView.builder(
          itemCount: approvalList.length,
          padding: const EdgeInsets.only(top: 20.0),
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              margin: EdgeInsets.only(bottom: 5.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: logolightGreen, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        onClickCard(approvalList[index], context);
                      },
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Image(
                              image: images,
                              width: 80,
                              height: 70,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    child: Text(
                                  approvalList[index].standardCodeDomainName2,
                                  style: mainTitleBlack,
                                )),
                                Padding(padding: EdgeInsets.only(bottom: 2)),
                                Text(
                                  'Application No: ${approvalList[index].loanApprovalApplicationNo}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 2)),
                                Text(
                                  '${approvalList[index].authorizationRequestEmpNo}-${approvalList[index].authorizationRequestEmpName}[${approvalList[index].branchName}]',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 2)),
                                Text(
                                  '${approvalList[index].authorizationRequestDate} ${approvalList[index].authorizationRequestTime}',
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 40),
                                child: Icon(Icons.keyboard_arrow_right)),
                          ]))),
            );
          });
    }
  }
}
