import 'package:json_annotation/json_annotation.dart';

import 'currency.dart';
import 'customerRegistration.dart';
import 'loanProduct.dart';

part 'createLoan.g.dart';

@JsonSerializable()
class CreateLoan {
  CreateLoan();

  String lcode;
  String ucode;
  String bcode;
  String ccode;
  String curcode;
  String pcode;

  num lamt;
  num ints;
  num intrate;
  num mfee;
  num afee;
  String rmode;
  String odate;
  String mdate;
  String firdate;
  num graperiod;
  String lpourpose;
  num ltv;
  num dscr;
  String refby;
  String lstatus;
  String u1;
  String u2;
  String u3;
  String u4;
  String u5;
  String branch;

  CustomerRegistration customer;
  LoanProduct loanProduct;
  String loanRequest;
  String user;
  Currency currency;

  factory CreateLoan.fromJson(Map<String, dynamic> json) =>
      _$CreateLoanFromJson(json);
  Map<String, dynamic> toJson() => _$CreateLoanToJson(this);
}
