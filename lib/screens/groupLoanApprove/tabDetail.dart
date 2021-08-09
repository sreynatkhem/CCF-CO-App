import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/screens/groupLoanApprove/widgetDetail.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  var list;
  DetailScreen({this.list});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailWidget(
                  context: context,
                  title: "group_loan",
                  subTitle: list['gname'])
              .getTextDetail(),
          Padding(padding: EdgeInsets.all(2)),
          DetailWidget(
                  context: context,
                  title: "create_by",
                  subTitle: getDateTimeYMD(list['datecreate']))
              .getTextDetail(),
          Padding(padding: EdgeInsets.all(2)),
          DetailWidget(
                  context: context,
                  title: "status",
                  subTitle: list['status'] == "R" ? "Request" : "")
              .getTextDetail(),
          Padding(padding: EdgeInsets.all(2)),
          DetailWidget(
                  context: context, title: "member_group_Loan", subTitle: "")
              .getTextDetail(),
          Expanded(
            flex: 4,
            child: Container(
                child: ListView.builder(
                    itemCount: list['groupLoanDetail'].length,
                    padding: const EdgeInsets.only(top: 20.0),
                    itemBuilder: (context, index) {
                      logger().e(
                          "llll: ${list['groupLoanDetail'][index]['isteamlead']}");
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              DetailWidget(
                                      context: context,
                                      title: AppLocalizations.of(context)!
                                          .translate('customer_name'),
                                      subTitle: ": " +
                                          list['groupLoanDetail'][index]['loan']
                                              ['customer'])
                                  .getTextDetail(),
                              Padding(padding: EdgeInsets.all(2)),
                              // list['groupLoanDetail'][index]['loan']
                              DetailWidget(
                                      context: context,
                                      title: list['groupLoanDetail'][index]
                                                  ['isteamlead'] ==
                                              't'
                                          ? "team_lead" + " "
                                          : AppLocalizations.of(context)!
                                                  .translate(
                                                      "member_group_Loan")! +
                                              " ",
                                      subTitle: list['groupLoanDetail'][index]
                                          ['loan']['customer'])
                                  .getTextDetail(),
                              Padding(padding: EdgeInsets.all(2)),
                              DetailWidget(
                                      context: context,
                                      title: 'customer_id',
                                      subTitle: list['groupLoanDetail'][index]
                                          ['loan']['lcode'])
                                  .getTextDetail(),
                              Padding(padding: EdgeInsets.all(2)),
                              DetailWidget(
                                      context: context,
                                      title: "loan_id",
                                      subTitle: list['groupLoanDetail'][index]
                                          ['loan']['lcode'])
                                  .getTextDetail(),
                              Padding(padding: EdgeInsets.all(2)),
                              DetailWidget(
                                      context: context,
                                      title: "loan_amount",
                                      subTitle: list['groupLoanDetail'][index]
                                              ['loan']['currency'] +
                                          numFormat.format(
                                              list['groupLoanDetail'][index]
                                                  ['loan']['lamt']))
                                  .getTextDetail(),
                              Padding(padding: EdgeInsets.all(2)),
                              DetailWidget(
                                      context: context,
                                      title: "currencies",
                                      subTitle: list['groupLoanDetail'][index]
                                          ['loan']['currency'])
                                  .getTextDetail(),
                              Padding(padding: EdgeInsets.all(2)),
                              DetailWidget(
                                      context: context,
                                      title: "interest_rate",
                                      subTitle:
                                          "${list['groupLoanDetail'][index]['loan']['intrate']}%")
                                  .getTextDetail(),
                              Padding(padding: EdgeInsets.all(2)),
                              DetailWidget(
                                      context: context,
                                      title: "maintenance_fee",
                                      subTitle:
                                          "${list['groupLoanDetail'][index]['loan']['mfee']}%")
                                  .getTextDetail(),
                              Padding(padding: EdgeInsets.all(2)),
                              DetailWidget(
                                      context: context,
                                      title: "admin_fee",
                                      subTitle:
                                          "${list['groupLoanDetail'][index]['loan']['afee']}%")
                                  .getTextDetail(),
                              Padding(padding: EdgeInsets.all(2)),
                              DetailWidget(
                                      context: context,
                                      title: "irr",
                                      subTitle:
                                          "${numFormat.format(list['groupLoanDetail'][index]['loan']['irr']).toString()}%")
                                  .getTextDetail(),
                              Padding(padding: EdgeInsets.all(2)),
                              DetailWidget(
                                      context: context,
                                      title: "repayment_method",
                                      subTitle:
                                          "${list['groupLoanDetail'][index]['loan']['rmode']}")
                                  .getTextDetail(),
                            ],
                          ),
                        ),
                      );
                    })),
          )
        ],
      ),
    );
  }
}
