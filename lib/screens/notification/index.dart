import 'dart:async';
import 'dart:convert';

import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/components/maxWidthWrapper.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/providers/notification/index.dart';
import 'package:chokchey_finance/screens/approval/approvalList.dart';
import 'package:chokchey_finance/screens/groupLoanApprove/index.dart';
import 'package:chokchey_finance/screens/listLoanApproval/tebBarDetail.dart';
import 'package:chokchey_finance/screens/loanArrear/detail.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;

import 'messageFromCEO.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationScreen> {
  var totalMessage;
  var totalUnread;
  var totalRead;
  var listMessages;
  final storage = new FlutterSecureStorage();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getNotificationLock(20, 1);
  }

  var _isLoading = false;
  Future getNotificationLock(_pageSizeParam, _pageNumberParam) async {
    setState(() {
      _isLoading = true;
    });
    final storage = new FlutterSecureStorage();

    var token = await storage.read(key: 'user_token');
    var userUcode = await storage.read(key: "user_ucode");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    final Map<String, dynamic> bodyRow = {
      "pageSize": "$_pageSizeParam",
      "pageNumber": "$_pageNumberParam",
      "ucode": "$userUcode"
    };
    try {
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'messages/byuser'),
          headers: headers,
          body: json.encode(bodyRow));
      var parsed = jsonDecode(response.body);
      setState(() {
        _isLoading = false;
      });
      for (var item in parsed) {
        setState(() {
          totalMessage = item['totalMessage'];
          totalUnread = item['totalUnread'];
          totalRead = item['totalRead'];
          listMessages = item['listMessages'];
        });
      }
      return parsed;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDialog(value) {
    slideDialog.showSlideDialog(
      context: context,
      child: Container(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 1,
                child: Image.network(
                  value['annpath'],
                  width: MediaQuery.of(context).size.width * 1,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: Text(
                    value['anntitle'],
                    style: mainTitleBlack,
                  )),
              Container(
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: Text(
                    value['anndes'],
                  )),
            ],
          ),
        ],
      )),
      barrierColor: Colors.white.withOpacity(0.7),
      pillColor: logolightGreen,
      backgroundColor: Colors.white,
    );
  }

  Future onTapsAnnouncement(values) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AnnouncementDetail(
                list: values,
              )),
    );
    // setState(() {
    //   _isLoading = true;
    // });
    // await NotificationProvider()
    //     .fetchNotificationAnnouncement(values['lcode'])
    //     .then((value) => {
    //           setState(() {
    //             _isLoading = false;
    //           }),
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => AnnouncementDetail(
    //                       list: values,
    //                     )),
    //           )
    //         })
    //     .catchError((onError) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }

  var isFetchingSuccessfully;

  Future onTapsDetail(values) async {
    setState(() {
      _isLoading = true;
    });
    await NotificationProvider()
        .postNotificationRead(values['id'])
        .then((value) => {
              setState(() {
                _isLoading = false;
              }),
              if (value['key'] == '200')
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CardDetailLoan(values)),
                  )
                }
              else
                {
                  showInSnackBar(
                      AppLocalizations.of(context)!.translate('failed') ??
                          'Failed',
                      Colors.redAccent)
                }
            });

    setState(() {
      _isLoading = false;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value, colorsBackground) {
    SnackBar snackBar = SnackBar(
      content: Text(value),
      backgroundColor: colorsBackground,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ScrollController _scrollController = ScrollController();
  StreamController _streamController = StreamController();
  StreamSink get itemsSink => _streamController.sink;
  bool onNotification(ScrollNotification notification) {
    // if (notification is ScrollUpdateNotification) {
    //   if (_scrollController.position.maxScrollExtent >=
    //           _scrollController.offset &&
    //       _scrollController.position.maxScrollExtent -
    //               _scrollController.offset <=
    //           1) {
    //     _additems();
    //   }
    // }
    return true;
  }

  bool isLoading = false;
  int _pageSize = 20;
  int _pageNumber = 1;

  Future _additems() async {
    setState(() {
      isLoading = true;
    });
    try {
      _pageSize += 10;
      // Fetch newItems with http
      // futureListLoanRegistraiton =
      //     Provider.of<LoanInternal>(context, listen: false)
      //         .getListLoan(_pageSize, _pageNumber);
      getNotificationLock(_pageSize, _pageNumber);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      itemsSink.addError(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future loadMore(_pageSize, _pageNumber) async {
    final storage = new FlutterSecureStorage();

    var token = await storage.read(key: 'user_token');
    var userUcode = await storage.read(key: "user_ucode");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    var bodyRow =
        "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$userUcode\",\n}";
    try {
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'messages/byuser'),
          headers: headers,
          body: bodyRow);
      var parsed = jsonDecode(response.body);
      for (var item in parsed) {
        setState(() {
          totalMessage = item['totalMessage'];
          totalUnread = item['totalUnread'];
          totalRead = item['totalRead'];
          listMessages = item['listMessages'];
        });
      }
    } catch (error) {
      logger().e('error: $error');
    }
  }

  Future<void> _getData() async {
    setState(() {
      _isLoading = true;
    });
    getNotificationLock(_pageSize, _pageNumber)
        .then((value) => {
              setState(() {
                _isLoading = false;
              })
            })
        .catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  navigatorGroupLoan(values) async {
    await NotificationProvider()
        .postNotificationRead(values['id'])
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => GroupLoanApprove(
            isRefresh: true,
          ),
        ),
      );
    }).catchError((onError) {
      logger().e('onError: $onError');
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          // start loading data
          setState(() {
            _pageSize += 10;
          });
          loadMore(_pageSize, _pageNumber);
        }
        return false;
      },
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Header(
              keys: _scaffoldKeys,
              headerTexts: 'notification',
              bodys: _isLoading
                  ? Center(
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _getData,
                      child: MaxWidthWrapper(
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: ListView.builder(
                                controller: _scrollController,
                                itemCount: listMessages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // var status = statusApproval(parsed[index]['rstatus']);
                                  logger().e(listMessages[index]['rcode']);
                                  if (listMessages.length >= 0) {
                                    return Container(
                                      height: 100,
                                      margin: EdgeInsets.only(bottom: 5.0),
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
                                              onTap: () {
                                                // var value = listMessages[index];
                                                var rcodeGroup;
                                                var subString;
                                                var groupLoanCode;
                                                if (listMessages[index]
                                                        ['rcode'] !=
                                                    "") {
                                                  subString =
                                                      listMessages[index]
                                                          ['rcode'];
                                                  rcodeGroup =
                                                      subString.substring(0, 1);
                                                  groupLoanCode = '6';
                                                }

                                                // if()
                                                if (listMessages[index]
                                                        ['title'] ==
                                                    "Apsara System") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ApprovalLists(),
                                                    ),
                                                  );
                                                } else if (groupLoanCode ==
                                                    rcodeGroup) {
                                                  navigatorGroupLoan(
                                                      listMessages[index]);
                                                } else if (listMessages[index]
                                                        ['data'] ==
                                                    "announcement") {
                                                  onTapsAnnouncement(
                                                      listMessages[index]);
                                                } else if (listMessages[index]
                                                        ['title'] ==
                                                    'Loan Arrears') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          DetailLoanArrear(
                                                              loanAccountNo:
                                                                  listMessages[
                                                                          index]
                                                                      [
                                                                      'lcode']),
                                                    ),
                                                  );
                                                } else {
                                                  onTapsDetail(
                                                      listMessages[index]);
                                                }
                                              },
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding: EdgeInsets.all(
                                                            8.0)),
                                                    // Image(
                                                    //   image: _imagesFindApproval,
                                                    //   width: 50,
                                                    //   height: 50,
                                                    // ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                              listMessages[
                                                                      index]
                                                                  ['title'],
                                                              style:
                                                                  mainTitleBlack),
                                                          Text(
                                                              '${listMessages[index]['body']}'),
                                                          // Padding(
                                                          //     padding:
                                                          //         EdgeInsets.only(bottom: 2)),
                                                          // Padding(
                                                          //     padding:
                                                          //         EdgeInsets.only(bottom: 2)),
                                                          // Text(
                                                          //     '${getDateTimeYMD(parsed[index]['loan']['odate'])}'),
                                                          // Padding(
                                                          //     padding:
                                                          //         EdgeInsets.only(bottom: 2)),
                                                          // Text(
                                                          //     '${parsed[index]['loan']['currency']} ${parsed[index]['loan']['lamt']}'),
                                                          // Padding(
                                                          //     padding:
                                                          //         EdgeInsets.only(bottom: 2)),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          // status,
                                                          Text(
                                                            '${listMessages[index]['date']}',
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                          if (listMessages[
                                                                      index]
                                                                  ['mstatus'] ==
                                                              1)
                                                            Icon(
                                                              Icons.done_all,
                                                              size: 15,
                                                            ),
                                                          // if (listMessages[index]['rdate'] != '')
                                                          //   Text(getDateTimeYMD(
                                                          //       listMessages[index]['rdate'])),
                                                        ],
                                                      ),
                                                    ),
                                                  ]))),
                                    );
                                  } else {
                                    return Center(
                                      child: Text('No notification'),
                                    );
                                  }
                                })),
                      ),
                    ),
            ),
    );
  }
}
