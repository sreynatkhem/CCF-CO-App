import 'package:chokchey_finance/components/button.dart';
import 'package:chokchey_finance/services/approvalList.dart';
import 'package:chokchey_finance/services/detailList.dart';
import 'package:chokchey_finance/services/detialJson.dart';
import 'package:chokchey_finance/services/registerApproval.dart';
import 'package:chokchey_finance/services/reject.dart';
import 'package:chokchey_finance/services/returnFuc.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'Detail.dart';
import 'comment.dart';
import 'approve.dart';

class TabBarMenu extends StatefulWidget {
  TabBarMenu(this.loanApprovalApplicationNo);
  final loanApprovalApplicationNo;

  @override
  _TabBarMenuState createState() => _TabBarMenuState(loanApprovalApplicationNo);
}

class _TabBarMenuState extends State<TabBarMenu> {
  final loanApprovalApplicationNo;
  _TabBarMenuState(this.loanApprovalApplicationNo);

  var _isInit = true;
  var _isLoading = false;
  var response = [];

  double _widtdButton = 100.0;
  double _heightButton = 33.0;
  double _borderRadius = 12.0;

  authrize(context) {
    setState(() {
      _isLoading = true;
    });
    var comments = controller.text;
    registerApproval(http.Client(), loanApprovalApplicationNo, 20, comments);
    Provider.of<ApprovelistProvider>(context, listen: false)
        .fetchApprovals(http.Client());
    Navigator.pop(context);
  }

  returnFuc(context) async {
    var comments = controller.text;

    setState(() {
      _isLoading = true;
    });
    await Provider.of<ApprovelistProvider>(context)
        .fetchApprovals(http.Client());
    await returnFunction(http.Client(), loanApprovalApplicationNo, 80, comments)
        .then((_) => {});
    Navigator.pop(context);
  }

  reject(context) async {
    var comments = controller.text;
    await Provider.of<ApprovelistProvider>(context)
        .fetchApprovals(http.Client());
    rejectFunction(http.Client(), loanApprovalApplicationNo, 90, comments);
    await Navigator.pop(context);
  }

  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var future = fetchListDetail(http.Client(), loanApprovalApplicationNo);
    var futureListApprove =
        fetchDetail(http.Client(), loanApprovalApplicationNo);

    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 16.0 : 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        backgroundColor: logolightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: <Widget>[
                  Container(
                    color: logolightGreen,
                    constraints: BoxConstraints.expand(height: 50),
                    child: TabBar(tabs: [
                      Tab(
                        text: "Detail",
                        icon: Icon(
                          Icons.details,
                          size: 20,
                        ),
                        iconMargin: EdgeInsets.all(0),
                      ),
                      Tab(
                          icon: Icon(
                            Icons.book,
                            size: 20,
                          ),
                          iconMargin: EdgeInsets.all(0),
                          text: "Approved"),
                      Tab(
                          icon: Icon(
                            Icons.comment,
                            size: 20,
                          ),
                          iconMargin: EdgeInsets.all(0),
                          text: "Comments"),
                    ]),
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(children: [
                        Detail(loanApprovalApplicationNo, future),
                        Approve(loanApprovalApplicationNo, futureListApprove),
                        Comments(controller)
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            heightFactor: 1,
            alignment: FractionalOffset.bottomCenter,
            child: MaterialButton(
                onPressed: () => {},
                child: Container(
                  padding: EdgeInsets.only(top: 0),
                  margin: EdgeInsets.all(0),
                  child: Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Button(
                          widtdButton: _widtdButton,
                          heightButton: _heightButton,
                          borderRadius: _borderRadius,
                          onPressed: () {
                            reject(context);
                          },
                          color: Colors.red,
                          text: 'Reject'),
                      Padding(padding: EdgeInsets.only(right: 5)),
                      Button(
                          widtdButton: _widtdButton,
                          heightButton: _heightButton,
                          borderRadius: _borderRadius,
                          onPressed: () {
                            returnFuc(context);
                          },
                          color: Colors.green,
                          text: 'Return'),
                      Padding(padding: EdgeInsets.only(right: 5)),
                      Button(
                          widtdButton: _widtdButton,
                          heightButton: _heightButton,
                          borderRadius: _borderRadius,
                          onPressed: () {
                            authrize(context);
                          },
                          color: logolightGreen,
                          text: 'Authrize'),
                    ],
                  )),
                )),
          ),
          Padding(padding: EdgeInsets.only(bottom: bottomPadding))
        ],
      ),
    );
  }
}
