// import 'package:chokchey_finance/components/cardDetial.dart';
// import 'package:chokchey_finance/models/listApproval.dart';
// import 'package:chokchey_finance/utils/storages/const.dart';
// import 'package:flutter/material.dart';

// class CardDetailWidget extends StatelessWidget {
//   final images = const AssetImage('assets/images/request.png');
//   final list;

//   CardDetailWidget(this.list);
//   // onClickCard(value, context) {
//   //   final loanApprovalApplicationNo = value.loanApprovalApplicationNo;
//   //   Navigator.of(context).push(new MaterialPageRoute<Null>(
//   //       builder: (BuildContext context) {
//   //         return new TabBarMenu(loanApprovalApplicationNo);
//   //       },
//   //       fullscreenDialog: true));
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: list.length,
//         padding: const EdgeInsets.only(top: 20.0),
//         itemBuilder: (context, index) {
//           var listes = list[index];
//           return CardDetail(
//             images: images,
//             applyInterestRate: listes['applyInterestRate'],
//             customerName: listes['customerName'],
//             applicationAmount: listes['applicationAmount'],
//             loanApprovalApplicationNo: listes['loanApprovalApplicationNo'],
//             productName: listes['productName'],
//             currencyCode: listes['currencyCode'],
//             loanPeriodMonthlyCount: listes['loanPeriodMonthlyCount'],
//             handleFee: listes['handleFee'],
//             cbcFee: listes['cbcFee'],
//             unUseFee: listes['unUseFee'],
//             loanHopeDate: listes['loanHopeDate'],
//             loanExpiryDate: listes['loanExpiryDate'],
//             interestExemptionPeriod: listes['interestExemptionPeriod'],
//             branchName: listes['branchName'],
//             firstInterestPaymentDate: listes['firstInterestPaymentDate'],
//           );
//         });
//   }
// }
