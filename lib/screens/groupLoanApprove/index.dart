import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/providers/groupLoan/index.dart';
import 'package:chokchey_finance/screens/groupLoanApprove/tabGroupLoanApprove.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupLoanApprove extends StatefulWidget {
  var isRefresh = false;
  GroupLoanApprove({this.isRefresh});
  @override
  _GroupLoanApproveState createState() =>
      _GroupLoanApproveState(isRefresh: this.isRefresh);
}

class _GroupLoanApproveState extends State<GroupLoanApprove> {
  var isRefresh = false;
  _GroupLoanApproveState({this.isRefresh});
  bool _isLoading = false;
  dynamic listGroupLoanApprove;
  static List<String> items;
  List<dynamic> newDataList;

  getListLoan(_pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<GroupLoanProvider>(context)
        .fetchGroupLoanAll(
            _pageSize, _pageNumber, status, code, bcode, sdate, edate)
        .then((value) {
      setState(() {
        _isLoading = false;
        newDataList = value;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (mounted) {
      getListLoan(20, 1, '', '', '', '', '');
    }
    super.didChangeDependencies();
  }

  void onLoading() async {
    await new Future.delayed(new Duration(seconds: 3), () {
      setState(() {
        isRefresh = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isRefresh == true) {
      onLoading();
    }
    return Provider<GroupLoanProvider>(
      create: (context) => GroupLoanProvider(),
      dispose: (context, value) => value.dispose(),
      child: Header(
        headerTexts: "group_loan_approve",
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              ModalRoute.withName("/Home")),
        ),
        bodys: Container(
          padding: EdgeInsets.all(10),
          child: isRefresh == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : newDataList != null && newDataList.length > 0
                      ? Column(children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: newDataList.length,
                                padding: const EdgeInsets.only(top: 20.0),
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Card(
                                        elevation: 5,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GroupLoanApproveDetail(
                                                        groupLoanID:
                                                            newDataList[index],
                                                      )),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('Group name: '),
                                                        Text(
                                                          '${newDataList[index]['gname']}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  fontWeight700),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.all(2)),
                                                    Text(
                                                        'Create by: ${newDataList[index]['user']['uname']}'),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.all(2)),
                                                    Text(
                                                        '${getDateTimeYMD(newDataList[index]['datecreate'])}'),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${newDataList[index]['status'] == "R" ? "Request" : ""}',
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: logolightGreen,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  );
                                }),
                            flex: 1,
                          ),
                        ])
                      : Center(child: Text('No Group Loan')),
        ),
      ),
    );
  }
}
