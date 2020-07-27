import 'package:chokchey_finance/components/cardDetial.dart';
import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class CardDetailWidget extends StatelessWidget {
  final images = const AssetImage('assets/images/request.png');
  final list;

  CardDetailWidget(this.list);
  // onClickCard(value, context) {
  //   final loanApprovalApplicationNo = value.loanApprovalApplicationNo;
  //   Navigator.of(context).push(new MaterialPageRoute<Null>(
  //       builder: (BuildContext context) {
  //         return new TabBarMenu(loanApprovalApplicationNo);
  //       },
  //       fullscreenDialog: true));
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListApproval>>(
        future: list,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.data == null ||
              snapshot.data.length == 0 ||
              snapshot.data.length <= 0) {
            return Center(
              child: Text(
                'No Details',
                style: mainTitleBlack,
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                padding: const EdgeInsets.only(top: 20.0),
                itemBuilder: (context, index) {
                  var list = snapshot.data[index];
                  return CardDetail(
                    images: images,
                    applyInterestRate: list.applyInterestRate,
                    customerName: list.customerName,
                    applicationAmount: list.applicationAmount,
                    loanApprovalApplicationNo: list.loanApprovalApplicationNo,
                    productName: list.productName,
                    currencyCode: list.currencyCode,
                    loanPeriodMonthlyCount: list.loanPeriodMonthlyCount,
                    handleFee: list.handleFee,
                    cbcFee: list.cbcFee,
                    unUseFee: list.unUseFee,
                    loanHopeDate: list.loanHopeDate,
                    loanExpiryDate: list.loanExpiryDate,
                    interestExemptionPeriod: list.interestExemptionPeriod,
                    branchName: list.branchName,
                    firstInterestPaymentDate: list.firstInterestPaymentDate,
                  );
                });
          }
        });
  }
}
