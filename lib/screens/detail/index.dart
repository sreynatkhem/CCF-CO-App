import 'dart:convert';

import 'package:chokchey_finance/components/button.dart';
import 'package:chokchey_finance/components/cardDetial.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/approvalList.dart';
import 'package:chokchey_finance/providers/detailList.dart';
import 'package:chokchey_finance/providers/detialJson.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/providers/registerApproval.dart';
import 'package:chokchey_finance/providers/reject.dart';
import 'package:chokchey_finance/providers/returnFuc.dart';
import 'package:chokchey_finance/screens/approval/approvalList.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/screens/detail/cardDetail.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'comment.dart';
import 'approve.dart';

class TabBarMenu extends StatefulWidget {
  final loanApprovalApplicationNo;
  TabBarMenu(
    this.loanApprovalApplicationNo,
  );
  @override
  _TabBarMenuState createState() => _TabBarMenuState();
}

class _TabBarMenuState extends State<TabBarMenu> {
  bool _isInit = false;
  bool _isLoading = false;
  var response = [];
  dynamic list = [];

  @override
  void didChangeDependencies() {
    setState(() {
      _isInit = true;
    });
    if (_isInit) {
      fetchListDetail();
    }
    super.didChangeDependencies();
  }

  dynamic approvalListLoan;

  Future fetchListDetail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(baseUrl + 'LRA0003'));
      request.body =
          "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"loanApprovalApplicationNo\": \"${widget.loanApprovalApplicationNo}\"\n    }\n}\n";
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var listes = jsonDecode(await response.stream.bytesToString());
        setState(() {
          _isLoading = false;
          list.add(listes['body']['loanApplicationDetailInfo']);
          approvalListLoan = listes['body']['approvalList'];
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double _widtdButton = 100.0;
  double _heightButton = 33.0;
  double _borderRadius = 12.0;

  authrize(
    context,
    http.Client client,
  ) async {
    setState(() {
      _isLoading = true;
    });
    var comments = controller.text;
    String user_id = await storage.read(key: 'user_id');
    String user_name = await storage.read(key: 'user_name');
    // final bodyRow =
    //     "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"$user_id\",\n    \"authorizerEmpName\": \"$user_name\",\n    \"evaluateStatusCode\": \"20\",\n    \"loanApprovalApplicationNo\": \"${widget.loanApprovalApplicationNo}\",\n    \"authorizationOpinionContents\": \"$comments\"\n    }\n}";
    // registerApproval(
    //     http.Client(), widget.loanApprovalApplicationNo, 20, comments);
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(baseUrl + 'LRA0004'));
      request.body =
          "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"$user_id\",\n    \"authorizerEmpName\": \"$user_name\",\n    \"evaluateStatusCode\": \"20\",\n    \"loanApprovalApplicationNo\": \"${widget.loanApprovalApplicationNo}\",\n    \"authorizationOpinionContents\": \"$comments\"\n    }\n}";
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      final respStr = await response.stream.bytesToString();
      var json = jsonDecode(respStr);
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 200) {
        if (json['header']['result'] == false) {
          showInSnackBar(json['header']['result']['resultMessage'],
              logolightGreen, _scaffoldKeyApsara);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Home(),
              ),
              ModalRoute.withName('/'));
        }
      }
    } catch (error) {
      client.close();
      setState(() {
        _isLoading = false;
      });
    }
  }

  returnFuc(
    context,
    http.Client client,
  ) async {
    var comments = controller.text;
    String user_id = await storage.read(key: 'user_id');
    String user_name = await storage.read(key: 'user_name');
    setState(() {
      _isLoading = true;
    });
    // final bodyRow =
    //     "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"$user_id\",\n    \"authorizerEmpName\": \"$user_name\",\n    \"evaluateStatusCode\": \"80\",\n    \"loanApprovalApplicationNo\": \"${widget.loanApprovalApplicationNo}\",\n    \"authorizationOpinionContents\": \"$comments\"\n    }\n}";
    // await returnFunction(
    //         http.Client(), widget.loanApprovalApplicationNo, 80, comments)
    //     .then((_) => {});
    try {
      setState(() {
        _isLoading = false;
      });
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(baseUrl + 'LRA0004'));
      request.body =
          "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"$user_id\",\n    \"authorizerEmpName\": \"$user_name\",\n    \"evaluateStatusCode\": \"80\",\n    \"loanApprovalApplicationNo\": \"${widget.loanApprovalApplicationNo}\",\n    \"authorizationOpinionContents\": \"$comments\"\n    }\n}";
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Home(),
            ),
            ModalRoute.withName('/'));
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      client.close();
    }
  }

  final storage = new FlutterSecureStorage();

  reject(
    context,
    http.Client client,
  ) async {
    setState(() {
      _isLoading = true;
    });
    var comments = controller.text;
    String user_id = await storage.read(key: 'user_id');
    String user_name = await storage.read(key: 'user_name');

    try {
      setState(() {
        _isLoading = false;
      });
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(baseUrl + 'LRA0004'));
      request.body =
          "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"$user_id\",\n    \"authorizerEmpName\": \"$user_name\",\n    \"evaluateStatusCode\": \"90\",\n    \"loanApprovalApplicationNo\": \"${widget.loanApprovalApplicationNo}\",\n    \"authorizationOpinionContents\": \"$comments\"\n    }\n}";
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Home(),
            ),
            ModalRoute.withName('/'));
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      client.close();
    }
  }

  TextEditingController controller = new TextEditingController();
  final images = const AssetImage('assets/images/request.png');
  final GlobalKey<ScaffoldState> _scaffoldKeyApsara =
      new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // var future = fetchListDetail(widget.loanApprovalApplicationNo);
    // var futureListApprove =
    //     fetchDetail(http.Client(), widget.loanApprovalApplicationNo);

    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 16.0 : 0.0;
    return Scaffold(
      key: _scaffoldKeyApsara,
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
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            child: TabBarView(children: [
                              list == null ||
                                      list.length == 0 ||
                                      list.length <= 0
                                  ? Center(
                                      child: Text(
                                        'No Details',
                                        style: mainTitleBlack,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: list!.length,
                                      padding: const EdgeInsets.only(top: 20.0),
                                      itemBuilder: (context, index) {
                                        var listes = list[index];
                                        // return Text("${listes.toString()}");
                                        return CardDetail(
                                          images: images,
                                          applyInterestRate:
                                              listes['applyInterestRate'],
                                          customerName: listes['customerName'],
                                          applicationAmount:
                                              listes['applicationAmount'],
                                          loanApprovalApplicationNo: listes[
                                              'loanApprovalApplicationNo'],
                                          productName: listes['productName'],
                                          currencyCode: listes['currencyCode'],
                                          loanPeriodMonthlyCount:
                                              listes['loanPeriodMonthlyCount'],
                                          handleFee: listes['handleFee'],
                                          cbcFee: listes['cbcFee'],
                                          unUseFee: listes['unUseFee'],
                                          loanHopeDate:
                                              listes['loanHopeDate'] != null
                                                  ? listes['loanHopeDate']
                                                  : "",
                                          loanExpiryDate:
                                              listes['loanExpiryDate'],
                                          interestExemptionPeriod:
                                              listes['interestExemptionPeriod'],
                                          branchName: listes['branchName'],
                                          firstInterestPaymentDate: listes[
                                              'firstInterestPaymentDate'],
                                        );
                                      }),
                              // Detail(widget.loanApprovalApplicationNo, future),
                              Approve(
                                widget.loanApprovalApplicationNo,
                                approvalListLoan,
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
                            reject(
                              context,
                              http.Client(),
                            );
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
                            returnFuc(
                              context,
                              http.Client(),
                            );
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
                            authrize(
                              context,
                              http.Client(),
                            );
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
