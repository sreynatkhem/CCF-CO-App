import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ListDatial.dart';

class CardDetail extends StatelessWidget {
  final dynamic images;
  final dynamic customerName;
  final dynamic applicationAmount;
  final dynamic loanApprovalApplicationNo;
  final dynamic productName;
  final dynamic currencyCode;
  final dynamic loanPeriodMonthlyCount;
  final dynamic applyInterestRate;
  final dynamic handleFee;
  final dynamic cbcFee;
  final dynamic unUseFee;
  final dynamic loanHopeDate;
  final dynamic loanExpiryDate;
  final dynamic interestExemptionPeriod;
  final dynamic branchName;
  final dynamic firstInterestPaymentDate;

  CardDetail({
    this.images,
    this.customerName,
    this.applicationAmount,
    this.loanApprovalApplicationNo,
    this.productName,
    this.currencyCode,
    this.loanPeriodMonthlyCount,
    this.applyInterestRate,
    this.handleFee,
    this.cbcFee,
    this.unUseFee,
    this.loanHopeDate,
    this.loanExpiryDate,
    this.interestExemptionPeriod,
    this.branchName,
    this.firstInterestPaymentDate,
  });

  getDateTimeApprove(time) {
    DateTime dateTimeApproved = DateTime.parse(time);
    String dateTime = DateFormat("yyyy-MM-dd").format(dateTimeApproved);
    return dateTime;
  }

  getDate(time) {
    DateTime dateTimeApproved = DateTime.parse(time);
    String dateTime = DateFormat("yyyy-MM-dd").format(dateTimeApproved);
    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: logolightGreen, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListDetail(
                      name: 'Name',
                      value: customerName.toString(),
                    ),
                    //
                    ListDetail(
                      name: 'Application No',
                      value: loanApprovalApplicationNo.toString(),
                    ),
                    //
                    ListDetail(
                      name: 'Product Name',
                      value: productName.toString(),
                    ),
                    //
                    ListDetail(
                        name: 'Principle', value: applicationAmount.toString()),
                    //
                    ListDetail(
                      name: 'Currency',
                      value: currencyCode.toString(),
                    ),
                    //
                    ListDetail(
                      name: 'Term',
                      value: loanPeriodMonthlyCount.toString() + ' Months',
                    ),
                    //
                    ListDetail(
                      name: 'Interest Rate',
                      value: applyInterestRate.toString(),
                    ),
                    //
                    ListDetail(
                      name: 'Admin Fee',
                      value: handleFee.toString(),
                    ),
                    //
                    ListDetail(
                      name: 'CBC Fee',
                      value: cbcFee.toString(),
                    ),
                    //
                    ListDetail(
                      name: 'Maintenance Fee',
                      value: unUseFee.toString(),
                    ),
                    //
                    ListDetail(
                      name: 'Disburse Date',
                      value: getDateTimeApprove(loanHopeDate),
                    ),
                    //
                    ListDetail(
                      name: 'Maturity Date',
                      value: getDateTimeApprove(loanExpiryDate),
                    ),
                    //
                    ListDetail(
                      name: 'Interest Exception',
                      value: interestExemptionPeriod.toString(),
                    ),
                    //
                    ListDetail(
                      name: 'Branch',
                      value: branchName.toString(),
                    ),
                    //
                    ListDetail(
                      name: 'First Repay Date',
                      value: firstInterestPaymentDate.toString(),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 5)),
                  ],
                ),
              ]))),
    );
  }
}
