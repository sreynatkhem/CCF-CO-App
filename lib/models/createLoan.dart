// import 'package:json_annotation/json_annotation.dart';

import 'loanRequest.dart';

part 'createLoan.g.dart';

// @JsonSerializable()
class CreateLoan {
  // CreateLoan();

  String? lcode;
  String? ucode;
  String? bcode;
  String? ccode;
  String? curcode;
  String? pcode;
  double? lamt;
  double? ints;
  double? intrate;
  double? mfee;
  double? afee;
  double? irr;
  String? rmode;
  String? expdate;
  String? odate;
  String? mdate;
  String? firdate;
  num? graperiod;
  String? lpourpose;
  double? ltv;
  double? dscr;
  String? refby;
  String? lstatus;
  String? u1;
  String? u2;
  String? u3;
  String? u4;
  String? u5;
  String? branch;
  String? customer;
  String? user;
  String? loanProduct;
  String? currency;
  late LoanRequest loanRequest;

  // factory CreateLoan.fromJson(Map<String?, dynamic> json) =>
  //     _$CreateLoanFromJson(json);
  Map<String?, dynamic> toJson() => _$CreateLoanToJson(this);
}
