import 'package:chokchey_finance/components/button.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/approvalList.dart';
import 'package:chokchey_finance/providers/detailList.dart';
import 'package:chokchey_finance/providers/detialJson.dart';
import 'package:chokchey_finance/providers/registerApproval.dart';
import 'package:chokchey_finance/providers/reject.dart';
import 'package:chokchey_finance/providers/returnFuc.dart';
import 'package:chokchey_finance/screens/approval/approvalList.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/screens/detail/cardDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'comment.dart';
import 'approve.dart';

class TabBarMenu extends StatefulWidget {
  TabBarMenu(
    this.loanApprovalApplicationNo,
  );
  final loanApprovalApplicationNo;

  @override
  _TabBarMenuState createState() => _TabBarMenuState(
        loanApprovalApplicationNo,
      );
}

class _TabBarMenuState extends State<TabBarMenu> {
  final loanApprovalApplicationNo;

  _TabBarMenuState(
    this.loanApprovalApplicationNo,
  );

  var _isInit = false;
  var _isLoading = false;
  var response = [];
  var list;

  @override
  void didChangeDependencies() {
    setState(() {
      _isInit = true;
    });
    if (_isInit) {
      list = fetchListDetail(loanApprovalApplicationNo);
    }
    super.didChangeDependencies();
  }

  double _widtdButton = 100.0;
  double _heightButton = 33.0;
  double _borderRadius = 12.0;

  authrize(context) {
    setState(() {
      _isLoading = true;
    });
    var comments = controller.text;
    registerApproval(http.Client(), loanApprovalApplicationNo, 20, comments);
    Provider.of<ApprovelistProvider>(context, listen: false).fetchApprovals();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ApprovalLists(
            isRefresh: true,
          ),
        ),
        ModalRoute.withName('/'));
  }

  returnFuc(context) async {
    var comments = controller.text;

    setState(() {
      _isLoading = true;
    });
    await Provider.of<ApprovelistProvider>(context).fetchApprovals();
    await returnFunction(http.Client(), loanApprovalApplicationNo, 80, comments)
        .then((_) => {});
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ApprovalLists(
            isRefresh: true,
          ),
        ),
        ModalRoute.withName('/'));
  }

  reject(context) async {
    var comments = controller.text;
    await Provider.of<ApprovelistProvider>(context).fetchApprovals();
    rejectFunction(http.Client(), loanApprovalApplicationNo, 90, comments);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ApprovalLists(
            isRefresh: true,
          ),
        ),
        ModalRoute.withName('/'));
  }

  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // var future = fetchListDetail(loanApprovalApplicationNo);
    var futureListApprove =
        fetchDetail(http.Client(), loanApprovalApplicationNo);

    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 16.0 : 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.translate('loan_information') ??
                'Loan Information'),
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
                    child: TabBar(indicatorColor: Colors.white, tabs: [
                      Tab(
                        text:
                            AppLocalizations.of(context)!.translate('detail') ??
                                "Detail",
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
                          text: AppLocalizations.of(context)!
                                  .translate('approved') ??
                              "Approved"),
                      Tab(
                          icon: Icon(
                            Icons.comment,
                            size: 20,
                          ),
                          iconMargin: EdgeInsets.all(0),
                          text: AppLocalizations.of(context)!
                                  .translate('comments') ??
                              "Comments"),
                    ]),
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(children: [
                        CardDetailWidget(list),
                        // Detail(loanApprovalApplicationNo, future),
                        Approve(
                          loanApprovalApplicationNo,
                          futureListApprove,
                        ),
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
                          text: AppLocalizations.of(context)!
                                  .translate('reject') ??
                              'Reject'),
                      Padding(padding: EdgeInsets.only(right: 5)),
                      Button(
                          widtdButton: _widtdButton,
                          heightButton: _heightButton,
                          borderRadius: _borderRadius,
                          onPressed: () {
                            returnFuc(context);
                          },
                          color: Colors.grey,
                          text: AppLocalizations.of(context)!
                                  .translate('return') ??
                              'Return'),
                      Padding(padding: EdgeInsets.only(right: 5)),
                      Button(
                          widtdButton: _widtdButton,
                          heightButton: _heightButton,
                          borderRadius: _borderRadius,
                          onPressed: () {
                            authrize(context);
                          },
                          color: logolightGreen,
                          text: AppLocalizations.of(context)!
                                  .translate('authrize') ??
                              'Authrize'),
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
