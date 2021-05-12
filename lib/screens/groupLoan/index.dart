import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/screens/groupLoan/selectGroupLoan.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class GroupLoan extends StatefulWidget {
  @override
  _GroupLoanState createState() => _GroupLoanState();
}

class _GroupLoanState extends State<GroupLoan> {
  final TextEditingController createGroupLoanDefaultController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    var isIphonex = isIphoneX(context) ? 0.85 : 0.8;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: logolightGreen,
        title: Text(AppLocalizations.of(context)!.translate('group_loan') ??
            "Group Loan"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              ModalRoute.withName("/Home")),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextField(
                  autocorrect: false,
                  autofocus: false,
                  onChanged: null,
                  controller: createGroupLoanDefaultController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: logolightGreen)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: logolightGreen),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: logolightGreen),
                    ),
                    labelText:
                        AppLocalizations.of(context)!.translate('group_loan') ??
                            'Group Name:',
                  ),
                )),

            //bottom submit
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: logolightGreen, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: logolightGreen,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupLoanSelect(
                                  controller:
                                      createGroupLoanDefaultController.text,
                                ))),
                    child: Container(
                      width: MediaQuery.of(context).size.width * isIphonex,
                      height: MediaQuery.of(context).size.width * 0.11,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                                AppLocalizations.of(context)!
                                        .translate("next") ??
                                    "Next",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
