// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'createLoan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLoan _$CreateLoanFromJson(Map<String, dynamic> json) {
  return CreateLoan()
    ..lcode = json['lcode'] as String
    ..ucode = json['ucode'] as String
    ..bcode = json['bcode'] as String
    ..ccode = json['ccode'] as String
    ..curcode = json['curcode'] as String
    ..pcode = json['pcode'] as String
    ..lamt = (json['lamt'] as num).toDouble()
    ..ints = (json['ints'] as num).toDouble()
    ..intrate = (json['intrate'] as num).toDouble()
    ..mfee = (json['mfee'] as num).toDouble()
    ..afee = (json['afee'] as num).toDouble()
    ..irr = (json['irr'] as num).toDouble()
    ..rmode = json['rmode'] as String
    ..expdate = json['expdate'] as String
    ..odate = json['odate'] as String
    ..mdate = json['mdate'] as String
    ..firdate = json['firdate'] as String
    ..graperiod = json['graperiod'] as num
    ..lpourpose = json['lpourpose'] as String
    ..ltv = (json['ltv'] as num).toDouble()
    ..dscr = (json['dscr'] as num).toDouble()
    ..refby = json['refby'] as String
    ..lstatus = json['lstatus'] as String
    ..u1 = json['u1'] as String
    ..u2 = json['u2'] as String
    ..u3 = json['u3'] as String
    ..u4 = json['u4'] as String
    ..u5 = json['u5'] as String
    ..branch = json['branch'] as String
    ..customer = json['customer'] as String
    ..user = json['user'] as String
    ..loanProduct = json['loanProduct'] as String
    ..currency = json['currency'] as String;
  // ..loanRequest = (json['loanRequest'] == null
  //     ? null
  //     : LoanRequest.fromJson(json['loanRequest'] as Map<String, dynamic>))!;
}

Map<String, dynamic> _$CreateLoanToJson(CreateLoan instance) =>
    <String, dynamic>{
      'lcode': instance.lcode,
      'ucode': instance.ucode,
      'bcode': instance.bcode,
      'ccode': instance.ccode,
      'curcode': instance.curcode,
      'pcode': instance.pcode,
      'lamt': instance.lamt,
      'ints': instance.ints,
      'intrate': instance.intrate,
      'mfee': instance.mfee,
      'afee': instance.afee,
      'rmode': instance.rmode,
      'odate': instance.odate,
      'mdate': instance.mdate,
      'firdate': instance.firdate,
      'graperiod': instance.graperiod,
      'lpourpose': instance.lpourpose,
      'ltv': instance.ltv,
      'dscr': instance.dscr,
      'refby': instance.refby,
      'lstatus': instance.lstatus,
      'u1': instance.u1,
      'u2': instance.u2,
      'u3': instance.u3,
      'u4': instance.u4,
      'u5': instance.u5,
      'branch': instance.branch,
      'customer': instance.customer,
      'user': instance.user,
      'loanProduct': instance.loanProduct,
      'currency': instance.currency,
      'loanRequest': instance.loanRequest
    };
