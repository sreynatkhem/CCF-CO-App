// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listLoanRequests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListLoanRequests _$ListLoanRequestsFromJson(Map<String, dynamic> json) {
  return ListLoanRequests()
    ..rcode = json['rcode'] as String
    ..ucode = json['ucode'] as String
    ..bcode = json['bcode'] as String
    ..lcode = json['lcode'] as String
    ..rdate = json['rdate'] as String
    ..rstatus = json['rstatus'] as String
    ..user = json['user'] as String
    ..loan = json['loan'] == null
        ? null
        : CustomerRegistration.fromJson(json['loan'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ListLoanRequestsToJson(ListLoanRequests instance) =>
    <String, dynamic>{
      'rcode': instance.rcode,
      'ucode': instance.ucode,
      'bcode': instance.bcode,
      'lcode': instance.lcode,
      'rdate': instance.rdate,
      'rstatus': instance.rstatus,
      'user': instance.user,
      'loan': instance.loan
    };
