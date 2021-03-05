import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/screens/groupLoanApprove/widgetDetail.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class ApproverScreen extends StatelessWidget {
  var list;
  ApproverScreen({this.list});

  //
  final _imagesFindApproval =
      const AssetImage('assets/images/findApproval.png');
  final _imagesList = const AssetImage('assets/images/list.png');

  //status approve
  statusApproval(value, context) {
    switch (value) {
      case 'R':
        {
          return Text(
              AppLocalizations.of(context).translate('request') ?? 'Request',
              style: mainTitleBlack);
        }
        break;

      case 'A':
        {
          return Text(
              AppLocalizations.of(context).translate('approved') ?? 'Approved',
              style: mainTitleBlack);
        }
        break;

      case 'D':
        {
          return Text(
              AppLocalizations.of(context).translate('disapprove') ??
                  'Disapprove',
              style: mainTitleBlack);
        }
        break;

      case 'T':
        {
          return Text(
              AppLocalizations.of(context).translate('return') ?? 'Return',
              style: mainTitleBlack);
        }
        break;
      default:
        {
          return Text('', style: mainTitleBlack);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var status = statusApproval(list['rstatus'], context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            margin: EdgeInsets.all(5),
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: logolightGreen, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {},
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 5)),
                              Image(
                                image: _imagesFindApproval,
                                width: 50,
                                height: 50,
                              ),
                              Padding(padding: EdgeInsets.only(right: 15)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      child: Text(
                                    '${list['gname']}',
                                    style: mainTitleBlack,
                                  )),
                                  Text('${getDateTimeYMD(list['datecreate'])}'),
                                  Padding(padding: EdgeInsets.only(bottom: 2)),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(bottom: 2)),
                              status,
                              Padding(
                                  padding: EdgeInsets.only(
                                top: 5,
                              )),
                              if (list['datecreate'] != '')
                                Text(getDateTimeYMD(list['datecreate'])),
                              Text(''),
                              Padding(
                                  padding: EdgeInsets.only(
                                right: 100,
                              ))
                            ],
                          ),
                        ]))),
          ),
          Expanded(
              flex: 3,
              child: list['groupLoanDetail'][0]['loanRequest']
                          ['loanApplications'] ==
                      null
                  ? Text("")
                  : ListView.builder(
                      itemCount: list['groupLoanDetail'][0]['loanRequest']
                              ['loanApplications']
                          .length,
                      itemBuilder: (context, index) {
                        var itemCount = list['groupLoanDetail'][0]
                            ['loanRequest']['loanApplications'];
                        return Container(
                          height: 80,
                          margin: EdgeInsets.only(
                            left: 2,
                            right: 2,
                            bottom: 5,
                          ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: logolightGreen, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {},
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5)),
                                            Image(
                                              image: _imagesList,
                                              width: 50,
                                              height: 50,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(right: 15)),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    child: Text(
                                                  "${itemCount[index]['userName']}",
                                                  style: mainTitleBlack,
                                                )),
                                                // Text(
                                                //     '${getListDetail[index]['branchName']}'),
                                                // Padding(
                                                //     padding: EdgeInsets
                                                //         .only(
                                                //             bottom:
                                                //                 2)),
                                                // Text(
                                                //     '${list['loan']['currency']} ${getListDetail[index]['lamt']}'),
                                                // Padding(
                                                //     padding: EdgeInsets
                                                //         .only(
                                                //             bottom:
                                                //                 2)),
                                                // Text(
                                                //     '${getDateTimeYMD(getListDetail[index]['adate'])}'),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 2)),
                                                if (itemCount[index]['cmt'] !=
                                                    '')
                                                  Container(
                                                    width: 210,
                                                    child: Text(
                                                      itemCount[index]['cmt'],
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 2)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 2)),
                                            statusApproval(
                                                itemCount[index]['lstatus'],
                                                context),
                                            Padding(
                                                padding: EdgeInsets.only(
                                              top: 5,
                                            )),
                                            Text(getDateTimeYMD(
                                                itemCount[index]['adate'])),
                                            Text(''),
                                            Padding(
                                                padding: EdgeInsets.only(
                                              right: 100,
                                            ))
                                          ],
                                        ),
                                      ]))),
                        );
                      })),
        ],
      ),
    );
  }
}
