// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Currency _$CurrencyFromJson(Map<String, dynamic> json) {
  return Currency()
    ..curcode = json['curcode'] as String
    ..curname = json['curname'] as String
    ..curdes = json['curdes'] as String
    ..u1 = json['u1'] as String
    ..u2 = json['u2'] as String
    ..u3 = json['u3'] as String
    ..u4 = json['u4'] as String
    ..u5 = json['u5'] as String
    ..loan = json['loan'] as String;
}

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'curcode': instance.curcode,
      'curname': instance.curname,
      'curdes': instance.curdes,
      'u1': instance.u1,
      'u2': instance.u2,
      'u3': instance.u3,
      'u4': instance.u4,
      'u5': instance.u5,
      'loan': instance.loan
    };
