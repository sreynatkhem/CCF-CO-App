// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loan _$LoanFromJson(Map<String, dynamic> json) {
  return Loan()
    ..lcode = json['lcode'] as String
    ..ucode = json['ucode'] as String
    ..bcode = json['bcode'] as String
    ..ccode = json['ccode'] as String
    ..curcode = json['curcode'] as String
    ..pcode = json['pcode'] as String
    ..lamt = json['lamt'] as num
    ..ints = json['ints'] as num
    ..intrate = json['intrate'] as num
    ..mfee = json['mfee'] as num
    ..afee = json['afee'] as num
    ..rmode = json['rmode'] as String
    ..odate = json['odate'] as String
    ..mdate = json['mdate'] as String
    ..firdate = json['firdate'] as String
    ..graperiod = json['graperiod'] as num
    ..lpourpose = json['lpourpose'] as String
    ..ltv = json['ltv'] as num
    ..dscr = json['dscr'] as num
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
}

Map<String, dynamic> _$LoanToJson(Loan instance) => <String, dynamic>{
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
      'currency': instance.currency
    };
