import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chokchey_finance/components/button.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/loan/loanApproval.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/screens/detail/comment.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'approve.dart';
import 'detailLoanApproval.dart';

class CardDetailLoan extends StatefulWidget {
  final list;

  CardDetailLoan(
    this.list,
  );

  @override
  _CardDetailLoanState createState() => _CardDetailLoanState(this.list);
}

class _CardDetailLoanState extends State<CardDetailLoan> {
  final list;

  _CardDetailLoanState(
    this.list,
  );

  var _isInit = false;
  var _isLoading = false;
  var response = [];
  var futureLoanApproval;
  final storage = new FlutterSecureStorage();
  var _isApprover;

  @override
  void didChangeDependencies() {
    futureLoanApproval = Provider.of<LoanApproval>(context)
        .getLoanApproval(20, 1, '', '', '', '', '');
    var test = storage.read(key: 'roles');
    test.then(
      (value) => setState(() {
        userRoles = jsonDecode(value);
      }),
    );
    super.didChangeDependencies();
    if (list != null) {
      getDetail();
    }
    if (mounted) {
      getIsApproval();
    }
  }

  getIsApproval() async {
    _isApprover = await storage.read(key: 'isapprover');
  }

  var listDetail;
  Future getDetail() async {
    var token = await storage.read(key: 'user_token');
    final response = await api().get(
      baseURLInternal + 'loanRequests/Applications/' + list['rcode'],
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
    );
    final parsed = jsonDecode(response.body);
    setState(() {
      listDetail = parsed != null ? parsed : null;
    });
    if (parsed['loan']['lstatus'] == 'R') {
      setState(() {
        hideBottomTabBar = true;
      });
    } else {
      setState(() {
        hideBottomTabBar = false;
      });
    }
  }

  double _widtdButton = 100.0;
  double _heightButton = 33.0;
  double _borderRadius = 12.0;
  var userRoles;
  var isFetchingSuccessfully;
  var isFetchingSuccessfullReturn;
  var isFetchingSuccessfullReject;
  bool hideBottomTabBar = true;

  authrize(value, context) async {
    var branch = await storage.read(key: 'branch');
    var user_ucode = await storage.read(key: 'user_ucode');
    var comments = controller.text;

    var rcode = value['rcode'];
    var ucode = user_ucode;
    var bcode = branch;
    var lcode = value['lcode'];
    var rdate = '';
    var roleList = userRoles;

    setState(() {
      _isLoading = true;
    });
    await Provider.of<LoanApproval>(context, listen: false)
        .approval(rcode, ucode, bcode, lcode, rdate, roleList, comments)
        .then((value) => {
              setState(() {
                _isLoading = false;
              }),
              if (value['loan']['lstatus'] == 'R')
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
            })
        .catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
    isFetchingSuccessfully =
        await Provider.of<LoanApproval>(context, listen: false)
            .isFetchingSuccessfully;
    if (isFetchingSuccessfully == true) {
      showInSnackBar(
          AppLocalizations.of(context).translate('successfully') ??
              'Successfully',
          logolightGreen);
    } else {
      showInSnackBar(
          AppLocalizations.of(context).translate('failed') ?? 'Failed',
          Colors.redAccent);
    }
    setState(() {
      _isLoading = false;
    });
  }

  returnFuc(value, context) async {
    var branch = await storage.read(key: 'branch');
    var user_ucode = await storage.read(key: 'user_ucode');
    var comments = controller.text;
    var rcode = value['rcode'];
    var ucode = user_ucode;
    var bcode = branch;
    var lcode = value['lcode'];
    var rdate = '';
    var roleList = userRoles;
    setState(() {
      _isLoading = true;
    });
    await Provider.of<LoanApproval>(context, listen: false)
        .returnFunction(rcode, ucode, bcode, lcode, rdate, roleList, comments)
        .then((value) => {
              if (value['loan']['lstatus'] == 'R')
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
            })
        .catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
    isFetchingSuccessfullReturn =
        await Provider.of<LoanApproval>(context, listen: false)
            .isFetchingSuccessfullyReturn;
    if (isFetchingSuccessfullReturn == true) {
      showInSnackBar(
          AppLocalizations.of(context).translate('successfully') ??
              'Successfully',
          logolightGreen);
    } else {
      showInSnackBar(
          AppLocalizations.of(context).translate('failed') ?? 'Failed',
          Colors.redAccent);
    }
  }

  reject(value, context) async {
    var branch = await storage.read(key: 'branch');
    var user_ucode = await storage.read(key: 'user_ucode');

    var comments = controller.text;
    var rcode = value['rcode'];
    var ucode = user_ucode;
    var bcode = branch;
    var lcode = value['lcode'];
    var rdate = '';
    var roleList = userRoles;
    setState(() {
      _isLoading = true;
    });
    await Provider.of<LoanApproval>(context, listen: false)
        .rejectFunction(rcode, ucode, bcode, lcode, rdate, roleList, comments)
        .then((value) => {
              setState(() {
                _isLoading = false;
              }),
              if (value['loan']['lstatus'] == 'R')
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
            })
        .catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });

    isFetchingSuccessfullReject =
        await Provider.of<LoanApproval>(context, listen: false)
            .isFetchingSuccessfullyReject;
    if (isFetchingSuccessfullReject == true) {
      showInSnackBar(
          AppLocalizations.of(context).translate('successfully') ??
              'Successfully',
          logolightGreen);
    } else {
      showInSnackBar(
          AppLocalizations.of(context).translate('failed') ?? 'Failed',
          Colors.redAccent);
    }
  }

  TextEditingController controller = new TextEditingController();
  // Display Snackbar
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value, colorsBackground) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: colorsBackground,
    ));
  }

  @override
  Widget build(BuildContext context) {
    futureLoanApproval = Provider.of<LoanApproval>(context)
        .getLoanApproval(20, 1, '', '', '', '', '');
    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 16.0 : 0.0;
    logger().e('_isApprover: $_isApprover');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate('loan_information') ??
                'Loan Information'),
        backgroundColor: logolightGreen,
      ),
      body: _isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: logolightGreen,
                          constraints: BoxConstraints.expand(height: 55),
                          child: TabBar(indicatorColor: Colors.white, tabs: [
                            Tab(
                              text: AppLocalizations.of(context)
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
                                text: AppLocalizations.of(context)
                                        .translate('approved') ??
                                    "Approved"),
                            Tab(
                                icon: Icon(
                                  Icons.comment,
                                  size: 20,
                                ),
                                iconMargin: EdgeInsets.all(0),
                                text: AppLocalizations.of(context)
                                        .translate('comments') ??
                                    "Comments"),
                          ]),
                        ),
                        Expanded(
                          child: Container(
                            child: TabBarView(children: [
                              CardDetailLoanRegitration(list),
                              if (_isLoading == true)
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                              if (_isLoading == false) ApprovalListCard(list),
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
                                          title: AppLocalizations.of(context)
                                                  .translate('reject') ??
                                              'Reject',
                                          desc:
                                              // AppLocalizations.of(context)
                                              //         .translate('thank_you') ??
                                              'Would you like to Reject?',
                                          btnOkOnPress: () async {
                                            reject(list, context);
                                          },
                                          btnCancelText:
                                              AppLocalizations.of(context)
                                                      .translate('cancel') ??
                                                  "Cancel",
                                          btnCancelOnPress: () async {},
                                          btnCancelIcon: Icons.close,
                                          btnOkIcon: Icons.check_circle,
                                          btnOkColor: logolightGreen,
                                          btnOkText:
                                              AppLocalizations.of(context)
                                                      .translate('okay') ??
                                                  'Okay')
                                        ..show();
                                    },
                                    color: Colors.red,
                                    text: AppLocalizations.of(context)
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
                                          title: AppLocalizations.of(context)
                                                  .translate('return') ??
                                              'Return',
                                          desc:
                                              // AppLocalizations.of(context)
                                              //         .translate('thank_you') ??
                                              'Would you like to Return?',
                                          btnOkOnPress: () async {
                                            returnFuc(list, context);
                                          },
                                          btnCancelText:
                                              AppLocalizations.of(context)
                                                      .translate('cancel') ??
                                                  "Cancel",
                                          btnCancelOnPress: () async {},
                                          btnCancelIcon: Icons.close,
                                          btnOkIcon: Icons.check_circle,
                                          btnOkColor: logolightGreen,
                                          btnOkText:
                                              AppLocalizations.of(context)
                                                      .translate('okay') ??
                                                  'Okay')
                                        ..show();
                                    },
                                    color: Colors.grey,
                                    text: AppLocalizations.of(context)
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
                                          title: AppLocalizations.of(context)
                                                  .translate('authrize') ??
                                              'Authrize',
                                          desc:
                                              // AppLocalizations.of(context)
                                              //         .translate('thank_you') ??
                                              'Would you like to authrize?',
                                          btnOkOnPress: () async {
                                            authrize(list, context);
                                          },
                                          btnCancelText:
                                              AppLocalizations.of(context)
                                                      .translate('cancel') ??
                                                  "Cancel",
                                          btnCancelOnPress: () async {},
                                          btnCancelIcon: Icons.close,
                                          btnOkIcon: Icons.check_circle,
                                          btnOkColor: logolightGreen,
                                          btnOkText:
                                              AppLocalizations.of(context)
                                                      .translate('okay') ??
                                                  'Okay')
                                        ..show();
                                    },
                                    color: logolightGreen,
                                    text: _isLoading
                                        ? 'loading'
                                        : AppLocalizations.of(context)
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
