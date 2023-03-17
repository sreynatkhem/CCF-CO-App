import 'dart:convert';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class ApprovalListCard extends StatefulWidget {
  final dynamic lists;

  ApprovalListCard(
    this.lists,
  );

  @override
  _ApprovalListCardState createState() => _ApprovalListCardState();
}

class _ApprovalListCardState extends State<ApprovalListCard> {
  final _imagesList = const AssetImage('assets/images/list.png');
  final _imagesFindApproval =
      const AssetImage('assets/images/findApproval.png');
  statusApproval(value) {
    switch (value) {
      case 'R':
        {
          return Text(
              AppLocalizations.of(context)!.translate('request') ?? 'Request',
              style: mainTitleBlack);
        }
        break;

      case 'A':
        {
          return Text(
              AppLocalizations.of(context)!.translate('approved') ?? 'Approved',
              style: mainTitleBlack);
        }
        break;

      case 'D':
        {
          return Text(
              AppLocalizations.of(context)!.translate('disapprove') ??
                  'Disapprove',
              style: mainTitleBlack);
        }
        break;

      case 'T':
        {
          return Text(
              AppLocalizations.of(context)!.translate('return') ?? 'Return',
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
  void didChangeDependencies() {
    if (mounted) {
      getDetail();
    }
    super.didChangeDependencies();
  }

  dynamic? status = Text('');
  var list;
  var getListDetail = [];
  var _isloading = false;
  getDetail() async {
    final storage = new FlutterSecureStorage();
    setState(() {
      _isloading = true;
    });
    try {
      var token = await storage.read(key: 'user_token');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final Response response = await api().get(
        Uri.parse(baseURLInternal +
            'loanRequests/Applications/' +
            widget.lists['rcode']),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var listData = jsonDecode(response.body);
        setState(() {
          getListDetail = listData['loanApplications'];
          list = listData;
          _isloading = false;
        });
        statusApproval(list['rstatus']);
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 80,
                  margin: EdgeInsets.all(10),
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
                                    Padding(
                                        padding: EdgeInsets.only(right: 15)),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            child: Text(
                                          '${list['user']}',
                                          style: mainTitleBlack,
                                        )),
                                        Text(
                                            '${getDateTimeYMD(list['rdate'])}'),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 2)),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 2)),
                                    status,
                                    Padding(
                                        padding: EdgeInsets.only(
                                      top: 5,
                                    )),
                                    if (list['rdate'] != '')
                                      Text(getDateTimeYMD(list['rdate'])),
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
                    child: _isloading
                        ? Center(
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : ListView.builder(
                            itemCount: getListDetail.length,
                            itemBuilder: (context, index) {
                              return _isloading
                                  ? Center(
                                      child: Container(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Container(
                                      height: 80,
                                      margin: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                      ),
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: logolightGreen,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                              splashColor:
                                                  Colors.blue.withAlpha(30),
                                              onTap: () {},
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5)),
                                                        Image(
                                                          image: _imagesList,
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 15)),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Container(
                                                                child: Text(
                                                              '${getListDetail[index]['userName']}',
                                                              style:
                                                                  mainTitleBlack,
                                                            )),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                            if (getListDetail[
                                                                        index]
                                                                    ['cmt'] !=
                                                                '')
                                                              Container(
                                                                width: 210,
                                                                child: Text(
                                                                  '${getListDetail[index]['cmt']}',
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            2)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 2)),
                                                        statusApproval(
                                                            getListDetail[index]
                                                                ['lstatus']),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                          top: 5,
                                                        )),
                                                        Text(getDateTimeYMD(
                                                            getListDetail[index]
                                                                ['adate'])),
                                                        Text(''),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
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
