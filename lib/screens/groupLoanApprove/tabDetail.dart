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
                  title: "Group name",
                  subTitle: list['gname'])
              .getTextDetail(),
          Padding(padding: EdgeInsets.all(2)),
          DetailWidget(
                  context: context,
                  title: "Create date ",
                  subTitle: getDateTimeYMD(list['datecreate']))
              .getTextDetail(),
          Padding(padding: EdgeInsets.all(2)),
          DetailWidget(
                  context: context,
                  title: "Status ",
                  subTitle: list['status'] == "R" ? "Request" : "")
              .getTextDetail(),
          Padding(padding: EdgeInsets.all(2)),
          DetailWidget(
                  context: context, title: "Member Group Loan", subTitle: "")
              .getTextDetail(),
          Expanded(
            flex: 4,
            child: Container(
                child: ListView.builder(
                    itemCount: list['groupLoanDetail'].length,
                    padding: const EdgeInsets.only(top: 20.0),
                    itemBuilder: (context, index) {
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              DetailWidget(
                                      context: context,
                                      title: "Customer name ",
                                      subTitle: list['groupLoanDetail'][index]
                                          ['loan']['customer'])
                                  .getTextDetail(),
                              Padding(padding: EdgeInsets.all(2)),
                              DetailWidget(
                                      context: context,
                                      title: "Team Lead ",
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
