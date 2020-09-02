import 'dart:async';
import 'dart:convert';

import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/providers/notification/index.dart';
import 'package:chokchey_finance/screens/listLoanApproval/tebBarDetail.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

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
  Future getNotificationLock(_pageSize, _pageNumber) async {
    setState(() {
      _isLoading = true;
    });
    final storage = new FlutterSecureStorage();

    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    var bodyRow =
        "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$user_ucode\",\n}";
    try {
      final response = await api().post(baseURLInternal + 'messages/byuser',
          headers: headers, body: bodyRow);
      var parsed = jsonDecode(response.body);
      setState(() {
        _isLoading = false;
      });
      setState(() {
        totalMessage = parsed[0]['totalMessage'];
        totalUnread = parsed[0]['totalUnread'];
        totalRead = parsed[0]['totalRead'];
        listMessages = parsed[0]['listMessages'];
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
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
                      AppLocalizations.of(context).translate('failed') ??
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
    _scaffoldKeys.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: colorsBackground,
    ));
  }

  ScrollController _scrollController = ScrollController();
  StreamController _streamController = StreamController();
  StreamSink get itemsSink => _streamController.sink;
  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (_scrollController.position.maxScrollExtent >=
              _scrollController.offset &&
          _scrollController.position.maxScrollExtent -
                  _scrollController.offset <=
              1) {
        _additems();
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotification,
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
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                          itemCount: listMessages.length,
                          itemBuilder: (BuildContext context, int index) {
                            // var status = statusApproval(parsed[index]['rstatus']);
                            if (listMessages.length >= 0) {
                              return Container(
                                height: 100,
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: logolightGreen, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                        splashColor: Colors.blue.withAlpha(30),
                                        onTap: () {
                                          // var value = listMessages[index];
                                          onTapsDetail(listMessages[index]);
                                        },
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5)),
                                                  // Image(
                                                  //   image: _imagesFindApproval,
                                                  //   width: 50,
                                                  //   height: 50,
                                                  // ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
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
                                                        listMessages[index]
                                                            ['title'],
                                                        style: mainTitleBlack,
                                                      )),
                                                      Container(
                                                        width: 260,
                                                        child: Text(
                                                          '${listMessages[index]['body']}',
                                                          maxLines: 4,
                                                        ),
                                                      ),
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
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 2)),
                                                  // status,
                                                  Text(
                                                    '${listMessages[index]['date']}',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                    top: 5,
                                                  )),
                                                  if (listMessages[index]
                                                          ['mstatus'] ==
                                                      1)
                                                    Icon(
                                                      Icons.done_all,
                                                      size: 15,
                                                    ),
                                                  // if (listMessages[index]['rdate'] != '')
                                                  //   Text(getDateTimeYMD(
                                                  //       listMessages[index]['rdate'])),
                                                  Text(''),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                    right: 100,
                                                  ))
                                                ],
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
    );
  }
}
