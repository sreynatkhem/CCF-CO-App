import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chokchey_finance/components/button.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/loan/loanApproval.dart';
import 'package:chokchey_finance/screens/detail/comment.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
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

  @override
  void didChangeDependencies() {
    setState(() {
      _isInit = true;
    });
    if (_isInit) {
      // list = fetchListDetail(loanApprovalApplicationNo);
    }
    var test = storage.read(key: 'roles');

    test.then(
      (value) => setState(() {
        userRoles = jsonDecode(value);
      }),
    );
    super.didChangeDependencies();
  }

  double _widtdButton = 100.0;
  double _heightButton = 33.0;
  double _borderRadius = 12.0;
  var userRoles;

  authrize(value, context) async {
    var branch = await storage.read(key: 'branch');

    var comments = controller.text;
    var rcode = value['rcode'];
    var ucode = value['ucode'];
    var bcode = branch;
    var lcode = value['lcode'];
    var rdate = value['rdate'];
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
              showInSnackBar(
                  AppLocalizations.of(context).translate('success') ??
                      'Success')
            });
    setState(() {
      _isLoading = false;
    });
  }

  returnFuc(value, context) async {
    var branch = await storage.read(key: 'branch');

    var comments = controller.text;
    var rcode = value['rcode'];
    var ucode = value['ucode'];
    var bcode = branch;
    var lcode = value['lcode'];
    var rdate = value['rdate'];
    var roleList = userRoles;
    setState(() {
      _isLoading = true;
    });
    await Provider.of<LoanApproval>(context, listen: false)
        .returnFunction(rcode, ucode, bcode, lcode, rdate, roleList, comments)
        .then((value) => {
              setState(() {
                _isLoading = false;
              }),
              showInSnackBar(
                  AppLocalizations.of(context).translate('return') ?? 'Return')
            });
    setState(() {
      _isLoading = false;
    });
  }

  reject(value, context) async {
    var branch = await storage.read(key: 'branch');

    var comments = controller.text;
    var rcode = value['rcode'];
    var ucode = value['ucode'];
    var bcode = branch;
    var lcode = value['lcode'];
    var rdate = value['rdate'];
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
              showInSnackBar(
                  AppLocalizations.of(context).translate('reject') ?? 'Reject')
            });
    setState(() {
      _isLoading = false;
    });
  }

  TextEditingController controller = new TextEditingController();
  // Display Snackbar
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 16.0 : 0.0;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate('loan_information') ??
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
                    constraints: BoxConstraints.expand(height: 55),
                    child: TabBar(indicatorColor: Colors.white, tabs: [
                      Tab(
                        text:
                            AppLocalizations.of(context).translate('detail') ??
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
                                btnCancelText: AppLocalizations.of(context)
                                        .translate('cancel') ??
                                    "Cancel",
                                btnCancelOnPress: () async {},
                                btnCancelIcon: Icons.close,
                                btnOkIcon: Icons.check_circle,
                                btnOkColor: logolightGreen,
                                btnOkText: AppLocalizations.of(context)
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
                                btnCancelText: AppLocalizations.of(context)
                                        .translate('cancel') ??
                                    "Cancel",
                                btnCancelOnPress: () async {},
                                btnCancelIcon: Icons.close,
                                btnOkIcon: Icons.check_circle,
                                btnOkColor: logolightGreen,
                                btnOkText: AppLocalizations.of(context)
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
                                btnCancelText: AppLocalizations.of(context)
                                        .translate('cancel') ??
                                    "Cancel",
                                btnCancelOnPress: () async {},
                                btnCancelIcon: Icons.close,
                                btnOkIcon: Icons.check_circle,
                                btnOkColor: logolightGreen,
                                btnOkText: AppLocalizations.of(context)
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
