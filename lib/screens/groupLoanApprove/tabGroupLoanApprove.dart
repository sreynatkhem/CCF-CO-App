import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chokchey_finance/components/button.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/groupLoan/index.dart';
import 'package:chokchey_finance/providers/loan/loanApproval.dart';
import 'package:chokchey_finance/screens/detail/comment.dart';
import 'package:chokchey_finance/screens/groupLoan/index.dart';
import 'package:chokchey_finance/screens/groupLoan/selectGroupLoan.dart';
import 'package:chokchey_finance/screens/groupLoanApprove/index.dart';
import 'package:chokchey_finance/screens/groupLoanApprove/tabApproved.dart';
import 'package:chokchey_finance/screens/groupLoanApprove/tabApproved.dart';
import 'package:chokchey_finance/screens/groupLoanApprove/tabDetail.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class GroupLoanApproveDetail extends StatefulWidget {
  var groupLoanID;

  GroupLoanApproveDetail({this.groupLoanID});
  @override
  _GroupLoanApproveDetailState createState() =>
      _GroupLoanApproveDetailState(groupLoanID: this.groupLoanID);
}

class _GroupLoanApproveDetailState extends State<GroupLoanApproveDetail> {
  //
  var groupLoanID;
  //
  _GroupLoanApproveDetailState({this.groupLoanID});

  //
  final storage = new FlutterSecureStorage();

  var _isApprover;
  var _isLoading = false;
  bool hideBottomTabBar = true;
  var userRoles;
  var isFetchingSuccessfully;
  var isFetchingSuccessfullReturn;
  var isFetchingSuccessfullReject;

  //
  double _widtdButton = 100.0;
  double _heightButton = 33.0;
  double _borderRadius = 12.0;

  //
  TextEditingController controller = new TextEditingController();

  //
  getIsApproval() async {
    _isApprover = await storage.read(key: 'isapprover');
    var listUserRoles = storage.read(key: 'roles');
    listUserRoles.then(
      (value) => setState(() {
        userRoles = jsonDecode(value);
      }),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      fetch();
      getIsApproval();
    }
  }

  var listGroupLoanById;

  fetch() async {
    setState(() {
      _isLoading = true;
    });
    await GroupLoanProvider()
        .fetchGroupLoanByID(groupLoanID['gcode'], "", "", "", "", "", "", "")
        .then((value) {
      if (value['groupLoanDetail'][0]['loan']['lstatus'] == 'G') {
        setState(() {
          hideBottomTabBar = true;
        });
      } else {
        setState(() {
          hideBottomTabBar = false;
        });
      }
      setState(() {
        _isLoading = false;
        listGroupLoanById = value;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  authrize(gcode, context, status) async {
    var branch = await storage.read(key: 'branch');
    var user_ucode = await storage.read(key: 'user_ucode');

    setState(() {
      _isLoading = true;
    });
    await Provider.of<GroupLoanProvider>(context, listen: false)
        .approvalRejectReturn(
            gcode, user_ucode, branch, userRoles, controller.text, status)
        .then((value) => {
              setState(() {
                _isLoading = false;
              }),
              if (value['groupLoanDetail'][0]['loan']['lstatus'] == 'R')
                {
                  setState(() {
                    hideBottomTabBar = true;
                  }),
                }
              else
                {
                  setState(() {
                    hideBottomTabBar = false;
                  }),
                },
              showInSnackBar(
                  AppLocalizations.of(context)!.translate('successfully') ??
                      'Successfully',
                  logolightGreen),
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => GroupLoanApprove(
                      isRefresh: true,
                    ),
                  ),
                  ModalRoute.withName('/'))
            })
        .catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      showInSnackBar(
          AppLocalizations.of(context)!.translate('failed') ?? 'Failed',
          Colors.redAccent);
    });
    isFetchingSuccessfully =
        await Provider.of<GroupLoanProvider>(context, listen: false)
            .isFetchingSuccessfully;
    if (isFetchingSuccessfully == true) {
      showInSnackBar(
          AppLocalizations.of(context)!.translate('successfully') ??
              'Successfully',
          logolightGreen);
    } else {
      showInSnackBar(
          AppLocalizations.of(context)!.translate('failed') ?? 'Failed',
          Colors.redAccent);
    }
    setState(() {
      _isLoading = false;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value, colorsBackground) {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: colorsBackground,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 16.0 : 0.0;
    return Header(
        keys: _scaffoldKey,
        headerTexts:
            AppLocalizations.of(context)!.translate('detail_group_loan'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bodys: _isLoading
            ? Center(
                child: Container(
                child: CircularProgressIndicator(),
              ))
            : Container(
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: DefaultTabController(
                        length: 3,
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: logolightGreen,
                              constraints: BoxConstraints.expand(height: 55),
                              child:
                                  TabBar(indicatorColor: Colors.white, tabs: [
                                Tab(
                                  text: AppLocalizations.of(context)!
                                          .translate('detail') ??
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
                                margin: EdgeInsets.all(10),
                                child: TabBarView(children: [
                                  //detail group loan
                                  DetailScreen(
                                    list: listGroupLoanById,
                                  ),
                                  if (_isLoading == true)
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  if (_isLoading == false)
                                    ApproverScreen(
                                      list: listGroupLoanById,
                                    ),
                                  Comments(controller)
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (_isApprover == 'Y')
                      if (hideBottomTabBar == true)
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
                                          AwesomeDialog(
                                              context: context,
                                              // animType: AnimType.LEFTSLIDE,
                                              headerAnimationLoop: false,
                                              dialogType: DialogType.INFO,
                                              title: AppLocalizations.of(
                                                          context)!
                                                      .translate('reject') ??
                                                  'Reject',
                                              desc:
                                                  // AppLocalizations.of(context)!
                                                  //         .translate('thank_you') ??
                                                  'Would you like to Reject?',
                                              btnOkOnPress: () async {
                                                authrize(groupLoanID['gcode'],
                                                    context, "Reject");
                                              },
                                              btnCancelText:
                                                  AppLocalizations.of(context)!
                                                          .translate(
                                                              'cancel') ??
                                                      "Cancel",
                                              btnCancelOnPress: () async {},
                                              btnCancelIcon: Icons.close,
                                              btnOkIcon: Icons.check_circle,
                                              btnOkColor: logolightGreen,
                                              btnOkText:
                                                  AppLocalizations.of(context)!
                                                          .translate('okay') ??
                                                      'Okay')
                                            ..show();
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
                                          AwesomeDialog(
                                              context: context,
                                              // animType: AnimType.LEFTSLIDE,
                                              headerAnimationLoop: false,
                                              dialogType: DialogType.INFO,
                                              title: AppLocalizations.of(
                                                          context)!
                                                      .translate('return') ??
                                                  'Return',
                                              desc:
                                                  // AppLocalizations.of(context)!
                                                  //         .translate('thank_you') ??
                                                  'Would you like to Return?',
                                              btnOkOnPress: () async {
                                                authrize(groupLoanID['gcode'],
                                                    context, "Return");
                                              },
                                              btnCancelText:
                                                  AppLocalizations.of(context)!
                                                          .translate(
                                                              'cancel') ??
                                                      "Cancel",
                                              btnCancelOnPress: () async {},
                                              btnCancelIcon: Icons.close,
                                              btnOkIcon: Icons.check_circle,
                                              btnOkColor: logolightGreen,
                                              btnOkText:
                                                  AppLocalizations.of(context)!
                                                          .translate('okay') ??
                                                      'Okay')
                                            ..show();
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
                                          AwesomeDialog(
                                              context: context,
                                              // animType: AnimType.LEFTSLIDE,
                                              headerAnimationLoop: false,
                                              dialogType: DialogType.INFO,
                                              title: AppLocalizations.of(
                                                          context)!
                                                      .translate('authrize') ??
                                                  'Authrize',
                                              desc:
                                                  // AppLocalizations.of(context)!
                                                  //         .translate('thank_you') ??
                                                  'Would you like to authrize?',
                                              btnOkOnPress: () async {
                                                authrize(groupLoanID['gcode'],
                                                    context, "Approve");
                                              },
                                              btnCancelText:
                                                  AppLocalizations.of(context)!
                                                          .translate(
                                                              'cancel') ??
                                                      "Cancel",
                                              btnCancelOnPress: () async {},
                                              btnCancelIcon: Icons.close,
                                              btnOkIcon: Icons.check_circle,
                                              btnOkColor: logolightGreen,
                                              btnOkText:
                                                  AppLocalizations.of(context)!
                                                          .translate('okay') ??
                                                      'Okay')
                                            ..show();
                                        },
                                        color: logolightGreen,
                                        text: _isLoading
                                            ? 'loading'
                                            : AppLocalizations.of(context)!
                                                    .translate('authrize') ??
                                                'Authrize'),
                                  ],
                                )),
                              )),
                        ),
                    Padding(padding: EdgeInsets.only(bottom: bottomPadding))
                  ],
                ),
              ));
  }
}
