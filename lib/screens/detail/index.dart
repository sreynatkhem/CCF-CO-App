import 'package:chokchey_finance/components/button.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/screens/approval/approvalList.dart';
import 'package:chokchey_finance/services/approvalList.dart';
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
  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    if (_isInit) {
      Provider.of<ApprovelistProvider>(context)
          .fetchApprovals(http.Client())
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    setState(() {
      _isLoading = false;
    });
    _isInit = false;
    super.didChangeDependencies();
  }

  double _widtdButton = 100.0;
  double _heightButton = 33.0;
  double _borderRadius = 12.0;

  authrize(context) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ApprovelistProvider>(context, listen: false)
        .fetchApprovals(http.Client());

    registerApproval(http.Client(), loanApprovalApplicationNo, 20);
    Navigator.pop(context);
  }

  returnFuc(context) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<ApprovelistProvider>(context)
        .fetchApprovals(http.Client());
    await returnFunction(http.Client(), loanApprovalApplicationNo, 80)
        .then((_) => {});
    Navigator.pop(context);
  }

  reject(context) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<ApprovelistProvider>(context)
        .fetchApprovals(http.Client());
    rejectFunction(http.Client(), loanApprovalApplicationNo, 90);
    await Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 16.0 : 0.0;
    return ChangeNotifierProvider(
      create: (cxt) => ApprovelistProvider(),
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
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
                                Detail(loanApprovalApplicationNo),
                                Approve(loanApprovalApplicationNo),
                                Comments()
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
              )),
    );
  }
}
