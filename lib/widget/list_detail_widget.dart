import 'package:chokchey_finance/modals/listApproval.dart';
import 'package:flutter/material.dart';

class ListDetail extends StatelessWidget {
  final List<ListApproval> approvalListDetail;

  ListDetail({Key key, this.approvalListDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: ListView.builder(
            itemCount: approvalListDetail.length,
            itemBuilder: (context, index) {
              return Container(
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Customer Name: '),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Text('Customer No: '),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Text('Application Amount: '),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Text('Currency: '),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Text('CreditRisk Rating Grade:  '),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${approvalListDetail[index].customerName.toString()}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w800),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Text(
                          '${approvalListDetail[index].customerNo.toString()}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w800),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Text(
                          '${approvalListDetail[index].applicationAmount.toString()}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w800),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Text(
                          '${approvalListDetail[index].currencyCode.toString()}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w800),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Text(
                          '${approvalListDetail[index].creditRiskRatingGrade.toString()}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
