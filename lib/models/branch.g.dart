// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Branch _$BranchFromJson(Map<String, dynamic> json) {
  return Branch()
    ..bcode = json['bcode'] as String
    ..bname = json['bname'] as String
    ..odate = json['odate'] as String
    ..bmname = json['bmname'] as String
    ..procode = json['procode'] as String
    ..discode = json['discode'] as String
    ..comcode = json['comcode'] as String
    ..vilcode = json['vilcode'] as String
    ..customer = json['customer'] as String;
}

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'bcode': instance.bcode,
      'bname': instance.bname,
      'odate': instance.odate,
      'bmname': instance.bmname,
      'procode': instance.procode,
      'discode': instance.discode,
      'comcode': instance.comcode,
      'vilcode': instance.vilcode,
      'customer': instance.customer
    };
