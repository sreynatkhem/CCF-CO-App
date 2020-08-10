// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'valueListCustomers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValueListCustomers _$ValueListCustomersFromJson(Map<String, dynamic> json) {
  return ValueListCustomers()
    ..ccode = json['ccode'] as String
    ..namekhr = json['namekhr'] as String
    ..nameeng = json['nameeng'] as String
    ..Gender = json['Gender'] as String;
}

Map<String, dynamic> _$ValueListCustomersToJson(ValueListCustomers instance) =>
    <String, dynamic>{
      'ccode': instance.ccode,
      'namekhr': instance.namekhr,
      'nameeng': instance.nameeng,
      'Gender': instance.Gender
    };
