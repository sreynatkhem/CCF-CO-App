import 'package:json_annotation/json_annotation.dart';

part 'valueListCustomers.g.dart';

@JsonSerializable()
class ValueListCustomers {
  ValueListCustomers();

  String ccode;
  String namekhr;
  String nameeng;
  String Gender;

  factory ValueListCustomers.fromJson(Map<String, dynamic> json) =>
      _$ValueListCustomersFromJson(json);
  Map<String, dynamic> toJson() => _$ValueListCustomersToJson(this);
}
