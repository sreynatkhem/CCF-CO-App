import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class GroupLoanDetail extends StatefulWidget {
  var groupName;
  var leaderGroupLoan;
  var memberGroupLoan;

  GroupLoanDetail({this.groupName, this.leaderGroupLoan, this.memberGroupLoan});
  @override
  _GroupLoanDetailState createState() => _GroupLoanDetailState(
      groupNameParam: this.groupName,
      leaderGroupLoanParam: this.leaderGroupLoan,
      memberGroupLoanParm: this.memberGroupLoan);
}

class _GroupLoanDetailState extends State<GroupLoanDetail> {
  //
  var groupNameParam;
  var leaderGroupLoanParam;
  var memberGroupLoanParm;
  _GroupLoanDetailState(
      {this.groupNameParam,
      this.leaderGroupLoanParam,
      this.memberGroupLoanParm});

  @override
  Widget build(BuildContext context) {
    return Header(
        headerTexts:
            AppLocalizations.of(context).translate('detail_group_loan') ??
                'Detail a group loan',
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bodys: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Card(
                    child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Icon(Icons.group_add),
                            Padding(padding: EdgeInsets.only(right: 10)),
                            Text(
                              AppLocalizations.of(context)
                                          .translate('group_name') +
                                      ":" ??
                                  "Group name:",
                              style: TextStyle(
                                fontSize: fontSizeXs,
                              ),
                            ),
                            Text(
                              " ${groupNameParam}",
                              style: TextStyle(
                                  fontSize: fontSizeXs,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ))),
              ),
              Expanded(
                flex: 0,
                child: Card(
                    child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.only(top: 0),
                                child: Icon(Icons.group)),
                            Padding(padding: EdgeInsets.only(right: 10)),
                            Container(
                              padding: EdgeInsets.only(top: 3),
                              child: Text(
                                AppLocalizations.of(context)
                                        .translate('leader') ??
                                    "Leader:",
                                style: TextStyle(
                                  fontSize: fontSizeXs,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              width: isIphoneX(context) ? 240 : 230,
                              child: Text(
                                " ${leaderGroupLoanParam}",
                                style: TextStyle(
                                    fontSize: fontSizeXs,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ))),
              ),
              Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: memberGroupLoanParm.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Container(
                                width: MediaQuery.of(context).size.width * 1,
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(top: 2),
                                        child: Icon(
                                          Icons.credit_card,
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(right: 10)),
                                    Container(
                                        // alignment: Alignment.topCenter,
                                        width: isIphoneX(context) ? 290 : 280,
                                        child: Text(
                                          "${memberGroupLoanParm[index]}",
                                          style: TextStyle(
                                              fontSize: fontSizeXs,
                                              fontWeight: FontWeight.w700),
                                        )),
                                  ],
                                )));
                      })),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        color: logolightGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Padding(padding: EdgeInsets.all(3)),
                              Text(
                                AppLocalizations.of(context)
                                        .translate('submit') ??
                                    "Submit",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          // if (memberGroupLoan.length == 0 ||
                          //     memberGroupLoan.length > 5 &&
                          //         leaderGroupLoan == "" &&
                          //         leaderGroupLoan == null) {
                          //   showInSnackBar(
                          //       AppLocalizations.of(context).translate(
                          //           'limit_select_a_group_loan_only'),
                          //       Colors.red);
                          // } else {
                          //   Navigator.of(context)
                          //       .push(new MaterialPageRoute<Null>(
                          //           builder: (BuildContext context) {
                          //             return new GroupLoanDetail(
                          //               groupName: groupNameParam,
                          //               leaderGroupLoan: leaderGroupLoan,
                          //               memberGroupLoan: memberGroupLoan,
                          //             );
                          //           },
                          //           fullscreenDialog: true));
                          // }
                        },
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              Padding(padding: EdgeInsets.all(3)),
                              Text(
                                AppLocalizations.of(context)
                                        .translate('cancel') ??
                                    "Cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                flex: 0,
              )
            ],
          ),
        ));
  }
}
